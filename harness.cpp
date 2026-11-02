// harness.cpp - always compiled /fp:precise. Exhaustive f32 test over every normal
// float in [-pi_f, pi_f], sampled f64 test, and a throughput benchmark.
#include <atomic>
#include <bit>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <random>
#include <thread>
#include <vector>

extern "C" void kernel_f32(const float* in, float* out, size_t n);
extern "C" void kernel_f64(const double* in, double* out, size_t n);

static constexpr double kPiHi = 3.141592653589793;
static constexpr double kPiLo = 1.2246467991473532e-16;

// Reference sin in double, accurate to well under 1 f64 ulp near +-pi via exact reduction.
static double ref_sin(double x)
{
    const double ax = std::fabs(x);
    if (ax > 2.0) {
        const double r = (kPiHi - ax) + kPiLo; // kPiHi - ax exact (Sterbenz)
        return x < 0 ? -std::sin(r) : std::sin(r);
    }
    return std::sin(x);
}

// Error in units of the ulp of the *correct* result at precision MantBits.
template<int MantBits, int MinExp>
static double ulp_err(double approx, double ref)
{
    if (std::isnan(approx) || std::isinf(approx)) return INFINITY;
    int e;
    std::frexp(ref, &e);              // ref in [2^(e-1), 2^e)
    int ue = std::max(e - 1, MinExp) - MantBits;
    return std::fabs(approx - ref) / std::ldexp(1.0, ue);
}

static const double kBuckets[] = {0.5, 1, 2, 3, 4, 5, 10, 100, 1e4, 1e6, INFINITY};
static constexpr int kNB = sizeof(kBuckets) / sizeof(kBuckets[0]);

// |x| ranges for the per-region breakdown.
static const double kRangeHi[] = {0x1p-12, 0.5, 2.0, 3.0, INFINITY};
static const char*  kRangeName[] = {"|x|<2^-12", "[2^-12,0.5)", "[0.5,2)", "[2,3)", "[3,pi]"};
static constexpr int kNR = 5;

struct Stats {
    double   max_ulp = 0, max_rel = 0;
    double   r_max[kNR] = {}, r_sum[kNR] = {};
    uint64_t r_n[kNR] = {};
    double   max_x = 0, max_got = 0, max_ref = 0;
    uint64_t n = 0, exact = 0;
    uint64_t hist[kNB] = {};
    double   sum_ulp = 0;

    void add(double x, double got, double ref, double u, bool ex)
    {
        ++n; exact += ex; sum_ulp += std::isinf(u) ? 0 : u;
        int r = 0; while (std::fabs(x) >= kRangeHi[r]) ++r;
        ++r_n[r]; r_sum[r] += std::isinf(u) ? 0 : u; r_max[r] = std::max(r_max[r], u);
        if (ref != 0) max_rel = std::max(max_rel, std::fabs(got - ref) / std::fabs(ref));
        int b = 0; while (u > kBuckets[b]) ++b;
        ++hist[b];
        if (u > max_ulp) { max_ulp = u; max_x = x; max_got = got; max_ref = ref; }
    }
    void merge(const Stats& o)
    {
        n += o.n; exact += o.exact; sum_ulp += o.sum_ulp;
        max_rel = std::max(max_rel, o.max_rel);
        for (int r = 0; r < kNR; ++r) { r_n[r] += o.r_n[r]; r_sum[r] += o.r_sum[r]; r_max[r] = std::max(r_max[r], o.r_max[r]); }
        for (int i = 0; i < kNB; ++i) hist[i] += o.hist[i];
        if (o.max_ulp > max_ulp) { max_ulp = o.max_ulp; max_x = o.max_x; max_got = o.max_got; max_ref = o.max_ref; }
    }
};

static void print_stats(const char* name, const Stats& s, int prec)
{
    std::printf("%s: n=%llu  max_ulp=%.3f  mean_ulp=%.4f  correctly_rounded=%.4f%%\n", name,
                (unsigned long long)s.n, s.max_ulp, s.sum_ulp / s.n, 100.0 * s.exact / s.n);
    std::printf("  worst x=%.*g (0x%08x)  got=%.*g  ref=%.17g\n", prec, s.max_x,
                std::bit_cast<uint32_t>((float)s.max_x), prec, s.max_got, s.max_ref);
    std::printf("  max_rel_err=%.3e\n", s.max_rel);
    for (int r = 0; r < kNR; ++r)
        if (s.r_n[r]) std::printf("  range %-12s n=%-11llu max_ulp=%-14.3f mean_ulp=%.4f\n", kRangeName[r],
                                  (unsigned long long)s.r_n[r], s.r_max[r], s.r_sum[r] / s.r_n[r]);
    std::printf("  hist:");
    double lo = 0;
    for (int i = 0; i < kNB; ++i) {
        if (s.hist[i]) std::printf(" (%g,%g]:%llu", lo, kBuckets[i], (unsigned long long)s.hist[i]);
        lo = kBuckets[i];
    }
    std::printf("\n");
}

// Every normal float in [-pi_f, pi_f]: |bits| in [0x00800000, 0x40490FDB] (pi_f = 3.14159274).
static Stats exhaustive_f32()
{
    constexpr uint32_t kLo = 0x00800000u, kHi = 0x40490FDBu;
    constexpr uint32_t kBlock = 1u << 16;
    const uint64_t total = uint64_t(kHi - kLo + 1);
    const uint64_t nblocks = (total + kBlock - 1) / kBlock;
    std::atomic<uint64_t> next{0};
    unsigned nt = std::max(1u, std::thread::hardware_concurrency());
    std::vector<Stats> per(nt);
    std::vector<std::thread> th;
    for (unsigned t = 0; t < nt; ++t)
        th.emplace_back([&, t] {
            std::vector<float> in(2 * kBlock), out(2 * kBlock);
            Stats s;
            for (uint64_t b; (b = next.fetch_add(1)) < nblocks;) {
                uint32_t start = kLo + uint32_t(b * kBlock);
                uint32_t cnt = uint32_t(std::min<uint64_t>(kBlock, total - b * kBlock));
                for (uint32_t i = 0; i < cnt; ++i) {
                    in[i] = std::bit_cast<float>(start + i);
                    in[cnt + i] = std::bit_cast<float>((start + i) | 0x80000000u);
                }
                kernel_f32(in.data(), out.data(), 2 * cnt);
                for (uint32_t i = 0; i < 2 * cnt; ++i) {
                    double ref = ref_sin(in[i]);
                    double u = ulp_err<23, -126>(out[i], ref);
                    s.add(in[i], out[i], ref, u, out[i] == (float)ref);
                }
            }
            per[t] = s;
        });
    for (auto& t : th) t.join();
    Stats all;
    for (auto& s : per) all.merge(s);
    return all;
}

// f64: 2e7 uniform samples in [-pi, pi] plus 2e7 samples in [pi - 2^-20, pi] (and negatives).
static Stats sampled_f64()
{
    constexpr size_t N = 10'000'000;
    std::mt19937_64 rng(12345);
    std::uniform_real_distribution<double> u(-kPiHi, kPiHi), near(kPiHi - 0x1p-20, kPiHi);
    std::vector<double> in(4 * N), out(4 * N);
    for (size_t i = 0; i < 2 * N; ++i) in[i] = u(rng);
    for (size_t i = 2 * N; i < 4 * N; i += 2) { in[i] = near(rng); in[i + 1] = -in[i]; }
    kernel_f64(in.data(), out.data(), in.size());
    Stats s;
    for (size_t i = 0; i < in.size(); ++i) {
        double ref = ref_sin(in[i]);
        s.add(in[i], out[i], ref, ulp_err<52, -1022>(out[i], ref), out[i] == ref);
    }
    return s;
}

static double bench_f32()
{
    constexpr size_t N = 4096;
    std::vector<float> in(N), out(N);
    for (size_t i = 0; i < N; ++i) in[i] = float(-kPiHi + 2 * kPiHi * (i + 0.5) / N);
    double best = 1e30;
    for (int rep = 0; rep < 30; ++rep) {
        auto t0 = std::chrono::steady_clock::now();
        for (int k = 0; k < 200; ++k) kernel_f32(in.data(), out.data(), N);
        auto t1 = std::chrono::steady_clock::now();
        best = std::min(best, std::chrono::duration<double, std::nano>(t1 - t0).count() / (200.0 * N));
    }
    return best;
}

int main(int argc, char** argv)
{
    bool quick = argc > 1 && !std::strcmp(argv[1], "--quick");
    // Spot check right next to pi, where the split matters most.
    const float probes[] = {3.14159274f, 3.1415925f, 3.141592f, 3.0f, 1e-3f};
    float po[5];
    kernel_f32(probes, po, 5);
    std::printf("probe:");
    for (int i = 0; i < 5; ++i) std::printf(" sin(%.9g)=%.9g[ref %.9g]", probes[i], po[i], (float)ref_sin(probes[i]));
    std::printf("\n");
    std::printf("bench_f32: %.3f ns/sample\n", bench_f32());
    if (quick) return 0;
    auto t0 = std::chrono::steady_clock::now();
    print_stats("f32 exhaustive", exhaustive_f32(), 9);
    print_stats("f64 sampled   ", sampled_f64(), 17);
    std::printf("elapsed: %.1fs\n", std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count());
}

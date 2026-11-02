// sin13.h - variants of cheb_split_sin_13 used to test FP reassociation guards.
#pragma once
#include <type_traits>
#include <emmintrin.h>

#define CHEB_POLY(T)                                    \
    const auto x2 = x * x;                              \
    auto p = T(1.329134413795446e-10);                  \
    p = p * x2 + T(-2.3317789608526773e-08);            \
    p = p * x2 + T(2.5222923566436173e-06);             \
    p = p * x2 + T(-0.00017350505790985756);            \
    p = p * x2 + T(0.006620879521805147);               \
    p = p * x2 + T(-0.10132118334670862);

#define CHEB_PI(T)                                                              \
    constexpr auto pi_hi = T(3.141592653589793);                                \
    constexpr auto pi_lo = std::is_same_v<T, float> ? T(-8.742277657347586e-08) \
                                                    : T(1.2246467991473532e-16);

// ---------------------------------------------------------------------------
// 1. The original, unguarded.
template<typename T>
inline auto sin_plain(T x) -> T
{
    CHEB_PI(T)
    CHEB_POLY(T)
    const auto lo = (x - pi_hi) - pi_lo;
    const auto hi = (x + pi_hi) + pi_lo;
    return lo * hi * p * x;
}

// ---------------------------------------------------------------------------
// 2. MSVC: #pragma float_control(precise, on) around a template.
#ifdef _MSC_VER
#pragma float_control(precise, on, push)
#endif
template<typename T>
inline auto sin_pragma_tpl(T x) -> T
{
    CHEB_PI(T)
    CHEB_POLY(T)
    const auto lo = (x - pi_hi) - pi_lo;
    const auto hi = (x + pi_hi) + pi_lo;
    return lo * hi * p * x;
}

// 3. Same pragma, non-template overloads.
inline float sin_pragma_fn(float x)
{
    using T = float;
    CHEB_PI(T)
    CHEB_POLY(T)
    const auto lo = (x - pi_hi) - pi_lo;
    const auto hi = (x + pi_hi) + pi_lo;
    return lo * hi * p * x;
}
inline double sin_pragma_fn(double x)
{
    using T = double;
    CHEB_PI(T)
    CHEB_POLY(T)
    const auto lo = (x - pi_hi) - pi_lo;
    const auto hi = (x + pi_hi) + pi_lo;
    return lo * hi * p * x;
}

// 4. Same pragma, forced out of line.
template<typename T>
__declspec(noinline) auto sin_pragma_noinline(T x) -> T
{
    CHEB_PI(T)
    CHEB_POLY(T)
    const auto lo = (x - pi_hi) - pi_lo;
    const auto hi = (x + pi_hi) + pi_lo;
    return lo * hi * p * x;
}

// 4b. Same pragma, __forceinline.
template<typename T>
__forceinline auto sin_pragma_force(T x) -> T
{
    CHEB_PI(T)
    CHEB_POLY(T)
    const auto lo = (x - pi_hi) - pi_lo;
    const auto hi = (x + pi_hi) + pi_lo;
    return lo * hi * p * x;
}

// 5. Only the split subtraction lives in a precise helper; poly stays fast.
template<typename T>
inline T split_sub_precise(T x, T a, T b) { return (x - a) - b; }
#ifdef _MSC_VER
#pragma float_control(pop)
#endif

template<typename T>
inline auto sin_pragma_helper(T x) -> T
{
    CHEB_PI(T)
    CHEB_POLY(T)
    const auto lo = split_sub_precise(x, pi_hi, pi_lo);
    const auto hi = split_sub_precise(x, -pi_hi, -pi_lo);
    return lo * hi * p * x;
}

// ---------------------------------------------------------------------------
// 6. volatile intermediate.
template<typename T>
inline auto sin_volatile(T x) -> T
{
    CHEB_PI(T)
    CHEB_POLY(T)
    volatile T vlo = x - pi_hi;
    volatile T vhi = x + pi_hi;
    const auto lo = vlo - pi_lo;
    const auto hi = vhi + pi_lo;
    return lo * hi * p * x;
}

// ---------------------------------------------------------------------------
// 7. SSE scalar intrinsics for the two-step split.
template<typename T>
inline auto sin_intrin(T x) -> T
{
    CHEB_PI(T)
    CHEB_POLY(T)
    T lo, hi;
    if constexpr (std::is_same_v<T, float>) {
        const __m128 vx = _mm_set_ss(x);
        lo = _mm_cvtss_f32(_mm_sub_ss(_mm_sub_ss(vx, _mm_set_ss(pi_hi)), _mm_set_ss(pi_lo)));
        hi = _mm_cvtss_f32(_mm_add_ss(_mm_add_ss(vx, _mm_set_ss(pi_hi)), _mm_set_ss(pi_lo)));
    } else {
        const __m128d vx = _mm_set_sd(x);
        lo = _mm_cvtsd_f64(_mm_sub_sd(_mm_sub_sd(vx, _mm_set_sd(pi_hi)), _mm_set_sd(pi_lo)));
        hi = _mm_cvtsd_f64(_mm_add_sd(_mm_add_sd(vx, _mm_set_sd(pi_hi)), _mm_set_sd(pi_lo)));
    }
    return lo * hi * p * x;
}

// ---------------------------------------------------------------------------
// 8. clang: #pragma clang fp reassociate(off) (block scoped).
#ifdef __clang__
template<typename T>
inline auto sin_clang_pragma(T x) -> T
{
    #pragma clang fp reassociate(off)
    CHEB_PI(T)
    CHEB_POLY(T)
    const auto lo = (x - pi_hi) - pi_lo;
    const auto hi = (x + pi_hi) + pi_lo;
    return lo * hi * p * x;
}
#endif

// ---------------------------------------------------------------------------
// 9. Out-of-TU definition (for /GL + /LTCG cross-module inlining test).
float  sin_extern(float x);
double sin_extern(double x);

// ---------------------------------------------------------------------------
// 10. Nesting: a fast-mode inline wrapper that calls the forceinline/precise kernel,
//     with surrounding arithmetic the fast-math optimizer is free to rewrite.
template<typename T>
inline auto sin_nested_force(T x) -> T
{
    const T a = sin_pragma_force(x) * T(0.5);
    const T b = sin_pragma_force(x) * T(0.5);
    return (a + b) * T(3) - (a + b) * T(2);
}

// Controls for the nesting test.
template<typename T>
inline auto sin_nested_plain(T x) -> T
{
    const T a = sin_plain(x) * T(0.5);
    const T b = sin_plain(x) * T(0.5);
    return (a + b) * T(3) - (a + b) * T(2);
}
template<typename T>
__forceinline auto sin_nested_force2(T x) -> T
{
    const T a = sin_pragma_force(x) * T(0.5);
    const T b = sin_pragma_force(x) * T(0.5);
    return (a + b) * T(3) - (a + b) * T(2);
}

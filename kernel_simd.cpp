// kernel_simd.cpp - hand-vectorized SSE2 version of cheb_split_sin_13<float>.
// f64 path just uses sin_plain; only the f32 result is of interest here.
#include <cstddef>
#include <emmintrin.h>
#include "sin13.h"

#ifdef SIMD_GUARD
#pragma float_control(precise, on, push)
#define SIMD_INLINE __forceinline
#else
#define SIMD_INLINE inline
#endif
static SIMD_INLINE __m128 sin_sse(__m128 x)
{
    const __m128 pi_hi = _mm_set1_ps(3.141592653589793f);
    const __m128 pi_lo = _mm_set1_ps(-8.742277657347586e-08f);
    const __m128 x2 = _mm_mul_ps(x, x);
    __m128 p = _mm_set1_ps(1.329134413795446e-10f);
    p = _mm_add_ps(_mm_mul_ps(p, x2), _mm_set1_ps(-2.3317789608526773e-08f));
    p = _mm_add_ps(_mm_mul_ps(p, x2), _mm_set1_ps(2.5222923566436173e-06f));
    p = _mm_add_ps(_mm_mul_ps(p, x2), _mm_set1_ps(-0.00017350505790985756f));
    p = _mm_add_ps(_mm_mul_ps(p, x2), _mm_set1_ps(0.006620879521805147f));
    p = _mm_add_ps(_mm_mul_ps(p, x2), _mm_set1_ps(-0.10132118334670862f));
#if defined(SIMD_OPS) && defined(__clang__)
    // clang vector-extension operators: the fsub is emitted here, under this region's pragma,
    // rather than inside <xmmintrin.h> where _mm_sub_ps is defined.
    const __m128 lo = (x - pi_hi) - pi_lo;
    const __m128 hi = (x + pi_hi) + pi_lo;
#else
    const __m128 lo = _mm_sub_ps(_mm_sub_ps(x, pi_hi), pi_lo);
    const __m128 hi = _mm_add_ps(_mm_add_ps(x, pi_hi), pi_lo);
#endif
    return _mm_mul_ps(_mm_mul_ps(_mm_mul_ps(lo, hi), p), x);
}
#ifdef SIMD_GUARD
#pragma float_control(pop)
#endif

extern "C" void kernel_f32(const float* in, float* out, size_t n)
{
    size_t i = 0;
    for (; i + 4 <= n; i += 4) _mm_storeu_ps(out + i, sin_sse(_mm_loadu_ps(in + i)));
    for (; i < n; ++i) out[i] = _mm_cvtss_f32(sin_sse(_mm_set_ss(in[i])));
}

extern "C" void kernel_f64(const double* in, double* out, size_t n)
{
    for (size_t i = 0; i < n; ++i) out[i] = sin_plain(in[i]);
}

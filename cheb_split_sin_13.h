// cheb_split_sin_13.h - recommended form: survives /fp:fast and -ffast-math on MSVC and clang(-cl),
// stays inlined and vectorizable.
//
//  * float_control(precise, on) gives the function precise semantics (MSVC: per function;
//    clang: per instruction in the region).
//  * __forceinline is required on MSVC: it will not auto-inline a precise function into a
//    /fp:fast caller (it emits a call instead). With __forceinline it inlines AND keeps the
//    callee's precise semantics.
#pragma once
#include <type_traits>

#if defined(_MSC_VER)
    #define FP_PRECISE_BEGIN __pragma(float_control(precise, on, push))
    #define FP_PRECISE_END   __pragma(float_control(pop))
    #define FP_FORCEINLINE   __forceinline
#elif defined(__clang__)
    #define FP_PRECISE_BEGIN _Pragma("float_control(precise, on, push)")
    #define FP_PRECISE_END   _Pragma("float_control(pop)")
    #define FP_FORCEINLINE   inline __attribute__((always_inline))
#else
    #error "untested compiler"
#endif

FP_PRECISE_BEGIN
template<typename T>
FP_FORCEINLINE auto cheb_split_sin_13(T x) -> T
{
    constexpr auto pi_hi = T(3.141592653589793);
    constexpr auto pi_lo = std::is_same_v<T, float> ? T(-8.742277657347586e-08) : T(1.2246467991473532e-16);
    const auto x2 = x * x;
    auto p = T(1.329134413795446e-10);
    p = p * x2 + T(-2.3317789608526773e-08);
    p = p * x2 + T(2.5222923566436173e-06);
    p = p * x2 + T(-0.00017350505790985756);
    p = p * x2 + T(0.006620879521805147);
    p = p * x2 + T(-0.10132118334670862);
    const auto lo = (x - pi_hi) - pi_lo;
    const auto hi = (x + pi_hi) + pi_lo;
    return lo * hi * p * x;
}
FP_PRECISE_END

// kernel.cpp - compiled under the FP flags being tested. SIN_FN selects the variant.
#include <cstddef>
#include "sin13.h"
#include "cheb_split_sin_13.h"

#ifndef SIN_FN
#error define SIN_FN
#endif

// CALLER_PRECISE: put the pragma on the caller (the block loop) instead of the callee.
#ifdef CALLER_PRECISE
#pragma float_control(precise, on, push)
#endif

extern "C" void kernel_f32(const float* in, float* out, size_t n)
{
    for (size_t i = 0; i < n; ++i) out[i] = SIN_FN(in[i]);
}

extern "C" void kernel_f64(const double* in, double* out, size_t n)
{
    for (size_t i = 0; i < n; ++i) out[i] = SIN_FN(in[i]);
}

#ifdef CALLER_PRECISE
#pragma float_control(pop)
#endif

# `cheb_split_sin_13` under fast-math: MSVC vs clang

**Question:** `cheb_split_sin_13` relies on `(x - pi_hi) - pi_lo` being evaluated in source order. Fast-math reassociation turns it into `x - (pi_hi + pi_lo)`, which folds to `x - pi_f`, and the accuracy gained from the split is lost. Clang has `#pragma clang fp reassociate(off)`, which survives inlining. **Does MSVC have an equivalent?**

**Short answer: yes, but only at function granularity, and it needs `__forceinline`.**

```cpp
#pragma float_control(precise, on, push)
template<typename T>
__forceinline auto cheb_split_sin_13(T x) -> T { /* unchanged */ }
#pragma float_control(pop)
```

Measured on MSVC 19.44.35211 (VS 2022 17.14), x64, `/O2 /fp:fast`:

| | max ulp, f32, exhaustive | ns/sample | codegen in the `/fp:fast` loop |
|---|---|---|---|
| unguarded | **12,303,662** | 0.362 | inlined, vectorized |
| `float_control(precise)` + `inline` | 4.904 | 1.734 | **not inlined**: one `call` per sample, scalar |
| `float_control(precise)` + `__forceinline` | **4.904** | **0.394** | **inlined, vectorized, precise** |
| whole TU `/fp:precise` (reference) | 4.904 | 0.392 | inlined, vectorized |

The guarded function produces results bit-identical to an all-`/fp:precise` build, at the same speed, inside a `/fp:fast` caller.

---

## 1. Setup

| | |
|---|---|
| CPU | AMD Ryzen 7 PRO 6850H (Zen 3+), 16 threads |
| MSVC | `cl` 19.44.35211 for x64 (VS 2022 Community, toolset 14.44.35207) |
| clang | clang-cl 19.1.0 (`x86_64-pc-windows-msvc`), from `C:\Program Files\LLVM` |
| Common flags | `/O2 /std:c++20 /EHsc`; SSE2 baseline unless the config says `avx2` (`/arch:AVX2`) |

### Test design

- **`kernel.cpp` is built under the flags being tested.** It holds a plain loop `out[i] = SIN_FN(in[i])` for `float` and `double`. The function under test is a header inline, so it is inlined into a fast-math caller (or not, which is part of what is being tested).
- **`harness.cpp` is always built `/fp:precise`.** It generates inputs, computes the reference, and measures error. It calls the kernel through an `extern "C"` boundary, so the harness's own math is never affected by the fast flags.
- **f32 exhaustive test.** Every *normal* float with `|x|` in `[FLT_MIN, pi_f]`, for both signs: **2,140,282,808 inputs**. `pi_f = 3.14159274` (`0x40490FDB`) is the float nearest pi; it lies slightly above pi and is included. Subnormals and ±0 are excluded.
- **f32 reference.** `sin` evaluated in double. For `|x| > 2` the argument is first reduced exactly: `r = (pi_hi - |x|) + pi_lo` in double. The `pi_hi - |x|` step is exact by Sterbenz's lemma. The reference error is below about 1e-16 relative, roughly 1e-9 of a float ulp, so it doesn't affect the measurements.
- **ulp definition.** `|got - ref| / ulp_f32(ref)`, where `ulp_f32` is the spacing of floats in `ref`'s binade.
- **f64 sampled test.** 2×10⁷ uniform samples in `[-pi, pi]`, plus 2×10⁷ samples in `[pi - 2⁻²⁰, pi]` and their negatives.
- **Benchmark.** A 4096-sample buffer evenly spread over `[-pi, pi]`, 200 passes per trial, best of 30 trials.
- **Generated code.** Kernel assembly saved with `/FAs` for every config (`asm/*.asm`). The LTCG case was checked with `dumpbin /disasm` on the linked exe, because the `/FAs` listing from a `/GL` compile is not the final code.

The exhaustive test takes about 5 s per configuration, and there are 43 configurations.

---

## 2. Baseline: your 5-ulp claim holds

With no fast-math, both compilers give the same result. The maximum error is **4.904 ulp**, at `x = 2.61832142` (`0x40279294`). That point is polynomial evaluation error; it is not near pi.

Error by input range, `/fp:precise` (MSVC and clang SSE2 are bit-identical):

| range of \|x\| | inputs | max ulp | mean ulp |
|---|---:|---:|---:|
| < 2⁻¹² | 1,912,602,624 | 2.167 | 1.501 |
| [2⁻¹², 0.5) | 184,549,376 | 3.289 | 0.800 |
| [0.5, 2) | 33,554,432 | 4.167 | 0.795 |
| [2, 3) | 8,388,608 | **4.904** | 0.712 |
| [3, pi_f] | 1,187,768 | 4.337 | 0.725 |

There are 212 inputs in (4, 5] ulp, and none above 5 ulp.

With AVX2, clang's default `-ffp-contract=on` contracts `p * x2 + c` into FMA, and the maximum drops to **4.437 ulp**. MSVC `/fp:precise` no longer contracts by default since VS 2022, so it stays at 4.904 ulp with AVX2.

> Note for slides: 89% of the float bit patterns in this range have |x| < 2⁻¹². Aggregate statistics such as mean ulp or "% correctly rounded" over all bit patterns are dominated by that tiny-x region, where the split is irrelevant. Report the maximum, and break it down by range.

---

## 3. What fast-math does to the split

### Unguarded results under fast-math

| config | max ulp | max ulp in [2,3) | max ulp in [3, pi_f] |
|---|---:|---:|---:|
| MSVC `/fp:fast` | 12,303,662 | 9.35 | 12,303,662 |
| MSVC `/fp:fast /arch:AVX2` | 12,303,662 | 9.35 | 12,303,662 |
| clang-cl `/fp:fast` (= `-ffast-math`) | 12,303,662 | 9.58 | 12,303,662 |
| clang-cl `/fp:fast /arch:AVX2` | 12,303,662 | 9.41 | 12,303,662 |

The worst input is `x = pi_f`. The reference is `-8.74e-8`, and every fast-math build returns `-0`, a 100% relative error. Near pi the result is just the leftover `x - pi`, so losing `pi_lo` costs every bit of it. The error is already about 2× worse in `[2, 3)`.

Away from pi, fast-math does no harm. The `< 0.5` ranges are unchanged.

### MSVC assembly for the inner loop

`/fp:fast`: `pi_lo` is gone. Only `0x40490fdb` (`pi_f`) remains:

```asm
movaps  xmm1, xmm4        ; xmm4 = {pi_f x4}
addps   xmm1, xmm3        ; hi = x + pi_f
movaps  xmm0, xmm3
subps   xmm0, xmm4        ; lo = x - pi_f
```

`/fp:precise`: both steps are kept, and the loop is still vectorized:

```asm
subps   xmm1, xmm4        ; x - pi_hi
subps   xmm1, xmm11       ; xmm11 = {0xb3bbbd2e x4} = pi_lo
addps   xmm0, xmm3        ; x + pi_hi
subps   xmm0, xmm12       ; xmm12 = {0x33bbbd2e x4} = -pi_lo
```

### f64 instantiation

The coefficients are a float-grade fit, so in double the polynomial itself is only good to about 5.7e-9 relative. Ulp is the wrong metric here, so I report maximum relative error:

| | max relative error, f64 |
|---|---:|
| precise | 5.73e-09 |
| fast (both compilers) | **2.45e-02** (worst at `x = 3.1415926535897882`) |

---

## 4. All MSVC options tried, under `/fp:fast`

"call" means the kernel loop contains a `call` per sample. "vec" means the loop uses packed SSE/AVX arithmetic.

| # | technique | max ulp f32 | ns/sample | call | vec | verdict |
|---|---|---:|---:|:-:|:-:|---|
| – | unguarded | 12,303,662 | 0.362 | | ✓ | broken |
| 2 | `float_control(precise,on,push)` around the **template** | 4.904 | 1.734 | ✓ | | correct, 4.8× slower |
| 3 | same, around a **non-template** overload | 4.904 | 1.708 | ✓ | | correct, 4.7× slower |
| 4 | same + `__declspec(noinline)` | 4.904 | 1.723 | ✓ | | correct, 4.8× slower |
| 4b | **same + `__forceinline`** | **4.904** | **0.399** | | ✓ | **correct and fast** |
| 4b | same, `/arch:AVX2` | 4.904 | 0.203 | | ✓ | correct and fast (precise AVX2 = 0.202) |
| 5 | pragma only on a tiny `split_sub` helper | 6.000 | 2.380 | ✓ | | correct split, but the call is not inlined |
| – | pragma on the **caller** (the loop), callee left fast | 12,303,662 | 1.745 | ✓ | | **broken and slow** |
| 6 | `volatile` intermediates | 4.954 | 1.800 | | | correct, scalar |
| 7 | scalar intrinsics `_mm_sub_ss` / `_mm_add_ss` | 4.954 | 1.559 | | | correct, scalar |
| 9 | function defined in a separate `/fp:precise` TU, no LTCG | 4.904 | 1.612 | ✓ | | correct, slow |
| 9 | same with `/GL` + `/LTCG` | 4.904 | 1.706 | ✓ | | **LTCG will not inline across a `/fp` mismatch** |
| – | hand-vectorized SSE (`_mm_sub_ps` …) | 12,303,662 | 0.366 | | ✓ | **broken**: packed intrinsics are reassociated |
| – | hand-vectorized SSE in a `float_control(precise)` + `__forceinline` helper | 4.904 | 0.393 | | ✓ | correct and fast |
| ref | `/fp:precise` for the whole TU | 4.904 | 0.392 | | ✓ | |
| ref | `/fp:strict` for the whole TU | 4.904 | 0.392 | | ✓ | |

### Findings

1. **MSVC binds FP semantics to the function where the code is *defined*.** It will not auto-inline a function across an FP-model mismatch:
   - **Precise callee, fast caller** (rows 2–4): correct, but becomes a call.
   - **Fast callee, precise caller** (the "pragma on the caller" row): wrong *and* a call. Putting the pragma on your `processBlock` does nothing for helpers defined elsewhere.

   This holds for templates and non-templates alike. A template takes the pragma state from where it is *defined*, not where it is instantiated.

2. **`__forceinline` overrides the refusal, and the inlined body keeps its precise semantics.** The kernel loop is vectorized. Fast-mode reassociation does not leak into the inlined code: both `pi_lo` constants (`0xb3bbbd2e`, `0x33bbbd2e`) are still in the loop, and the results are bit-identical to `/fp:precise`. This is MSVC's equivalent of clang's per-instruction flags. Microsoft's docs don't describe it: they say only that the pragmas work "at function-level, not within a function". So it is behaviour I observed, not a documented guarantee.

3. **Precise-ness spreads to every caller up the chain.** Once precise code has been `__forceinline`d into a function `W`, MSVC also stops auto-inlining `W` into fast callers. The three nesting tests show this, with the same wrapper body in each:

   | wrapper | inner kernel | ns/sample | wrapper inlined into loop? |
   |---|---|---:|---|
   | `inline` | fast `sin_plain` | 0.526 | yes |
   | `inline` | precise `__forceinline` | 2.340 | **no**: `call sin_nested_force` |
   | `__forceinline` | precise `__forceinline` | 0.567 | yes |

   Inside the non-inlined wrapper, the precise split is intact. **Rule: every inline function between the precise kernel and the hot loop needs `__forceinline` too.** Alternatively, call the guarded kernel directly from the loop. (The wrappers' 6.49 ulp comes from the wrapper's own arithmetic, `(a+b)*3 - (a+b)*2`, not from the kernel.)

4. **Intrinsics are not a barrier for packed code on MSVC.** Scalar `_mm_sub_ss` was left alone. But in a hand-vectorized `_mm_sub_ps` kernel, MSVC `/fp:fast` folded `pi_hi + pi_lo` exactly as it does for plain C++. "We use intrinsics so we're safe" is false on MSVC too.

5. **`volatile` works but blocks vectorization** (1.80 ns vs 0.39 ns).

6. **Precise costs almost nothing for this kernel.** MSVC SSE2: 0.392 vs 0.362 ns (+8%). AVX2: 0.202 vs 0.189 ns (+7%). The only fast-math wins here are minor scheduling and the AVX2 FMAs, so guarding this function gives up almost nothing.

---

## 5. Clang comparison (clang-cl 19.1, `/fp:fast` = `-ffast-math`)

| technique | max ulp f32 | ns/sample | verdict |
|---|---:|---:|---|
| unguarded | 12,303,662 | 0.352 | broken |
| `#pragma clang fp reassociate(off)` in the function body | 4.904 | 0.401 | correct, inlined, vectorized |
| same, AVX2 | 4.437 | 0.151 | correct; FMA contraction still allowed |
| MS `#pragma float_control(precise, on)`, plain `inline` | 4.904 | 0.402 | correct, inlined, vectorized: **clang does not refuse to inline** |
| pragma on the caller only | 12,303,662 | 0.349 | broken (same rule as MSVC) |
| scalar `_mm_sub_ss` intrinsics | 12,303,662 | 0.351 | **broken**: clang intrinsics are ordinary IR `fsub` |
| `volatile` | 4.605 | 2.765 | correct, 7× slower |
| hand-vectorized SSE, unguarded | 12,303,662 | 0.351 | broken |
| hand-vectorized SSE in a `float_control(precise)` helper | **12,303,662** | 0.353 | **still broken** (see below) |
| same, but `lo`/`hi` written with vector operators `(x - pi_hi) - pi_lo` | 4.605 | 0.386 | correct |
| precise TU (reference) | 4.904 | 0.400 | |
| precise TU, AVX2 (reference) | 4.437 | 0.141 | |

### Pitfall: a pragma doesn't cover intrinsics on clang

Clang attaches FP flags to each instruction according to the pragma state in effect *where that instruction's source is written*. `_mm_sub_ps` is an inline function in `<xmmintrin.h>`, whose body is `(__m128)((__v4sf)a - (__v4sf)b)`. That body was parsed under the TU's fast-math flags, outside your pragma region. So `#pragma float_control(precise)` around an intrinsic-based helper protects nothing.

The fix is to write the critical subtraction with GCC/clang vector operators on `__m128` *inside* the guarded region. `#pragma clang fp reassociate(off)` should behave the same way, since it uses the same mechanism; I didn't run that combination.

MSVC is the reverse case: its intrinsics are compiler built-ins, so the MSVC pragma does cover them.

### Why clang and MSVC differ on inlining

LLVM stores fast-math flags per instruction (`reassoc`, `contract`, …). An inlined callee keeps its own instructions' flags, so mixing precise and fast code in one function is free. MSVC evidently tracks the FP model per function, which is why it refuses to inline across a mismatch unless forced. Both compilers agree on the rule that matters: **the semantics come from where the code is written, not from where it ends up.**

---

## 6. Recommendation (tested)

See `cheb_split_sin_13.h`:

```cpp
#if defined(_MSC_VER)          // MSVC and clang-cl
    #define FP_PRECISE_BEGIN __pragma(float_control(precise, on, push))
    #define FP_PRECISE_END   __pragma(float_control(pop))
    #define FP_FORCEINLINE   __forceinline
#elif defined(__clang__)
    #define FP_PRECISE_BEGIN _Pragma("float_control(precise, on, push)")
    #define FP_PRECISE_END   _Pragma("float_control(pop)")
    #define FP_FORCEINLINE   inline __attribute__((always_inline))
#endif

FP_PRECISE_BEGIN
template<typename T>
FP_FORCEINLINE auto cheb_split_sin_13(T x) -> T
{
    /* original body, unchanged */
}
FP_PRECISE_END
```

Exhaustive results for this exact header, called from a `/fp:fast` loop:

| config | max ulp f32 | ns/sample | inlined + vectorized | f64 max rel |
|---|---:|---:|:-:|---:|
| MSVC `/fp:fast` | 4.904 | 0.394 | ✓ | 5.73e-09 |
| MSVC `/fp:fast /arch:AVX2` | 4.904 | 0.201 | ✓ | 5.73e-09 |
| clang-cl `/fp:fast` | 4.904 | 0.398 | ✓ | 5.73e-09 |
| clang-cl `/fp:fast /arch:AVX2` | 4.437 | 0.143 | ✓ | 5.73e-09 |

Every row matches its compiler's all-precise build bit for bit, and runs at precise speed.

### Caveats for the talk

- **Undocumented on MSVC.** The inline refusal and the precise-semantics-under-`__forceinline` behaviour are observed on 19.44.35211. Microsoft's docs promise neither. Keep the exhaustive test in CI; `./build.sh && ./run_all.sh` takes about 4 minutes.
- **Unlike `reassociate(off)`, `float_control(precise)` turns off everything** for that function: reassociation, contraction (FMA), and fast-math NaN/inf/signed-zero assumptions. On clang you can use `reassociate(off)` to keep FMA (4.437 ulp on AVX2). On MSVC there is no reassociation-only switch. Adding `#pragma fp_contract(on)` inside the region should re-enable FMA, but I didn't test it.
- **`__forceinline` is a request.** MSVC can still decline it (warning C4714), for example under `/Ob0` debug builds. The code then becomes a call, which is slow but still correct.
- **Wrap the whole call chain.** Any inline wrapper between the kernel and the hot loop also needs `__forceinline` on MSVC (finding 3).
- **Guard at the definition.** A pragma on the caller does nothing, on either compiler.
- **Clang + intrinsics.** Use vector operators inside the guarded region (section 5).
- **GCC was not tested.** It has neither pragma. `__attribute__((optimize("no-associative-math")))` is the usual approach there, and GCC documents that `optimize` attributes can block inlining.

---

## 7. Files and reproduction

| file | purpose |
|---|---|
| `cheb_split_sin_13.h` | the recommended, guarded function |
| `sin13.h` | every variant tested (`sin_plain`, `sin_pragma_tpl`, `sin_pragma_force`, `sin_volatile`, `sin_intrin`, `sin_clang_pragma`, nesting tests, …) |
| `kernel.cpp` | block loop compiled under the test flags (`-DSIN_FN=…`, optional `-DCALLER_PRECISE`) |
| `kernel_simd.cpp` | hand-vectorized SSE kernel (`-DSIMD_GUARD`, `-DSIMD_OPS`) |
| `extern_impl.cpp` | `/fp:precise` out-of-TU definition for the separate-TU and LTCG tests |
| `harness.cpp` | exhaustive f32 test, sampled f64 test, benchmark (always `/fp:precise`) |
| `build.sh` | config table → `build/<config>.exe`, `asm/<config>.asm` |
| `run_all.sh` | runs everything → `results/<config>.txt` |
| `env.bat` | loads `vcvars64` and adds LLVM to `PATH` |

From Git Bash:

```sh
./build.sh            # or: ./build.sh msvc_fast_recommended clang_fast_plain ...
./run_all.sh          # full exhaustive run, ~4 min on 16 threads
build/msvc_fast_plain.exe --quick   # probes near pi + benchmark only
```

Each `results/*.txt` contains spot probes next to pi, the benchmark, f32 and f64 summaries (max ulp, worst input, max relative error), a per-range breakdown, and an error histogram.

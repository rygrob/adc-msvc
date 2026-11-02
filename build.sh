#!/bin/sh
# build.sh - builds one exe per configuration into build/, kernel asm into asm/.
# Usage: ./build.sh            (all)   |   ./build.sh name...  (subset)
set -e
cd "$(dirname "$0")"
mkdir -p build asm
CXX="/O2 /std:c++20 /EHsc /nologo /W3"
run() { cmd //c ".\env.bat $*" ; }

[ -f build/harness.obj ] || run cl $CXX /fp:precise /c harness.cpp /Fobuild/harness.obj

# name | compiler | kernel flags | SIN_FN | extra
CONFIGS='
msvc_precise_plain        |cl      |/fp:precise           |sin_plain
msvc_strict_plain         |cl      |/fp:strict            |sin_plain
msvc_fast_plain           |cl      |/fp:fast              |sin_plain
msvc_fast_pragma_tpl      |cl      |/fp:fast              |sin_pragma_tpl
msvc_fast_pragma_fn       |cl      |/fp:fast              |sin_pragma_fn
msvc_fast_pragma_noinline |cl      |/fp:fast              |sin_pragma_noinline
msvc_fast_pragma_force    |cl      |/fp:fast              |sin_pragma_force
msvc_fast_nested_force    |cl      |/fp:fast              |sin_nested_force
msvc_fast_nested_plain    |cl      |/fp:fast              |sin_nested_plain
msvc_fast_nested_force2   |cl      |/fp:fast              |sin_nested_force2
msvc_fast_caller_pragma   |cl      |/fp:fast /DCALLER_PRECISE|sin_plain
msvc_fast_pragma_helper   |cl      |/fp:fast              |sin_pragma_helper
msvc_fast_volatile        |cl      |/fp:fast              |sin_volatile
msvc_fast_intrin          |cl      |/fp:fast              |sin_intrin
msvc_fast_extern          |cl      |/fp:fast              |sin_extern     |extern
msvc_fast_extern_ltcg     |cl      |/fp:fast /GL          |sin_extern     |ltcg
msvc_avx2_precise_plain   |cl      |/fp:precise /arch:AVX2|sin_plain
msvc_avx2_fast_plain      |cl      |/fp:fast /arch:AVX2   |sin_plain
msvc_avx2_fast_pragma_tpl |cl      |/fp:fast /arch:AVX2   |sin_pragma_tpl
msvc_avx2_fast_intrin     |cl      |/fp:fast /arch:AVX2   |sin_intrin
msvc_avx2_fast_pragma_force|cl     |/fp:fast /arch:AVX2   |sin_pragma_force
msvc_avx2_fast_caller_pragma|cl    |/fp:fast /arch:AVX2 /DCALLER_PRECISE|sin_plain
msvc_fast_recommended     |cl      |/fp:fast              |cheb_split_sin_13
msvc_avx2_fast_recommended|cl      |/fp:fast /arch:AVX2   |cheb_split_sin_13
clang_fast_recommended    |clang-cl|/fp:fast              |cheb_split_sin_13
clang_avx2_fast_recommended|clang-cl|/fp:fast /arch:AVX2  |cheb_split_sin_13
msvc_fast_simd            |cl      |/fp:fast              |sin_plain      |      |kernel_simd.cpp
msvc_fast_simd_guard      |cl      |/fp:fast /DSIMD_GUARD |sin_plain      |      |kernel_simd.cpp
clang_fast_simd_guard     |clang-cl|/fp:fast /DSIMD_GUARD |sin_plain      |      |kernel_simd.cpp
clang_fast_simd_guard_ops |clang-cl|/fp:fast /DSIMD_GUARD /DSIMD_OPS|sin_plain|   |kernel_simd.cpp
msvc_precise_simd         |cl      |/fp:precise           |sin_plain      |      |kernel_simd.cpp
clang_fast_simd           |clang-cl|/fp:fast              |sin_plain      |      |kernel_simd.cpp
clang_precise_simd        |clang-cl|                      |sin_plain      |      |kernel_simd.cpp
clang_precise_plain       |clang-cl|                      |sin_plain
clang_fast_plain          |clang-cl|/fp:fast              |sin_plain
clang_fast_clang_pragma   |clang-cl|/fp:fast              |sin_clang_pragma
clang_fast_pragma_tpl     |clang-cl|/fp:fast              |sin_pragma_tpl
clang_fast_caller_pragma  |clang-cl|/fp:fast /DCALLER_PRECISE|sin_plain
clang_fast_volatile       |clang-cl|/fp:fast              |sin_volatile
clang_fast_intrin         |clang-cl|/fp:fast              |sin_intrin
clang_avx2_precise_plain  |clang-cl|/arch:AVX2            |sin_plain
clang_avx2_fast_plain     |clang-cl|/fp:fast /arch:AVX2   |sin_plain
clang_avx2_fast_clang_pragma|clang-cl|/fp:fast /arch:AVX2 |sin_clang_pragma
'
echo "$CONFIGS" | while IFS='|' read -r name cc flags fn extra src; do
    name=$(echo $name); [ -z "$name" ] && continue
    if [ $# -gt 0 ]; then case " $* " in *" $name "*) ;; *) continue;; esac; fi
    cc=$(echo $cc); fn=$(echo $fn); extra=$(echo $extra); src=$(echo $src); [ -z "$src" ] && src=kernel.cpp
    echo "== $name"
    run $cc $CXX $flags /DSIN_FN=$fn /c $src /Fobuild/$name.k.obj /FAs /Faasm/$name.asm
    objs="build/harness.obj build/$name.k.obj"; lflags=""
    if [ -n "$extra" ]; then
        gl=""; [ "$extra" = ltcg ] && gl="/GL" && lflags="/LTCG"
        run cl $CXX /fp:precise $gl /c extern_impl.cpp /Fobuild/$name.e.obj /FAs /Faasm/$name.extern.asm
        objs="$objs build/$name.e.obj"
    fi
    run link /nologo $lflags $objs /OUT:build/$name.exe
done

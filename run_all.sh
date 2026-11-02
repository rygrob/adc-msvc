#!/bin/sh
# run_all.sh - runs every built configuration, one result file each in results/.
cd "$(dirname "$0")"; mkdir -p results
for e in build/*.exe; do
    n=$(basename $e .exe); [ "$n" = ltcg_dbg ] && continue
    echo "== $n"; ./$e > results/$n.txt; cat results/$n.txt
done

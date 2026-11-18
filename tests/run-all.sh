#!/bin/bash
# Dev-time suite runner: run every tests/test-*.sh and report pass or fail per script.
# Usage: ./tests/run-all.sh
# Exit 0 when every script passes, 1 on the first failure.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
count=0
failed=""

for t in "$ROOT"/tests/test-*.sh; do
    name="$(basename "$t")"
    count=$((count + 1))
    printf '==> %s\n' "$name"
    # The knowledge fixture runs its full scenario only with --all.
    if [ "$name" = "test-knowledge-repair-fixture.sh" ]; then
        run_ok=0
        bash "$t" --all || run_ok=$?
    else
        run_ok=0
        bash "$t" || run_ok=$?
    fi
    if [ "$run_ok" -eq 0 ]; then
        printf 'PASS %s\n' "$name"
    else
        printf 'FAIL %s\n' "$name"
        failed="$name"
        break
    fi
done

if [ -n "$failed" ]; then
    echo "FAILED: $failed"
    exit 1
fi
printf 'PASSED: %s test scripts.\n' "$count"
exit 0

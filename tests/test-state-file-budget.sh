#!/bin/bash
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMON="$ROOT/ai/policies/ai-policy-common.md"
VALIDATOR="$ROOT/support-files/validate-protocol.sh"
LOAD="$ROOT/ai/procedures/load-context.md"
CHECKPOINT="$ROOT/ai/procedures/write-checkpoint.md"
REPAIR="$ROOT/ai/procedures/repair-state-files.md"
# shellcheck disable=SC2016
SENTENCE='counted in the shared state-file budget in `ai-policy-common.md`'
fail=0

pass() { printf 'PASS %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

present() {
    local file="$1" needle="$2" label="$3"
    if grep -qF -- "$needle" "$file"; then
        pass "$label"
    else
        fail_case "$label is missing"
    fi
}

absent() {
    local file="$1" needle="$2" label="$3"
    if grep -qF -- "$needle" "$file"; then
        fail_case "$label is present"
    else
        pass "$label is absent"
    fi
}

present "$COMMON" "30,720-byte advisory budget" "the shared budget in the common policy"
absent "$COMMON" "8 KB soft target" "the old context size target"
absent "$COMMON" "7 KB soft target" "the old progress size target"
absent "$COMMON" "5 KB soft target" "the old next-steps size target"
absent "$COMMON" "20 KB" "the old 20 KB total"

count="$(grep -Fc -- "$SENTENCE" "$COMMON")"
if [ "$count" -eq 3 ]; then pass "the three header blocks carry the number-free size sentence"; else fail_case "the number-free size sentence appears $count times, expected 3"; fi

present "$VALIDATOR" "30720" "the validator shared budget"
absent "$VALIDATOR" "20480" "the old validator total"

present "$LOAD" "over 300 characters" "the load long-line count"
present "$LOAD" "30,720" "the load shared budget"
present "$CHECKPOINT" "not condensable" "the checkpoint not-condensable outcome"
present "$CHECKPOINT" "30,720" "the checkpoint shared budget"
present "$REPAIR" "not condensable" "the repair not-condensable outcome"
present "$REPAIR" "30,720" "the repair shared budget"

if [ "$fail" -eq 0 ]; then
    echo "PASSED: the shared state-file budget, the number-free headers, and the condense stops."
    exit 0
fi
echo "FAILED: the shared state-file budget, the number-free headers, or the condense stops."
exit 1

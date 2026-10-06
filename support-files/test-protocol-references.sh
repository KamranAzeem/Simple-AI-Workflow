#!/bin/bash
# Reference-integrity test for protocol entity names.
#
# Two check groups:
#   1. Resolvability: every PROCEDURE / STEP / TIER / ITEM reference in the live
#      protocol files resolves to exactly one definition in AGENTS.md, and every
#      defined name is unique.
#   2. Conformance: no letter-based procedure reference, and no numeric tier or
#      step reference, remains in the live protocol files.
#
# Live protocol files are AGENTS.md, ai/shared/coordination.md, and ai/policies/*.md.
# Historical records (daily checkpoints, closed tickets, ADR history) and ordinary
# "step" usage in runbooks/scripts are intentionally out of scope.
#
# Exit 0 when all checks pass, 1 otherwise.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 1

LIVE_FILES=(AGENTS.md ai/shared/coordination.md)
while IFS= read -r f; do
    LIVE_FILES+=("$f")
done < <(find ai/policies -maxdepth 1 -name '*.md' 2>/dev/null | sort)

fail=0

# --- definitions from AGENTS.md ---
defined_procedures="$(grep -oE '^### PROCEDURE [A-Z][A-Z-]*:' AGENTS.md | sed -E 's/^### PROCEDURE ([A-Z][A-Z-]*):/\1/' | sort)"
defined_steps="$(grep -oE '\*\*STEP-[A-Z][A-Z-]*' AGENTS.md | sed -E 's/\*\*STEP-//' | sort)"
defined_tiers="$(grep -oE '^## TIER [A-Z][A-Z-]*' AGENTS.md | sed -E 's/^## TIER //' | sort)"
defined_items="$(grep -oE '\*\*ITEM [A-Z][A-Z-]*' AGENTS.md | sed -E 's/\*\*ITEM //' | sort)"

check_unique() {
    local label="$1" list="$2" dups
    dups="$(printf '%s\n' "$list" | grep -v '^$' | sort | uniq -d)"
    if [ -n "$dups" ]; then
        echo "FAIL: duplicate $label name(s): $(printf '%s' "$dups" | tr '\n' ' ')"
        fail=1
    fi
}

check_unique "procedure" "$defined_procedures"
check_unique "step" "$defined_steps"
check_unique "tier" "$defined_tiers"
check_unique "item" "$defined_items"

echo "Definitions: $(printf '%s\n' "$defined_procedures" | grep -c .) procedures, $(printf '%s\n' "$defined_steps" | grep -c .) steps, $(printf '%s\n' "$defined_tiers" | grep -c .) tiers, $(printf '%s\n' "$defined_items" | grep -c .) items."

check_refs() {
    local kind="$1" re="$2" defs="$3"
    local refs r
    refs="$(grep -hoE "$re" "${LIVE_FILES[@]}" 2>/dev/null \
        | sed -E 's/^(PROCEDURE|STEP|TIER|ITEM)[ -]//' \
        | sort -u)"
    for r in $refs; do
        if ! printf '%s\n' "$defs" | grep -qx "$r"; then
            echo "FAIL: $kind reference '$r' has no definition in AGENTS.md"
            fail=1
        fi
    done
}

check_refs "PROCEDURE" 'PROCEDURE [A-Z][A-Z-]+' "$defined_procedures"
check_refs "STEP" 'STEP[- ][A-Z][A-Z-]+' "$defined_steps"
check_refs "TIER" 'TIER [A-Z][A-Z-]+' "$defined_tiers"
check_refs "ITEM" 'ITEM [A-Z][A-Z-]+' "$defined_items"

# --- conformance: no letters or numbers in live references ---
if grep -nE '\bPROCEDURE [A-I]\b|\bProcedure [A-I]\b' "${LIVE_FILES[@]}" >/dev/null 2>&1; then
    echo "FAIL: letter-based procedure reference found in a live protocol file:"
    grep -nE '\bPROCEDURE [A-I]\b|\bProcedure [A-I]\b' "${LIVE_FILES[@]}"
    fail=1
fi
if grep -nE '\bTIER [0-9]\b' "${LIVE_FILES[@]}" >/dev/null 2>&1; then
    echo "FAIL: numeric tier reference found in a live protocol file:"
    grep -nE '\bTIER [0-9]\b' "${LIVE_FILES[@]}"
    fail=1
fi
if grep -nE '\bStep [0-9]\b' "${LIVE_FILES[@]}" >/dev/null 2>&1; then
    echo "FAIL: numeric step reference found in a live protocol file:"
    grep -nE '\bStep [0-9]\b' "${LIVE_FILES[@]}"
    fail=1
fi

if [ "$fail" -eq 0 ]; then
    echo "PASS: all references resolve and no letter or numeric references remain."
    exit 0
fi
exit 1

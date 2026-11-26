#!/bin/bash
# Dev-time wrapper: run the authoring validator over every policy, procedure, and AGENTS.md.
# Usage: ./tests/test-policy-shape.sh
# Exit 0 when the tree passes and a broken fixture fails, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

fail=0

policies=$(find "$ROOT/ai/policies" -maxdepth 1 -type f -name 'ai-policy-*.md' | wc -l)
procedures=$(find "$ROOT/ai/procedures" -maxdepth 1 -type f -name '*.md' | wc -l)

out="$(bash "$VALIDATOR" "$ROOT/AGENTS.md" "$ROOT"/ai/policies/ai-policy-*.md "$ROOT"/ai/procedures/*.md 2>&1)"
rc=$?
if [ "$rc" -ne 0 ]; then
    printf '%s\n' "$out"
    printf 'FAIL: the tree does not pass the authoring validator\n'
    fail=1
else
    printf 'PASS: %s policies and %s procedures pass the authoring validator\n' "$policies" "$procedures"
fi

mkdir -p "$WORK/ai/policies"
{
    printf '# DO NOT MODIFY THIS FILE\n\n'
    printf 'Broken fixture.\n'
} > "$WORK/ai/policies/ai-policy-broken.md"

out="$(bash "$VALIDATOR" "$WORK/ai/policies/ai-policy-broken.md" 2>&1)"
rc=$?
if [ "$rc" -eq 0 ]; then
    printf 'FAIL: the wrapper accepted a broken fixture\n'
    printf '%s\n' "$out"
    fail=1
else
    printf 'PASS: a broken fixture fails the wrapper\n'
fi

# --- Non-Negotiables index shape in the common policy ---
check_non_negotiables() {
    local file="$1" sec bytes item2 item3 long
    sec="$(awk '/^## Non-Negotiables/{f=1;next} f&&/^## /{exit} f' "$file")"
    if [ -z "$sec" ]; then
        printf 'FAIL: %s has no Non-Negotiables section\n' "$file"
        return 1
    fi
    bytes="$(printf '%s\n' "$sec" | wc -c | tr -d ' ')"
    if [ "$bytes" -gt 3000 ]; then
        printf 'FAIL: %s Non-Negotiables section is %s bytes, over the 3000 bound\n' "$file" "$bytes"
        return 1
    fi
    if printf '%s\n' "$sec" | grep -vqE '^([0-9]+\. |$)'; then
        printf 'FAIL: %s has a Non-Negotiables item that is not one line\n' "$file"
        return 1
    fi
    item2="$(printf '%s\n' "$sec" | grep -E '^2\. ' | tr -d '`' | sed 's/[[:space:]]*$//' || true)"
    item3="$(printf '%s\n' "$sec" | grep -E '^3\. ' | tr -d '`' | sed 's/[[:space:]]*$//' || true)"
    if [ "$item2" != '2. **Full file reads.** See Full File Reads in AGENTS.md TIER READ-FIRST-RULES.' ]; then
        printf 'FAIL: %s item 2 is not the exact pointer line: %s\n' "$file" "$item2"
        return 1
    fi
    if [ "$item3" != '3. **No truncated evidence.** See No Sliced Evidence in AGENTS.md TIER READ-FIRST-RULES.' ]; then
        printf 'FAIL: %s item 3 is not the exact pointer line: %s\n' "$file" "$item3"
        return 1
    fi
    long="$(printf '%s\n' "$sec" | awk 'length($0) > 240 {print NR ": " length($0)}')"
    if [ -n "$long" ]; then
        printf 'FAIL: %s has a Non-Negotiables item over 240 characters: %s\n' "$file" "$long"
        return 1
    fi
    return 0
}

if check_non_negotiables "$ROOT/ai/policies/ai-policy-common.md"; then
    printf 'PASS: the Non-Negotiables index is reference-only\n'
else
    fail=1
fi

mkdir -p "$WORK/neg"
{
    printf '## Non-Negotiables (read first, apply always)\n\n'
    printf '1. **Evidence-Based Investigation**: see the Investigation Contract below.\n'
    printf '2. **Full file reads.** Read every file you reason about in full, line 1 to EOF, and re-read from disk when a task needs it again (Full File Reads in AGENTS.md TIER READ-FIRST-RULES).\n'
    printf '3. **No truncated evidence.** See No Sliced Evidence in AGENTS.md TIER READ-FIRST-RULES.\n'
} > "$WORK/neg/item2.md"
if check_non_negotiables "$WORK/neg/item2.md" >/dev/null 2>&1; then
    printf 'FAIL: the check accepted a restating item 2\n'
    fail=1
else
    printf 'PASS: a restating item 2 fails the check\n'
fi

{
    printf '## Non-Negotiables (read first, apply always)\n\n'
    printf '1. **Evidence-Based Investigation**: see the Investigation Contract below.\n'
    printf '2. **Full file reads.** See Full File Reads in AGENTS.md TIER READ-FIRST-RULES.\n'
    printf '3. **No truncated evidence.** Never pipe investigation output through head, tail, or -N limits; count first, then read it all (No Sliced Evidence in AGENTS.md).\n'
} > "$WORK/neg/item3.md"
if check_non_negotiables "$WORK/neg/item3.md" >/dev/null 2>&1; then
    printf 'FAIL: the check accepted a restating item 3\n'
    fail=1
else
    printf 'PASS: a restating item 3 fails the check\n'
fi

{
    printf '## Non-Negotiables (read first, apply always)\n\n'
    printf '1. **Evidence-Based Investigation**: see the Investigation Contract below.\n'
    printf '2. **Full file reads.** Read every file you reason about in full and re-read from disk (Full File Reads in AGENTS.md TIER READ-FIRST-RULES).\n'
    printf '3. **No truncated evidence.** Do not use head or tail on investigation output (No Sliced Evidence in AGENTS.md).\n'
} > "$WORK/neg/paraphrase.md"
if check_non_negotiables "$WORK/neg/paraphrase.md" >/dev/null 2>&1; then
    printf 'FAIL: the check accepted a paraphrased restatement\n'
    fail=1
else
    printf 'PASS: a paraphrased restatement fails the check\n'
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: policy shape wrapper."
    exit 1
fi
echo "PASSED: policy shape wrapper."
exit 0

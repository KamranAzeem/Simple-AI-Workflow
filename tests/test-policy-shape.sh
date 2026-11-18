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

if [ "$fail" -ne 0 ]; then
    echo "FAILED: policy shape wrapper."
    exit 1
fi
echo "PASSED: policy shape wrapper."
exit 0

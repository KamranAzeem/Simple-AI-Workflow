#!/bin/bash
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
F="$ROOT/AGENTS.md"
fail=0

lines=$(wc -l < "$F")
words=$(wc -w < "$F")
bytes=$(wc -c < "$F")

[ "$lines" -le 160 ] || { echo "FAIL: AGENTS.md has $lines lines (cap 160)."; fail=1; }
[ "$words" -le 2400 ] || { echo "FAIL: AGENTS.md has $words words (cap 2,400)."; fail=1; }
[ "$bytes" -le 24900 ] || { echo "FAIL: AGENTS.md has $bytes bytes (cap 24,900)."; fail=1; }

while IFS= read -r line; do
    if [ "${#line}" -gt 600 ]; then
        echo "FAIL: AGENTS.md bullet over 600 characters: ${line:0:80}..."
        fail=1
    fi
done < <(grep -E '^[[:space:]]*- ' "$F")

if grep -q "sub-agents and role-based team members" "$F"; then
    echo "FAIL: AGENTS.md restates the single-writer mechanics; point at the common policy."
    fail=1
fi

for anchor in "## TIER CONFIGURATION" "## TIER READ-FIRST-RULES" "### Boot Scan Exclusions" "## Shared Protocol Steps" "## Protocol Dispatch" "## TIER TRIGGERED-PROCEDURES" "## TIER APPENDIX"; do
    if ! grep -qxF "$anchor" "$F"; then
        echo "FAIL: missing required section: $anchor"
        fail=1
    fi
done

if [ "$fail" -ne 0 ]; then
    echo "FAILED: AGENTS.md shape fixture."
    exit 1
fi
echo "PASSED: AGENTS.md shape fixture (lines, words, bytes, bullet length, one mechanics owner, sections)."
exit 0

#!/bin/bash
# README shape fixture for the restructured landing page.
# The README is user-facing, so this test pins the narrative, the shape,
# the counts, the team features, and the local links.
# Usage: ./tests/test-readme-shape.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
README="$ROOT/README.md"
GUIDE="$ROOT/docs/workflow-guide.md"
SETUP="$ROOT/docs/setup.md"

fail=0

pass() { printf 'PASS %s\n' "$1"; }

fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

present() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        pass "$label"
    else
        fail_case "$label"
    fi
}

absent() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        fail_case "$label"
    else
        pass "$label"
    fi
}

if [ ! -f "$README" ]; then
    echo "FAIL: README.md is missing."
    exit 1
fi

lines="$(wc -l < "$README")"
if [ "$lines" -le 250 ]; then
    pass "README is at most 250 lines"
else
    fail_case "README is $lines lines; the cap is 250"
fi

present "$README" "## Contents" "README has a table of contents"
present "$README" "Stop improvising with AI. Work the same predictable way every time." "README opens with the agreed promise"

for phrase in "project tickets" "diary" "HLD" "LLD" "acceptance tests" "verification" "bullets" "tables"; do
    present "$README" "$phrase" "README gap names: $phrase"
done

for phrase in "predictable" "reproducible" "auditable" "bootstrap"; do
    present "$README" "$phrase" "README fix names: $phrase"
done

for phrase in "load context using AGENTS.md protocol" "plan the issue" "implement the plan" "checkpoint"; do
    present "$README" "$phrase" "README flow names: $phrase"
done

for heading in "### Setup" "### Daily loop" "### Memory" "### Quality" "### Delivery" "### Maintenance" "### Team"; do
    present "$README" "$heading" "README group: $heading"
done

for phrase in "Team AI Directory" "Team AI Knowledge Repository" "knowledge/" "skills/" "trust boundary"; do
    present "$README" "$phrase" "README team feature: $phrase"
done
present "$README" "## Path migration in v7.7.0" "README has the v7.7.0 path migration section"
present "$README" "scope-migration-<date>" "README names the migration backup"

present "$README" "## What it is not" "README has the boundaries section"
present "$README" "Not a platform" "README boundary: platform"
present "$README" "Not a replacement" "README boundary: judgment"
present "$README" "Not a heavy install" "README boundary: install"
present "$README" "## Works with any assistant" "README has the secondary multi-assistant section"
present "$README" "26 policies" "README states the policy count"
present "$README" "16 procedures" "README states the procedure count"
present "$README" "59 triggers" "README states the trigger count"
present "$README" "v7.8.1" "README banner names v7.8.1"
present "$README" "The implementation request is the approval for the branch, the commits, the push, and the close sequence named in the plan's \`## Close Sequence\`" "README states the two-step approval"
present "$README" "This page describes the protocol. The protocol modules" "README states the protocol modules are authoritative"
present "$README" "## Docs and slides" "README has the docs index"
absent "$README" "you probably don't need this" "README drops the old one-assistant line"

present "$GUIDE" "## 25. Common Instructions" "guide has the full command list"
present "$GUIDE" "## 24. Skills" "guide has the skills section anchor"
present "$SETUP" "## Updating an Existing Project" "setup has the updating section"

while IFS= read -r link; do
    case "$link" in
        http*|mailto:*|'#'*) continue ;;
    esac
    target="${link%%#*}"
    [ -z "$target" ] && continue
    if [ -e "$ROOT/$target" ]; then
        pass "local link resolves: $target"
    else
        fail_case "local link missing: $target"
    fi
done < <(grep -oE '\]\([^)]+\)' "$README" | sed 's/^](//;s/)$//')

if [ "$fail" -ne 0 ]; then
    echo "FAILED: README shape fixture."
    exit 1
fi
echo "PASSED: README shape fixture (promise, gap, fix, flow, groups, team, boundaries, counts, links)."
exit 0

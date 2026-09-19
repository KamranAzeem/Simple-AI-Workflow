#!/usr/bin/env bash
# Regression test for sync-agents-md.sh customization-file handling.
# Builds throwaway projects in a temp directory and checks each layout.
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
SCRIPT="$DIR/sync-agents-md.sh"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

SRC="$WORK/src/AGENTS.md"
mkdir -p "$WORK/src"
printf '%s\n' "# Agents" > "$SRC"

fail=0
pass() { echo "  PASS: $1"; }
failmsg() { echo "  FAIL: $1"; fail=1; }

expect() {
  # expect <description> <condition...>
  local desc="$1"; shift
  if "$@"; then pass "$desc"; else failmsg "$desc"; fi
}

# --- Case 1: root ai-customization.md is a symlink to ai/ai-customization.md ---
p1="$WORK/root1/symlink"
mkdir -p "$p1/ai"
printf '%s\n' "# Agents" > "$p1/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- dba" > "$p1/ai/ai-customization.md"
ln -s "ai/ai-customization.md" "$p1/ai-customization.md"

echo "Case 1: root file is a symlink to the real file in ai/"
bash "$SCRIPT" --source "$SRC" --target-path "$WORK/root1" > "$WORK/case1.log" 2>&1
expect "root file is still a symlink" test -L "$p1/ai-customization.md"
expect "real file still exists" test -f "$p1/ai/ai-customization.md"
expect "real file not renamed to .bak" test ! -e "$p1/ai/ai-customization.md.bak"
expect "no .bak at project root" test ! -e "$p1/ai-customization.md.bak"
expect "config written to the real file" grep -qF "**Global AI Workflow Directory**: $WORK/src" "$p1/ai/ai-customization.md"
expect "symlink still resolves to the file" test -f "$p1/ai-customization.md"
expect "original content preserved" grep -qF "## Active Expertise" "$p1/ai/ai-customization.md"

# --- Case 2: normal regular root file, no config section ---
p2="$WORK/root2/normal"
mkdir -p "$p2"
printf '%s\n' "# Agents" > "$p2/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- web-frontend" > "$p2/ai-customization.md"

echo "Case 2: normal regular root file"
bash "$SCRIPT" --source "$SRC" --target-path "$WORK/root2" > "$WORK/case2.log" 2>&1
expect "root file is still regular (not a symlink)" test ! -L "$p2/ai-customization.md"
expect "config added" grep -qF "**Global AI Workflow Directory**: $WORK/src" "$p2/ai-customization.md"
expect "original content preserved" grep -qF -- "- web-frontend" "$p2/ai-customization.md"

# --- Case 3: legacy layout, no root file ---
p3="$WORK/root3/legacy"
mkdir -p "$p3/ai"
printf '%s\n' "# Agents" > "$p3/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- observability" > "$p3/ai/ai-customization.md"

echo "Case 3: legacy ai/ai-customization.md, no root file"
bash "$SCRIPT" --source "$SRC" --target-path "$WORK/root3" > "$WORK/case3.log" 2>&1
expect "file moved to project root" test -f "$p3/ai-customization.md"
expect "old location removed" test ! -e "$p3/ai/ai-customization.md"
expect "config added at root" grep -qF "**Global AI Workflow Directory**: $WORK/src" "$p3/ai-customization.md"

# --- Case 4: genuine conflict, old file plus regular root file ---
p4="$WORK/root4/conflict"
mkdir -p "$p4/ai"
printf '%s\n' "# Agents" > "$p4/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- accounting" > "$p4/ai/ai-customization.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- mobile" > "$p4/ai-customization.md"

echo "Case 4: old file plus regular root file (unchanged behavior)"
bash "$SCRIPT" --source "$SRC" --target-path "$WORK/root4" > "$WORK/case4.log" 2>&1
expect "old file renamed to .bak at project root" test -f "$p4/ai-customization.md.bak"
expect "old location removed" test ! -e "$p4/ai/ai-customization.md"
expect "root file left in place" grep -qF -- "- mobile" "$p4/ai-customization.md"

echo ""
if [ "$fail" -eq 0 ]; then
  echo "All checks passed."
else
  echo "Some checks failed."
fi
exit "$fail"

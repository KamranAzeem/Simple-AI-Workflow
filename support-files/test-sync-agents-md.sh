#!/usr/bin/env bash
# Regression test for sync-agents-md.sh customization, exclusion, and failure handling.
# Builds throwaway projects in a temp directory and checks each layout.
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
SCRIPT="$DIR/sync-agents-md.sh"
EXPECTED_WORKFLOW_DIR=$(cd "$DIR/.." && pwd -P)
WORK=$(mktemp -d)
cleanup() {
  chmod -R u+w "$WORK" 2>/dev/null || true
  rm -rf "$WORK"
}
trap cleanup EXIT

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
expect "config written to the real file" grep -qF "**Global AI Workflow Directory**: $EXPECTED_WORKFLOW_DIR" "$p1/ai/ai-customization.md"
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
expect "config added" grep -qF "**Global AI Workflow Directory**: $EXPECTED_WORKFLOW_DIR" "$p2/ai-customization.md"
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
expect "config added at root" grep -qF "**Global AI Workflow Directory**: $EXPECTED_WORKFLOW_DIR" "$p3/ai-customization.md"

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

# --- Case 5: self-exclusion, nested workflow tree, sibling, identical ---
clone="$WORK/self/target/Simple-AI-Workflow"
mkdir -p "$clone/support-files" "$clone/sub"
cp "$SCRIPT" "$clone/support-files/sync-agents-md.sh"
printf '%s\n' "# Clone" > "$clone/AGENTS.md"
printf '%s\n' "# Nested" > "$clone/sub/AGENTS.md"

project="$WORK/self/target/project"
mkdir -p "$project"
printf '%s\n' "# Project" > "$project/AGENTS.md"

identical="$WORK/self/target/project-identical"
mkdir -p "$identical"
cp "$clone/AGENTS.md" "$identical/AGENTS.md"

sibling="$WORK/self/target/Simple-AI-Workflow-Other"
mkdir -p "$sibling"
printf '%s\n' "# Sibling" > "$sibling/AGENTS.md"

echo "Case 5: self-exclusion, nested tree, sibling, identical"
set +e
bash "$clone/support-files/sync-agents-md.sh" --source "$clone/AGENTS.md" --target-path "$WORK/self/target" > "$WORK/case5.log" 2>&1
rc5=$?
set -e
expect "case 5 exit status 0" test "$rc5" -eq 0
expect "clone AGENTS.md unchanged" grep -qF "# Clone" "$clone/AGENTS.md"
expect "nested workflow AGENTS.md unchanged" grep -qF "# Nested" "$clone/sub/AGENTS.md"
expect "project AGENTS.md synced" grep -qF "# Clone" "$project/AGENTS.md"
expect "sibling AGENTS.md synced" grep -qF "# Clone" "$sibling/AGENTS.md"
expect "identical target reported up to date" grep -qF "AGENTS.md already up to date" "$WORK/case5.log"
expect "source skip logged" grep -qF "Skipping source file" "$WORK/case5.log"
expect "workflow tree skip logged" grep -qF "Skipping workflow file" "$WORK/case5.log"
expect "project config points at the clone" grep -qF "**Global AI Workflow Directory**: $clone" "$project/ai-customization.md"
expect "identical target still got customization" test -f "$identical/ai-customization.md"

# --- Case 6: dry-run makes no writes and previews both outcomes ---
dry_project="$WORK/dryrun/project"
mkdir -p "$dry_project"
printf '%s\n' "# Old" > "$dry_project/AGENTS.md"
dry_identical="$WORK/dryrun/identical"
mkdir -p "$dry_identical"
cp "$SRC" "$dry_identical/AGENTS.md"

echo "Case 6: dry-run"
bash "$SCRIPT" --source "$SRC" --target-path "$WORK/dryrun" --dry-run > "$WORK/case6.log" 2>&1
expect "dry-run project unchanged" grep -qF "# Old" "$dry_project/AGENTS.md"
expect "dry-run identical unchanged" cmp -s "$SRC" "$dry_identical/AGENTS.md"
expect "dry-run project has no customization file" test ! -e "$dry_project/ai-customization.md"
expect "dry-run identical has no customization file" test ! -e "$dry_identical/ai-customization.md"
expect "dry-run previews update" grep -qF "DRY-RUN: would update" "$WORK/case6.log"
expect "dry-run previews identical" grep -qF "AGENTS.md already up to date" "$WORK/case6.log"
expect "dry-run previews customization creation" grep -qF "creating with default configuration" "$WORK/case6.log"

# --- Case 7: failure isolation ---
if [ "$(id -u)" -eq 0 ]; then
  echo "Case 7: failure isolation skipped as root"
  pass "failure-isolation case skipped as root"
else
  mkdir -p "$WORK/fail/good" "$WORK/fail/bad"
  printf '%s\n' "# Good" > "$WORK/fail/good/AGENTS.md"
  printf '%s\n' "# Bad" > "$WORK/fail/bad/AGENTS.md"
  chmod 444 "$WORK/fail/bad/AGENTS.md"
  chmod 555 "$WORK/fail/bad"
  echo "Case 7: failure isolation"
  set +e
  bash "$SCRIPT" --source "$SRC" --target-path "$WORK/fail" > "$WORK/case7.log" 2>&1
  rc7=$?
  set -e
  expect "case 7 exit status 1" test "$rc7" -eq 1
  expect "failing target reported" grep -qF "FAILED: $WORK/fail/bad/AGENTS.md" "$WORK/case7.log"
  expect "good target processed after failure" grep -qF "# Agents" "$WORK/fail/good/AGENTS.md"
  expect "bad target unchanged" grep -qF "# Bad" "$WORK/fail/bad/AGENTS.md"
  chmod 755 "$WORK/fail/bad"
  chmod 644 "$WORK/fail/bad/AGENTS.md"
fi

# --- Case 8: source location ---
source_clone="$WORK/sourcecase/clone"
mkdir -p "$source_clone/support-files" "$source_clone/sub"
cp "$SCRIPT" "$source_clone/support-files/sync-agents-md.sh"
printf '%s\n' "# Clone" > "$source_clone/AGENTS.md"
printf '%s\n' "# SubSource" > "$source_clone/sub/AGENTS.md"
source_project="$WORK/sourcecase/target/project"
mkdir -p "$source_project"
printf '%s\n' "# Project" > "$source_project/AGENTS.md"

echo "Case 8a: source in a clone subdirectory"
bash "$source_clone/support-files/sync-agents-md.sh" --source "$source_clone/sub/AGENTS.md" --target-path "$WORK/sourcecase/target" > "$WORK/case8a.log" 2>&1
expect "subdirectory source synced" grep -qF "# SubSource" "$source_project/AGENTS.md"
expect "subdirectory source uses clone root" grep -qF "**Global AI Workflow Directory**: $source_clone" "$source_project/ai-customization.md"
expect "subdirectory source has no outside warning" bash -c "! grep -qF 'outside the workflow clone' '$WORK/case8a.log'"

outside="$WORK/sourcecase/outside"
mkdir -p "$outside"
printf '%s\n' "# Outside" > "$outside/AGENTS.md"
outside_project="$WORK/sourcecase/target2/project"
mkdir -p "$outside_project"
printf '%s\n' "# Project2" > "$outside_project/AGENTS.md"

echo "Case 8b: source outside the clone"
bash "$source_clone/support-files/sync-agents-md.sh" --source "$outside/AGENTS.md" --target-path "$WORK/sourcecase/target2" > "$WORK/case8b.log" 2>&1
expect "outside source synced" grep -qF "# Outside" "$outside_project/AGENTS.md"
expect "outside source warns" grep -qF "outside the workflow clone" "$WORK/case8b.log"
expect "outside source still uses clone root" grep -qF "**Global AI Workflow Directory**: $source_clone" "$outside_project/ai-customization.md"

# --- Case 9: symlinked target and unreadable subtree ---
symlink_target="$WORK/symlink/target/project"
mkdir -p "$symlink_target"
printf '%s\n' "# Project" > "$symlink_target/AGENTS.md"
ln -s "$WORK/symlink/target" "$WORK/symlink/link"
echo "Case 9a: symlinked target"
bash "$SCRIPT" --source "$SRC" --target-path "$WORK/symlink/link" > "$WORK/case9a.log" 2>&1
expect "symlinked target processed" grep -qF "# Agents" "$symlink_target/AGENTS.md"

if [ "$(id -u)" -eq 0 ]; then
  echo "Case 9b: unreadable subtree skipped as root"
  pass "unreadable-subtree case skipped as root"
else
  mkdir -p "$WORK/unreadable/target/good" "$WORK/unreadable/target/bad"
  printf '%s\n' "# Good" > "$WORK/unreadable/target/good/AGENTS.md"
  chmod 000 "$WORK/unreadable/target/bad"
  echo "Case 9b: unreadable subtree"
  set +e
  bash "$SCRIPT" --source "$SRC" --target-path "$WORK/unreadable/target" > "$WORK/case9b.log" 2>&1
  rc9=$?
  set -e
  expect "case 9b exit status 2" test "$rc9" -eq 2
  expect "readable target processed" grep -qF "# Agents" "$WORK/unreadable/target/good/AGENTS.md"
  expect "discovery warning printed" grep -qF "could not be read" "$WORK/case9b.log"
  chmod 755 "$WORK/unreadable/target/bad"
fi

echo ""
if [ "$fail" -eq 0 ]; then
  echo "All checks passed."
else
  echo "Some checks failed."
fi
exit "$fail"

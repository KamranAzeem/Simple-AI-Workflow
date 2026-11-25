#!/usr/bin/env bash
# Regression test for sync-agents-md.sh: initialization, key rewrite, project,
# user, and team migration, backups, collisions, dry-run, and failure isolation.
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
SCRIPT="$ROOT/support-files/sync-agents-md.sh"
EXPECTED_WORKFLOW_DIR="$ROOT"
WORK=$(mktemp -d)
export HOME="$WORK/home"
DATE=$(date +%Y-%m-%d)
# shellcheck disable=SC2329
cleanup() {
  chmod -R u+w "$WORK" 2>/dev/null || true
  rm -rf "$WORK"
}
trap cleanup EXIT
mkdir -p "$HOME/.ai/settings" "$HOME/.ai/backups"

SRC="$WORK/src/AGENTS.md"
mkdir -p "$WORK/src"
printf '%s\n' "# Agents" > "$SRC"

fail=0
pass() { echo "  PASS: $1"; }
failmsg() { echo "  FAIL: $1"; fail=1; }

expect() {
  local desc="$1"; shift
  if "$@"; then pass "$desc"; else failmsg "$desc"; fi
}

make_project() {
  local dir="$1"
  mkdir -p "$dir"
  printf '%s\n' "# Agents" > "$dir/AGENTS.md"
  printf '%s\n' "# AI Customization" "" "## AI Workflow Configuration" "" "**Workflow AI Directory**: $EXPECTED_WORKFLOW_DIR" "" "**User AI Directory**: $HOME/.ai/" "" "## Active Expertise" "- meta" > "$dir/ai-customization.md"
}

make_min_project() {
  local dir="$1"
  mkdir -p "$dir"
  printf '%s\n' "# Agents" > "$dir/AGENTS.md"
  printf '%s\n' "# AI Customization" "" "## Active Expertise" "- meta" > "$dir/ai-customization.md"
}

run_sync() {
  local target="$1" log="$2"
  shift 2
  set +e
  bash "$SCRIPT" --source "$SRC" --target-path "$target" "$@" > "$log" 2>&1
  local rc=$?
  set -e
  printf '%s\n' "$rc"
}

# --- Case 1: uninitialized target is refused and untouched ---
p1="$WORK/case1/project"
mkdir -p "$p1"
printf '%s\n' "# Agents" > "$p1/AGENTS.md"
printf '%s\n' "# old" > "$p1/keep.txt"
rc1=$(run_sync "$WORK/case1" "$WORK/case1.log")
expect "case 1 exits 1" test "$rc1" -eq 1
expect "case 1 explains bootstrap" grep -qF 'Uninitialized project. Run "bootstrap using AGENTS.md protocol".' "$WORK/case1.log"
expect "case 1 does not create customization" test ! -e "$p1/ai-customization.md"
expect "case 1 leaves AGENTS.md untouched" grep -qF "# Agents" "$p1/AGENTS.md"

# --- Case 2: symlinked customization is refused ---
p2="$WORK/case2/project"
mkdir -p "$p2/ai"
printf '%s\n' "# Agents" > "$p2/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- dba" > "$p2/ai/ai-customization.md"
ln -s "ai/ai-customization.md" "$p2/ai-customization.md"
rc2=$(run_sync "$WORK/case2" "$WORK/case2.log")
expect "case 2 exits 1" test "$rc2" -eq 1
expect "case 2 reports the symlink refusal" grep -qF "symlink; refusing to migrate" "$WORK/case2.log"
expect "case 2 leaves the symlink" test -L "$p2/ai-customization.md"
expect "case 2 leaves AGENTS.md untouched" grep -qF "# Agents" "$p2/AGENTS.md"

# --- Case 3: regular root customization, old keys and active expertise rewrite ---
p3="$WORK/case3/project"
mkdir -p "$p3"
printf '%s\n' "# Agents" > "$p3/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## AI Workflow Configuration" "" "**Global AI Workflow Directory**: /old/workflow" "" "**Global User AI Directory**: $HOME/.ai/" "" "## Active Expertise" "- global-settings" > "$p3/ai-customization.md"
rc3=$(run_sync "$WORK/case3" "$WORK/case3.log")
expect "case 3 exits 0" test "$rc3" -eq 0
expect "case 3 rewrites the workflow key" grep -qF "**Workflow AI Directory**: /old/workflow" "$p3/ai-customization.md"
expect "case 3 rewrites the user key" grep -qF "**User AI Directory**: $HOME/.ai/" "$p3/ai-customization.md"
expect "case 3 rewrites the expertise name" grep -qF -- "- user-settings" "$p3/ai-customization.md"
expect "case 3 adds Merge Policy" grep -qF "## Merge Policy" "$p3/ai-customization.md"
expect "case 3 syncs AGENTS.md" grep -qF "# Agents" "$p3/AGENTS.md"

# --- Case 4: legacy ai/ customization moves to the root ---
p4="$WORK/case4/project"
mkdir -p "$p4/ai"
printf '%s\n' "# Agents" > "$p4/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- observability" > "$p4/ai/ai-customization.md"
rc4=$(run_sync "$WORK/case4" "$WORK/case4.log")
expect "case 4 exits 0" test "$rc4" -eq 0
expect "case 4 moves the customization" test -f "$p4/ai-customization.md"
expect "case 4 removes the old file" test ! -e "$p4/ai/ai-customization.md"
expect "case 4 adds the new config key" grep -qF "**Workflow AI Directory**: $EXPECTED_WORKFLOW_DIR" "$p4/ai-customization.md"
expect "case 4 preserves the expertise" grep -qF -- "- observability" "$p4/ai-customization.md"

# --- Case 5: both files, the root file wins and the old file stays untouched ---
p5="$WORK/case5/project"
mkdir -p "$p5/ai"
printf '%s\n' "# Agents" > "$p5/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- accounting" > "$p5/ai/ai-customization.md"
printf '%s\n' "# AI Customization" "" "## AI Workflow Configuration" "" "**Workflow AI Directory**: $EXPECTED_WORKFLOW_DIR" "" "## Active Expertise" "- mobile" > "$p5/ai-customization.md"
rc5=$(run_sync "$WORK/case5" "$WORK/case5.log")
expect "case 5 exits 0" test "$rc5" -eq 0
expect "case 5 keeps the root expertise" grep -qF -- "- mobile" "$p5/ai-customization.md"
expect "case 5 leaves the old file" test -f "$p5/ai/ai-customization.md"
expect "case 5 makes no .bak" test ! -e "$p5/ai-customization.md.bak"

# --- Case 6: project knowledge, state, backup, and collision ---
p6="$WORK/case6/project"
make_project "$p6"
mkdir -p "$p6/ai/shared/project-knowledge" "$p6/ai/knowledge"
printf 'old lesson\n' > "$p6/ai/shared/project-knowledge/lesson-one.md"
printf 'old lesson\n' > "$p6/ai/shared/project-knowledge/collision.md"
printf 'existing\n' > "$p6/ai/knowledge/collision.md"
printf 'state\n' > "$p6/ai/progress.md"
printf '# template\n' > "$p6/ai/shared/project-knowledge/issue-template.md"
rc6=$(run_sync "$WORK/case6" "$WORK/case6.log")
expect "case 6 exits 0" test "$rc6" -eq 0
expect "case 6 moves the project lesson" test -f "$p6/ai/knowledge/lesson-one.md"
expect "case 6 moves the issue template" test -f "$p6/ai/knowledge/issue-template.md"
expect "case 6 removes the old project store" test ! -e "$p6/ai/shared/project-knowledge"
expect "case 6 backs up the project store" test -f "$p6/ai/artifacts/scope-migration-$DATE/project-knowledge/lesson-one.md"
expect "case 6 keeps the existing collision" grep -qx 'existing' "$p6/ai/knowledge/collision.md"
expect "case 6 writes the collision suffix" test -f "$p6/ai/knowledge/collision.md.migrated-$DATE"
expect "case 6 moves the state file" test -f "$p6/ai/state/progress.md"
expect "case 6 adds the migration note" grep -qF "[MIGRATION-$DATE]" "$p6/ai/state/progress.md"
six_before="$(find "$p6/ai/knowledge" -type f -exec sha256sum {} \; | sort)"
rc6b=$(run_sync "$WORK/case6" "$WORK/case6b.log")
six_after="$(find "$p6/ai/knowledge" -type f -exec sha256sum {} \; | sort)"
expect "case 6 second run exits 0" test "$rc6b" -eq 0
expect "case 6 second run is a no-op" test "$six_before" = "$six_after"

# --- Case 7: user knowledge, settings, skills, and backup ---
p7="$WORK/case7/project"
make_project "$p7"
mkdir -p "$HOME/.ai/global-knowledge" "$HOME/.ai/settings"
printf 'user lesson\n' > "$HOME/.ai/global-knowledge/user-lesson.md"
printf '# settings\n' > "$HOME/.ai/settings/global-user-settings.md"
printf 'existing settings\n' > "$HOME/.ai/settings/user-settings.md"
rc7=$(run_sync "$WORK/case7" "$WORK/case7.log")
expect "case 7 exits 0" test "$rc7" -eq 0
expect "case 7 moves the user lesson" test -f "$HOME/.ai/knowledge/user-lesson.md"
expect "case 7 removes the old user store" test ! -e "$HOME/.ai/global-knowledge"
expect "case 7 creates user skills" test -d "$HOME/.ai/skills"
expect "case 7 moves the settings file with a suffix" test -f "$HOME/.ai/settings/user-settings.md.migrated-$DATE"
expect "case 7 keeps the existing settings" grep -qx 'existing settings' "$HOME/.ai/settings/user-settings.md"
expect "case 7 backs up the user store" test -f "$HOME/.ai/backups/scope-migration-$DATE/user/user-lesson.md"
expect "case 7 keeps the repair backup exception" test -d "$HOME/.ai/backups"

# --- Case 8: team root key rewrite and merge from both old directories ---
p8="$WORK/case8/project"
make_project "$p8"
team="$WORK/case8/team"
mkdir -p "$team/team-knowledge" "$team/lessons"
printf 'from team-knowledge\n' > "$team/team-knowledge/a.md"
printf 'from lessons\n' > "$team/lessons/b.md"
printf '%s\n' "" "**Team AI Knowledge Directory**: $team" >> "$p8/ai-customization.md"
rc8=$(run_sync "$WORK/case8" "$WORK/case8.log")
expect "case 8 exits 0" test "$rc8" -eq 0
expect "case 8 rewrites the team root key" grep -qF "**Team AI Directory**: $team" "$p8/ai-customization.md"
expect "case 8 migrates team-knowledge" test -f "$team/knowledge/a.md"
expect "case 8 migrates lessons" test -f "$team/knowledge/b.md"
expect "case 8 removes the old team dirs" test ! -e "$team/team-knowledge" -a ! -e "$team/lessons"
expect "case 8 backs up the team store" test -f "$HOME/.ai/backups/scope-migration-$DATE/team/a.md"

# --- Case 9: unreachable user store degrades to PENDING ---
p9="$WORK/case9/project"
make_min_project "$p9"
printf '%s\n' "" "**User AI Directory**: $WORK/case9/missing" >> "$p9/ai-customization.md"
rc9=$(run_sync "$WORK/case9" "$WORK/case9.log")
expect "case 9 exits 0" test "$rc9" -eq 0
expect "case 9 reports PENDING" grep -qF "PENDING: user store unreachable" "$WORK/case9.log"

# --- Case 10: dry-run previews and writes nothing ---
p10="$WORK/case10/project"
make_project "$p10"
mkdir -p "$p10/ai/shared/project-knowledge"
printf 'old\n' > "$p10/ai/shared/project-knowledge/lesson.md"
rc10=$(run_sync "$WORK/case10" "$WORK/case10.log" --dry-run)
expect "case 10 exits 0" test "$rc10" -eq 0
expect "case 10 previews the backup" grep -qF "DRY-RUN: would copy the project knowledge store" "$WORK/case10.log"
expect "case 10 previews the move" grep -qF "DRY-RUN: would move" "$WORK/case10.log"
expect "case 10 writes no project store" test ! -e "$p10/ai/knowledge"
expect "case 10 writes no backup" test ! -e "$p10/ai/artifacts/scope-migration-$DATE"

# --- Case 11: failure isolation ---
if [ "$(id -u)" -eq 0 ]; then
  echo "Case 11: failure isolation skipped as root"
  pass "failure-isolation case skipped as root"
else
  good="$WORK/case11/good"
  bad="$WORK/case11/bad"
  make_project "$good"
  make_project "$bad"
  chmod 444 "$bad/AGENTS.md"
  chmod 555 "$bad"
  rc11=$(run_sync "$WORK/case11" "$WORK/case11.log")
  expect "case 11 exits 1" test "$rc11" -eq 1
  expect "case 11 reports the bad target" grep -qF "FAILED: $bad/AGENTS.md" "$WORK/case11.log"
  expect "case 11 processes the good target" grep -qF "# Agents" "$good/AGENTS.md"
  expect "case 11 leaves the bad AGENTS.md" grep -qF "# Agents" "$bad/AGENTS.md"
  chmod 755 "$bad"
  chmod 644 "$bad/AGENTS.md"
fi

# --- Case 12: symlinked store root is refused ---
p12="$WORK/case12/project"
make_project "$p12"
mkdir -p "$p12/ai/shared" "$WORK/case12/real-store"
printf 'lesson\n' > "$WORK/case12/real-store/lesson.md"
ln -s "$WORK/case12/real-store" "$p12/ai/shared/project-knowledge"
rc12=$(run_sync "$WORK/case12" "$WORK/case12.log")
expect "case 12 exits 1" test "$rc12" -eq 1
expect "case 12 reports the store symlink" grep -qF "refusing symlinked project knowledge store root" "$WORK/case12.log"
expect "case 12 leaves the symlink store" test -L "$p12/ai/shared/project-knowledge"

# --- Case 13: self-exclusion, nested workflow tree, sibling, identical ---
clone="$WORK/self/target/Simple-AI-Workflow"
mkdir -p "$clone/support-files" "$clone/sub"
cp "$SCRIPT" "$clone/support-files/sync-agents-md.sh"
cp "$ROOT/support-files/path-probe.sh" "$clone/support-files/path-probe.sh"
printf '%s\n' "# Clone" > "$clone/AGENTS.md"
printf '%s\n' "# Nested" > "$clone/sub/AGENTS.md"
project="$WORK/self/target/project"
make_min_project "$project"
identical="$WORK/self/target/project-identical"
mkdir -p "$identical"
cp "$clone/AGENTS.md" "$identical/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## AI Workflow Configuration" "" "**Workflow AI Directory**: $clone" > "$identical/ai-customization.md"
sibling="$WORK/self/target/Simple-AI-Workflow-Other"
make_min_project "$sibling"
set +e
bash "$clone/support-files/sync-agents-md.sh" --source "$clone/AGENTS.md" --target-path "$WORK/self/target" > "$WORK/case13.log" 2>&1
rc13=$?
set -e
expect "case 13 exits 0" test "$rc13" -eq 0
expect "case 13 leaves the clone AGENTS.md" grep -qF "# Clone" "$clone/AGENTS.md"
expect "case 13 leaves the nested AGENTS.md" grep -qF "# Nested" "$clone/sub/AGENTS.md"
expect "case 13 syncs the project" grep -qF "# Clone" "$project/AGENTS.md"
expect "case 13 syncs the sibling" grep -qF "# Clone" "$sibling/AGENTS.md"
expect "case 13 reports identical" grep -qF "AGENTS.md already up to date" "$WORK/case13.log"
expect "case 13 logs the source skip" grep -qF "Skipping source file" "$WORK/case13.log"
expect "case 13 logs the workflow skip" grep -qF "Skipping workflow file" "$WORK/case13.log"
expect "case 13 uses the clone root for the project" grep -qF "**Workflow AI Directory**: $clone" "$project/ai-customization.md"

# --- Case 14: source location ---
source_clone="$WORK/sourcecase/clone"
mkdir -p "$source_clone/support-files" "$source_clone/sub"
cp "$SCRIPT" "$source_clone/support-files/sync-agents-md.sh"
cp "$ROOT/support-files/path-probe.sh" "$source_clone/support-files/path-probe.sh"
printf '%s\n' "# Clone" > "$source_clone/AGENTS.md"
printf '%s\n' "# SubSource" > "$source_clone/sub/AGENTS.md"
source_project="$WORK/sourcecase/target/project"
make_min_project "$source_project"
# The copied script resolves its own clone root from its location.
set +e
bash "$source_clone/support-files/sync-agents-md.sh" --source "$source_clone/sub/AGENTS.md" --target-path "$WORK/sourcecase/target" > "$WORK/case14.log" 2>&1
rc14=$?
set -e
expect "case 14 exits 0" test "$rc14" -eq 0
expect "case 14 syncs the subdirectory source" grep -qF "# SubSource" "$source_project/AGENTS.md"
expect "case 14 uses the clone root" grep -qF "**Workflow AI Directory**: $source_clone" "$source_project/ai-customization.md"

echo ""
if [ "$fail" -eq 0 ]; then
  echo "All checks passed."
else
  echo "Some checks failed."
fi
exit "$fail"

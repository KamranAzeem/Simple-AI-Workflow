#!/usr/bin/env bash
# Regression test for backup-ai.sh: discovery markers, archives, restore, safety,
# dry run, failure isolation, and exit codes.
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
SCRIPT="$ROOT/support-files/backup-ai.sh"
WORK=$(mktemp -d)
# shellcheck disable=SC2329
cleanup() {
  chmod -R u+w "$WORK" 2>/dev/null || true
  rm -rf "$WORK"
}
trap cleanup EXIT

fail=0
pass() { echo "  PASS: $1"; }
failmsg() { echo "  FAIL: $1"; fail=1; }
expect() {
  local desc="$1"; shift
  if "$@"; then pass "$desc"; else failmsg "$desc"; fi
}
add_custom() {
  mkdir -p "$1"
  printf '%s\n' "# AI Customization" > "$1/ai-customization.md"
}
add_state_shared() {
  mkdir -p "$1/ai/state" "$1/ai/shared"
  printf '%s\n' "state" > "$1/ai/state/next-steps.md"
  printf '%s\n' "shared" > "$1/ai/shared/coordination.md"
}
archive_for() { find "$1" -maxdepth 1 -name '*.tar.gz' -print | head -n 1; }

run_ok() {
  local log="$1"; shift
  bash "$SCRIPT" "$@" > "$log" 2>&1
}

# --- Case 1: customization-only project ---
p1="$WORK/c1/root/project"
mkdir -p "$p1/ai/notes"
printf '%s\n' "note" > "$p1/ai/notes/a.md"
add_custom "$p1"
run_ok "$WORK/c1.log" --target-path "$WORK/c1" --backup-dir "$WORK/b1"
arch1=$(archive_for "$WORK/b1")
expect "case 1 exit 0" test -n "$arch1"
expect "case 1 name pattern" bash -c "printf '%s' '$arch1' | grep -qE '/root_project_[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}\\.tar\\.gz$'"
expect "case 1 has ai file" bash -c "tar -tzf '$arch1' | grep -qx 'ai/notes/a.md'"
expect "case 1 has customization" bash -c "tar -tzf '$arch1' | grep -qx 'ai-customization.md'"
mkdir -p "$WORK/c1-restore"
tar -xzf "$arch1" -C "$WORK/c1-restore"
expect "case 1 restores customization" grep -qF "# AI Customization" "$WORK/c1-restore/ai-customization.md"

# --- Case 2: state and shared, no customization ---
p2="$WORK/c2/parent/project"
add_state_shared "$p2"
run_ok "$WORK/c2.log" --target-path "$WORK/c2" --backup-dir "$WORK/b2"
arch2=$(archive_for "$WORK/b2")
expect "case 2 archived" test -n "$arch2"
expect "case 2 has state" bash -c "tar -tzf '$arch2' | grep -qx 'ai/state/next-steps.md'"
expect "case 2 has shared" bash -c "tar -tzf '$arch2' | grep -qx 'ai/shared/coordination.md'"

# --- Case 3: unrelated ai/ is not a project ---
p3="$WORK/c3/parent/project"
mkdir -p "$p3/ai/model"
printf '%s\n' "x" > "$p3/ai/model/weights.bin"
run_ok "$WORK/c3.log" --target-path "$WORK/c3" --backup-dir "$WORK/b3"
expect "case 3 no archive" test -z "$(archive_for "$WORK/b3" 2>/dev/null || true)"
expect "case 3 reports none" grep -qF "No projects found" "$WORK/c3.log"

# --- Case 4: the workflow clone is skipped ---
clone="$WORK/c4/Simple-AI-Workflow"
mkdir -p "$clone/support-files"
cp "$SCRIPT" "$clone/support-files/backup-ai.sh"
add_custom "$clone"
add_state_shared "$clone"
sibling="$WORK/c4/sibling"
add_custom "$sibling"
bash "$clone/support-files/backup-ai.sh" --target-path "$WORK/c4" --backup-dir "$WORK/b4" > "$WORK/c4.log" 2>&1
arch4=$(archive_for "$WORK/b4")
expect "case 4 sibling archived" test -n "$arch4"
expect "case 4 clone skipped" bash -c "! printf '%s\n' '$arch4' | grep -q 'Simple-AI-Workflow'"
expect "case 4 one archive" test "$(find "$WORK/b4" -name '*.tar.gz' | wc -l | tr -d ' ')" -eq 1

# --- Case 5: do not rescan inside a matched project ---
p5="$WORK/c5/outer"
add_custom "$p5"
child="$p5/nested"
add_state_shared "$child"
run_ok "$WORK/c5.log" --target-path "$WORK/c5" --backup-dir "$WORK/b5"
expect "case 5 one archive" test "$(find "$WORK/b5" -name '*.tar.gz' | wc -l | tr -d ' ')" -eq 1
expect "case 5 outer archived" bash -c "find '$WORK/b5' -name '*_outer_*.tar.gz' | grep -q ."

# --- Case 6: .git is not descended ---
p6="$WORK/c6/repo/.git/hidden"
add_state_shared "$p6"
run_ok "$WORK/c6.log" --target-path "$WORK/c6" --backup-dir "$WORK/b6"
expect "case 6 no archive" test -z "$(archive_for "$WORK/b6" 2>/dev/null || true)"

# --- Case 7: default directory creation, reuse, and dry-run ---
home1="$WORK/home1"
home2="$WORK/home2"
mkdir -p "$home1" "$home2"
p7="$WORK/c7/project"
add_custom "$p7"
HOME="$home1" bash "$SCRIPT" --target-path "$WORK/c7" > "$WORK/c7a.log" 2>&1
expect "case 7 default dir created" test -d "$home1/.ai/backups"
expect "case 7 creation reported" grep -qF "Created backup directory" "$WORK/c7a.log"
rm -f "$home1/.ai/backups"/*.tar.gz
HOME="$home1" bash "$SCRIPT" --target-path "$WORK/c7" > "$WORK/c7b.log" 2>&1
expect "case 7 default dir reused" bash -c "! grep -qF 'Created backup directory' '$WORK/c7b.log'"
HOME="$home2" bash "$SCRIPT" --target-path "$WORK/c7" --dry-run > "$WORK/c7c.log" 2>&1
expect "case 7 dry run writes nothing" test ! -e "$home2/.ai/backups"
expect "case 7 dry run lists project" grep -qF "DRY-RUN: would archive" "$WORK/c7c.log"

# --- Case 8: secrets included by default and excluded on request ---
p8="$WORK/c8/project"
mkdir -p "$p8/ai/secrets"
printf '%s\n' "token" > "$p8/ai/secrets/token.txt"
printf '%s\n' "keep" > "$p8/ai/keep.txt"
add_custom "$p8"
run_ok "$WORK/c8.log" --target-path "$WORK/c8" --backup-dir "$WORK/b8"
arch8=$(archive_for "$WORK/b8")
expect "case 8 secret included" bash -c "tar -tzf '$arch8' | grep -qx 'ai/secrets/token.txt'"
run_ok "$WORK/c8b.log" --target-path "$WORK/c8" --backup-dir "$WORK/b8b" --exclude-secrets
arch8b=$(archive_for "$WORK/b8b")
expect "case 8 secret excluded" bash -c "! tar -tzf '$arch8b' | grep -q 'ai/secrets'"
expect "case 8 normal file included" bash -c "tar -tzf '$arch8b' | grep -qx 'ai/keep.txt'"

# --- Case 9: symlinked customization is dereferenced ---
p9="$WORK/c9/project"
mkdir -p "$p9/ai"
printf '%s\n' "# Real Custom" > "$p9/ai/ai-customization.md"
ln -s "ai/ai-customization.md" "$p9/ai-customization.md"
run_ok "$WORK/c9.log" --target-path "$WORK/c9" --backup-dir "$WORK/b9"
arch9=$(archive_for "$WORK/b9")
expect "case 9 customization is regular" bash -c "tar -tvzf '$arch9' | grep -q '^-.* ai-customization.md$'"
mkdir -p "$WORK/c9-restore"
tar -xzf "$arch9" -C "$WORK/c9-restore"
expect "case 9 content restored" grep -qF "# Real Custom" "$WORK/c9-restore/ai-customization.md"

# --- Case 10: no overwrite ---
mkdir -p "$WORK/bin"
printf '%s\n' '#!/bin/sh' "printf '%s\\n' '2026-01-01_00-00'" > "$WORK/bin/date"
chmod +x "$WORK/bin/date"
p10="$WORK/c10/project"
add_custom "$p10"
PATH="$WORK/bin:$PATH" bash "$SCRIPT" --target-path "$WORK/c10" --backup-dir "$WORK/b10" > "$WORK/c10a.log" 2>&1
set +e
PATH="$WORK/bin:$PATH" bash "$SCRIPT" --target-path "$WORK/c10" --backup-dir "$WORK/b10" > "$WORK/c10b.log" 2>&1
rc10=$?
set -e
expect "case 10 second run exits 1" test "$rc10" -eq 1
expect "case 10 collision reported" grep -qF "archive already exists" "$WORK/c10b.log"
expect "case 10 one archive" test "$(find "$WORK/b10" -name '*.tar.gz' | wc -l | tr -d ' ')" -eq 1

# --- Case 11: broken symlink fails one project only ---
p11="$WORK/c11/good"
add_custom "$p11"
bad="$WORK/c11/bad"
mkdir -p "$bad"
ln -s "missing.md" "$bad/ai-customization.md"
set +e
bash "$SCRIPT" --target-path "$WORK/c11" --backup-dir "$WORK/b11" > "$WORK/c11.log" 2>&1
rc11=$?
set -e
expect "case 11 exits 1" test "$rc11" -eq 1
expect "case 11 good project archived" bash -c "find '$WORK/b11' -name '*_good_*.tar.gz' | grep -q ."
expect "case 11 broken link reported" grep -qF "cannot read the customization file" "$WORK/c11.log"

# --- Case 12: argument and path errors exit 2 ---
set +e
bash "$SCRIPT" --target-path "$WORK/missing" > "$WORK/c12a.log" 2>&1; rc12a=$?
bash "$SCRIPT" --target-path > "$WORK/c12b.log" 2>&1; rc12b=$?
bash "$SCRIPT" --target-path "$WORK" --backup-dir > "$WORK/c12c.log" 2>&1; rc12c=$?
bash "$SCRIPT" --help > "$WORK/c12d.log" 2>&1; rc12d=$?
set -e
expect "case 12 missing target exits 2" test "$rc12a" -eq 2
expect "case 12 missing value exits 2" test "$rc12b" -eq 2
expect "case 12 missing backup value exits 2" test "$rc12c" -eq 2
expect "case 12 help exits 0" test "$rc12d" -eq 0

# --- Case 13: partial discovery failure ---
if [ "$(id -u)" -eq 0 ]; then
  echo "Case 13: partial discovery skipped as root"
  pass "partial discovery skipped as root"
else
  good="$WORK/c13/good"
  add_custom "$good"
  mkdir -p "$WORK/c13/bad"
  chmod 000 "$WORK/c13/bad"
  set +e
  bash "$SCRIPT" --target-path "$WORK/c13" --backup-dir "$WORK/b13" > "$WORK/c13.log" 2>&1
  rc13=$?
  set -e
  chmod 755 "$WORK/c13/bad"
  expect "case 13 exits 2" test "$rc13" -eq 2
  expect "case 13 good project archived" bash -c "find '$WORK/b13' -name '*_good_*.tar.gz' | grep -q ."
  expect "case 13 warning printed" grep -qF "could not be read" "$WORK/c13.log"
fi

# --- Case 14: owner-only mode ---
p14="$WORK/c14/project"
add_custom "$p14"
run_ok "$WORK/c14.log" --target-path "$WORK/c14" --backup-dir "$WORK/b14"
arch14=$(archive_for "$WORK/b14")
expect "case 14 mode 600" bash -c "find '$arch14' -perm 600 -print | grep -q ."

# --- Case 15: spaces in parent and project names ---
p15="$WORK/c15/parent with space/project name"
add_custom "$p15"
run_ok "$WORK/c15.log" --target-path "$WORK/c15" --backup-dir "$WORK/b15"
arch15=$(archive_for "$WORK/b15")
expect "case 15 archive exists" test -n "$arch15"
expect "case 15 name sanitized" bash -c "printf '%s' '$arch15' | grep -q 'parent_with_space_project_name_'"
mkdir -p "$WORK/c15-restore"
tar -xzf "$arch15" -C "$WORK/c15-restore"
expect "case 15 restores" test -f "$WORK/c15-restore/ai-customization.md"

# --- Case 16: the search path itself is a project ---
p16="$WORK/c16"
add_custom "$p16"
run_ok "$WORK/c16.log" --target-path "$WORK/c16" --backup-dir "$WORK/b16"
expect "case 16 archived" test -n "$(archive_for "$WORK/b16")"

# --- Case 17: backup directory with a space ---
p17="$WORK/c17/project"
add_custom "$p17"
run_ok "$WORK/c17.log" --target-path "$WORK/c17" --backup-dir "$WORK/back up"
expect "case 17 archived" test -n "$(archive_for "$WORK/back up")"

# --- Case 18: heavy directories are pruned ---
p18="$WORK/c18/node_modules/fake-project"
add_state_shared "$p18"
run_ok "$WORK/c18.log" --target-path "$WORK/c18" --backup-dir "$WORK/b18"
expect "case 18 pruned project not archived" test -z "$(archive_for "$WORK/b18" 2>/dev/null || true)"
expect "case 18 reports none" grep -qF "No projects found" "$WORK/c18.log"

# --- Case 19: progress lines ---
expect "case 19 scanning line" grep -qF "Scanning" "$WORK/c1.log"
expect "case 19 found line" grep -qF "Found project:" "$WORK/c1.log"
expect "case 19 discovery complete line" grep -qF "Discovery complete:" "$WORK/c1.log"
expect "case 19 backing up line" grep -qF "Backing up:" "$WORK/c1.log"
expect "case 19 summary line" grep -qF "Summary:" "$WORK/c1.log"

# --- Case 20: unavailable POSIX mode check keeps the archive ---
p20="$WORK/c20/project"
add_custom "$p20"
BACKUP_AI_POSIX_MODES=0 bash "$SCRIPT" --target-path "$WORK/c20" --backup-dir "$WORK/b20" > "$WORK/c20.log" 2>&1
arch20=$(archive_for "$WORK/b20")
expect "case 20 archive kept" test -n "$arch20"
expect "case 20 unavailable notice" grep -qF "ACL verification unavailable" "$WORK/c20.log"

# --- Case 21: tar failure prints its cause ---
mkdir -p "$WORK/binfail"
printf '%s\n' '#!/bin/sh' 'printf "%s\n" "fake tar exploded" >&2' 'exit 1' > "$WORK/binfail/tar"
chmod +x "$WORK/binfail/tar"
p21="$WORK/c21/project"
add_custom "$p21"
set +e
PATH="$WORK/binfail:$PATH" bash "$SCRIPT" --target-path "$WORK/c21" --backup-dir "$WORK/b21" > "$WORK/c21.log" 2>&1
rc21=$?
set -e
expect "case 21 exits 1" test "$rc21" -eq 1
expect "case 21 tar cause printed" grep -qF "fake tar exploded" "$WORK/c21.log"
expect "case 21 no archive" test -z "$(archive_for "$WORK/b21" 2>/dev/null || true)"

# --- Case 22: summary counts ---
expect "case 22 mixed summary" grep -qF "Summary: 1 archived, 1 failed" "$WORK/c11.log"

echo ""
if [ "$fail" -eq 0 ]; then
  echo "All checks passed."
else
  echo "Some checks failed."
fi
exit "$fail"

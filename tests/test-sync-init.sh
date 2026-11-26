#!/usr/bin/env bash
# shellcheck disable=SC2329
# Fixture for sync-agents-md.sh --init: success, refusals, packaging errors,
# dry run, idempotence, rollback, docs, and static Bash/PowerShell parity.
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
SCRIPT="$ROOT/support-files/sync-agents-md.sh"
PS_SCRIPT="$ROOT/support-files/sync-agents-md.ps1"
PRESETS="$ROOT/docs/examples/customization-presets"
WORK=$(mktemp -d)
LOG="$WORK/log.txt"
fail=0

pass() { echo "  PASS: $1"; }
failmsg() { echo "  FAIL: $1"; fail=1; }
expect() { local d="$1"; shift; if "$@" >/dev/null 2>&1; then pass "$d"; else failmsg "$d"; fi; }
absent() { ! grep -qF -- "$2" "$1"; }
neither() { [ ! -e "$1" ] && [ ! -e "$2" ]; }

cleanup() { chmod -R u+w "$WORK" 2>/dev/null || true; rm -rf "$WORK"; }
trap cleanup EXIT

run_init() {
  local target="$1"; shift
  set +e
  bash "$SCRIPT" --init --target-path "$target" "$@" > "$LOG" 2>&1
  local rc=$?
  set -e
  printf '%s\n' "$rc"
}

run_args() {
  set +e
  bash "$SCRIPT" "$@" > "$LOG" 2>&1
  local rc=$?
  set -e
  printf '%s\n' "$rc"
}

roles="cloud-architect solution-architect web-developer mobile-developer platform-engineer dba data-engineer security-engineer"

expected_customization() {
  local role="$1" dest="$2"
  awk -v wf="$ROOT" '$0 == "**Workflow AI Directory**: /path/to/Simple-AI-Workflow" { print "**Workflow AI Directory**: " wf; next } { print }' "$PRESETS/$role.md" > "$dest"
}

make_clone() {
  local clone="$1"
  mkdir -p "$clone/support-files" "$clone/docs/examples/customization-presets"
  cp "$SCRIPT" "$clone/support-files/sync-agents-md.sh"
  cp "$ROOT/AGENTS.md" "$clone/AGENTS.md"
  cp "$PRESETS"/*.md "$clone/docs/examples/customization-presets/"
}

run_clone() {
  local clone="$1"; shift
  set +e
  bash "$clone/support-files/sync-agents-md.sh" --init "$@" > "$LOG" 2>&1
  local rc=$?
  set -e
  printf '%s\n' "$rc"
}

# --- Case 1: all eight roles scaffold ---
for role in $roles; do
  t="$WORK/roles/$role"
  mkdir -p "$t/sub"
  printf 'keep\n' > "$t/keep.txt"
  printf 'sub\n' > "$t/sub/keep.txt"
  keep_before=$(sha256sum "$t/keep.txt" | awk '{print $1}')
  sub_before=$(find "$t/sub" -type f -exec sha256sum {} \; | sort)
  rc=$(run_init "$t" --role "$role")
  expect "role $role exits 0" test "$rc" -eq 0
  expect "role $role writes AGENTS.md" test -f "$t/AGENTS.md"
  expect "role $role copies AGENTS.md exactly" cmp -s "$ROOT/AGENTS.md" "$t/AGENTS.md"
  expect "role $role writes customization" test -f "$t/ai-customization.md"
  expected_customization "$role" "$WORK/expected-$role.md"
  expect "role $role transforms the preset exactly" cmp -s "$WORK/expected-$role.md" "$t/ai-customization.md"
  expect "role $role has no Default Shell" absent "$t/ai-customization.md" '**Default Shell**:'
  expect "role $role has the workflow path" grep -qF "**Workflow AI Directory**: $ROOT" "$t/ai-customization.md"
  expect "role $role keeps the user path" grep -qF '**User AI Directory**: [HOME]/.ai/' "$t/ai-customization.md"
  expect "role $role has no placeholder" absent "$t/ai-customization.md" '/path/to/Simple-AI-Workflow'
  expect "role $role writes no ai directory" test ! -e "$t/ai"
  expect "role $role keeps unrelated hash" test "$(sha256sum "$t/keep.txt" | awk '{print $1}')" = "$keep_before"
  expect "role $role keeps subdir content" test "$(find "$t/sub" -type f -exec sha256sum {} \; | sort)" = "$sub_before"
done
expect "web-developer mode 0644 on AGENTS.md" test "$(stat -c '%a' "$WORK/roles/web-developer/AGENTS.md")" = "644"
expect "web-developer mode 0644 on customization" test "$(stat -c '%a' "$WORK/roles/web-developer/ai-customization.md")" = "644"
expect "platform-engineer keeps the MD044 comment" grep -qF 'markdownlint-disable MD044' "$WORK/roles/platform-engineer/ai-customization.md"
expect "platform-engineer keeps the plain linux token" grep -qxF -- '- linux-system-admin' "$WORK/roles/platform-engineer/ai-customization.md"

# --- Case 2: dry run ---
t="$WORK/dry"; mkdir -p "$t"
rc=$(run_init "$t" --role web-developer --dry-run)
expect "dry run exits 0" test "$rc" -eq 0
expect "dry run writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"
expect "dry run lists AGENTS write" grep -qF "Would write: $t/AGENTS.md" "$LOG"
expect "dry run lists customization write" grep -qF "Would write: $t/ai-customization.md" "$LOG"
expect "dry run prints the bootstrap hint" grep -qF 'bootstrap using AGENTS.md protocol' "$LOG"

# --- Case 3: existing regular AGENTS.md ---
t="$WORK/existing-agents"; mkdir -p "$t"; printf 'old\n' > "$t/AGENTS.md"
rc=$(run_init "$t" --role web-developer)
expect "existing AGENTS.md exits 1" test "$rc" -eq 1
expect "existing AGENTS.md named" grep -qF "Refusing to initialize: $t/AGENTS.md already exists." "$LOG"
expect "existing AGENTS.md leaves customization absent" test ! -e "$t/ai-customization.md"
expect "existing AGENTS.md unchanged" grep -qx 'old' "$t/AGENTS.md"

# --- Case 4: existing regular customization ---
t="$WORK/existing-custom"; mkdir -p "$t"; printf 'old\n' > "$t/ai-customization.md"
rc=$(run_init "$t" --role web-developer)
expect "existing customization exits 1" test "$rc" -eq 1
expect "existing customization named" grep -qF "Refusing to initialize: $t/ai-customization.md already exists." "$LOG"
expect "existing customization leaves AGENTS absent" test ! -e "$t/AGENTS.md"

# --- Case 5: both root files exist ---
t="$WORK/both"; mkdir -p "$t"; printf 'a\n' > "$t/AGENTS.md"; printf 'c\n' > "$t/ai-customization.md"
rc=$(run_init "$t" --role web-developer)
expect "both existing exits 1" test "$rc" -eq 1
expect "both existing names AGENTS" grep -qF "Refusing to initialize: $t/AGENTS.md already exists." "$LOG"
expect "both existing names customization" grep -qF "Refusing to initialize: $t/ai-customization.md already exists." "$LOG"

# --- Case 6: dangling symlink AGENTS.md ---
t="$WORK/symlink-agents"; mkdir -p "$t"; ln -s missing "$t/AGENTS.md"
rc=$(run_init "$t" --role web-developer)
expect "symlink AGENTS exits 2" test "$rc" -eq 2
expect "symlink AGENTS named" grep -qF "Refusing to initialize: $t/AGENTS.md is a symlink." "$LOG"
expect "symlink AGENTS stays a symlink" test -L "$t/AGENTS.md"
expect "symlink AGENTS leaves customization absent" test ! -e "$t/ai-customization.md"

# --- Case 7: symlink customization ---
t="$WORK/symlink-custom"; mkdir -p "$t"; printf 'x\n' > "$WORK/real-custom"; ln -s "$WORK/real-custom" "$t/ai-customization.md"
rc=$(run_init "$t" --role web-developer)
expect "symlink customization exits 2" test "$rc" -eq 2
expect "symlink customization named" grep -qF "Refusing to initialize: $t/ai-customization.md is a symlink." "$LOG"
expect "symlink customization leaves AGENTS absent" test ! -e "$t/AGENTS.md"
expect "symlink customization stays a symlink" test -L "$t/ai-customization.md"
expect "symlink customization keeps the link target" test "$(readlink "$t/ai-customization.md")" = "$WORK/real-custom"
expect "symlink customization keeps the target file" grep -qx 'x' "$WORK/real-custom"

# --- Case 7b: mixed regular and symlink ---
t="$WORK/mixed"; mkdir -p "$t"; printf 'a\n' > "$t/AGENTS.md"; printf 'x\n' > "$WORK/real-mixed"; ln -s "$WORK/real-mixed" "$t/ai-customization.md"
rc=$(run_init "$t" --role web-developer)
expect "mixed root paths exit 2" test "$rc" -eq 2
expect "mixed root paths name AGENTS" grep -qF "Refusing to initialize: $t/AGENTS.md already exists." "$LOG"
expect "mixed root paths name customization" grep -qF "Refusing to initialize: $t/ai-customization.md is a symlink." "$LOG"

# --- Case 8: unknown role ---
t="$WORK/unknown"; mkdir -p "$t"
rc=$(run_init "$t" --role not-a-role)
expect "unknown role exits 2" test "$rc" -eq 2
expect "unknown role named" grep -qF 'Unknown role: not-a-role' "$LOG"
expect "unknown role lists presets" grep -qF 'Available presets: cloud-architect solution-architect web-developer mobile-developer platform-engineer dba data-engineer security-engineer' "$LOG"
expect "unknown role writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"

# --- Case 9: path traversal values ---
for bad in '../cloud-architect' 'cloud/architect' '.' '..' 'Web-Developer'; do
  t="$WORK/traversal-$(printf '%s' "$bad" | tr '/.' '__')"; mkdir -p "$t"
  rc=$(run_init "$t" --role "$bad")
  expect "traversal $bad exits 2" test "$rc" -eq 2
  expect "traversal $bad is unknown" grep -qF "Unknown role: $bad" "$LOG"
  expect "traversal $bad writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"
done

# --- Case 10: targets inside the clone ---
clone_inside="$WORK/clone inside"
make_clone "$clone_inside"
target_inside="$clone_inside/support-files"
rc=$(run_clone "$clone_inside" --target-path "$target_inside" --role web-developer)
expect "target inside clone exits 2" test "$rc" -eq 2
expect "target inside clone named" grep -qF 'Target is the workflow clone or inside it' "$LOG"
expect "target inside clone writes no AGENTS" test ! -e "$target_inside/AGENTS.md"
expect "target inside clone writes no customization" test ! -e "$target_inside/ai-customization.md"
rc=$(run_clone "$clone_inside" --target-path "$clone_inside" --role web-developer)
expect "clone root exits 2" test "$rc" -eq 2
expect "clone root writes no customization" test ! -e "$clone_inside/ai-customization.md"

# --- Case 11: non-directory target ---
printf 'x\n' > "$WORK/not-a-dir"
rc=$(run_init "$WORK/not-a-dir" --role web-developer)
expect "non-directory target exits 2" test "$rc" -eq 2
expect "non-directory target named" grep -qF "Target path is not a directory: $WORK/not-a-dir" "$LOG"

# --- Case 12: missing and wrong-mode arguments ---
t="$WORK/args"; mkdir -p "$t"
rc=$(run_args --init --target-path "$t")
expect "init without role exits 2" test "$rc" -eq 2
expect "init without role message" grep -qF -- '--role is required with --init.' "$LOG"
rc=$(run_args --init --role web-developer)
expect "init without target exits 2" test "$rc" -eq 2
expect "init without target message" grep -qF -- '--target-path is required with --init.' "$LOG"
rc=$(run_args --source "$ROOT/AGENTS.md" --init --target-path "$t" --role web-developer)
expect "source with init exits 2" test "$rc" -eq 2
expect "source with init message" grep -qF -- '--source is not allowed with --init.' "$LOG"
rc=$(run_args --source "$ROOT/AGENTS.md" --target-path "$t" --role web-developer)
expect "role without init exits 2" test "$rc" -eq 2
expect "role without init message" grep -qF -- '--role is only valid with --init.' "$LOG"

# --- Case 13: idempotence ---
t="$WORK/idempotent"; mkdir -p "$t"; rc=$(run_init "$t" --role web-developer)
agents_before=$(sha256sum "$t/AGENTS.md" | awk '{print $1}')
custom_before=$(sha256sum "$t/ai-customization.md" | awk '{print $1}')
rc=$(run_init "$t" --role web-developer)
expect "second init exits 1" test "$rc" -eq 1
expect "second init keeps AGENTS" test "$(sha256sum "$t/AGENTS.md" | awk '{print $1}')" = "$agents_before"
expect "second init keeps customization" test "$(sha256sum "$t/ai-customization.md" | awk '{print $1}')" = "$custom_before"

# --- Case 14: rollback on a failed second rename ---
t="$WORK/rollback"; mkdir -p "$t" "$WORK/fakebin"
cat > "$WORK/fakebin/mv" <<'EOF'
#!/bin/bash
n=$(cat "$FAKE_MV_COUNT" 2>/dev/null || echo 0)
n=$((n + 1))
echo "$n" > "$FAKE_MV_COUNT"
if [ "$n" -eq 2 ]; then echo "injected mv failure" >&2; exit 1; fi
if [ -x /bin/mv ]; then exec /bin/mv "$@"; fi
exec /usr/bin/mv "$@"
EOF
chmod +x "$WORK/fakebin/mv"
set +e
PATH="$WORK/fakebin:$PATH" FAKE_MV_COUNT="$WORK/mv-count" bash "$SCRIPT" --init --target-path "$t" --role web-developer > "$LOG" 2>&1
rc=$?
set -e
expect "rollback exits 1" test "$rc" -eq 1
expect "rollback removes AGENTS.md" test ! -e "$t/AGENTS.md"
expect "rollback removes customization" test ! -e "$t/ai-customization.md"
expect "rollback leaves no temp files" bash -c "! ls '$t'/.agents.* '$t'/.custom.* 2>/dev/null"

# --- Case 15: copied-clone cases under a path with a space ---
clone="$WORK/clone with space"
make_clone "$clone"
t="$WORK/copied-success"; mkdir -p "$t"
rc=$(run_clone "$clone" --target-path "$t" --role web-developer)
expect "copied clone success exits 0" test "$rc" -eq 0
expect "copied clone workflow path" grep -qF "**Workflow AI Directory**: $clone" "$t/ai-customization.md"

clone2="$WORK/clone missing preset"
make_clone "$clone2"; rm "$clone2/docs/examples/customization-presets/dba.md"
t="$WORK/copied-missing-preset"; mkdir -p "$t"
clone_before=$(find "$clone2" -type f -exec sha256sum {} \; | sort)
rc=$(run_clone "$clone2" --target-path "$t" --role dba)
clone_after=$(find "$clone2" -type f -exec sha256sum {} \; | sort)
expect "missing preset exits 1" test "$rc" -eq 1
expect "missing preset named" grep -qF 'Missing preset file for role dba' "$LOG"
expect "missing preset lists presets" grep -qF 'Available presets: cloud-architect solution-architect web-developer mobile-developer platform-engineer dba data-engineer security-engineer' "$LOG"
expect "missing preset writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"
expect "missing preset keeps the clone unchanged" test "$clone_before" = "$clone_after"

clone3="$WORK/clone symlink preset"
make_clone "$clone3"; printf 'x\n' > "$clone3/real-preset"; rm "$clone3/docs/examples/customization-presets/security-engineer.md"; ln -s "$clone3/real-preset" "$clone3/docs/examples/customization-presets/security-engineer.md"
t="$WORK/copied-symlink-preset"; mkdir -p "$t"
rc=$(run_clone "$clone3" --target-path "$t" --role security-engineer)
expect "symlink preset exits 1" test "$rc" -eq 1
expect "symlink preset named" grep -qF 'Invalid preset file for role security-engineer' "$LOG"
expect "symlink preset writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"

clone4="$WORK/clone no placeholder"
make_clone "$clone4"; printf '# no placeholder\n' > "$clone4/docs/examples/customization-presets/web-developer.md"
t="$WORK/copied-no-placeholder"; mkdir -p "$t"
rc=$(run_clone "$clone4" --target-path "$t" --role web-developer)
expect "missing placeholder exits 1" test "$rc" -eq 1
expect "missing placeholder named" grep -qF 'missing the workflow placeholder' "$LOG"
expect "missing placeholder writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"

clone5="$WORK/clone duplicate placeholder"
make_clone "$clone5"; printf '**Workflow AI Directory**: /path/to/Simple-AI-Workflow\n' >> "$clone5/docs/examples/customization-presets/web-developer.md"
t="$WORK/copied-duplicate"; mkdir -p "$t"
rc=$(run_clone "$clone5" --target-path "$t" --role web-developer)
expect "duplicate placeholder exits 1" test "$rc" -eq 1
expect "duplicate placeholder named" grep -qF 'duplicate workflow placeholder' "$LOG"
expect "duplicate placeholder writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"

clone6="$WORK/clone forbidden key"
make_clone "$clone6"; printf '**Default Shell**: bash\n' >> "$clone6/docs/examples/customization-presets/web-developer.md"
t="$WORK/copied-forbidden"; mkdir -p "$t"
rc=$(run_clone "$clone6" --target-path "$t" --role web-developer)
expect "forbidden key exits 1" test "$rc" -eq 1
expect "forbidden key named" grep -qF 'forbidden Default Shell key' "$LOG"
expect "forbidden key writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"

clone7="$WORK/clone missing agents"
make_clone "$clone7"; rm "$clone7/AGENTS.md"
t="$WORK/copied-missing-agents"; mkdir -p "$t"
rc=$(run_clone "$clone7" --target-path "$t" --role web-developer)
expect "missing canonical AGENTS exits 1" test "$rc" -eq 1
expect "missing canonical AGENTS named" grep -qF 'Missing canonical AGENTS.md' "$LOG"
expect "missing canonical AGENTS writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"

# --- Case 16: docs ---
expect "setup has the init heading" grep -qF '## Initialize a new project' "$ROOT/docs/setup.md"
expect "setup has the Bash init command" grep -qF -- '--init --target-path' "$ROOT/docs/setup.md"
expect "setup has the PowerShell init command" grep -qF -- '-Init -TargetPath' "$ROOT/docs/setup.md"
expect "setup has the dry-run flags" grep -qF -- '--dry-run' "$ROOT/docs/setup.md"
expect "setup has the bootstrap hint" grep -qF 'bootstrap using AGENTS.md protocol' "$ROOT/docs/setup.md"
expect "setup states the exit codes" grep -qF 'Init exits 0 on success, 2 for validation errors, and 1 when it refuses' "$ROOT/docs/setup.md"
expect "setup states the symlink refusal" grep -qF 'when either path is a symlink' "$ROOT/docs/setup.md"
expect "setup states the non-directory refusal" grep -qF 'when the target is not a directory' "$ROOT/docs/setup.md"
expect "guide links setup" grep -qF 'setup.md#initialize-a-new-project' "$ROOT/docs/ai-customization-guide.md"
expect "template has no Default Shell" absent "$ROOT/docs/ai-customization.md" '**Default Shell**:'
expect "presets have no Default Shell" bash -c "! grep -q '\\*\\*Default Shell\\*\\*:' '$PRESETS'/*.md"
expect "guide keeps the optional key" grep -qF "**\`Default Shell\`**" "$ROOT/docs/ai-customization-guide.md"

# --- Case 17: static Bash/PowerShell parity ---
for slug in $roles; do
  expect "bash lists $slug" grep -qF "$slug" "$SCRIPT"
  expect "pwsh lists $slug" grep -qF "$slug" "$PS_SCRIPT"
done
for msg in 'Unknown role' 'Missing preset file' '--source is not allowed with --init.' '--role is only valid with --init.' 'Default Shell' 'Refusing to initialize:'; do
  expect "bash message $msg" grep -qF -- "$msg" "$SCRIPT"
  expect "pwsh message $msg" grep -qF -- "$msg" "$PS_SCRIPT"
done

echo ""
if [ "$fail" -ne 0 ]; then
  echo "Some checks failed."
else
  echo "All checks passed."
fi
exit "$fail"

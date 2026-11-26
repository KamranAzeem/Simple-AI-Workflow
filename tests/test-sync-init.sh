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

live_list=$(for f in "$PRESETS"/*.md; do [ -f "$f" ] || continue; [ -L "$f" ] && continue; basename "$f" .md; done | LC_ALL=C sort)
roles=$(printf '%s\n' "$live_list" | tr '\n' ' ' | sed 's/ $//')

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

run_clone_list() {
  local clone="$1"
  set +e
  bash "$clone/support-files/sync-agents-md.sh" --list-presets > "$LOG" 2>&1
  local rc=$?
  set -e
  printf '%s\n' "$rc"
}

# --- Case 0: live list and standalone rules ---
rc=$(run_args --list-presets)
expect "list exits 0" test "$rc" -eq 0
expect "list matches the live directory" test "$(cat "$LOG")" = "$live_list"
rc=$(run_args --list-presets --help)
expect "list with help exits 2" test "$rc" -eq 2
expect "list with help message" grep -qF -- '--list-presets cannot be combined with other options.' "$LOG"
rc=$(run_args --list-presets --init)
expect "list with init exits 2" test "$rc" -eq 2
expect "list with init message" grep -qF -- '--list-presets cannot be combined with other options.' "$LOG"
rc=$(run_args --list-presets --source "$ROOT/AGENTS.md")
expect "list with source exits 2" test "$rc" -eq 2
rc=$(run_args --list-presets --target-path "$WORK/list-target")
expect "list with target exits 2" test "$rc" -eq 2
rc=$(run_args --list-presets --target-path "")
expect "list with empty target exits 2" test "$rc" -eq 2
expect "list with empty target message" grep -qF -- '--list-presets cannot be combined with other options.' "$LOG"
rc=$(run_args --list-presets --role web-developer)
expect "list with role exits 2" test "$rc" -eq 2
rc=$(run_args --list-presets --dry-run)
expect "list with dry-run exits 2" test "$rc" -eq 2

clone_missing_dir="$WORK/clone missing dir"
make_clone "$clone_missing_dir"
rm -rf "$clone_missing_dir/docs/examples/customization-presets"
rc=$(run_clone_list "$clone_missing_dir")
expect "missing presets dir list exits 1" test "$rc" -eq 1
expect "missing presets dir named" grep -qF 'Presets directory not found:' "$LOG"
t="$WORK/clone-missing-dir-target"; mkdir -p "$t"
rc=$(run_clone "$clone_missing_dir" --target-path "$t" --role web-developer)
expect "missing presets dir role exits 1" test "$rc" -eq 1
expect "missing presets dir role named" grep -qF 'Presets directory not found:' "$LOG"
expect "missing presets dir role writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"

clone_empty="$WORK/clone empty dir"
make_clone "$clone_empty"
rm -f "$clone_empty/docs/examples/customization-presets"/*.md
rc=$(run_clone_list "$clone_empty")
expect "empty presets list exits 1" test "$rc" -eq 1
expect "empty presets named" grep -qF 'No presets found in' "$LOG"
t="$WORK/clone-empty-target"; mkdir -p "$t"
rc=$(run_clone "$clone_empty" --target-path "$t" --role web-developer)
expect "empty presets role exits 1" test "$rc" -eq 1
expect "empty presets role message" grep -qF 'No presets found in' "$LOG"
expect "empty presets role writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"

# --- Case 1: all live roles scaffold ---
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
expect "unknown role lists presets" grep -qF "Available presets: $roles" "$LOG"
expect "unknown role guide reference" grep -qF '11-presets-by-role' "$LOG"
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
rc=$(run_args --init --role --target-path "$t")
expect "missing role value exits 2" test "$rc" -eq 2
expect "missing role value named" grep -qF 'Missing value for --role' "$LOG"
expect "missing role value lists presets" grep -qF "Available presets: $roles" "$LOG"
expect "missing role value guide reference" grep -qF '11-presets-by-role' "$LOG"
rc=$(run_args --init --target-path "$t")
expect "init without role exits 2" test "$rc" -eq 2
expect "init without role message" grep -qF -- '--role is required with --init.' "$LOG"
expect "init without role lists presets" grep -qF "Available presets: $roles" "$LOG"
expect "init without role guide reference" grep -qF '11-presets-by-role' "$LOG"
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

clone2="$WORK/clone removed preset"
make_clone "$clone2"; rm "$clone2/docs/examples/customization-presets/dba.md"
t="$WORK/copied-removed-preset"; mkdir -p "$t"
clone2_roles=$(for f in "$clone2/docs/examples/customization-presets"/*.md; do [ -f "$f" ] || continue; [ -L "$f" ] && continue; basename "$f" .md; done | LC_ALL=C sort | tr '\n' ' ' | sed 's/ $//')
clone_before=$(find "$clone2" -type f -exec sha256sum {} \; | sort)
rc=$(run_clone "$clone2" --target-path "$t" --role dba)
clone_after=$(find "$clone2" -type f -exec sha256sum {} \; | sort)
expect "removed preset exits 2" test "$rc" -eq 2
expect "removed preset is unknown" grep -qF 'Unknown role: dba' "$LOG"
expect "removed preset lists the live set" grep -qF "Available presets: $clone2_roles" "$LOG"
expect "removed preset writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"
expect "removed preset keeps the clone unchanged" test "$clone_before" = "$clone_after"

clone_add="$WORK/clone add preset"
make_clone "$clone_add"
cp "$clone_add/docs/examples/customization-presets/web-developer.md" "$clone_add/docs/examples/customization-presets/temp-role.md"
rc=$(run_clone_list "$clone_add")
expect "temp preset appears in the list" grep -qxF 'temp-role' "$LOG"
t="$WORK/copied-temp-target"; mkdir -p "$t"
rc=$(run_clone "$clone_add" --target-path "$t" --role temp-role)
expect "temp preset init exits 0" test "$rc" -eq 0
expect "temp preset init writes customization" test -f "$t/ai-customization.md"

clone3="$WORK/clone symlink preset"
make_clone "$clone3"; printf 'x\n' > "$clone3/real-preset"; rm "$clone3/docs/examples/customization-presets/security-engineer.md"; ln -s "$clone3/real-preset" "$clone3/docs/examples/customization-presets/security-engineer.md"
t="$WORK/copied-symlink-preset"; mkdir -p "$t"
rc=$(run_clone "$clone3" --target-path "$t" --role security-engineer)
expect "symlink preset exits 1" test "$rc" -eq 1
expect "symlink preset named" grep -qF 'Invalid preset file for role security-engineer' "$LOG"
expect "symlink preset writes nothing" neither "$t/AGENTS.md" "$t/ai-customization.md"
rc=$(run_clone_list "$clone3")
expect "symlink preset list exits 0" test "$rc" -eq 0
expect "symlink preset omitted from list" absent "$LOG" 'security-engineer'
expect "symlink preset list keeps another role" grep -qxF 'web-developer' "$LOG"

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

expect "setup lists the live command" grep -qF -- '--list-presets' "$ROOT/docs/setup.md"
expect "setup says the list is live" grep -qF 'reads the live' "$ROOT/docs/setup.md"
expect "guide says the live directory is the source" grep -qF 'The live presets directory is the source' "$ROOT/docs/ai-customization-guide.md"
btick=$(printf '\140')
guide_roles=$(grep -oE "^\| ${btick}[a-z0-9-]+${btick}" "$ROOT/docs/ai-customization-guide.md" | sed "s/^| ${btick}//; s/${btick}\$//" | LC_ALL=C sort)
expect "guide table matches the live presets" test "$guide_roles" = "$live_list"
setup_roles=$(grep -oE -- '--role [a-z0-9-]+' "$ROOT/docs/setup.md" | awk '{print $2}' | sort -u)
expect "setup has an example role" test -n "$setup_roles"
for r in $setup_roles; do
  expect "setup example $r is live" grep -qxF "$r" <<< "$live_list"
done

# --- Case 17: no fixed list, usage, and static parity ---
for slug in $live_list; do
  [ "$slug" = "web-developer" ] && continue
  expect "bash does not fix $slug" absent "$SCRIPT" "$slug"
  expect "pwsh does not fix $slug" absent "$PS_SCRIPT" "$slug"
done
bash_usage=$(sed -n '/^usage()/,/^EOF$/p' "$SCRIPT")
ps_help=$(sed -n '1,/^#>/p' "$PS_SCRIPT")
expect "bash usage lists --list-presets" grep -qF -- '--list-presets' <<< "$bash_usage"
expect "pwsh help lists -ListPresets" grep -qF -- '-ListPresets' <<< "$ps_help"
expect "bash usage keeps the web-developer example" grep -qF 'web-developer' <<< "$bash_usage"
expect "pwsh help keeps the web-developer example" grep -qF 'web-developer' <<< "$ps_help"
for msg in 'Unknown role' 'Invalid preset file' 'Presets directory not found' 'No presets found' '--list-presets cannot be combined' '--source is not allowed with --init.' '--role is only valid with --init.' 'Default Shell' 'Refusing to initialize:'; do
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

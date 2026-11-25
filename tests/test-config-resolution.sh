#!/bin/bash
# Dev-time fixture for the configurable User AI Directory and Default Shell.
# Usage: ./tests/test-config-resolution.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

present() {
    local file="$1" text="$2" label="$3"
    if grep -qF -- "$text" "$file" 2>/dev/null; then
        printf 'PASS %s\n' "$label"
    else
        printf 'FAIL %s\n' "$label"
        fail=1
    fi
}

absent() {
    local file="$1" text="$2" label="$3"
    if grep -qF -- "$text" "$file" 2>/dev/null; then
        printf 'FAIL %s\n' "$label"
        fail=1
    else
        printf 'PASS %s\n' "$label"
    fi
}

# Anchors and documented rules.
present "$ROOT/AGENTS.md" "User AI Directory" "AGENTS.md has the user directory anchor"
present "$ROOT/AGENTS.md" "default \`[HOME]/.ai/\`" "AGENTS.md states the user directory default"
present "$ROOT/docs/ai-customization.md" "User AI Directory" "customization template has the user directory key"
present "$ROOT/docs/ai-customization.md" "Default Shell" "customization template has the default shell key"
present "$ROOT/docs/ai-customization.md" "zsh" "customization template lists zsh"
present "$ROOT/docs/ai-customization.md" "pwsh" "customization template lists pwsh"
present "$ROOT/docs/ai-customization.md" "git-bash" "customization template lists git-bash"
present "$ROOT/docs/user-settings.md" "Default Shell Path" "settings template has the shell path key"
present "$ROOT/ai/procedures/load-context.md" "Then read every settings file" "load-context reads the whole settings directory early"
present "$ROOT/ai/procedures/load-context.md" "User AI Directory" "load-context resolves the user directory"
present "$ROOT/ai/procedures/load-context.md" "Default Shell Path" "load-context resolves the shell path"
present "$ROOT/ai/procedures/load-context.md" "git-bash" "load-context resolves git-bash"
# shellcheck disable=SC2016
present "$ROOT/ai/procedures/load-context.md" 'An absent `Default Shell` key keeps the current or default shell' "load-context treats the shell key as optional"
present "$ROOT/ai/procedures/load-context.md" "reported, and the boot continues with built-ins" "load-context reports and continues"
present "$ROOT/ai/procedures/load-context.md" "The optional index helper uses its bash shebang" "load-context keeps the optional helper independent"
absent "$ROOT/ai/procedures/load-context.md" "not one of" "the old unknown-shell stop is gone"
present "$ROOT/support-files/validate-protocol.sh" "User AI Directory" "validator reads the user directory key"
# shellcheck disable=SC2016
present "$ROOT/support-files/validate-protocol.sh" 'USER_DIR="$HOME/.ai"' "validator keeps the default directory"
present "$ROOT/support-files/validate-protocol.sh" "%USERPROFILE%" "validator resolves the Windows home token"
present "$ROOT/ai/procedures/create-backup.md" 'tar -czf "' "backup quotes the Linux target"
present "$ROOT/ai/procedures/bootstrap-project.md" "User AI Directory" "bootstrap reads the user directory"
present "$ROOT/support-files/sync-agents-md.sh" "PENDING: user store unreachable" "sync probes the user directory"
present "$ROOT/support-files/sync-agents-md.ps1" "PENDING: user store unreachable" "PowerShell sync probes the user directory"

# Sync behavior: a missing configured directory warns and is never added or changed.
WORK="$(mktemp -d)"
HOME="$WORK/home"
export HOME
mkdir -p "$HOME/.ai/settings" "$HOME/.ai/knowledge" "$HOME/.ai/skills" "$HOME/.ai/backups"
# shellcheck disable=SC2329
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT
mkdir -p "$WORK/missing"
printf '%s\n' "# Agents" > "$WORK/missing/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## AI Workflow Configuration" "" "**Workflow AI Directory**: $ROOT" "" "**User AI Directory**: $WORK/does-not-exist" "" "## Active Expertise" "- meta" > "$WORK/missing/ai-customization.md"
if bash "$ROOT/support-files/sync-agents-md.sh" --source "$ROOT/AGENTS.md" --target-path "$WORK/missing" > "$WORK/missing.log" 2>&1; then
    if grep -qF "PENDING: user store unreachable" "$WORK/missing.log"; then
        printf 'PASS %s\n' "sync reports a missing user directory"
    else
        printf 'FAIL %s\n' "sync reports a missing user directory"
        fail=1
    fi
    if [ "$(grep -c '^\*\*User AI Directory\*\*:' "$WORK/missing/ai-customization.md")" = "1" ]; then
        printf 'PASS %s\n' "sync keeps the existing user directory key"
    else
        printf 'FAIL %s\n' "sync keeps the existing user directory key"
        fail=1
    fi
else
    printf 'FAIL %s\n' "sync exits cleanly on a missing user directory"
    fail=1
fi

mkdir -p "$WORK/nokey"
printf '%s\n' "# Agents" > "$WORK/nokey/AGENTS.md"
printf '%s\n' "# AI Customization" "" "## Active Expertise" "- meta" > "$WORK/nokey/ai-customization.md"
if bash "$ROOT/support-files/sync-agents-md.sh" --source "$ROOT/AGENTS.md" --target-path "$WORK/nokey" > "$WORK/nokey.log" 2>&1; then
    absent "$WORK/nokey/ai-customization.md" "User AI Directory" "sync adds no user directory key"
else
    printf 'FAIL %s\n' "sync exits cleanly without the user directory key"
    fail=1
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: config resolution fixture."
    exit 1
fi
echo "PASSED: config resolution fixture."
exit 0

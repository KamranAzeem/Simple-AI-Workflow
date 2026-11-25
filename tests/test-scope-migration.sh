#!/bin/bash
# Fixture for the v7.7.0 scope vocabulary, live file renames, and no-global guard.
set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 1

fail=0
pass() { printf 'PASS %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

present() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then pass "$label"; else fail_case "$label"; fi
}
absent() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then fail_case "$label"; else pass "$label"; fi
}

# --- live file renames ---
for new in ai/policies/ai-policy-user-settings.md ai/procedures/repair-user-settings.md docs/user-settings.md ai/knowledge/scope-vocabulary-and-storage-roots.md; do
    if [ -f "$new" ]; then pass "new file exists: $new"; else fail_case "new file missing: $new"; fi
done
for old in ai/policies/ai-policy-global-settings.md ai/procedures/repair-global-settings.md docs/global-user-settings.md ai/knowledge/global-vocabulary-and-storage-roots.md; do
    if [ -e "$old" ]; then fail_case "old file still present: $old"; else pass "old file is gone: $old"; fi
done

# --- scope keys ---
for key in "Workflow AI Directory" "User AI Directory" "Team AI Directory" "Workflow AI Policies Directory" "Workflow AI Skills Directory" "User AI Knowledge Directory" "User AI Skills Directory" "User AI Settings Directory" "User AI Backups Directory" "Team AI Knowledge Directory" "Team AI Skills Directory" "Project AI Knowledge Directory"; do
    present AGENTS.md "$key" "AGENTS.md has $key"
done

# --- no-global guard ---
# Strip marked legacy blocks, marked single lines, trigger sections, and the
# allowed historical paths before scanning live protocol files and docs.
sanitize() {
    awk '
        /<!-- LEGACY-GLOBAL-START -->/ { block = 1; next }
        /<!-- LEGACY-GLOBAL-END -->/ { block = 0; next }
        block { next }
        /<!-- LEGACY-GLOBAL -->/ { next }
        /^## Triggers[[:space:]]*$/ { trig = 1; next }
        trig && /^## / { trig = 0 }
        trig { next }
        { print }
    ' "$1"
}

old_tokens='Global AI (Workflow|User|Policies|Knowledge|Settings|Skills|Backups)|Global Knowledge|Global User|global-knowledge/|team-knowledge/|project-knowledge/|global-settings|global-user-settings'

live_files=(
    AGENTS.md
    ai/policies/ai-policy-common.md
    ai/policies/ai-policy-meta.md
    ai/policies/ai-policy-knowledge.md
    ai/policies/ai-policy-team-knowledge.md
    ai/policies/ai-policy-issue-management.md
    ai/policies/ai-policy-user-settings.md
    ai/procedures/load-context.md
    ai/procedures/post-compaction-recovery.md
    ai/procedures/write-checkpoint.md
    ai/procedures/repair-user-settings.md
    ai/procedures/repair-knowledge-files.md
    ai/procedures/knowledge-publish.md
    ai/knowledge/scope-vocabulary-and-storage-roots.md
    docs/workflow-guide.md
    docs/setup.md
    docs/ai-customization-guide.md
    docs/ai-customization.md
    docs/user-settings.md
    README.md
)

for live in "${live_files[@]}"; do
    cleaned="$(sanitize "$live")"
    hits="$(printf '%s\n' "$cleaned" | grep -nE "$old_tokens" || true)"
    if [ -n "$hits" ]; then
        fail_case "old scope token in live file: $live"
        printf '%s\n' "$hits"
    else
        pass "no unmarked old scope token: $live"
    fi
done

# --- trigger aliases and removal note ---
present ai/procedures/repair-user-settings.md "- repair user settings" "new settings trigger"
present ai/procedures/repair-user-settings.md "- repair global settings" "legacy settings trigger"
present ai/procedures/write-checkpoint.md "- update user knowledge" "new knowledge trigger"
present ai/procedures/write-checkpoint.md "- update global knowledge" "legacy knowledge trigger"
present docs/announcements/v7.7.0.md "removed in v7.8.0" "announcement names the alias removal"
present ai/procedures/repair-user-settings.md "removed in v7.8.0" "procedure names the alias removal"

# --- index scope token ---
present support-files/validate-policy-authoring.sh "scope=workflow" "authoring validator reports workflow scope"
present support-files/index-protocol.sh "scope[n] = \"project\"" "index helper expects workflow scope"
present support-files/index-protocol-contract.md "scope\` is \`workflow\` or \`project\`" "index contract names workflow scope"

# --- migration detection is marked ---
if grep -qF "LEGACY-GLOBAL" ai/procedures/load-context.md; then
    pass "load-context marks legacy detection"
else
    fail_case "load-context marks legacy detection"
fi
if grep -qF "LEGACY-GLOBAL" support-files/sync-agents-md.sh; then
    pass "sync marks legacy detection"
else
    fail_case "sync marks legacy detection"
fi

# --- README and announcement tables ---
present README.md "## Path migration in v7.7.0" "README migration section"
present README.md "Global AI Knowledge Directory" "README table lists the old key"
present README.md "User AI Knowledge Directory" "README table lists the new key"
present docs/announcements/v7.7.0.md "## Migration map" "announcement migration table"
present docs/announcements/v7.7.0.md "scope-migration-<date>/user/" "announcement backup path"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: scope migration fixture."
    exit 1
fi
echo "PASSED: scope migration fixture."
exit 0

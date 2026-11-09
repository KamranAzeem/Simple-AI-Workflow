#!/bin/bash
# Dev-time fixture for the load-context boot discovery contract.
# Usage: ./support-files/test-load-context-boot.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
HOME="$WORK/home"
PROJECT="$WORK/project"
export HOME

mkdir -p "$HOME/.ai/settings" "$HOME/.ai/global-knowledge" "$HOME/.ai/backups"
mkdir -p "$PROJECT/ai"/{state,shared/project-knowledge,shared/handoffs,issues/open,issues/in-progress,issues/closed,secrets,artifacts,code-review-reports,notes,pending,plans,daily-checkpoints,policies}
mkdir -p "$PROJECT/design-docs/.git"

for d in secrets artifacts code-review-reports notes pending plans; do
    printf 'canary\n' > "$PROJECT/ai/$d/canary-$d.txt"
done
printf 'canary\n' > "$PROJECT/ai/issues/closed/canary-closed.txt"
printf 'canary\n' > "$PROJECT/design-docs/.git/canary-git.txt"
printf 'canary\n' > "$PROJECT/ai/shared/archive.tar.gz"
printf 'canary\n' > "$HOME/.ai/backups/canary-backup.txt"
printf 'settings\n' > "$HOME/.ai/settings/global-user-settings.md"
printf 'knowledge\n' > "$HOME/.ai/global-knowledge/global-topic.md"

printf '# Test customization\n' > "$PROJECT/ai-customization.md"
for f in context progress next-steps; do printf 'state\n' > "$PROJECT/ai/state/$f.md"; done
printf 'coordination\n' > "$PROJECT/ai/shared/coordination.md"
printf '# Checkpoint\n' > "$PROJECT/ai/daily-checkpoints/2026-11-09.md"
printf 'open\n' > "$PROJECT/ai/issues/open/open-one.md"
printf '# design\n' > "$PROJECT/design-docs/design-one.md"
printf '# DO NOT MODIFY THIS FILE\n\nFixture.\n\n<!-- AI-ASSISTANT: READ-ONLY START -->\n\n# AI Policy: Fixture\n\nGovern the fixture.\n\n## Scope\n\n- Fixture.\n\n## Rules\n\n- Follow the fixture.\n\n## References\n\n- Fixture.\n\n<!-- AI-ASSISTANT: READ-ONLY END -->\n' > "$PROJECT/ai/policies/ai-policy-fixture.md"

for i in $(seq 1 1000); do printf 'k\n' > "$PROJECT/ai/shared/project-knowledge/k$i.md"; done
for i in $(seq 1 1000); do printf 'a\n' > "$PROJECT/ai/artifacts/a$i.txt"; done

discovery() {
    cd "$PROJECT" || return 1
    printf 'customization: %s files\n' "$(find . -maxdepth 1 -type f -name 'ai-customization.md' | wc -l)"
    printf 'ai/state: %s files\n' "$(find ai/state -type f | wc -l)"
    printf 'ai/shared: %s files\n' "$(find ai/shared \( -name '*.tar*' -o -name '*.zip' \) -prune -o -type f -print | wc -l)"
    printf 'project-knowledge: %s files\n' "$(find ai/shared/project-knowledge -type f | wc -l)"
    printf 'handoffs: %s files\n' "$(find ai/shared/handoffs -type f | wc -l)"
    printf 'issues/open: %s files\n' "$(find ai/issues/open -type f | wc -l)"
    printf 'issues/in-progress: %s files\n' "$(find ai/issues/in-progress -type f | wc -l)"
    printf 'daily-checkpoints: %s files\n' "$(find ai/daily-checkpoints -type f | wc -l)"
    printf 'policies: %s files\n' "$(find ai/policies -type f | wc -l)"
    printf 'design-docs: %s files\n' "$(find design-docs -name .git -prune -o -type f -print | wc -l)"
    printf 'global-settings: %s files\n' "$(find "$HOME/.ai/settings" -type f | wc -l)"
    printf 'global-knowledge: %s files\n' "$(find "$HOME/.ai/global-knowledge" -type f | wc -l)"
    printf 'global-policies: %s files\n' "$(find "$ROOT/ai/policies" -type f | wc -l)"
    printf 'procedures: %s files\n' "$(find "$ROOT/ai/procedures" -type f | wc -l)"
}

fail=0
out="$(discovery)"

if printf '%s\n' "$out" | grep -qi 'canary'; then
    echo "FAIL: an excluded canary leaked into the discovery output."
    fail=1
fi
bytes=$(printf '%s' "$out" | wc -c)
if [ "$bytes" -gt 16384 ]; then
    echo "FAIL: discovery output is $bytes bytes, over the 16 KB bound."
    fail=1
fi
if ! printf '%s\n' "$out" | grep -q 'project-knowledge: 1000 files'; then
    echo "FAIL: project-knowledge count is not 1000."
    fail=1
fi
if printf '%s\n' "$out" | grep -q 'ai/artifacts'; then
    echo "FAIL: the artifacts directory was scanned."
    fail=1
fi
if ! grep -q 'Read the latest checkpoint once' "$ROOT/ai/procedures/load-context.md"; then
    echo "FAIL: the single checkpoint read is not stated in the procedure."
    fail=1
fi

index_out="$(cd "$PROJECT" && bash "$ROOT/support-files/validate-policy-authoring.sh" --index ai/policies/ai-policy-fixture.md 2>&1)"
index_rc=$?
if [ "$index_rc" -ne 0 ] || ! printf '%s\n' "$index_out" | grep -q 'summary|modules=1'; then
    echo "FAIL: the developer index oracle failed on the fixture policy."
    printf '%s\n' "$index_out"
    fail=1
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: boot discovery fixture."
    exit 1
fi
echo "PASSED: boot discovery fixture (canaries, 1000 files, 16 KB, single checkpoint read, index oracle)."
exit 0

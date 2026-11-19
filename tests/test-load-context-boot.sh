#!/bin/bash
# Dev-time fixture for the load-context boot contract and the read-only index helper.
# Usage: ./tests/test-load-context-boot.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
HOME="$WORK/home"
PROJECT="$WORK/project"
export HOME

mkdir -p "$HOME/.ai/settings" "$HOME/.ai/global-knowledge" "$HOME/.ai/backups"
mkdir -p "$PROJECT/ai"/{state,shared/project-knowledge,shared/handoffs,issues/open,issues/in-progress,issues/closed,secrets,artifacts,code-review-reports,notes,pending,plans,daily-checkpoints,policies,skills}
mkdir -p "$PROJECT/design-docs/.git" "$PROJECT/ai/policies/.canaryhidden" "$PROJECT/ai/policies/tmp" "$PROJECT/ai/skills/example"
printf -- '---\nname: example\ndescription: Example skill.\n---\n' > "$PROJECT/ai/skills/example/SKILL.md"

for d in secrets artifacts code-review-reports notes pending plans; do
    printf 'canary-boot\n' > "$PROJECT/ai/$d/canary-$d.txt"
done
printf 'canary-boot\n' > "$PROJECT/ai/issues/closed/canary-closed.txt"
printf 'canary-boot\n' > "$PROJECT/design-docs/.git/canary-git.txt"
printf 'settings\n' > "$HOME/.ai/settings/global-user-settings.md"
printf 'knowledge\n' > "$HOME/.ai/global-knowledge/global-topic.md"
printf 'state\n' > "$PROJECT/ai/state/context.md"
printf 'state\n' > "$PROJECT/ai/state/progress.md"
printf 'state\n' > "$PROJECT/ai/state/next-steps.md"
printf 'coordination\n' > "$PROJECT/ai/shared/coordination.md"
printf '# Checkpoint\n' > "$PROJECT/ai/daily-checkpoints/2026-11-19.md"
printf 'open\n' > "$PROJECT/ai/issues/open/open-one.md"
printf '# design\n' > "$PROJECT/design-docs/design-one.md"
printf '# DO NOT MODIFY THIS FILE\n\nFixture.\n\n<!-- AI-ASSISTANT: READ-ONLY START -->\n\n# AI Policy: Fixture\n\nGovern the fixture.\n\n## Scope\n\n- Fixture.\n\n## Rules\n\n- Follow the fixture.\n\n## References\n\n- Fixture.\n\n<!-- AI-ASSISTANT: READ-ONLY END -->\n' > "$PROJECT/ai/policies/ai-policy-fixture.md"
printf '# DO NOT MODIFY THIS FILE\n\nCanary.\n\n<!-- AI-ASSISTANT: READ-ONLY START -->\n\n# AI Policy: Canary\n\nGovern the canary.\n\n## Scope\n\n- Canary.\n\n## Rules\n\n- Follow the canary.\n\n## References\n\n- Canary.\n\n<!-- AI-ASSISTANT: READ-ONLY END -->\n' > "$PROJECT/ai/policies/.canaryhidden/ai-policy-canaryhidden.md"
cp "$PROJECT/ai/policies/.canaryhidden/ai-policy-canaryhidden.md" "$PROJECT/ai/policies/tmp/ai-policy-canarytmp.md"
ln -s ai-policy-fixture.md "$PROJECT/ai/policies/ai-policy-canarylink.md"

fail=0
present() {
    local file="$1" needle="$2" label="$3"
    if grep -qF -- "$needle" "$file"; then
        printf 'PASS %s\n' "$label"
    else
        printf 'FAIL %s\n' "$label"
        fail=1
    fi
}
absent() {
    local file="$1" needle="$2" label="$3"
    if grep -qF -- "$needle" "$file"; then
        printf 'FAIL %s\n' "$label"
        fail=1
    else
        printf 'PASS %s\n' "$label"
    fi
}

P="$ROOT/ai/procedures/load-context.md"
for anchor in "index-protocol.sh" "index-source=helper" "index-source=fallback" "age-source=commit|mtime" "STEP-STATE-FILE-PROOF-OF-READ" "Global Knowledge files" "NOT loaded here" "Author identity" "update design documents" "Boot Scan Exclusions" "16 KB" "STEP-SKILLS-INDEX" "Global AI Skills Directory" "STEP-POLICY-LOADING"; do
    present "$P" "$anchor" "procedure anchor: $anchor"
done
# shellcheck disable=SC2016
for old in "Use one command block" "do not run the validator at load context" '`cat`' '`sed`' '`awk`' '`sort`' '`uniq`' '`comm`'; do
    absent "$P" "$old" "old shell instruction: $old"
done

out="$(cd "$PROJECT" && bash "$ROOT/support-files/index-protocol.sh" 2>&1)"
rc=$?
if [ "$rc" -eq 0 ]; then
    printf 'PASS %s\n' "the index helper exits 0"
else
    printf 'FAIL the index helper exited %s\n' "$rc"
    fail=1
fi
if printf '%s\n' "$out" | grep -q 'summary|modules='; then
    printf 'PASS %s\n' "the index helper prints a summary"
else
    printf 'FAIL the index helper summary is missing\n'
    fail=1
fi
if printf '%s\n' "$out" | grep -q '^policy|project|fixture|'; then
    printf 'PASS %s\n' "the index helper indexes the project policy"
else
    printf 'FAIL the index helper missed the project policy\n'
    fail=1
fi
if printf '%s\n' "$out" | grep -qi 'canary'; then
    printf 'FAIL a canary leaked into the index\n'
    fail=1
else
    printf 'PASS %s\n' "the index helper excludes the canaries"
fi

dev="$(cd "$PROJECT" && bash "$ROOT/support-files/validate-policy-authoring.sh" --index ai/policies/ai-policy-fixture.md 2>&1)"
dev_rc=$?
if [ "$dev_rc" -eq 0 ] && printf '%s\n' "$dev" | grep -q 'summary|modules=1'; then
    printf 'PASS %s\n' "the dev index oracle still works on the fixture"
else
    printf 'FAIL the dev index oracle failed on the fixture\n'
    fail=1
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: boot contract fixture."
    exit 1
fi
echo "PASSED: boot contract fixture (procedure anchors, helper, canaries, dev index)."
exit 0

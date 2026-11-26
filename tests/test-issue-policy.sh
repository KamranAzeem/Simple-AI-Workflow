#!/bin/bash
# Dev-time fixture for the issue-management plug-in boundary and loads.
# Usage: ./tests/test-issue-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMON="$ROOT/ai/policies/ai-policy-common.md"
ISSUE="$ROOT/ai/policies/ai-policy-issue-management.md"
MANAGE="$ROOT/ai/procedures/manage-issues.md"
IMPLEMENT="$ROOT/ai/procedures/implement-plan.md"
LOADCTX="$ROOT/ai/procedures/load-context.md"
TEMPLATE="$ROOT/ai/knowledge/issue-template.md"
CODEREVIEW="$ROOT/ai/policies/ai-policy-code-review.md"
HANDOFF="$ROOT/ai/procedures/create-handoff.md"
REPAIR_KNOWLEDGE="$ROOT/ai/procedures/repair-knowledge-files.md"
REPAIR_SETTINGS="$ROOT/ai/procedures/repair-user-settings.md"
DESIGN="$ROOT/ai/policies/ai-policy-design-docs.md"
KNOWLEDGE="$ROOT/ai/policies/ai-policy-knowledge.md"
GLOBALSET="$ROOT/ai/policies/ai-policy-user-settings.md"
CHECKPOINT="$ROOT/ai/procedures/write-checkpoint.md"
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

line() {
    local file="$1" text="$2" label="$3"
    if grep -qxF -- "$text" "$file" 2>/dev/null; then
        printf 'PASS %s\n' "$label"
    else
        printf 'FAIL %s\n' "$label"
        fail=1
    fi
}

present "$COMMON" "## Issue Invariant" "common has the issue invariant"
absent "$COMMON" "### Work-Item Invariants" "common no longer holds the work-item rules"
present "$ISSUE" "- issue standards" "plug-in declares the issue trigger"
present "$ISSUE" "- ticket standards" "plug-in declares the ticket trigger"
present "$ISSUE" "- Mode: trigger" "plug-in declares the trigger mode"
present "$ISSUE" "### Ticket Fields" "plug-in holds the ticket fields"
present "$ISSUE" "### Plan" "plug-in holds the plan rules"
present "$ISSUE" "### Work-Item Invariants" "plug-in holds the work-item rules"
present "$ISSUE" "ai/knowledge/issue-template.md" "plug-in owns the template rule"
present "$LOADCTX" "ai-policy-issue-management.md" "load-context loads the plug-in for a missing template"
present "$LOADCTX" "### Ticket Fields" "load-context builds the template from the fields"
present "$MANAGE" "ai-policy-issue-management.md" "manage-issues loads the plug-in"
present "$IMPLEMENT" "ai-policy-issue-management.md" "implement-plan loads the plug-in"
present "$ISSUE" "- Set \`IssueType\` to \`Feature\`, \`Defect/Bugfix\`, \`Improvement/Refactor\`, \`Documentation\`, \`Task\`, or \`Idea\`." "plug-in lists the Idea type"
present "$TEMPLATE" "\`Documentation\`, \`Task\`, \`Idea\`." "template lists the Idea type"
present "$MANAGE" "- file an idea" "manage-issues declares the idea trigger"
present "$MANAGE" '# PROCEDURE MANAGE-ISSUES: When the user says "manage issues", "file an issue", "file an idea", "new idea", "I want to work on this idea", "close issue", "list issues", "plan the issue", or "plan issue #N"' "manage-issues H1 names the idea close variants"
present "$ISSUE" "File an idea with \`IssueType: Idea\`; grill it, then continue the normal steps or close it with a dated \`Won't fix\` note." "plug-in states the idea intake"
present "$ISSUE" "- Set \`Label\` to empty, \`Insufficient Information\`, or \`Unworkable\`." "plug-in keeps the workability labels"
present "$COMMON" "the implementation request that triggers PROCEDURE IMPLEMENT-PLAN is that separate approval when the plan's \`## Close Sequence\` names the action, otherwise ask." "common policy states the two-step approval"
present "$COMMON" "external system write" "common policy keeps the external-system approval gate"
if awk '/^## Triggers/{on=1;next} /^## /{on=0} on' "$MANAGE" | grep -qE 'new idea|I want to work on this idea'; then
    printf 'FAIL the idea close variants are in the Triggers block\n'
    fail=1
else
    printf 'PASS the idea close variants stay in the H1\n'
fi

present "$CODEREVIEW" "### Blocking Review Gate" "code-review policy owns the blocking gate"
present "$CODEREVIEW" "- **Minor**: fix before approval." "code-review policy makes Minor blocking"
present "$CODEREVIEW" "Treat every Critical, Major, and Minor finding as blocking." "gate blocks every severity"
present "$CODEREVIEW" "Keep Suggestion optional; never relabel a defect as a Suggestion." "gate keeps Suggestion optional"
present "$CODEREVIEW" "Keep no cap and no demotion." "gate has no cap and no demotion"
present "$CODEREVIEW" "Close a false positive only by an evidence-backed rebuttal the reviewer accepts, or by the user's decision after the evidence." "gate owns the false-positive path"
present "$CODEREVIEW" "A finding inside the diff scope, the reviewed-file scope, or the ticket scope blocks approval; a valid finding inside the diff scope or the reviewed-file scope but outside the ticket scope defers to a new ticket only with the user's explicit approval, and the verdict stays CHANGES REQUESTED until then." "gate orders the scope outcomes"
present "$CODEREVIEW" "A finding outside all three scopes is surfaced and does not block the verdict." "gate surfaces the out-of-scope finding"
present "$CODEREVIEW" "Stay read-only; the author fixes every finding." "gate keeps the reviewer read-only"
present "$CODEREVIEW" "the changed lines" "gate defines the diff scope"
present "$CODEREVIEW" "the changed code paths in the touched files" "gate defines the reviewed-file scope"
present "$CODEREVIEW" "the behaviors named in the ticket" "gate defines the ticket scope"
present "$CODEREVIEW" "See the blocking review gate for the scope rule." "pre-existing findings point at the gate"
present "$CODEREVIEW" "diff scope" "gate names the diff scope"
present "$CODEREVIEW" "reviewed-file scope" "gate names the reviewed-file scope"
present "$CODEREVIEW" "ticket scope" "gate names the ticket scope"
absent "$CODEREVIEW" "do not block this change's verdict" "old non-blocking sentence is gone"
absent "$CODEREVIEW" "fix when convenient" "old Minor wording is gone"
present "$CODEREVIEW" "### Verdict and Delta Verification" "code-review policy owns the verdict binding"
present "$CODEREVIEW" "Bind every review verdict to the reviewed artifact's SHA-256." "gate binds the verdict to the hash"
present "$CODEREVIEW" "Fix every finding, then run one delta verification; do not reopen scope." "gate requires one delta verification"
present "$CODEREVIEW" "Treat a post-approval edit as invalidating the approval; hash the new artifact for a delta verification." "gate invalidates a post-approval edit"
present "$CODEREVIEW" "File a new post-approval finding as a follow-up ticket unless it is a regression." "gate treats a new post-approval finding as a follow-up"

for f in "$ISSUE" "$MANAGE" "$IMPLEMENT" "$HANDOFF" "$REPAIR_KNOWLEDGE" "$REPAIR_SETTINGS" "$DESIGN" "$KNOWLEDGE" "$GLOBALSET"; do
    base="$(basename "$f")"
    present "$f" "blocking review gate" "$base cites the blocking review gate"
    present "$f" "ai-policy-code-review.md" "$base names the code-review policy"
done

for f in "$ISSUE" "$MANAGE" "$IMPLEMENT" "$HANDOFF"; do
    base="$(basename "$f")"
    absent "$f" "Critical and Major finding" "$base drops the Critical and Major list"
    absent "$f" "Critical or Major finding" "$base drops the Critical or Major list"
    absent "$f" "Fix every Critical finding." "$base drops the Critical-only rule"
    absent "$f" "Fix every Major finding." "$base drops the Major-only rule"
done

line "$ISSUE" "### Plan Template" "issue policy owns the plan template"
line "$ISSUE" "## Goal" "plan template has the Goal section"
line "$ISSUE" "## Evidence" "plan template has the Evidence section"
line "$ISSUE" "## Depth" "plan template has the Depth section"
line "$ISSUE" "## Context" "plan template has the Context section"
line "$ISSUE" "## Decisions (ADR)" "plan template has the Decisions section"
line "$ISSUE" "## Deltas" "plan template has the Deltas section"
line "$ISSUE" "## Acceptance Criteria" "plan template has the Acceptance Criteria section"
line "$ISSUE" "## Verification" "plan template has the Verification section"
line "$ISSUE" "## Peer Review Log" "plan template has the Peer Review Log section"
line "$ISSUE" "## Risks and Rollback" "plan template has the Risks and Rollback section"
line "$ISSUE" "## Close Sequence" "plan template has the Close Sequence section"
present "$ISSUE" "baseline" "close sequence names the baseline"
present "$ISSUE" "Each acceptance criterion has at least one behavioral assertion." "plan template states the assertion floor"
present "$ISSUE" "More are allowed and the number is not capped." "plan template keeps the assertion floor uncapped"
present "$ISSUE" "A behavioral assertion is an executable check that fails when the rule is absent or wrong, not a snapshot of AI prose." "plan template defines the behavioral assertion"
present "$ISSUE" "Static policy text may assert exact clauses; AI-generated plans and reviews assert structure and decisions." "plan template scopes the assertion kinds"
present "$ISSUE" "Use context plus acceptance criteria for an \`S\` or \`M\` ticket." "issue policy gives S and M the light path"
present "$ISSUE" "Use an HLD and an LLD with acceptance criteria for an \`L\` or \`XL\` ticket." "issue policy gives L and XL the full set"
present "$DESIGN" "For small and medium work, use context plus acceptance criteria." "design policy gives small and medium the light path"
present "$DESIGN" "For large and architectural work, use the full document set." "design policy gives large and architectural the full set"
present "$DESIGN" "For large or architectural work" "design policy aligns the session-start check"
absent "$ISSUE" "for an \`M\`, \`L\`, or \`XL\` ticket" "issue policy drops the M/L/XL HLD/LLD rule"
absent "$DESIGN" "For medium, large, and architectural work" "design policy drops the old proportional depth"
absent "$DESIGN" "For medium or larger work" "design policy drops the old session-start check"
present "$ISSUE" "Commit the current planning records, including the plan and ticket, as a baseline chore commit" "issue policy owns the baseline rule"
present "$ISSUE" "Permit only that baseline chore commit as the exception to the no-pre-work rule." "issue policy owns the narrow no-pre-work exception"
present "$ISSUE" "Treat the implementation request plus the Close Sequence as the explicit approval for the protected-branch baseline commit" "issue policy names the protected-branch approval"
present "$ISSUE" "Verify a clean tree and the baseline path list" "issue policy requires the clean-tree preflight"
present "$ISSUE" "Protected Branches" "issue policy cites the common protected-branches rule"
present "$MANAGE" "Plan Template" "manage-issues cites the plan template"
present "$IMPLEMENT" "Plan Template" "implement-plan checks the plan template"
present "$IMPLEMENT" "baseline" "implement-plan checks the baseline"
present "$IMPLEMENT" "Verify the tree is clean" "implement-plan checks the clean tree"
present "$CHECKPOINT" "Current position" "checkpoint report names the current position block"
present "$CHECKPOINT" "[NEXT-STEPS]" "checkpoint report names the next-steps section"
present "$CHECKPOINT" "The block carries no \`Next up\` and no remaining queue." "checkpoint keeps the queue out of the current position"
present "$CHECKPOINT" "Last active" "checkpoint report names the last-active item"
present "$CHECKPOINT" "Name the ticket path or slug" "checkpoint report names ticket-backed items"
present "$CHECKPOINT" "ten or fewer remain" "checkpoint report caps the full list at ten"
present "$CHECKPOINT" "otherwise list a count and the \`ai/state/next-steps.md\` pointer" "checkpoint report has the count fallback"
present "$CHECKPOINT" "The transaction log remains the delta" "checkpoint report keeps the delta log"
absent "$CHECKPOINT" '`Next up` lists the active item first' "checkpoint report drops the old next-up clause"

report_contract() {
    local total="$1" active="$2" i
    printf 'Current position:\n'
    printf -- '- Milestone: fixture\n'
    printf -- '- Last active: fixture entry\n'
    printf '[NEXT-STEPS]\n'
    printf -- '- Active: %s\n' "$active"
    if [ "$total" -le 10 ]; then
        i=2
        while [ "$i" -le "$total" ]; do
            printf -- '- Remaining: item-%02d\n' "$i"
            i=$((i + 1))
        done
    else
        printf -- '- Remaining: %d more open items in ai/state/next-steps.md\n' "$((total - 1))"
    fi
    printf '[PROGRESS] Added: "fixture"\n'
    printf '[NEXT-STEPS] Removed: "none" | Added: "fixture"\n'
}

active_path="ai/issues/open/checkpoint-next-steps-reporting.md"
report_10="$(report_contract 10 "$active_path")"
report_11="$(report_contract 11 "$active_path")"

if printf '%s\n' "$report_10" | grep -qF -- "- Remaining: item-09" \
    && printf '%s\n' "$report_10" | grep -qF -- "- Remaining: item-10"; then
    printf 'PASS %s\n' "checkpoint contract lists all ten items"
else
    printf 'FAIL %s\n' "checkpoint contract lists all ten items"
    fail=1
fi
if printf '%s\n' "$report_11" | grep -qF -- "- Remaining: 10 more open items in ai/state/next-steps.md" \
    && ! printf '%s\n' "$report_11" | grep -qF -- "item-11"; then
    printf 'PASS %s\n' "checkpoint contract uses the count and pointer over ten"
else
    printf 'FAIL %s\n' "checkpoint contract uses the count and pointer over ten"
    fail=1
fi
if printf '%s\n' "$report_10" | grep -qF -- "- Active: $active_path"; then
    printf 'PASS %s\n' "checkpoint contract names the active ticket"
else
    printf 'FAIL %s\n' "checkpoint contract names the active ticket"
    fail=1
fi
current_line="$(printf '%s\n' "$report_10" | grep -n -m1 -F 'Current position' | cut -d: -f1)"
next_line="$(printf '%s\n' "$report_10" | grep -n -m1 -F '[NEXT-STEPS]' | cut -d: -f1)"
progress_line="$(printf '%s\n' "$report_10" | grep -n -m1 -F '[PROGRESS]' | cut -d: -f1)"
next_log_line="$(printf '%s\n' "$report_10" | grep -n -m1 -F '[NEXT-STEPS] Removed' | cut -d: -f1)"
if [ "$current_line" -lt "$next_line" ] && [ "$next_line" -lt "$progress_line" ] && [ "$progress_line" -lt "$next_log_line" ]; then
    printf 'PASS %s\n' "checkpoint contract keeps the queue before the separate log"
else
    printf 'FAIL %s\n' "checkpoint contract keeps the queue before the separate log"
    fail=1
fi
current_block="$(printf '%s\n' "$report_10" | sed -n '1,/^\[NEXT-STEPS\]$/p' | sed '$d')"
if ! printf '%s\n' "$current_block" | grep -qE 'Next up|Remaining'; then
    printf 'PASS %s\n' "checkpoint current position carries no queue"
else
    printf 'FAIL %s\n' "checkpoint current position carries no queue"
    fail=1
fi
if [ "$(printf '%s\n' "$report_10" | grep -c '^\[NEXT-STEPS\]')" -eq 2 ]; then
    printf 'PASS %s\n' "checkpoint contract shows the queue and the log separately"
else
    printf 'FAIL %s\n' "checkpoint contract shows the queue and the log separately"
    fail=1
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: issue-management plug-in fixture."
    exit 1
fi
echo "PASSED: issue-management plug-in fixture."
exit 0

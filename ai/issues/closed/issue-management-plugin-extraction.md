Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Move the issue management protocol to a trigger-loaded plug-in

Description:

**Context**: the third of the six common extraction children in `extract-common-policy-sections-into-standalone-plugin-policies.md`. The unit table names the target, the two triggers, the two loading procedures, and the size.

**Scope**:

- Create `ai-policy-issue-management.md` with the guard and markers, the title `# AI Policy: Issue Management`, a one-line purpose, `## Triggers` with `- issue standards` and `- ticket standards`, `## Loading` with `- Mode: trigger`, `## Scope`, the moved ticket storage, fields, content, plan, and work-item invariants, and `## References`.
- Move 86 lines from the common policy.
- Keep a short `## Issue Invariant` in the common policy: one unit of work is one ticket; the issue contract owns the storage, fields, content, plan, delivery invariants, and the issue template rule.
- Update the load-context template instruction: when the template is missing, load the issue plug-in and create it from its `### Ticket Fields`.
- Update `MANAGE-ISSUES` and `IMPLEMENT-PLAN` to load the plug-in.
- Add a dev-time fixture, `tests/test-issue-policy.sh`, that pins the common invariant, the two triggers, the loading mode, the template instruction, and the two procedure loads.
- Raise the policy floor to 22.
- Add the ADR entry and update the current docs.
- No release.

**Out of scope**:

- Any change to the issue rules themselves.
- The design-docs, coding-baseline, and thinking-modes children.
- The `MANAGE-ISSUES` workflow steps, which stay in the procedure.

**Acceptance criteria**:

- The new policy passes the authoring validator and has both triggers, the trigger mode, and the moved rules.
- The common policy keeps a short issue invariant and names no policy file outside the canonical header literal; its References stay two bullets.
- The load-context template instruction points at the issue plug-in and loads it only when the template is missing.
- MANAGE-ISSUES and IMPLEMENT-PLAN load the plug-in.
- The new fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The policy count and the floor are 22.
- The authoring and protocol validators pass; shellcheck and markdownlint are clean.
- The ADR entry records the extraction.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai/issues/in-progress/knowledge-plugin-extraction.md`, `ai-policy-common.md`, `ai-policy-meta.md`, `ai/procedures/manage-issues.md`, `ai/procedures/implement-plan.md`, `ai/procedures/load-context.md`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The common policy held `## Issue Management Protocol` with the storage, fields, content, plan, and work-item invariants.
- The unit table names `ai-policy-issue-management.md`, the triggers `issue standards` and `ticket standards`, and MANAGE-ISSUES and IMPLEMENT-PLAN as loaders.
- LOAD-CONTEXT created the issue template from the compact field list in the common policy; the instruction now loads the plug-in only when the template is missing.
- The validator requires the template file and has no issue-section anchors.

## Red Run (T1)

`bash tests/test-issue-policy.sh` exited 1: the plug-in was missing, the common invariant was absent, the template instruction pointed at the common policy, and neither procedure loaded the plug-in.

## Green Run (T5)

- `tests/test-issue-policy.sh`: PASSED.
- `tests/run-all.sh`: 12 scripts pass.
- Protocol validator: 8/8, policy scan 22 with floor 22.
- Authoring: PASSED.
- Index: 36 modules, 22 policies, 14 procedures, 45 triggers, 0 conflicts, 0 errors.
- shellcheck clean; markdownlint 0.

## High-Level Design

- The issue rules move to a global plug-in. The common policy keeps a short `## Issue Invariant`; the plug-in owns the template rule.
- The plug-in declares `Mode: trigger` with `issue standards` and `ticket standards`; MANAGE-ISSUES and IMPLEMENT-PLAN load it.
- The template path loads the plug-in only when the template is missing.
- The policy count and floor become 22; the new fixture pins the boundary and the loads.

## Low-Level Design and Acceptance Criteria

- T1: the fixture checks the common invariant, both triggers, the trigger mode, the template rule, the conditional load instruction, and the two procedure loads.
- T2: `ai-policy-issue-management.md` exists with the guard, markers, title, purpose, both triggers, the mode, the scope, the moved rules, and references.
- T3: the common policy keeps the `## Issue Invariant`; the load-context template instruction loads the plug-in only when the template is missing.
- T4: MANAGE-ISSUES and IMPLEMENT-PLAN load the plug-in.
- T5: the fixture and the suite are green.
- T6: the floor is 22; the validation doc, the verification-toolchain note, and the ADR are updated.
- T7: the implementation review is APPROVED, the branch is green, and no trunk merge occurs.

## Risks and Mitigations

- The template could be created before the rule moves: the instruction loads the plug-in only when the template is missing.
- The common invariant could duplicate the template rule: the plug-in owns it.
- The procedures could apply the rules without loading them: both load the plug-in.
- The policy count could drift: the floor is 22.
- The moved rules stay verbatim and the fixture proves the anchor set.
- No release: the program release waits for all units.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the knowledge commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/issue-management-plugin-extraction.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_23-20_review-11.md`: APPROVED.
- Implementation round 2, `ai/code-review-reports/2026-11-16_23-35_review-12.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the issue plug-in, the common invariant, the conditional template load, the two procedure loads, the new fixture, the floor at 22, the validation doc, the verification-toolchain note, and the ADR. The suite is green, and implementation review 12 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.

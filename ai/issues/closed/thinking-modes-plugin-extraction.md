Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Move the grilling and brainstorming modes to a trigger-loaded plug-in

Description:

**Context**: the sixth common extraction child in `extract-common-policy-sections-into-standalone-plugin-policies.md`. The unit table marks it optional and low value, with triggers `grill me` and `brainstorm`.

**Scope**:

- Create `ai-policy-thinking-modes.md` with the guard and markers, the title `# AI Policy: Thinking Modes`, a one-line purpose, `## Triggers` with `- grill me` and `- brainstorm`, `## Loading` with `- Mode: trigger`, `## Scope`, the moved `## Grilling` and `## Brainstorming` sections, and `## References`.
- Move the 20 lines from the common policy.
- Keep a `## Thinking Modes` invariant in the common policy: reach shared understanding before implementation; the thinking-modes contract owns convergent grilling and divergent brainstorming.
- Update the Pre-Work Gate's convergence pointer to the thinking-modes contract, without naming a policy file.
- Update `MANAGE-ISSUES` planning and `IMPLEMENT-PLAN` preflight to load the policy when they grill or brainstorm.
- Add `tests/test-thinking-modes-policy.sh` pinning the invariant, both triggers, the loading mode, the moved modes, the Pre-Work Gate pointer, and the two procedure loads.
- Raise the policy floor to 23.
- Add the ADR entry and update the current docs.
- No release.

**Out of scope**:

- Any change to the grilling or brainstorming methods.
- The legacy children.

**Acceptance criteria**:

- The new policy passes the authoring validator and has both triggers, the trigger mode, and the moved modes.
- The common policy keeps the thinking-modes invariant and names no policy file outside the canonical header literal.
- The Pre-Work Gate points at the contract; MANAGE-ISSUES and IMPLEMENT-PLAN load the policy.
- The new fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The policy count and floor are 23.
- The authoring and protocol validators pass; shellcheck and markdownlint are clean.
- The ADR entry records the extraction.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai/issues/in-progress/design-docs-plugin-extraction.md`, `ai-policy-common.md`, `ai-policy-meta.md`, `ai/procedures/manage-issues.md`, `ai/procedures/implement-plan.md`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The common policy held `## Grilling` and `## Brainstorming`, 20 lines, and the Pre-Work Gate pointed at the Grilling section.
- The unit table names `ai-policy-thinking-modes.md`, the triggers `grill me` and `brainstorm`, and marks the unit optional and low value.
- No procedure referenced the two sections by name; no validator anchor exists for them.

## Red Run (T1)

`bash tests/test-thinking-modes-policy.sh` exited 1: the plug-in was missing, the common still held both modes, the Pre-Work Gate pointed at the section, and neither procedure loaded the policy.

## Green Run (T5)

- The thinking-modes fixture: PASSED.
- `tests/run-all.sh`: 14 scripts pass.
- Protocol validator: 8/8, policy scan 23 with floor 23.
- Authoring: PASSED.
- Index: 37 modules, 23 policies, 14 procedures, 47 triggers, 0 conflicts, 0 errors.
- shellcheck clean; markdownlint 0.

## High-Level Design

- The modes move to a global plug-in with a trigger mode. The common keeps a short `## Thinking Modes` invariant.
- The Pre-Work Gate points at the contract; MANAGE-ISSUES planning and IMPLEMENT-PLAN preflight load the policy for the internal run.
- The policy count and floor become 23.

## Low-Level Design and Acceptance Criteria

- T1: the fixture pins the invariant, both triggers, the mode, the moved sections, the gate pointer, and the two procedure loads.
- T2: `ai-policy-thinking-modes.md` exists with the guard, markers, title, purpose, both triggers, the trigger mode, the scope, the moved sections, and references.
- T3: the common keeps the `## Thinking Modes` invariant and the Pre-Work Gate points at the contract.
- T4: MANAGE-ISSUES and IMPLEMENT-PLAN load the policy.
- T5: the fixture and the suite are green.
- T6: the floor is 23; the validation doc, the verification-toolchain note, and the ADR are updated.
- T7: the implementation review is APPROVED, the branch is green, and no trunk merge occurs.

## Risks and Mitigations

- The triggers are substrings of the documented phrases; the namespace check passes.
- The internal Pre-Work Gate run has no user trigger: the two procedures load the policy.
- The common boundary holds: the gate points at the contract, not a file.
- The policy count and floor are 23.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the coding-baseline deferral commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/thinking-modes-plugin-extraction.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_22-35_review-15.md`: APPROVED.
- Implementation round 2, `ai/code-review-reports/2026-11-16_22-50_review-16.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the thinking-modes plug-in, the common invariant, the Pre-Work Gate pointer, the two procedure loads, the new fixture, the floor at 23, the validation doc, the verification-toolchain note, and the ADR. The suite is green, and implementation review 16 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.

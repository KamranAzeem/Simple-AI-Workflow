Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Rewrite the Linux system administration policy to the authoring standard and declare its expertise loading

Description:

**Context**: the first of the five legacy children in `extract-common-policy-sections-into-standalone-plugin-policies.md`. The policy is structurally valid but not prose-rewritten to the authoring standard, and it has no loading declaration.

**Scope**:

- Rewrite `ai-policy-linux-system-admin.md` to the authoring standard: one sentence per bullet, imperative voice, no filler, no duplicated rules, flat bullets, and the same section ownership.
- Preserve every rule: the purpose, the scope, the eight role capabilities, the six OS-specific standards, the test-before-execute rules, the four validation types, the four testing standards, and the three references.
- Add `## Loading` with `- Mode: expertise`, because the policy loads through `## Active Expertise` or by name.
- Add `tests/test-linux-policy.sh` pinning the loading declaration and the key rule anchors.
- Add the ADR entry and update the current docs if they need the loading note.
- No policy count or trigger change.

**Out of scope**:

- Any change to the Linux rules themselves.
- The other four legacy policies.

**Acceptance criteria**:

- The rule-coverage matrix in the plan maps every existing rule to its rewritten location; no rule is dropped or weakened.
- The policy passes the authoring validator and carries `- Mode: expertise`.
- The fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The index reports `mode=expertise` for the policy.
- The implementation review, including the prose and rule-coverage pass, is APPROVED.
- Shellcheck and markdownlint are clean.
- The ADR entry records the rewrite.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai-policy-linux-system-admin.md`, `ai-policy-meta.md`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The Linux policy was 65 lines with no loading declaration; the index reported `mode=legacy`.
- The rule inventory: purpose 1, scope 1, role 8, OS standards 6, test-before-execute 3, validation 4, testing 4, references 3, 30 rules.
- The authoring standard requires one sentence per bullet, imperative voice, and no duplicated rules.

## Red Run (T1)

`bash tests/test-linux-policy.sh` exited 1: no `## Loading` and `mode=legacy`.

## Green Run (T3)

- The Linux fixture: PASSED, including `mode=expertise`.
- `tests/run-all.sh`: 15 scripts pass.
- Protocol validator: 8/8, policy scan 23 with floor 23.
- Authoring: PASSED.
- Index: 37 modules, 23 policies, 14 procedures, 47 triggers, 0 conflicts, 0 errors.
- shellcheck clean; markdownlint 0.

## High-Level Design

- Editorial rewrite only: one sentence per bullet, imperative voice, same sections and rules.
- Add `## Loading` with `- Mode: expertise`, matching the Active Expertise and by-name paths.
- The fixture pins the loading and the key anchors; the prose and coverage pass is peer-reviewed.

## Low-Level Design and Acceptance Criteria

- T1: the fixture pins the loading, the expertise mode, the key rule anchors, and the index mode.
- T2: the rewrite keeps all 30 rules and adds the loading declaration.
- T3: the fixture and the suite are green.
- T4: the validators, shellcheck, and markdownlint are green.
- T5: the review, including the rule-coverage pass, is APPROVED.
- T6: the ADR entry is appended and the change is committed.

## Risks and Mitigations

- The rewrite could drop a rule: the coverage matrix and the review.
- The prose is not testable: the review is the gate.
- The loading mode matches the existing path.
- No policy-count or trigger change.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the thinking-modes commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/linux-legacy-policy-rewrite.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_23-05_review-17.md`: APPROVED.
- Implementation round 2, `ai/code-review-reports/2026-11-16_23-20_review-18.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the Linux policy is rewritten to the authoring standard, all 30 rules are preserved, the loading declaration is `Mode: expertise`, the fixture pins the loading and anchors, and the docs and ADR are updated. The suite is green, and implementation review 18 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.

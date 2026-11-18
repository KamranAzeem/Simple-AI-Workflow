Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Rewrite the Windows system administration policy to the authoring standard and declare its expertise loading

Description:

**Context**: the fourth of the five legacy children in `extract-common-policy-sections-into-standalone-plugin-policies.md`. The policy is structurally valid but not prose-rewritten to the authoring standard, and it has no loading declaration.

**Scope**:

- Rewrite `ai-policy-windows-system-admin.md` to the authoring standard: one sentence per bullet, imperative voice, no filler, no duplicated rules, flat bullets, and the same section ownership.
- Preserve every rule: the purpose, the two scope statements, the ten role capabilities, the eleven framework and governance rules, the fourteen PowerShell rules, the eight Active Directory rules, the eleven security-operation rules, the fourteen testing rules, and the three references.
- Add `## Loading` with `- Mode: expertise`, because the policy loads through `## Active Expertise` or by name.
- Add `tests/test-windows-policy.sh` pinning the loading declaration, the key rule anchors, and the index mode.
- Add the ADR entry and update the current docs if they need the loading note.
- No policy count or trigger change.

**Out of scope**:

- Any change to the Windows rules themselves.
- The last legacy policy, academic.

**Acceptance criteria**:

- The rule-coverage matrix in the plan maps every existing rule to its rewritten location; no rule is dropped or weakened.
- The policy passes the authoring validator and carries `- Mode: expertise`.
- The fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The index reports `mode=expertise` for the policy.
- The implementation review, including the prose and rule-coverage pass, is APPROVED.
- Shellcheck and markdownlint are clean.
- The ADR entry records the rewrite.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai-policy-windows-system-admin.md`, `ai-policy-meta.md`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The policy was 144 lines with no loading declaration; the index reported `mode=legacy`.
- Rule inventory: 71 rules (purpose 1, scope 2, role 10, frameworks 11, PowerShell 14, Active Directory 8, security operations 11, testing 14), plus 3 references.
- The authoring standard requires one sentence per bullet, imperative voice, and no rationale; every directive is kept.
- The Linux, accounting, and career entries establish the rewrite pattern.

## Rule-Coverage Matrix

- Purpose and the two scope statements: kept.
- Role: the senior framing and ten capabilities: kept.
- Frameworks: SCT, CIS, DISA STIG, Zero Trust, CAF, ITIL, Secure Score, Intune, MECM, Windows Admin Center, DSC: kept.
- PowerShell: seven language and style rules, four safety rules, three remoting rules: kept, including the exact encoding call.
- Active Directory: four design rules and four GPO authorship rules: kept.
- Security operations: eight hardening items and three JIT and privileged-access rules: kept.
- Testing: four test-before-execute rules, six validation types, four testing standards: kept.
- References: kept.

No rule is dropped, merged, or weakened.

## Red Run (T1)

`bash tests/test-windows-policy.sh` exited 1: no `## Loading`, `mode=legacy`, the `&` headings, and no expertise mode; the encoding anchor also failed until the exact API call was restored.

## Green Run (T5)

- The Windows fixture: PASSED, including `mode=expertise`.
- `tests/run-all.sh`: 18 scripts pass.
- Protocol validator: 8/8, policy scan 23 with floor 23.
- Authoring: PASSED.
- Index: 37 modules, 23 policies, 14 procedures, 47 triggers, 0 conflicts, 0 errors.
- shellcheck clean; markdownlint 0.

## High-Level Design

- Editorial rewrite only: one sentence per bullet, imperative voice, same sections and rules.
- `## Loading` with `- Mode: expertise`.
- The fixture pins the loading, the framework and testing anchors, and the index mode.

## Low-Level Design and Acceptance Criteria

- T1: the fixture fails before the rewrite and passes after it.
- T2: all 71 rules and the 3 references are preserved.
- T3: `## Loading` carries `- Mode: expertise` and no `## Triggers` or `Load in:`.
- T4: the fixture pins the loading, the key anchors, and the index mode.
- T5: the fixture and the suite are green; the index reports `mode=expertise`.
- T6: the validators, shellcheck, and markdownlint are green.
- T7: the review is APPROVED and the ADR entry is appended.

## Risks and Mitigations

- A directive could disappear with its rationale: the matrix and the review walk every bullet.
- The prose is not testable: the review is the gate.
- No policy-count or trigger change; the floor stays 23.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the career commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/windows-legacy-policy-rewrite.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, coverage matrix, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_23-59_review-23.md`: APPROVED.
- Implementation round 2, `ai/code-review-reports/2026-11-17_00-05_review-24.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the Windows policy is rewritten to the authoring standard, all 71 rules are preserved, the loading declaration is `Mode: expertise`, the fixture pins the loading and anchors, and the docs and ADR are updated. The suite is green, and implementation review 24 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.

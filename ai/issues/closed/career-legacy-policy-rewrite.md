Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Rewrite the career coaching policy to the authoring standard and declare its expertise loading

Description:

**Context**: the third of the five legacy children in `extract-common-policy-sections-into-standalone-plugin-policies.md`. The policy is structurally valid but not prose-rewritten to the authoring standard, and it has no loading declaration.

**Scope**:

- Rewrite `ai-policy-career-coaching.md` to the authoring standard: one sentence per bullet, imperative voice, no filler, no duplicated rules, flat bullets, and the same section ownership.
- Preserve every rule: the purpose, the scope, the hybrid-persona role and its five capabilities, the four core-standard groups, the STAR method and the four mock-session rules, the five testing rules, and the three references.
- Convert the sample customization and the three suggested prompts to non-normative fenced examples under `## Examples`, as the authoring standard requires.
- Add `## Loading` with `- Mode: expertise`, because the policy loads through `## Active Expertise` or by name.
- Add `tests/test-career-policy.sh` pinning the loading declaration, the key rule anchors, the example rule, and the index mode.
- Add the ADR entry and update the current docs if they need the loading note.
- No policy count or trigger change.

**Out of scope**:

- Any change to the career rules themselves.
- The other two legacy policies.

**Acceptance criteria**:

- The rule-coverage matrix in the plan maps every existing rule to its rewritten location; no rule is dropped or weakened.
- The policy passes the authoring validator and carries `- Mode: expertise`.
- The fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The index reports `mode=expertise` for the policy.
- The implementation review, including the prose and rule-coverage pass, is APPROVED.
- Shellcheck and markdownlint are clean.
- The ADR entry records the rewrite.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai-policy-career-coaching.md`, `ai-policy-meta.md`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The policy was 106 lines with no loading declaration; the index reported `mode=legacy`.
- Rule inventory: 28 rules (purpose 1, scope 1, role 5, core standards 8, interview protocol 8, testing 5), plus 1 customization sample, 3 prompts, and 3 references.
- The authoring standard requires one sentence per bullet, imperative voice, and examples only as non-normative fenced blocks.
- The ADR 2026-07-25 keeps the single `career-coaching` token; the Linux and accounting entries establish the rewrite pattern.

## Rule-Coverage Matrix

- Purpose and scope: kept.
- Role: hybrid persona and the five capabilities: resume, cover letters, interview preparation, career strategy, and executive recruitment: kept.
- Core standards: ATS (2), conciseness (2), feedback (2), actionable edits (2): kept.
- Interview protocol: STAR (4) and mock sessions (4): kept.
- Testing: ATS scan, length check, metrics audit, keyword match, incomplete information: kept.
- Sample customization and the three prompts: preserved verbatim under `## Examples`, marked non-normative.
- References: kept.

No rule is dropped, merged, or weakened.

## Red Run (T1)

`bash tests/test-career-policy.sh` exited 1: no `## Loading`, `mode=legacy`, no `## Examples`, and the old sample heading remained.

## Green Run (T5)

- The career fixture: PASSED, including `mode=expertise`.
- `tests/run-all.sh`: 17 scripts pass.
- Protocol validator: 8/8, policy scan 23 with floor 23.
- Authoring: PASSED.
- Index: 37 modules, 23 policies, 14 procedures, 47 triggers, 0 conflicts, 0 errors.
- shellcheck clean; markdownlint 0.

## High-Level Design

- Editorial rewrite only: one sentence per bullet, imperative voice, same sections and rules.
- `## Loading` with `- Mode: expertise`.
- The sample and prompts merge into one non-normative `## Examples` section, the only structural change beyond the loading.
- The fixture pins the loading, the hybrid role, the key anchors, the example rule, and the index mode.

## Low-Level Design and Acceptance Criteria

- T1: the fixture fails before the rewrite and passes after it.
- T2: all 28 rules and the 3 references are preserved.
- T3: `## Loading` carries `- Mode: expertise` and no `## Triggers` or `Load in:`.
- T4: the sample and prompts are non-normative fenced blocks under `## Examples`, preserved verbatim.
- T5: the fixture and the suite are green; the index reports `mode=expertise`.
- T6: the validators, shellcheck, and markdownlint are green.
- T7: the review is APPROVED and the ADR entry is appended.

## Risks and Mitigations

- The rewrite could drop a rule: the coverage matrix and the review.
- The prose is not testable: the review is the gate.
- The examples could drift: they are preserved verbatim and pinned in the fixture.
- No policy-count or trigger change; the floor stays 23.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the accounting commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/career-legacy-policy-rewrite.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, coverage matrix, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_23-55_review-21.md`: APPROVED.
- Implementation round 2, `ai/code-review-reports/2026-11-16_23-58_review-22.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the career policy is rewritten to the authoring standard, all 28 rules are preserved, the sample and prompts are non-normative examples, the loading declaration is `Mode: expertise`, the fixture pins the loading and anchors, and the docs and ADR are updated. The suite is green, and implementation review 22 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.

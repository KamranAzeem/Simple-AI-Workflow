Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Rewrite the academic research policy to the authoring standard and declare its expertise loading

Description:

**Context**: the fifth and last legacy child in `extract-common-policy-sections-into-standalone-plugin-policies.md`. The policy is structurally valid but not prose-rewritten to the authoring standard, and it has no loading declaration.

**Scope**:

- Rewrite `ai-policy-academic-researcher.md` to the authoring standard: one sentence per bullet, imperative voice, no filler, no duplicated rules, flat bullets, and the same section ownership.
- Preserve every rule across the purpose, the scope, the role, the governing frameworks, the core principles, the source-quality rules, the ethical DO and DO NOT lists, the plagiarism, copyright, citation, AI-disclosure, statistics, data, human-subjects, security, authorship, conflict, and post-publication rules, the nine process stages, the literature-review standards, the domain rigor rules, the AI operating boundaries, the checklist, and the verification checks.
- Flatten the nested process-stage and per-paper-capture bullets into headings with flat bullets.
- Remove the `## Appendix: Gaps Identified & Filled` changelog; it carries no directive.
- Convert the AI-disclosure example to a non-normative fenced block.
- Add `## Loading` with `- Mode: expertise`, because the policy loads through `## Active Expertise` or by name.
- Add `tests/test-academic-policy.sh` pinning the loading declaration, the key rule anchors, and the index mode.
- Add the ADR entry and update the current docs if they need the loading note.
- No policy count or trigger change.

**Out of scope**:

- Any change to the academic rules themselves.
- The common and legacy extractions.

**Acceptance criteria**:

- The rule-coverage matrix in the plan maps every existing rule to its rewritten location; no rule is dropped or weakened.
- The policy passes the authoring validator and carries `- Mode: expertise`.
- The fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The index reports `mode=expertise` for the policy.
- The implementation review, including the prose and rule-coverage pass, is APPROVED.
- Shellcheck and markdownlint are clean.
- The ADR entry records the rewrite.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai-policy-academic-researcher.md`, `ai-policy-meta.md`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The policy was 398 lines with no loading declaration; the index reported `mode=legacy`.
- Rule inventory: 209 rules across the purpose, the scope, the role, and 22 numbered sections, plus 1 disclosure example, 3 references, and a changelog appendix with no directive.
- The authoring standard requires one sentence per bullet, imperative voice, no rationale, no nested bullets, and examples only as non-normative fenced blocks.
- The Linux, accounting, career, and Windows entries establish the rewrite pattern.

## Rule-Coverage Matrix

- Purpose, scope, and role: kept.
- Sections 1 and 2: the frameworks and the five core principles: kept.
- Section 3: the hard filter, the four acceptable-source tiers, the six prohibited rules and the primary-artifact note, the five venue-verification rules, the four recency rules, and the three sourcing rules: kept.
- Sections 4 and 5: the twelve DO rules and the fourteen DO NOT rules: kept.
- Sections 6 through 16: plagiarism, copyright, citation, AI disclosure, statistics, data, human subjects, security ethics, authorship, conflicts, and post-publication: kept.
- Section 17: the nine stages with objective, AI role, and guardrail, and the three supervision checkpoints: kept, flattened into one heading per stage.
- Section 18: the literature rules and the three per-paper-capture groups: kept.
- Sections 19 through 22: domain rigor, AI boundaries, the checklist, and the verification checks: kept.
- References: kept.
- The changelog appendix is removed; it carries no directive.

No rule is dropped, merged, or weakened.

## Red Run (T1)

`bash tests/test-academic-policy.sh` exited 1: no `## Loading`, `mode=legacy`, the old `&` headings, the changelog appendix, and four supervision-checkpoint matches; the `ORI` anchor also failed until the acronym was restored.

## Green Run (T5)

- The academic fixture: PASSED, including `mode=expertise` and the three checkpoints.
- `tests/run-all.sh`: 19 scripts pass.
- Protocol validator: 8/8, policy scan 23 with floor 23.
- Authoring: PASSED.
- Index: 37 modules, 23 policies, 14 procedures, 47 triggers, 0 conflicts, 0 errors.
- shellcheck clean; markdownlint 0.

## High-Level Design

- Editorial rewrite: one sentence per bullet, imperative voice, same sections and § cross-references.
- Flatten the process stages and the per-paper capture into headings with flat bullets.
- `## Loading` with `- Mode: expertise`; the disclosure example becomes a non-normative fenced block; the changelog appendix is removed.

## Low-Level Design and Acceptance Criteria

- T1: the fixture fails before the rewrite and passes after it.
- T2: all 209 rules and the 3 references are preserved.
- T3: `## Loading` carries `- Mode: expertise` and no `## Triggers` or `Load in:`.
- T4: the example is non-normative and the appendix is gone.
- T5: the fixture and the suite are green; the index reports `mode=expertise`.
- T6: the validators, shellcheck, and markdownlint are green.
- T7: the review is APPROVED and the ADR entry is appended.

## Risks and Mitigations

- A directive could disappear: the section matrix and the section-by-section review.
- The prose is not testable: the review is the gate.
- A stage or checkpoint could be lost in the flattening: the fixture pins all nine stages and the three checkpoints.
- No policy-count or trigger change; the floor stays 23.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the Windows commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/academic-legacy-policy-rewrite.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, coverage matrix, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-17_00-20_review-25.md`: APPROVED.
- Implementation round 2, `ai/code-review-reports/2026-11-17_00-35_review-26.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the academic policy is rewritten to the authoring standard, all 209 rules are preserved, the stages are flattened, the disclosure example is non-normative, the changelog appendix is gone, the loading declaration is `Mode: expertise`, the fixture pins the section map and anchors, and the docs and ADR are updated. The suite is green, and implementation review 26 is APPROVED. This completes the five legacy children; the ticket stays in-progress until the program merge, and the program release still waits for the coding-baseline unit and the live test.

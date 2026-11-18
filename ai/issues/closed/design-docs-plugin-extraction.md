Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Merge the common design-document standards into the procedure-loaded design-docs policy

Description:

**Context**: the fourth of the six common extraction children in `extract-common-policy-sections-into-standalone-plugin-policies.md`. Unlike the other units, the target policy already exists and already holds most of the rules; this is a merge with deduplication.

**Scope**:

- Add a real purpose sentence and a `## Loading` section with `- Mode: procedure` and `- Load in: update-design-docs` to `ai-policy-design-docs.md`. The current line 9 is a loading note, not a purpose.
- Merge the rules from the common policy that the policy lacks: the document chain, requirement gathering, proportional depth, layering, the session-start artifact check, the unique-ID rule, the Delivery Ledger status values and format, the supplementary documents, the update discipline, and the plan-is-not-a-design-document location rule.
- Deduplicate: the policy already owns document types, per-type skeletons, naming, location and migration, extraction, conciseness, confirmation, the ledger update rule, and the prohibited list. Do not restate them.
- Keep a `## Design Invariant` in the common policy: design documents live in `design-docs/`, are written or updated only through `"update design documents"`, and the design-docs contract owns the chain, types, depth, ledger, naming, and migration.
- Update the common policy's `### Pre-Work Gate` items to point at the design contract, without naming a policy file.
- Update `MANAGE-ISSUES` `STEP-PLAN` and `IMPLEMENT-PLAN` `STEP-PREFLIGHT` to load the policy when design depth is needed.
- Add `tests/test-design-docs-policy.sh` pinning the invariant, the loading declaration, the merged rules, and the planning and pre-work loads.
- Add the ADR entry and update the current docs.
- No policy count change; the floor stays 22.

**Out of scope**:

- Any change to the design rules themselves.
- The coding-baseline and thinking-modes children.
- The `update-design-docs` and `migrate-design-docs` procedures, which already load the policy.

**Acceptance criteria**:

- The policy has a purpose sentence, `Mode: procedure`, `Load in: update-design-docs`, and every missing rule merged without duplication.
- The common policy keeps the design invariant and names no policy file outside the canonical header literal.
- The Pre-Work Gate points at the contract without naming a policy file, and `MANAGE-ISSUES` and `IMPLEMENT-PLAN` load the policy when design depth is needed.
- The new fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The policy count remains 22.
- The authoring and protocol validators pass; shellcheck and markdownlint are clean.
- The ADR entry records the merge.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai/issues/in-progress/issue-management-plugin-extraction.md`, `ai-policy-common.md`, `ai-policy-design-docs.md`, `ai/procedures/update-design-docs.md`, `ai/procedures/migrate-design-docs.md`, `ai/procedures/manage-issues.md`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The common policy held the design standards through `## Design Documentation Standards`.
- The design policy already owned the types, skeletons, naming, location, migration, extraction, conciseness, ledger update rule, and prohibited list; the gaps were the chain, requirement gathering, depth, layering, the session-start check, the ID rule, the ledger status values, the supplementary documents, the update discipline, and the plan-location rule.
- The Pre-Work Gate lives in the common policy and may not name a policy file; the planning and pre-work loads belong in the procedures.

## Red Run (T1)

`bash tests/test-design-docs-policy.sh` exited 1: no loading declaration, the loading note was still the purpose, the merged rules were absent, and the planning procedures did not load the policy.

## Green Run (T5)

- The design fixture: PASSED.
- `tests/run-all.sh`: 13 scripts pass.
- Protocol validator: 8/8, policy scan 22 with floor 22.
- Authoring: PASSED.
- Index: 36 modules, 22 policies, 14 procedures, 45 triggers, 0 conflicts, 0 errors; the design-docs policy reports `mode=procedure`.
- shellcheck clean; markdownlint 0.

## High-Level Design

- The policy becomes the single owner. The common keeps a `## Design Invariant`.
- The policy gains a purpose, `Mode: procedure`, `Load in: update-design-docs`, and the missing rules, deduplicated.
- The Pre-Work Gate points at the contract; MANAGE-ISSUES and IMPLEMENT-PLAN load the policy for planning and pre-work.

## Low-Level Design and Acceptance Criteria

- T1: the fixture pins the invariant, the loading, the gaps, and the loads.
- T2: the policy has a purpose, the loading declaration, and the merged rules without restating the ones it owns.
- T3: the common keeps the invariant; the Pre-Work Gate items point at the contract.
- T4: MANAGE-ISSUES planning and IMPLEMENT-PLAN preflight load the policy.
- T5: the fixture and the suite are green.
- T6: the validation doc, the verification-toolchain note, and the ADR are updated.
- T7: the implementation review is APPROVED, the branch is green, and no trunk merge occurs.

## Risks and Mitigations

- The merge could duplicate rules: only the gaps were added.
- The Pre-Work Gate could dangle: it points at the contract, and the procedures load the file.
- The loading note could survive: it is replaced by a purpose.
- The ledger status values and format are merged.
- No policy-count change; the floor stays 22.
- No release: the program release waits for all units.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the issue-management commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/design-docs-plugin-extraction.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_22-00_review-13.md`: APPROVED.
- Implementation round 2, `ai/code-review-reports/2026-11-16_22-25_review-14.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the policy purpose and loading declaration, the merged gaps, the common design invariant, the Pre-Work Gate pointers, the planning and pre-work loads, the new fixture, the validation doc, the verification-toolchain note, and the ADR. The suite is green, and implementation review 14 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.

Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Give the review-sequencing rules a policy and ADR home instead of leaving them only in project knowledge

Description:

## Problem

The review-sequencing rules in the protocol verification note are normative, but they currently live only in a project-knowledge file. Project knowledge is just-in-time context, not authority. A rule that governs protocol design and development should have an enforceable home in a policy and a decision record in the ADR store.

The checkpoint summary called the review-sequencing and quality-gate rules "live". That is only partly true. The uniform blocking gate is in the code-review policy and the ADR store. The sequencing rules are not.

## Current state

- `ai/shared/project-knowledge/protocol-verification-toolchain.md:34-46` contains a `### Quality Gate` with normative rules.
- The uniform blocking gate is in `ai/policies/ai-policy-code-review.md:77-88` and ADR `design-docs/protocol-decisions.md:1416`.
- The plan template, assertion floor, and clean-tree baseline are in `ai/policies/ai-policy-issue-management.md` and ADR `:1426`.
- The following rules appear only in the knowledge file at `protocol-verification-toolchain.md:38-42`:
  - Bind every review verdict to the reviewed artifact's SHA-256.
  - Approve only with zero open Critical, Major, or Minor findings.
  - Fix every finding, then run one delta verification; do not reopen scope.
  - A post-approval edit invalidates the approval; a new hash needs a delta verification.
  - A new post-approval finding becomes a follow-up ticket unless it is a regression.
- `ai/policies/ai-policy-code-review.md` has the blocking gate but not the hash binding, delta verification, post-approval invalidation, or follow-up rule.
- The design decision rules say design documents live in `design-docs/` and genuine decisions belong in the decision store (`protocol-decisions.md:469`, `:479`).

## Desired outcome

- Move the sequencing rules into `ai/policies/ai-policy-code-review.md` as enforceable policy, probably a short `### Verdict and Delta Verification` section near the Blocking Review Gate or the Iteration Protocol.
- Add one self-contained ADR to `design-docs/protocol-decisions.md` for the decision, with context and consequences. Date it when implemented; it must not depend on a commit, branch, plan, or report.
- Reduce `ai/shared/project-knowledge/protocol-verification-toolchain.md` to the operational command checklist and environment caveats. Replace the normative gate and sequencing text with a pointer to the policy and ADR. Keep the knowledge header and the 15 KB trigger.
- Keep the uniform gate and the plan-quality rules in their existing policy and ADR homes. Remove duplicate restatements from the knowledge file or turn them into pointers.
- Add a fixture or assertion that pins the code-review policy clauses if a test can do so without brittle prose matching.
- Keep the command runbook in knowledge, not in design-docs. Design-docs records the decision; it is not a shell-command handbook.

## Acceptance criteria

- `ai/policies/ai-policy-code-review.md` states all five sequencing rules: hash binding, zero open Critical/Major/Minor, one delta verification, post-approval invalidation, and follow-up unless regression. An executable assertion fails when any clause is absent.
- `design-docs/protocol-decisions.md` has a dated, self-contained ADR for the decision. An executable assertion checks the heading and the five clauses; the entry names no commit, branch, plan, or non-committed report.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md` no longer carries the sequencing rules as their only home. It points to the code-review policy and the ADR, keeps its header, and stays under 15 KB. An executable assertion checks the pointer and the absence of the normative duplicate.
- The uniform gate and the plan-quality rules still resolve to their existing policy and ADR owners, with no contradictory copy. The existing tests and a cross-reference check pass.
- The full gate passes: protocol 8/8, authoring, suite 31/31, markdownlint 0, and the index counts. The plan records the exact commands and results.
- The command checklist remains in project knowledge or a maintainer runbook, never in `design-docs/`.

## Out of scope

- Moving the command checklist or exact test counts into `design-docs/`.
- Rewriting other project-knowledge files or the entire verification note.
- Changing the severity definitions, the blocking-gate scope, the plan template, the assertion floor, or the clean-tree baseline.
- Changing the peer-review procedure or report format beyond the policy addition.
- Choosing the release level now; the plan decides it, likely a PATCH.
- The scope-normalization ticket and the rest of the backlog.

## Notes

- This is a protocol change. In Protocol Developer Mode, load `design-docs/protocol-decisions.md` fully and get explicit human approval before committing. The implementation must add the ADR entry as part of the change.
- Keep the code-review policy tight and rationale-free; the reason belongs in the ADR and in the knowledge `Why` section.
- The verification note has exact counts that can drift; verify them when this is implemented.
- The issue records the 2026-11-25 discussion: the user's principle is that a rule governing protocol design and development must not live only in knowledge. The refined split is ADR for the decision, policy for the enforceable rule, knowledge for the runbook.
- No plan or branch exists yet; this ticket stays in `open/` until picked up.

---

2026-11-25

Plan: ai/plans/review-sequencing-rules-policy-home.md

Planning correction: the knowledge standard makes a knowledge file self-standing and forbids pointers to policies or docs. The verification note will therefore drop the duplicated gate and sequencing rules instead of linking to the policy and ADR. The code-review policy remains the operative owner and the ADR store records the decision.

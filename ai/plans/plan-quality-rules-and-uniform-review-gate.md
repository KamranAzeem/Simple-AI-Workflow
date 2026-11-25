# Plan: Uniform Review Gate

## Goal

Make one blocking review gate, owned by the code-review policy: every Critical, Major, and Minor finding is fixed before approval, with no cap and no demotion; a valid finding outside the ticket scope defers only with the user's explicit approval. Release v7.5.0.

## Evidence

- Ticket `ai/issues/open/plan-quality-rules.md` (119 lines) records the gate decision and the scope cut: the plan template, assertion floor, depth alignment, and clean-tree gate move to `ai/issues/open/plan-quality-follow-up-rules.md`.
- The local Critical/Major lists are in `ai-policy-issue-management.md:90`, `:91`, `:94`, `:105`, `ai/procedures/manage-issues.md:17`, `ai/procedures/implement-plan.md:10`, and `ai/procedures/create-handoff.md:11`.
- `ai-policy-code-review.md:74` defines Minor as "fix when convenient"; `docs/workflow-guide.md:271` repeats it. `ai-policy-code-review.md:25` states the reviewer is read-only. `ai-policy-code-review.md:39` keeps a pre-existing finding outside the change out of the verdict.
- `tests/test-issue-policy.sh` (71 lines) checks the issue policy, both delivery procedures, and the implementation-request approval sentence. `tests/test-docs-audit.sh:141` checks the guide's Close Sequence sentence.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md:95` is the stale caveat; lines 34 and 81 already state the uniform rule. `codebase-skeleton-map-simple-ai-workflow.md:53`, `:56`, and `:62` describe the current Critical-and-Major gate and the pending implementation.
- Baseline commands on 2026-11-25: `support-files/validate-protocol.sh` passed 8/8; `support-files/validate-policy-authoring.sh` passed; `bash tests/run-all.sh` passed 31/31; `validate-policy-authoring.sh --triggers` passed.
- The worktree has seven modified planning records and two untracked files: this plan and the follow-up ticket. Implementation starts from a clean tree; the user handles these records before the implementation request. This plan does not change that policy.
- Open questions: none.

## Depth

M, light path: context, acceptance criteria, and the ADRs below. No HLD or LLD is created.

## Context

This is the core gate only. The plan template, assertion floor, proportional depth, and clean-tree policy are deferred to the follow-up ticket. The change replaces policy clauses; it removes no product feature, data, or path migration.

## Decisions (ADR)

- ADR: the code-review policy owns the uniform blocking gate. Context: seven places copy a Critical-and-Major list with different wording. Consequence: one gate; the issue policy, the procedures, and the guide cite it; no cap, no demotion; Suggestion stays optional; the reviewer stays read-only. The gate defines the diff scope as the changed lines, the reviewed-file scope as the changed code paths in the touched files, and the ticket scope as the behaviors named in the ticket. A finding inside any scope blocks approval. A finding outside all three is surfaced and does not block. A valid finding outside the ticket scope but inside the diff or reviewed-file scope defers only with the user's explicit approval, and the verdict stays CHANGES REQUESTED until then. This supersedes the 2026-10-28 rule that fixes only Critical and Major.
- ADR: the core gate ships alone. Context: the broad plan churned through six review rounds on template, assertion, depth, and clean-tree wording. Consequence: this change carries only the gate; the four deferred rules are tracked in `ai/issues/open/plan-quality-follow-up-rules.md`.

## Deltas

- `ai-policy-code-review.md`: add the `### Blocking Review Gate` subsection, change Minor to "fix before approval", state Suggestion cannot relabel a defect, no cap, no demotion, the read-only reviewer, the false-positive path, and the three scopes, reword line 38 "are in scope" to "are examined", and replace the pre-existing-finding sentence at line 39 with `See the blocking review gate for the scope rule.`
- `ai-policy-issue-management.md`: remove the Critical/Major rules at lines 90, 91, 94, and 105, keep the re-review and APPROVED rules at 92-93, and cite the blocking review gate for plan and implementation review.
- `ai/procedures/manage-issues.md`, `ai/procedures/implement-plan.md`, `ai/procedures/create-handoff.md`: cite the blocking review gate and remove the local Critical-and-Major lists.
- `ai/procedures/repair-knowledge-files.md` and `ai/procedures/repair-global-settings.md`: cite the same gate in their review steps; they already require an APPROVED verdict.
- `ai-policy-design-docs.md`, `ai-policy-knowledge.md`, and `ai-policy-global-settings.md`: cite the same gate in their review rules.
- `docs/workflow-guide.md` Section 12: replace the whole Minor bullet with `- **Minor**: fix before approval.`, state the gate, and add "This is an expectation, not a cap" to the 2 to 4 round paragraph.
- `tests/test-issue-policy.sh`: add the gate, citation, removed-list, no cap, no demotion, Suggestion, read-only, scope, and line-39 assertions.
- `tests/test-docs-audit.sh`: add the gate and Minor assertions to Section 12 and assert the old Minor bullet is gone.
- `design-docs/protocol-decisions.md`: add the two ADR entries and the supersession sentence.
- `docs/announcements/v7.5.0.md`, `README.md`: write the announcement, record the deterministic release URL, and point the banner at it.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md:95` and `codebase-skeleton-map-simple-ai-workflow.md:53`, `:56`, and `:62`: replace the current Critical-and-Major wording with the uniform gate.
- `ai/shared/project-knowledge/release-practices.md`: no change; the announcement and README banner are the release surface and the file forbids release history.
- No validator change. The policy count is 25, the procedure count is 16, and the trigger count is 54.

## Acceptance Criteria

- AC-1: The code-review policy owns the gate, the other owners cite it, and the local lists are gone. Assertion: `tests/test-issue-policy.sh` fails unless `ai-policy-code-review.md` contains `### Blocking Review Gate` and `- **Minor**: fix before approval.`; each of `ai-policy-issue-management.md`, `ai/procedures/manage-issues.md`, `ai/procedures/implement-plan.md`, `ai/procedures/create-handoff.md`, `ai/procedures/repair-knowledge-files.md`, `ai/procedures/repair-global-settings.md`, `ai-policy-design-docs.md`, `ai-policy-knowledge.md`, and `ai-policy-global-settings.md` contains both `blocking review gate` and `ai-policy-code-review.md`; and `Critical and Major finding`, `Critical or Major finding`, `Fix every Critical finding.`, and `Fix every Major finding.` are absent from the issue policy and the three delivery procedures.
- AC-2: The gate has no cap and no demotion, Suggestion stays optional, the reviewer stays read-only, and the outcomes are ordered. Assertion: `tests/test-issue-policy.sh` fails unless the code-review policy contains `Treat every Critical, Major, and Minor finding as blocking.`, `Keep Suggestion optional; never relabel a defect as a Suggestion.`, `Keep no cap and no demotion.`, `Close a false positive only by an evidence-backed rebuttal the reviewer accepts, or by the user's decision after the evidence.`, `A finding inside the diff scope, the reviewed-file scope, or the ticket scope blocks approval; a valid finding inside the diff scope or the reviewed-file scope but outside the ticket scope defers to a new ticket only with the user's explicit approval, and the verdict stays CHANGES REQUESTED until then.`, `A finding outside all three scopes is surfaced and does not block the verdict.`, `Stay read-only; the author fixes every finding.`, `the changed lines`, `the changed code paths in the touched files`, `the behaviors named in the ticket`, and `See the blocking review gate for the scope rule.`; `diff scope`, `reviewed-file scope`, and `ticket scope` appear; `do not block this change's verdict` is absent; and `fix when convenient` is absent from the code-review policy.
- AC-3: The guide states the Minor definition, the gate, and the round expectation. Assertion: `tests/test-docs-audit.sh` fails unless `docs/workflow-guide.md` contains `- **Minor**: fix before approval.`, `Every Critical, Major, and Minor finding blocks approval.`, and `an expectation, not a cap`, and lacks `fix when convenient`.
- AC-4: The release surface, the ADR store, and the knowledge notes are current, and no test file is added. Assertion: `tests/test-docs-audit.sh` fails unless `docs/announcements/v7.5.0.md` exists and contains `https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.5.0`, `README.md` contains `docs/announcements/v7.5.0.md`, `design-docs/protocol-decisions.md` contains `## 2026-11-25: The code-review policy owns the uniform blocking gate`, `## 2026-11-25: The core gate ships alone`, and `This supersedes the 2026-10-28 rule that fixes only Critical and Major.`, `protocol-verification-toolchain.md` contains `The uniform Critical, Major, and Minor gate is live.` and lacks `The all-findings rule is a proposal`, and `codebase-skeleton-map-simple-ai-workflow.md` contains `the uniform Critical, Major, and Minor gate` and lacks `the critical-and-major review gate`, `currently name only Critical and Major`, and `the implementation is pending`; and `git diff --diff-filter=A --name-only master...HEAD` lists no `tests/test-*.sh`.
- AC-5: No new test file is added and the suite stays at 31. Assertion: `bash tests/run-all.sh` reports `PASSED: 31 test scripts.`

## Verification

- `bash support-files/validate-protocol.sh` must pass 8/8.
- `./support-files/validate-policy-authoring.sh $(git diff --name-only master...HEAD -- ai/policies ai/procedures)` must pass.
- `./support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)` must pass.
- `bash tests/run-all.sh` must report 31 test scripts and pass.
- `markdownlint-cli2` must report 0 issues on the changed markdown, using `.markdownlint-cli2.jsonc`.
- `bash support-files/index-protocol.sh` must report 25 policies, 16 procedures, 54 triggers, 0 conflicts, and 0 errors.
- The implementation starts from a clean tree; the current planning records are committed or discarded by the user before the implementation request.

## Peer Review Log

- The broad plan ran six review rounds, reports `2026-11-25_17-46_review-136.md` through `2026-11-25_18-42_review-141.md`, and did not reach APPROVED.
- The scope was cut to this core gate at the user's instruction on 2026-11-25.
- Core revision, round 7: CHANGES REQUESTED, 1 Critical, 6 Major, and 7 Minor. Report `ai/code-review-reports/2026-11-25_18-55_review-142.md`. All findings are fixed.
- Core revision, round 8: APPROVED, 0 Critical and 0 Major, 7 Minor advisory. Report `ai/code-review-reports/2026-11-25_18-59_review-143.md`. The Minor findings are fixed after the verdict.

## Risks and Rollback

- Risk: the blocking Minor slows a review. Mitigation: Suggestion stays optional, and the false-positive path is evidence-based.
- Risk: the citations drift. Mitigation: one owner and tests in two fixtures.
- Risk: the deferred rules are forgotten. Mitigation: they are tracked in `ai/issues/open/plan-quality-follow-up-rules.md`.
- Rollback: revert the branch. No product feature, data, or path migration is removed.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `master`, from a clean tree at the implementation request.
- Branch: `feature/uniform-review-gate`.
- Merge mode: `direct` from `## Merge Policy` in `ai-customization.md`.
- Ticket: `ai/issues/open/plan-quality-rules.md`.
- Release: v7.5.0 (MINOR), annotated tag and GitHub Release.
- External writes: none to an external tracker or PR/MR; the trunk push, the tag push, and the GitHub Release are the only remote writes.
- Evidence: the pre-merge Verification results and the Peer Review Log verdict are recorded in the branch checkpoint; the merge outcome and the tag are in git history and the GitHub Release body; the deterministic release URL `https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.5.0` is recorded in the announcement; no git metadata is written to a state file.
- Mechanics: `PROCEDURE IMPLEMENT-PLAN` owns the order; this block holds the decisions.

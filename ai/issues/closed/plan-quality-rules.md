Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Adopt plan-quality rules and require every Critical, Major, and Minor review finding to be fixed

Description:

The 2026-11-24 team-knowledge plan took 13 review rounds, 37 Major and 86 Minor findings, and 87 minutes by review-report timestamps (96-minute planning block) for a 220-line plan that restated procedures and close mechanics. The rejected `plan-review-loop-budget.md` proposed a three-round cap and demoted Major findings to notes. That is rejected because it hides defects.

Plan-quality rules to adopt:

- Plans cite the procedures and list only the decisions: repo, base, branch, merge mode, ticket, release, external writes, and evidence. The `## Close Sequence` block holds those decisions; do not copy the procedure steps.
- At least one behavioral assertion per acceptance criterion. Add more when a criterion has multiple behaviors; do not cap the number. Do not assert exact sentences for AI-driven output.
- Before the implementation branch, commit unrelated current records as a baseline chore commit. The plan and ticket are the only expected changes. Do not put park or restore mechanics in a plan.
- Size and depth follow the scope: S and M use the light path (context, acceptance criteria, and an ADR for a real decision); L/XL use the full design set.

Non-negotiable review rule:

- Every Critical, Major, and Minor finding is fixed before approval. No finding becomes a note or a checklist item in place of a fix.
- No round cap. Review continues until the findings are resolved and the verdict is APPROVED.

Out of scope:

- Demoting findings by severity.
- A fixed review-round limit.
- Replacing fixes with checklists.

Needs:

- Policy changes in `ai-policy-code-review.md` (the gate), `ai-policy-issue-management.md` (plan and implementation reviews cite the gate), and `ai-policy-design-docs.md` (the depth rule).
- Procedure changes in `ai/procedures/manage-issues.md`, `implement-plan.md`, and `create-handoff.md` to cite the code-review gate.
- The plan template in the owning policy, the user guide, the tests, the ADR, and the release.

Acceptance criteria:

- The plan rules and the plan template are in `ai-policy-issue-management.md`; `PROCEDURE MANAGE-ISSUES` cites the template and `PROCEDURE IMPLEMENT-PLAN` checks it.
- A plan lists only the decisions in the `## Close Sequence` block: repo, base, branch, merge mode, ticket, release, external writes, and evidence. It cites `PROCEDURE IMPLEMENT-PLAN` for the mechanics and does not copy the steps.
- Each acceptance criterion has at least one behavioral assertion; more are allowed and the number is not capped.
- Before the implementation branch, the unrelated current records are committed as a baseline chore commit; the plan and ticket are the only expected changes. The plan contains no park or restore mechanics.
- Depth is S and M light path (context, acceptance criteria, and an ADR for a real decision); L/XL the full design set, aligned across the issue policy, design policy, and guide.
- Every Critical, Major, and Minor finding is fixed by the author before APPROVED in every review that uses the severity scale. The code-review policy owns the gate; the issue policy and the procedures cite it. The reviewer is read-only in every review. No cap and no demotion. Suggestion stays optional and cannot relabel a defect.
- The change has an ADR, tests, docs, a passing validator, suite, and markdownlint.

Source: the user's decision on 2026-11-25 and the rejected `plan-review-loop-budget.md`.

---

2026-11-25

## Examination and decisions

### Settled wording

- Replace "One behavioral assertion per acceptance criterion" with "At least one behavioral assertion per acceptance criterion. Add more when a criterion has multiple behaviors; do not cap the number."
- Replace "Each acceptance criterion has one behavioral assertion" with "Each acceptance criterion has at least one behavioral assertion."
- A behavioral assertion is an executable check that fails when the rule is absent or wrong, not a snapshot of AI prose. Static policy text may assert exact clauses; AI-generated plans and reviews assert structure and decisions.

### Decisions

- Close Sequence: keep the `## Close Sequence` block. It holds the decision addresses only: repo, base, branch, merge mode, ticket, release yes or no and tag, external writes, and evidence. It cites `PROCEDURE IMPLEMENT-PLAN` for the mechanics and does not copy the procedure steps. This preserves the approval source and the existing tests.
- Depth: S and M use the light path (context, acceptance criteria, and an ADR for a real decision); L/XL use the full design set. Align `ai-policy-issue-management.md:80-81`, `ai-policy-design-docs.md:58-60`, and `docs/workflow-guide.md:403,492`. The plan-quality M uses the light path.
- Clean tree: before opening the implementation branch, commit the unrelated current records as a baseline chore commit. Planning may run on a dirty tree. After the baseline, the plan and ticket are the only expected changes; `PROCEDURE IMPLEMENT-PLAN` fails on any other path. The plan contains no park or restore. The baseline commit is approved.
- All findings, uniform: every Critical, Major, and Minor finding is fixed by the author before APPROVED in every review that uses the severity scale. The code-review policy owns the gate and changes Minor to "fix before approval". The plan, implementation, handoff, code, PR, knowledge-repair, global-settings, and design-docs reviews use the same gate. The reviewer never fixes in any review, including PR/MR. A false positive closes only by an evidence-backed rebuttal the reviewer accepts, or by the user's decision after the evidence. A valid out-of-scope finding defers to a new ticket only with the user's explicit approval; the verdict stays CHANGES REQUESTED until then. Suggestion stays optional and cannot relabel a defect.
- Plan template: add one `### Plan Template` to `ai-policy-issue-management.md` as a normative literal block. `PROCEDURE MANAGE-ISSUES` cites it; `PROCEDURE IMPLEMENT-PLAN` checks the plan has its sections; `docs/workflow-guide.md` points to it. Do not create a separate file. Sections: goal, evidence, depth, deltas, Close Sequence decisions, acceptance criteria with the assertion floor, verification, peer review log, and risks or rollback when the work removes or migrates.
- Tests: extend `tests/test-issue-policy.sh`; do not add a new test file, so the test count stays 31. Update `tests/test-docs-audit.sh` for the plan template and the uniform gate. Assert the plan rules, the code-review gate and its citations, the clean-tree gate, the S/M and L/XL depth rule, the template, and the absence of the cap and demotion. The static policy clauses may be asserted exactly; AI-generated plans are not snapshot-tested.
- Release: MINOR. Use v7.5.0 if this lands before the naming work. Add an ADR in `design-docs/protocol-decisions.md`, an announcement, release notes, and the docs.

### Examination findings

- The blocking gate currently reads "Critical and Major" in `ai-policy-issue-management.md:90-94,105`, `ai/procedures/manage-issues.md:17`, `ai/procedures/implement-plan.md:10`, and `ai/procedures/create-handoff.md:11`. The same rule is used in every review. B makes the code-review policy the owner of the gate and those five places cite it. `repair-knowledge-files`, `repair-global-settings`, and `design-docs` already say to fix or resolve every finding; confirm they cite the same gate.
- `ai-policy-code-review.md:74` defines Minor as "fix when convenient"; `docs/workflow-guide.md:271` repeats it. B changes both to "fix before approval" and makes the code-review policy the gate owner. The Suggestion category stays optional; a defect is never a Suggestion.
- The `## Close Sequence` block is used by `AGENTS.md`, `ai-policy-common.md:71`, `ai-policy-issue-management.md:75`, `ai/procedures/manage-issues.md:16`, `docs/workflow-guide.md:405`, `README.md:82`, the validator, and multiple tests. Do not remove it. The delta-only rule refines its content; deleting it would ripple through the approval chain.
- No plan template exists. `ai-policy-issue-management.md` has `### Plan` rules; `PROCEDURE MANAGE-ISSUES` names Evidence and Close Sequence. The AC's "plan template" needs the new policy section. A separate file is unnecessary and would duplicate the policy.
- The depth rules conflict: `ai-policy-issue-management.md:80-81` says M/L/XL use HLD and LLD; `ai-policy-design-docs.md:58-60` says medium and large use the full set; `docs/workflow-guide.md:403` says HLD, LLD, acceptance criteria, and ADRs; `docs/workflow-guide.md:492` says medium, large, and architectural work uses the full set. Align them to S and M light path, L/XL full set. The plan-quality M uses the light path.
- The clean-tree start gate is absent. The policy checks clean only at the terminal gate (`ai-policy-issue-management.md:103-104`). The worktree is dirty. The approved baseline commit is the precondition.
- PR/MR review is already read-only (`ai-policy-code-review.md:25`; `docs/workflow-guide.md:237`). The user's "report only" answer is the existing reviewer role. The author fixes every Critical, Major, and Minor finding in every review. The bad-finding path is confirmed: evidence-backed rebuttal or the user's explicit deferral.
- The test surface is ready: `tests/test-issue-policy.sh` already checks the issue policy, manage-issues, implement-plan, and the close-sequence approval. `tests/test-docs-audit.sh:141` checks the guide's close-sequence sentence, which must stay.
- The handoff move is out of scope. The proposal to put `coordination.md` and handoffs in one directory is recorded in `global-to-workflow-policy-terminology.md`.

### Implementation surface

- `ai-policy-code-review.md`: the blocking gate, Minor "fix before approval", the Suggestion boundary, and the no-relabel rule.
- `ai-policy-issue-management.md`: plan template, decision-only close block, S/M light path and L/XL full set, plan and implementation reviews cite the gate, clean-tree start gate.
- `ai-policy-design-docs.md`: proportional depth to S/M light path and L/XL full set.
- `ai/procedures/manage-issues.md`, `implement-plan.md`, and `create-handoff.md`: cite the gate instead of the local Critical-and-Major list.
- `docs/workflow-guide.md`: Minor and the gate, plan template, clean-tree start, and depth in Sections 16 and 22.
- `tests/test-issue-policy.sh` and `tests/test-docs-audit.sh`: assertions.
- `design-docs/protocol-decisions.md`: ADR.
- `docs/announcements/v7.5.0.md` and `ai/shared/project-knowledge/release-practices.md`: release.
- Confirm `repair-knowledge-files`, `repair-global-settings`, and `design-docs` cite the same gate; they already say to fix or resolve every finding.

### No-bloat decisions

- Keep the `## Close Sequence` block; refine its content instead of removing the approval anchor.
- Keep the plan template in the owning policy; no second file.
- Extend the existing issue test; no new test file and no test-count ripple.
- Do not add a new validator; the authoring validator plus the test are enough for policy text.
- B is uniform: one gate in the code-review policy; the issue policy and the procedures cite it. No per-review exception and no duplicated local rule. The design-policy and guide depth alignment is required for consistency, not optional.
- Do not fold the handoff move into this ticket; it is a separate migration.

### Open decisions

- None. The bad-finding path is confirmed, the uniform gate is chosen, and the release is v7.5.0 if this lands before the naming work.

Source: the 2026-11-25 grilling, the `plan-review-loop-budget.md` close record, and the repository examination on 2026-11-25.

2026-11-25

Plan attached below.

Baseline wording clarification: the baseline chore commit carries the current planning records, including this ticket's plan entry. After it, the plan file is the only expected untracked path.

2026-11-25

Scope cut to the core uniform review gate after six review rounds on the broad plan. The plan template, assertion floor, depth alignment, and clean-tree gate move to `ai/issues/open/plan-quality-follow-up-rules.md`. The acceptance criteria for those four rules are tracked there.

## Close

2026-11-25: Implemented the core uniform review gate. Delta verification and implementation review APPROVED. Protocol 8/8, authoring PASSED, triggers PASSED, suite 31/31, markdownlint 0, index 25 policies, 16 procedures, 54 triggers, 0 conflicts, 0 errors. Release: v7.5.0.

## Implementation Plan

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

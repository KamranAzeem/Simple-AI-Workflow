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

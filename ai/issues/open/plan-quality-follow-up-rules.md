Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: P2
Size: M
Label:
URL:
Summary: Adopt the deferred plan-quality rules: plan template, assertion floor, proportional depth, and the clean-tree gate

Description:

The core uniform review gate shipped separately in `ai/issues/closed/plan-quality-rules.md` (v7.5.0). These four rules were cut from that plan after six review rounds on the broad plan.

- Plan template: add one `### Plan Template` to `ai-policy-issue-management.md`; `manage-issues` cites it; `implement-plan` checks it.
- Assertion floor: each acceptance criterion has at least one behavioral assertion; more are allowed and the number is not capped.
- Proportional depth: S and M use the light path; L/XL use the full design set, aligned across the issue policy, design policy, and guide.
- Clean-tree gate: a baseline chore commit before the branch, with the protected-branch approval and the no-pre-work exception stated next to the no-pre-work rule in the issue policy.

Acceptance criteria:

- The plan template is one normative literal in `ai-policy-issue-management.md`, cited by `PROCEDURE MANAGE-ISSUES` and checked by `PROCEDURE IMPLEMENT-PLAN`.
- The assertion floor is stated and no cap exists.
- The depth rule is identical in the issue policy, the design policy, and the guide.
- The clean-tree gate names the baseline commit, the approval, the no-pre-work exception, and the implementation preflight.
- The change has an ADR, tests, docs, a passing validator, suite, and markdownlint.

## Settled decisions

- Plan template: one normative literal with these sections: goal, evidence, depth, deltas, Close Sequence decisions, acceptance criteria with the assertion floor, verification, peer review log, and risks or rollback.
- Assertion floor: at least one behavioral assertion per acceptance criterion; more are allowed and the number is not capped. A behavioral assertion is an executable check that fails when the rule is absent or wrong, not a snapshot of AI prose. Static policy text may assert exact clauses; AI-generated plans and reviews assert structure and decisions.
- Proportional depth: S and M use the light path; L and XL use the full set. Align `ai-policy-issue-management.md` `### Plan`, `ai-policy-design-docs.md` `## Proportional Depth`, and `docs/workflow-guide.md`.
- Unblocked: the core gate shipped in v7.5.0; this is the next plan.
- Clean-tree ownership: the baseline commit replaces the core plan's "user handles the records" rule; one clean-tree rule.
- Baseline actor and approval: the plan names the baseline in its Close Sequence; the AI creates it after the implementation request, and that request plus the close sequence is the explicit approval for the protected-branch commit.
- No-pre-work exception: permit only the baseline chore commit of the current planning records, named in the plan's Close Sequence, before the implementation branch; put it next to the no-pre-work rule in `ai-policy-issue-management.md` and cite the common policy's branch approval.
- Baseline contents and preflight: the baseline carries the current planning records, including the plan and ticket. Implementation starts from a clean tree; `PROCEDURE IMPLEMENT-PLAN` checks the baseline path list and a clean tree before opening the branch.

Source: the 2026-11-25 scope cut on `ai/issues/closed/plan-quality-rules.md`.

2026-11-25

Plan: `ai/plans/plan-quality-follow-up-rules.md` (M, light path). Approved at review-146.

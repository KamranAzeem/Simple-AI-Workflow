Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: P2
Size: M
Label:
URL:
Summary: Adopt the deferred plan-quality rules: plan template, assertion floor, proportional depth, and the clean-tree gate

Description:

The core uniform review gate ships separately in `plan-quality-rules.md`. These four rules were cut from that plan after six review rounds on the broad plan.

- Plan template: add one `### Plan Template` to `ai-policy-issue-management.md`; `manage-issues` cites it; `implement-plan` checks it.
- Assertion floor: each acceptance criterion has at least one behavioral assertion; more are allowed and the number is not capped.
- Proportional depth: S and M use the light path; L/XL use the full design set, aligned across the issue policy, design policy, and guide.
- Clean-tree gate: a baseline chore commit before the branch, with the protected-branch approval and the no-pre-work exception stated in the common policy.

Acceptance criteria:

- The plan template is one normative literal in `ai-policy-issue-management.md`, cited by `PROCEDURE MANAGE-ISSUES` and checked by `PROCEDURE IMPLEMENT-PLAN`.
- The assertion floor is stated and no cap exists.
- The depth rule is identical in the issue policy, the design policy, and the guide.
- The clean-tree gate names the baseline commit, the approval, the no-pre-work exception, and the implementation preflight.
- The change has an ADR, tests, docs, a passing validator, suite, and markdownlint.

Source: the 2026-11-25 scope cut on `plan-quality-rules.md`.

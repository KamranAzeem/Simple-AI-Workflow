# Plan: Plan-Quality Follow-Up Rules

## Goal

Add the four deferred plan-quality rules: one plan template with the assertion floor, the S/M light-path and L/XL full-set depth, and the clean-tree baseline gate. Release v7.6.0.

## Evidence

- `ai/issues/open/plan-quality-follow-up-rules.md` (42 lines) records the four rules and the settled clean-tree decisions: the baseline replaces the core plan's "user handles the records" rule; the AI creates it after the implementation request; the narrow no-pre-work exception lives in the issue policy; the baseline carries all planning records and the preflight checks the path list and clean tree.
- `ai/issues/closed/plan-quality-rules.md` (`### Settled wording`, `### Decisions`) records the template sections and the behavioral-assertion definition.
- Current gaps: `ai-policy-issue-management.md` `### Plan` has no plan template and says M/L/XL use HLD/LLD; `### Work-Item Invariants` has no clean-tree gate or baseline exception. `ai-policy-design-docs.md` `## Proportional Depth` and `## Session-Start Check` say medium/large use the full set. `docs/workflow-guide.md` Section 16 and Section 22 say medium and larger use the full set. `ai-policy-common.md` `- **Protected Branches**` has the branch approval.
- Baseline: protocol 8/8, suite 31/31, markdownlint 0, index 25 policies / 16 procedures / 54 triggers / 0 conflicts / 0 errors.
- Open questions: none.

## Depth

M, light path: context, acceptance criteria, and the ADRs below. The first delta changes the policy that currently says M uses the full set; the ticket's settled depth decision authorizes this plan's light path.

## Context

The four rules were deferred from the core gate in v7.5.0. The change replaces policy clauses, adds one policy subsection, one ADR entry, the release surface, and tests. It removes no product feature, data, or path migration. The release is v7.6.0 (MINOR) because the four rules are a feature; v7.5.0 carried the gate.

## Decisions (ADR)

- ADR: one plan template literal. The issue policy owns it; `manage-issues` cites it; `implement-plan` checks it. The template sections: goal, evidence, depth, context, decisions, deltas, acceptance criteria, verification, peer review log, risks and rollback, close sequence. The Close Sequence decision list adds `baseline`.
- ADR: the assertion floor. Each acceptance criterion has at least one behavioral assertion; more are allowed and the number is not capped. A behavioral assertion is an executable check that fails when the rule is absent or wrong, not a snapshot of AI prose. Static policy text may assert exact clauses; AI-generated plans and reviews assert structure and decisions.
- ADR: S and M use the light path; L and XL use the full set. Align the issue policy `### Plan`, the design policy `## Proportional Depth` and `## Session-Start Check`, and the guide Sections 16 and 22.
- ADR: the clean-tree baseline. It replaces the core plan's "user handles the records" rule. The plan's Close Sequence names the baseline. The AI commits the current planning records, including the plan and ticket, after the implementation request; that request plus the close sequence is the explicit approval for the protected-branch commit, under the common policy's `Protected Branches` rule. The narrow no-pre-work exception lives in the issue policy next to the no-pre-work rule. `implement-plan` verifies the baseline path list and a clean tree before opening the branch.

## Deltas

### Plan template

Add `### Plan Template` to `ai-policy-issue-management.md` after the `### Plan` bullets and before `### Work-Item Invariants`, as one normative literal:

```markdown
# Plan: <title>

## Goal

## Evidence

## Depth

## Context

## Decisions (ADR)

## Deltas

## Acceptance Criteria

## Verification

## Peer Review Log

## Risks and Rollback

## Close Sequence
```

- State the assertion floor below the literal: "Each acceptance criterion has at least one behavioral assertion. More are allowed and the number is not capped. A behavioral assertion is an executable check that fails when the rule is absent or wrong, not a snapshot of AI prose. Static policy text may assert exact clauses; AI-generated plans and reviews assert structure and decisions."
- Add `baseline` to the `## Close Sequence` decision list at `### Plan`.
- Cite the template in `ai/procedures/manage-issues.md` step 4 and check it in `ai/procedures/implement-plan.md` step 1.

### Depth

- `ai-policy-issue-management.md` `### Plan`: replace the S versus M/L/XL depth lines with "Use context plus acceptance criteria for an S or M ticket. Use an HLD and an LLD with acceptance criteria for an L or XL ticket."
- `ai-policy-design-docs.md` `## Proportional Depth`: replace the small versus medium/large lines with "For small and medium work, use context plus acceptance criteria. For large and architectural work, use the full document set."
- `ai-policy-design-docs.md` `## Session-Start Check`: replace "For medium or larger work" with "For large or architectural work."
- `docs/workflow-guide.md` Section 16: replace "Small tickets need context and acceptance criteria; medium and larger need an HLD, an LLD, acceptance criteria, and ADRs." with "Small and medium tickets need context and acceptance criteria; large and architectural work needs an HLD, an LLD, acceptance criteria, and ADRs. Use the plan template in the issue policy; each acceptance criterion has at least one behavioral assertion."
- `docs/workflow-guide.md` Section 22: replace "small work needs context plus acceptance criteria, while medium, large, and architectural work gets the full set" with "small and medium work needs context plus acceptance criteria, while large and architectural work gets the full set."

### Clean-tree gate

- `ai-policy-issue-management.md` `### Work-Item Invariants`: add:
  - "Commit the current planning records, including the plan and ticket, as a baseline chore commit before opening the implementation branch; the plan's Close Sequence names the baseline."
  - "Permit only that baseline chore commit as the exception to the no-pre-work rule."
  - "Treat the implementation request plus the Close Sequence as the explicit approval for the protected-branch baseline commit; `ai-policy-common.md` `- **Protected Branches**` is the approval gate."
  - "Verify a clean tree and the baseline path list before opening the implementation branch."
- Add `ai-policy-common.md` (`## Universal Operational Guardrails`) to the issue policy's References.
- `ai/procedures/implement-plan.md` step 1: verify the plan has the template sections and names the baseline; commit the current planning records as the baseline; verify the tree is clean and the baseline path list matches; open the feature branch; move the ticket to in-progress; carry the planning state.
- No common-policy change; the existing `Protected Branches` rule is cited.

### Tests, release, and knowledge

- `tests/test-issue-policy.sh`: add assertions for the template sections and close-sequence baseline, the assertion floor and definition, the S/M and L/XL depth lines in the issue policy and the design policy (including the Session-Start Check), the clean-tree and no-pre-work exception, the common `Protected Branches` citation, and the `manage-issues`/`implement-plan` citations. Assert the old "M, L, or XL", "For medium, large, and architectural work", and "For medium or larger work" phrases are gone.
- `tests/test-docs-audit.sh`: add assertions for the guide Sections 16 and 22 text, the plan template pointer, the assertion floor, the v7.6.0 announcement, the README banner, the ADR heading, and the toolchain/map updates; assert the old "medium and larger" and "medium, large, and architectural" phrases are gone.
- `design-docs/protocol-decisions.md`: add `## 2026-11-25: The deferred plan-quality rules land` with the four decisions.
- `docs/announcements/v7.6.0.md` and `README.md`: write the announcement, record `https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.6.0`, and point the banner at it.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md`: add the plan template, S/M light versus L/XL full, and clean-tree baseline to the Quality Gate.
- `ai/shared/project-knowledge/codebase-skeleton-map-simple-ai-workflow.md`: mark the four rules live and update the follow-up ticket status and counts.
- No new policy, procedure, trigger, or test file; counts stay 25/16/54 and suite 31.

## Acceptance Criteria

- AC-1: The issue policy has one `### Plan Template` literal with the sections; the Close Sequence list includes `baseline`; `manage-issues` cites the template and `implement-plan` checks it. Assertion: `tests/test-issue-policy.sh` fails unless the policy contains the template heading and every section, the close-sequence `baseline` token, the `manage-issues` `Plan Template` citation, and the `implement-plan` `Plan Template` check.
- AC-2: The assertion floor and definition are stated; no cap exists. Assertion: the test fails unless the issue policy contains the exact floor and definition sentences and the guide contains the plan-template and assertion-floor sentence.
- AC-3: S and M use the light path; L and XL use the full set, in the issue policy, design policy (including the Session-Start Check), and guide Sections 16 and 22. Assertion: the tests fail unless the new phrases are present and the old medium/large phrases are absent.
- AC-4: The clean-tree gate names the baseline, the protected-branch approval, the narrow no-pre-work exception, and the implementation preflight; the exception lives in the issue policy and cites the common `Protected Branches` rule; `implement-plan` checks the baseline path list and a clean tree. Assertion: the test fails unless those phrases and citations are present.
- AC-5: The change has the ADR, announcement, README, knowledge updates, passing protocol/authoring/triggers, suite 31/31, markdownlint 0, and index 25/16/54/0/0. Assertion: `tests/test-docs-audit.sh` checks the release surface and knowledge; the verification commands pass; `git diff --diff-filter=A --name-only master...HEAD` lists no `tests/test-*.sh`.

## Verification

- `bash support-files/validate-protocol.sh` passes 8/8.
- `./support-files/validate-policy-authoring.sh` on every changed policy/procedure passes.
- `./support-files/validate-policy-authoring.sh --triggers` passes.
- `bash tests/run-all.sh` reports `PASSED: 31 test scripts.`
- `markdownlint-cli2` reports 0 issues on the changed markdown.
- `bash support-files/index-protocol.sh` reports 25 policies, 16 procedures, 54 triggers, 0 conflicts, 0 errors.
- No new test file is added.

## Peer Review Log

- Round 1: review-146; the report is the binding verdict. The plan is not edited after an APPROVED verdict.

## Risks and Rollback

- Risk: the baseline commit on the protected branch. Mitigation: the plan names it, the implementation request approves, and `implement-plan` verifies the path list and clean tree.
- Risk: the template grows the issue policy. Mitigation: one literal, no duplicated rules.
- Risk: depth drift. Mitigation: tests assert the issue policy, design policy, and guide.
- Rollback: revert the branch; no product feature, data, or path migration is removed.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `master`, from a clean tree after the baseline commit.
- Branch: `feature/plan-quality-follow-up-rules`.
- Merge mode: `direct` from `## Merge Policy`; `auto` behaves as `direct`.
- Ticket: `ai/issues/open/plan-quality-follow-up-rules.md`.
- Baseline: the current planning records, including this plan and the ticket; the AI commits it after the implementation request; that request plus this block is the explicit approval for the protected-branch commit.
- Release: v7.6.0 (MINOR), annotated tag and GitHub Release.
- External writes: none to an external tracker or PR/MR; the trunk push, the tag push, and the GitHub Release are the only remote writes.
- Evidence: the pre-merge Verification results and the Peer Review Log verdict are recorded in the branch checkpoint; the merge outcome and the tag are in git history and the GitHub Release body; the deterministic release URL `https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.6.0` is in the announcement; no git metadata is written to a state file.
- Mechanics: `PROCEDURE IMPLEMENT-PLAN` owns the order; this block holds the decisions.

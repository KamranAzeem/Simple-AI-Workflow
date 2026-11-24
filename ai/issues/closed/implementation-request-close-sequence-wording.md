Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: The wording makes the implementation request stop short of the plan's close sequence and forces a third merge approval

Description:

## Problem

The implementation request should deliver the plan's full `## Close Sequence`: squash merge, delete the branch, push the trunk, and tag and publish the release when the plan names one. The current wording says the merge, the tag, the release, and every external write need their own explicit approval. The AI reads that as a third approval, separate from the implementation request. It stops after pushing the branch and asks for `merge it` again.

The expected two-step is:

1. Branch approval: "work on the issue". This covers local commits and pushes on the feature branch.
2. Implementation approval: "implement the plan". This is the separate approval for the close sequence named in the plan, including the trunk merge, tag, release, and push.

The second step is the approval the common policy asks for. It is not a third step.

## Evidence

- Observed on 2026-11-24 for the docs and slides batch: the branch was implemented and pushed, then the AI asked for `merge it`; the user had already said `proceed`. The merge only happened after the user replied `merge nit`.
- Observed on 2026-11-24 for the Kanban skill: the branch was implemented, reviewed, committed, and pushed; the AI asked for `merge it`; the user had already said `proceed with kanban which seems small`. The merge only happened after the user questioned the extra step.
- `ai/procedures/implement-plan.md:8-13`: STEP-SHIP says for `direct`, "squash merge to trunk, delete the branch, and push", and "Tag and publish the release when the plan names one." The procedure is designed to deliver the close sequence.
- `ai/policies/ai-policy-issue-management.md:96-112`: the work item is complete only when the branch is merged and deleted, the trunk is pushed, and the release is tagged and published when the work carries a release.
- `design-docs/protocol-decisions.md:773-779`: the terminal-state ADR. "A work item is complete only when the ticket is closed with the plan attached, the checkpoint is written, the branch is merged and deleted, the trunk is pushed, and the release is tagged and published when the work carries a release. A plan whose last action is an approval request is incomplete."
- `design-docs/protocol-decisions.md:781-787`: the feature-branch ADR. "Approval of a feature branch authorizes local commits and pushes on that branch. Trunk merge, tags, releases, and external system writes need separate approval." The implementation request is that separate approval.
- `ai/policies/ai-policy-common.md:71`: "Get separate approval for a trunk merge, a tag, a release, and an external system write." This is the rule, but it does not say the implementation request satisfies it.
- `docs/workflow-guide.md:399` and `:618`: "The implementation request is the approval for the branch, the commits, and the push. The merge, the tag, the release, and every external write need their own explicit approval." This sentence makes the merge a third step.
- `README.md:82`: the same sentence.
- `docs/simple-ai-workflow-slides.md:407` and `:626`: the speaker notes repeat it.
- `docs/announcements/v5.5.0.md:19`: historical record; do not edit.
- History: the separate-approval line entered `ai/policies/ai-policy-common.md` in `eb91256` (2026-11-18, v6.6.4). The guide sentence was last changed in `2f3a081` (2026-11-19). The issue management policy and procedures were last changed in `fbaed83` (2026-11-18) and were not changed on 2026-11-24. The behavior is from the wording, not a new procedure change.

## Proposed fix

- Reword `docs/workflow-guide.md:399` and `:618`:

  "The implementation request is the approval for the branch, the commits, the push, and the close sequence named in the plan's `## Close Sequence`, including the trunk merge, tag, release, and external writes. The branch approval alone covers only commits and pushes on the branch. Ask for a separate approval only when the plan does not name the action or the request is not an implementation request."

- Reword `README.md:82` to match.
- Update the two deck speaker notes at `docs/simple-ai-workflow-slides.md:407` and `:626`.
- Clarify `ai/policies/ai-policy-common.md:71`:

  "Get separate approval for a trunk merge, a tag, a release, and an external system write; the implementation request that triggers PROCEDURE IMPLEMENT-PLAN is that separate approval when the plan's `## Close Sequence` names the action, otherwise ask."

- Keep the protected-branch gate for a plan that does not name the action, for a request that is not an implementation request, and for an external ticket that needs its tracker update.
- Add an ADR entry that supersedes the ambiguity, and update the tests that pin the wording.
- Do not edit the historical v5.5.0 announcement.

## Acceptance criteria

- The guide, the README, the two deck speaker notes, and the common policy state the two-step model without ambiguity.
- An implementation request that names the plan delivers the full close sequence without a third merge approval.
- The protected-branch gate remains for the cases above.
- The ADR records the decision.
- The docs and slide fixtures, the protocol validator, markdownlint, shellcheck, and the suite pass.

## Scope

- Documentation and policy wording, plus the ADR and tests.
- No procedure code change; PROCEDURE IMPLEMENT-PLAN already names the full close sequence.
- No release for this fix alone; the combined plan sets v7.3.0.

---
2026-11-24
Delivered with the idea intake; the plan is attached to `ai/issues/closed/idea-intake-flow.md`. The release is v7.3.0.

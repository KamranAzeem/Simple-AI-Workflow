Reported: 2026-10-31
Reporter: Kamran Azeem (via Kilo)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: A work item can stall at "verified" because the plan and the review gate never require the close sequence.

Description:

## What happened

In a live client project, an AI session implemented and verified a work item, ran six plan review rounds, and then stopped. Nothing was committed. The feature branches stayed level with their base and carried only working-tree changes. The ticket stayed in `in-progress/`, the plan stayed in `ai/plans/`, no review report was written, and the checkpoint recorded "merge pending".

## Root causes

- The plan ended at "request merge approval" and never listed commit, review reports, acceptance-criteria ticks, plan attachment, ticket close, checkpoint, squash merge, branch deletion, or push.
- Plan review checked acceptance criteria and design, never the procedure.
- The checkpoint described an uncommitted branch as pending approval, so the record repeated the gap.
- The protocol never states that approval of a feature branch covers commits and pushes on that branch. Stopping at "verified" was the safe reading of that ambiguity.

## Agreed scope

- Define the terminal state of a work item.
- Require a `## Close Sequence` section in every plan that binds repos, branches, base refs, ticket, review record, checkpoint location, and evidence of done.
- Make plan review check the plan against the issue procedure.
- Add a two-command terminal gate before any close or merge claim: per repo in scope, the branch is at least one commit ahead of its resolved base, and the working tree is clean.
- State that an approved feature branch includes local commits and pushes on that branch, while trunk merge, tags, releases, and external system writes stay gated.
- Require every unblocked procedure step to be completed before an approval is requested.
- State that an uncommitted branch is unfinished work, never "merge pending".
- State that AI state lives only under the project root `ai/`, tracked or not.

## Out of scope

- New helper scripts. The gate is two documented commands per repo.
- The knowledge-file repair work.
- Changes to the live client project. This ticket fixes the protocol only.

## Constraints

- Protocol Developer Mode applies. `design-docs/protocol-decisions.md` must be loaded before any protocol edit.
- A plan with evidence, HLD, LLD, and acceptance criteria follows before implementation.
- The release target is v5.5.0 after the merge, with approval.

---

2026-10-31
Closed. Implemented on the branch; validators, reference test, and markdownlint pass.

## Implementation Plan: Work Item Close Sequence and Terminal State

Ticket: `ai/issues/closed/work-item-close-sequence-and-terminal-state.md`
Date: 2026-10-31
Status: Implemented and closed

## Evidence

- `AGENTS.md` (380 lines): `STEP-PLAN-MANDATE` (line 271) requires an `## Evidence` section and plan depth, but no close sequence. `STEP-PLAN-REVIEW` (line 272) fixes Critical and Major findings only. `STEP-BRANCH-REVIEW` (line 273) implements and reviews, with no gate on the branch state. `STEP-MERGE-SEQUENCE` (line 274) lists the close actions but states no terminal state, no base ref, and no evidence requirement.
- `ai/policies/ai-policy-common.md` (788 lines): `### Branch-Gating Requirement` (lines 43-51) requires a human-approved feature branch and does not say the approval covers commits and pushes. `### Plan` (lines 304-327) has no close-sequence requirement. `### Branch and Merge` (lines 329-355) mirrors the sequence. `## Universal Operational Guardrails` (lines 106-122) has no exhaust-the-unblocked-steps rule. `## State File Ownership Protocol` (lines 368-382) has no project-root-only rule for AI state.
- `ai/policies/ai-policy-code-review.md` (112 lines): `## Review Dimensions` (lines 40-53) has six dimensions. None checks procedural completeness.
- `support-files/validate-protocol.sh` (446 lines): eight check groups and named `AGENTS.md` anchors. It does not assert step text, so added steps need no script change.
- `support-files/validate-policy-authoring.sh` (236 lines): enforces the policy shape, title, purpose line, `## Scope`, `## References`, READ-ONLY order, procedure aliases, and trigger uniqueness.
- `support-files/test-protocol-references.sh` (91 lines): extracts `PROCEDURE`, `STEP`, `TIER`, and `ITEM` definitions, checks uniqueness, and resolves references. It prints counts and asserts no fixed number. This change adds no new step, so the count stays at 95 and the existing names remain resolvable.
- `ai/shared/project-knowledge/issue-template.md` (64 lines): the canonical ticket format and lifecycle.
- `ai/shared/project-knowledge/release-practices.md` (62 lines): the release checklist, announcement, tag, push, and GitHub Release.
- `docs/workflow-guide.md` (lines 367-375): the issue workflow in user-facing words.
- `README.md` (line 373): the issue-management summary, and line 3: the release banner.
- `docs/simple-ai-workflow-slides.md` (line 44): the issue-management slide.
- `design-docs/protocol-decisions.md` (761 lines): no pre-work commits (line 409), open the branch before editing (475), one branch and one squash commit (611), plans carry evidence and automatic review (619), and the checkpoint never runs git (499).
- The incident: two feature branches with no commits, a dirty working tree, no review report, a ticket left in `in-progress/`, a plan left in `ai/plans/`, and a checkpoint that called the uncommitted branch "merge pending". Details are in the ticket. No client name, branch name, or commit hash enters this plan.
- Working-tree state at plan time: `git status --porcelain` shows the uncommitted v5.4.1 release checkpoint (three state files and two daily checkpoints) and the user's notes cleanup. These predate this work item.
- Negative terminal-gate evidence, captured on this branch before the first commit: `git rev-list --count master..HEAD` returns `0`, and `git status --porcelain` is non-empty. The gate rejects this state, which is the incident state.
- User decisions confirmed on 2026-10-31: approval of a feature branch covers commits and pushes on that branch; the project root repo owns `ai/`; no new scripts; release v5.5.0; plan review records in the plan log only.

## Goal

Close the gap between "implemented and verified" and the true end of a work item. Bind the close actions to the plan, check the plan against the procedure, gate any close or merge claim on the branch state, and record an uncommitted branch as unfinished work.

## Scope

### In scope

- `AGENTS.md`: `STEP-PLAN-MANDATE`, `STEP-PLAN-REVIEW`, `STEP-BRANCH-REVIEW`, `STEP-MERGE-SEQUENCE`.
- `ai-policy-common.md`: `### Branch-Gating Requirement`, `### Plan`, `### Branch and Merge`, `## Universal Operational Guardrails`, `## State File Ownership Protocol`, and the checkpoint contract.
- `ai-policy-code-review.md`: one procedural-completeness review dimension.
- `design-docs/protocol-decisions.md`: the ADR entries below.
- `docs/workflow-guide.md`, `README.md`, `docs/simple-ai-workflow-slides.md`, `docs/announcements/v5.5.0.md`, `release-practices.md`.
- Verification with the existing validators, the reference test, and markdownlint.

### Out of scope

- New scripts or helpers.
- Knowledge-file repair changes.
- Changes to any other project.
- Historical ADRs, checkpoints, and closed tickets.
- A separate plan template file.
- A new trigger or procedure.

## HLD

The work item gains one terminal state and three gates that point at it.

- **Plan binding.** The plan carries a `## Close Sequence` section. It binds each close action to its repo, branch, base ref, ticket, review record, checkpoint location, and evidence. The procedure owns the order. The plan owns the addresses.
- **Plan review gate.** Plan review returns `CHANGES REQUESTED` when a close action is missing, unowned, or has no evidence. The code-review dimension is conditional: it applies only when the reviewed artifact is a plan or a close claim.
- **Branch gate.** Before any close or merge claim, each repo in scope must be at least one commit ahead of its resolved base and have a clean working tree.
- **Terminal state.** Ticket closed with the plan attached, checkpoint written, branch merged and deleted, trunk pushed, and a tagged GitHub Release when the work carries a release. For external work, the merged PR/MR replaces the local squash merge.
- **Autonomy boundary.** An approved feature branch covers local commits and pushes on that branch. Trunk merge, tags, releases, and external system writes stay gated.
- **Universal rule.** Complete every procedure step that needs no approval before requesting an approval.
- **State rule.** All AI state lives under the project root `ai/`, tracked or not. A checkpoint belongs there. An uncommitted branch is unfinished work.

### Design decisions (ADR content)

**ADR: A work item has a terminal state and a plan close sequence**

A work item is complete only at the terminal state above. Every plan binds its close actions to concrete repos, branches, base refs, artifacts, and evidence. A plan whose last action is an approval request is incomplete.

Context: the plan ended at "request merge approval", six review rounds passed it, and the close actions never ran.

Consequences: the plan no longer stands in for the procedure. Plan review checks the binding.

**ADR: Feature-branch approval covers commits and pushes**

Approval of a feature branch authorizes local commits and pushes on that branch. Trunk merge, tags, releases, and external system writes need separate approval.

Context: the ambiguity let "verified" look like the safe stopping point.

Consequences: the unblocked close actions run without another approval round.

**ADR: AI state lives only under the project root `ai/`**

All AI state and checkpoints live under the project root `ai/` directory, whether or not that directory is version controlled. A secondary repository never holds a checkpoint. When `ai/` is tracked, the checkpoint commit goes with the project root repo's branch.

Context: a multi-repo work item made "checkpoint on the branch" ambiguous.

Consequences: one state location. Secondary repos carry only their own changes.

**ADR: Plan and branch review check procedural completeness**

The code-review policy gains a procedural-completeness dimension. It checks the close-sequence binding and the terminal gate. Plan review returns `CHANGES REQUESTED` when a close action is missing, unowned, or unverified.

Context: reviews checked acceptance criteria and design only.

Consequences: a missing close step fails at plan review, not at merge time.

## LLD with AC

### LLD-001: Plan mandate

- Add the `## Close Sequence` requirement to `STEP-PLAN-MANDATE`.
- Bind each action to its repo, branch, base ref, ticket, review record, checkpoint, and evidence.
- State that a plan whose last action is an approval request is incomplete.

AC: a plan without the section fails review.

### LLD-002: Plan review

- Add the procedural-completeness check to `STEP-PLAN-REVIEW`.
- Return `CHANGES REQUESTED` for a missing, unowned, or unverified close action.
- Record the verdict in the plan's Peer Review Log.

AC: the review rejects the incident plan shape.

### LLD-003: Branch gate

- Add the terminal gate to `STEP-BRANCH-REVIEW`.
- For each repo, resolve the base ref from the plan.
- Require at least one commit ahead of the base and an empty `git status --porcelain`.
- Block an approval or close claim when either check fails.

AC: a zero-commit or dirty branch cannot be called ready.

### LLD-004: Terminal state

- Add the terminal state to `STEP-MERGE-SEQUENCE`.
- Include the external PR/MR variant.

AC: the procedure names the finish line.

### LLD-005: Feature-branch autonomy

- Add the autonomy boundary to `### Branch-Gating Requirement`.

AC: the policy says branch approval covers commits and pushes.

### LLD-006: Plan binding

- Add the binding and the incomplete-plan rule to `### Plan`.

AC: the common policy matches the procedure.

### LLD-007: Branch and merge detail

- Add the terminal gate and the resolved-base rule to `### Branch and Merge`.

AC: the common policy states the gate.

### LLD-008: Unblocked steps

- Add one bullet to `## Universal Operational Guardrails` requiring every unblocked step before an approval request.

AC: the rule is always loaded.

### LLD-009: State location and wording

- Add the project-root-only rule to `## State File Ownership Protocol`.
- Add the uncommitted-branch-is-unfinished-work rule to the checkpoint contract.

AC: state location and checkpoint wording are fixed.

### LLD-010: Review dimension

- Add a seventh dimension to `## Review Dimensions` in `ai-policy-code-review.md`.
- Restrict the dimension to a plan or a close claim.

AC: a reviewer checks procedural completeness on plans and close claims only.

### LLD-013: Working-tree reconciliation

- Inspect the pre-existing working-tree changes before the first commit.
- Include the v5.4.1 release checkpoint files in this branch's commit.
- Confirm the notes cleanup with the user before including it.
- Never mix an unrelated code change into this work item.

AC: the terminal gate's clean-tree condition is honest, and no unrelated change is committed silently.

### LLD-011: ADRs

- Add the four decisions above to `design-docs/protocol-decisions.md`.

AC: each decision is recorded with context and consequences.

### LLD-012: Docs and release

- Update the workflow guide issue section.
- Update the README issue bullet.
- Update the slides issue line.
- Add `docs/announcements/v5.5.0.md`.
- Point the README banner at the announcement.
- Add the `v5.5.0` section to `release-practices.md`.

AC: user-facing docs match the new behavior; the release is documented.

## Close Sequence

- Repos in scope: the project root repo only, `Simple-AI-Workflow`. The `ai/` directory is tracked here.
- Branch: `feature/work-item-close-sequence-and-terminal-state`.
- Base ref: `master`. Resolve it at close with `git rev-parse --verify master` and compare it with `origin/master`.
- Working-tree reconciliation: include the uncommitted v5.4.1 state and diary changes, and confirm the notes cleanup with the user.
- Implementation review: run on the branch. Record each round and verdict in the plan's Peer Review Log. Fix every Critical and Major finding.
- Plan attachment: append the final plan under `## Implementation Plan` in the ticket.
- Plan link: replace the dated plan link with `Plan attached below.`.
- Plan file: delete `ai/plans/work-item-close-sequence-and-terminal-state-plan.md`.
- Ticket: move `ai/issues/in-progress/work-item-close-sequence-and-terminal-state.md` to `ai/issues/closed/`.
- Checkpoint: write `ai/state/progress.md`, `ai/state/next-steps.md`, `ai/state/context.md`, and `ai/daily-checkpoints/2026-10-31.md` on the branch.
- Gate: after the work commits, confirm `git rev-list --count master..HEAD` is greater than zero and `git status --porcelain` is empty.
- Merge: squash merge the branch to `master`.
- Branch deletion: delete the feature branch.
- Push: push `master`.
- Release: tag `v5.5.0`, push the tag, and publish the GitHub Release after approval.
- Review record: the plan's Peer Review Log for the issue-flow reviews. No separate report file. The `peer review` trigger and its report requirement are unchanged.

## Files to Change

- `AGENTS.md`.
- `ai/policies/ai-policy-common.md`.
- `ai/policies/ai-policy-code-review.md`.
- `design-docs/protocol-decisions.md`.
- `docs/workflow-guide.md`.
- `docs/simple-ai-workflow-slides.md`.
- `docs/announcements/v5.5.0.md` (new).
- `README.md`.
- `ai/shared/project-knowledge/release-practices.md`.
- `ai/issues/in-progress/work-item-close-sequence-and-terminal-state.md` (plan link, then close).
- `ai/state/` and `ai/daily-checkpoints/2026-10-31.md`.

## Implementation Steps

0. Reconcile the pre-existing working-tree changes with the user before the first commit.
1. Write this plan and append its file name to the ticket as a dated comment.
2. Run plan review and fix every Critical and Major finding.
3. Update the four `AGENTS.md` steps.
4. Update the six common-policy sections.
5. Add the review dimension.
6. Add the four ADRs.
7. Update the docs, announcement, README banner, and release practices.
8. Run the verification set.
9. Run the implementation review and fix every Critical and Major finding.
10. Attach the plan to the ticket, replace the link, delete the plan file.
11. Close the ticket on the branch.
12. Run the checkpoint on the branch.
13. Commit on the branch.
14. Squash merge to `master`, delete the branch, and push.
15. Tag `v5.5.0` and publish the GitHub Release after approval.

## Verification

- `bash support-files/validate-protocol.sh` passes 8/8.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md ai/policies/ai-policy-code-review.md` passes.
- `bash support-files/test-protocol-references.sh` passes and the new step name is unique.
- Markdownlint reports 0 issues on the changed markdown.
- New policy text contains no `should`, `prefer`, `consider`, or `try`.
- No new file under `support-files/` and no new script.
- Terminal gate, run in this repo at close: `git rev-list --count master..HEAD` is greater than zero, and `git status --porcelain` is empty.
- Negative gate evidence, captured before the first commit: the same two commands show zero commits and a dirty tree, so the gate rejects the incident state.
- No changed policy or document describes an uncommitted branch as "merge pending"; the only occurrences are the prohibition and the incident record.
- The ticket is closed on the branch with the plan attached.
- `ai/plans/` contains no plan file for this ticket.
- The README banner points at `docs/announcements/v5.5.0.md`.
- The Close Sequence names every close action and its artifact.
- The working-tree reconciliation is recorded, and the notes cleanup is confirmed.
- The issue-flow reviews are recorded in the plan log, and no report file is expected.

## Acceptance Criteria

- The plan mandate requires a bound `## Close Sequence`.
- Plan review rejects a missing, unowned, or unverified close action.
- Branch review rejects a zero-commit or dirty branch.
- The merge sequence states the terminal state for local and external work.
- Branch approval covers commits and pushes on the branch.
- Trunk merge, tags, releases, and external writes stay gated.
- The guardrail requires every unblocked step before an approval request.
- AI state lives only under the project root `ai/`, tracked or not.
- An uncommitted branch is recorded as unfinished work.
- The code-review policy has a procedural-completeness dimension.
- Four ADRs are recorded with context and consequences.
- The guide, README, slides, announcement, and release practices are updated.
- All verification commands pass.
- The ticket is closed using the new rule, with the plan attached and the plan file deleted.
- No new script is added.
- The Close Sequence binds every close action.
- Pre-existing changes are reconciled without mixing an unrelated code change.
- The review dimension applies only to plans and close claims.

## Risks

- The common policy and `AGENTS.md` can drift. Mitigation: mirror the wording and review both in the same change.
- The base ref can be wrong. Mitigation: bind it in the plan and confirm it at close.
- The close sequence can become a restatement of the procedure. Mitigation: bind instance data only.
- Touching `AGENTS.md` can break a validator anchor. Mitigation: run the validator set.
- The docs can contradict the policy. Mitigation: update them on the same branch and search for stale wording.
- The release is a minor version. Mitigation: add the announcement and the release-practices section.
- Pre-existing uncommitted changes can block the clean-tree gate or be committed by accident. Mitigation: reconcile them with the user before the first commit.

## Peer Review Log

- Round 1: CHANGES REQUESTED. 4 Major, 2 Minor. Applied: bound the missing close actions (implementation review, plan attachment, link replacement, plan deletion, release), corrected the added-step claim, made the review dimension conditional, added the working-tree reconciliation, clarified the review-record boundary, and recorded the negative gate evidence.
- Round 2: APPROVED. 0 Critical, 0 Major. The close sequence now binds every action, the gate has positive and negative evidence, and the pre-existing changes have an owner.
- Implementation review round 1: CHANGES REQUESTED. 0 Critical, 4 Major, 1 Minor. Applied: corrected the terminal-state order and the pushed-branch wording, made the unblocked-steps guardrail positive, moved the gate after the review fixes, and corrected the "merge pending" verification wording. The Minor was a markdown list-spacing failure, fixed.
- Implementation review round 2: APPROVED. 0 Critical, 0 Major. The protocol validator, authoring validator, reference test, and markdownlint pass.

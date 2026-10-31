Reported: 2026-10-31
Reporter: Kamran Azeem (via Kilo)
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Planning an issue must not open a feature branch; only the explicit implement request opens one.

Description:

## Desired flow

- File the issue in `ai/issues/open/` with no branch.
- Analyze it while it stays in `open/`.
- Write the plan and run plan review with no branch and no commits.
- Open the feature branch and move the ticket to `in-progress/` only when the user asks to implement the plan.

## Current gap

- `ai/policies/ai-policy-common.md:312` requires the feature branch before the plan.
- `AGENTS.md:264` opens the branch at "Start work" with no planning and implementation split.
- `ai-policy-common.md:373` and `ai/shared/project-knowledge/issue-template.md:52` say "when work starts".
- `docs/workflow-guide.md:371` says "Start work with manage issues" opens the branch.
- `design-docs/protocol-decisions.md:475` requires the branch before any file change, which includes the plan.
- This session followed the old rule: the ticket was moved to `in-progress/` and the branch was opened before the plan was written.

## Agreed scope

- Change the branch timing only.
- Keep ticket creation and status-by-directory unchanged.
- Keep the plan's close-sequence binding; it names the branch created at implementation.
- Record the decision and release a patch.

## Out of scope

- New triggers.
- New scripts.
- Changes to the close sequence or terminal gate.
- Changes to any other project.

---

2026-10-31
Closed. Implemented on the branch; validators, reference test, and markdownlint pass.

## Implementation Plan: Planning Does Not Open a Feature Branch

Ticket: `ai/issues/closed/planning-does-not-open-a-feature-branch.md`
Date: 2026-10-31
Status: Implemented and closed

## Evidence

- `ai/policies/ai-policy-common.md:312`: `### Plan` opens the feature branch before creating the plan. This is the primary blocker.
- `ai/policies/ai-policy-common.md:373`: `### Lifecycle` moves the ticket to `in-progress/` when "work starts".
- `AGENTS.md:263`: `Create` writes the ticket under `ai/issues/open/` and opens no branch. This part is already correct.
- `AGENTS.md:264`: `Start work` opens the feature branch, then moves the ticket. The trigger does not separate planning from implementation.
- `AGENTS.md:271`: `STEP-PLAN-MANDATE` creates the plan and adds the close sequence, with no branch rule.
- `AGENTS.md:273`: `STEP-BRANCH-REVIEW` implements on the feature branch, assuming it already exists.
- `ai/shared/project-knowledge/issue-template.md:52`: the lifecycle opens the branch when "work starts".
- `docs/workflow-guide.md:371`: "Start work with `manage issues`" opens the feature branch.
- `README.md:373`: the issue bullet describes one branch per ticket, with no branch timing.
- `docs/simple-ai-workflow-slides.md:44`: the issue-management slide, with no branch timing.
- `design-docs/protocol-decisions.md:475`: the 2026-10-12 decision opens the branch before any file change on a work item. Writing the plan is a file change, so it forces a branch at planning time.
- `design-docs/protocol-decisions.md:611`: the 2026-10-28 decision keeps the plan, implementation, and close on one branch. It still applies from implementation onward.
- `support-files/validate-protocol.sh` and `support-files/validate-policy-authoring.sh`: no new anchors are needed.
- `support-files/test-protocol-references.sh`: no new step is added, so the count stays at 12 procedures and 95 steps.
- Current state proof, captured while writing this plan: `git branch --show-current` returns `master`; no `feature/planning-*` branch exists; the ticket is in `ai/issues/open/`; this plan is in `ai/plans/`; no commit has been made for this work.
- Captured status at plan time: the branch is `master`, the planning-branch list is empty, and only the ticket and this plan are untracked.
- User decision on 2026-10-31: planning is branch-free; the branch opens only on the explicit implement request.

## Goal

Separate planning from implementation. File and analyze the issue with no branch, write and review the plan with no branch and no commits, and open the branch and move the ticket only when the user asks to implement the plan.

## Scope

### In scope

- `ai/policies/ai-policy-common.md`: `### Plan` and `### Lifecycle`.
- `AGENTS.md`: `STEP-ACT-ON-ISSUE-REQUEST`, `STEP-PLAN-MANDATE`, `STEP-BRANCH-REVIEW`.
- `ai/shared/project-knowledge/issue-template.md`: lifecycle step 2.
- `docs/workflow-guide.md`, `README.md`, `docs/simple-ai-workflow-slides.md`.
- `design-docs/protocol-decisions.md`: the ADR entries below.
- `docs/announcements/v5.5.1.md` and `ai/shared/project-knowledge/release-practices.md`.
- Verification with the existing validators and markdownlint.

### Out of scope

- New triggers or procedures.
- New scripts.
- Changes to the close sequence or the terminal gate.
- Changes to any other project.
- Historical ADRs, checkpoints, and closed tickets.

## HLD

The work item has two phases with one branch boundary.

- **Planning phase, no branch.** The ticket stays in `open/`. The plan lives in `ai/plans/` and is reviewed. No branch is created and no commit is made. Planning artifacts are untracked working files.
- **Implementation phase, branch.** The explicit "implement the plan" request opens the feature branch, moves the ticket to `in-progress/`, and starts the code work. The plan file joins the branch when it opens.
- **Branch-before-edit rule.** The 2026-10-12 rule is narrowed. Code and configuration changes require the branch. Planning artifacts, meaning the plan file and the ticket status or comment, are exempt.
- **One branch, one squash.** The 2026-10-28 decision still applies from implementation onward. The branch carries the plan, implementation, close, checkpoint, and release documentation.
- **Close sequence.** The plan names the branch that will be created at implementation. The terminal gate runs when the branch exists, at implementation review and close.

### Design decisions (ADR content)

**ADR: Planning does not open a feature branch**

File and analyze the issue in `open/`. Write and review the plan with no branch and no commits. Open the feature branch only when the user asks to implement the plan.

Context: the protocol opened the branch before the plan, so a planning-only request changed the repository state.

Consequences: planning is read-mostly and branch-free. The plan file is an untracked working artifact until implementation. This supersedes the planning half of the 2026-10-12 "Open the branch before editing" decision. The old entry stays as history.

**ADR: Implementation opens the branch and moves the ticket**

The explicit implement request opens the feature branch and moves the ticket from `open/` to `in-progress/`. The plan file joins the branch at that point.

Context: "start work" was ambiguous and fired at planning time.

Consequences: the branch boundary is the planning and implementation boundary.

**ADR: The branch-before-edit rule exempts planning artifacts**

Code and configuration changes still require the feature branch. The plan file and the ticket status or comment are exempt while the ticket is in `open/`.

Context: the 2026-10-12 rule treated every file change as implementation work.

Consequences: planning can run on the trunk working tree without committing. The exemption is narrow.

## LLD with AC

### LLD-001: Common Plan rules

- Replace "Open the feature branch before creating the plan." with "Create the plan while the ticket stays in `open/`."
- Add "Do not open a feature branch for planning."

AC: the common policy no longer requires a branch for planning.

### LLD-002: Common lifecycle

- Change "Move a ticket from `open/` to `in-progress/` when work starts." to "when implementation starts."

AC: the lifecycle names implementation, not work.

### LLD-003: Start implementation action

- Rename `Start work` to `Start implementation`.
- Trigger it only when the user asks to implement the plan.
- Open the feature branch first, then move the ticket to `in-progress/`.

AC: the action cannot fire at planning time.

### LLD-004: Plan mandate

- State that the plan is created while the ticket is in `open/`.
- State that no feature branch is opened for planning.

AC: the procedure matches the common policy.

### LLD-005: Branch review

- Start with "When the user asks to implement the plan, open the feature branch and move the ticket to `in-progress/`."
- Keep the implementation and review steps unchanged.

AC: the branch is opened at implementation.

### LLD-006: Issue template

- Change lifecycle step 2 to open the branch when the user asks to implement the plan.

AC: the template matches the procedure.

### LLD-007: Workflow guide

- Change the "Start work" bullet to the implement trigger.
- Add a planning bullet that says the ticket stays in `open/` and no branch opens.

AC: the guide describes the two phases.

### LLD-008: README and slides

- Add the branch timing to the issue bullet.
- Add the branch timing to the issue-management slide.

AC: the user-facing summary matches.

### LLD-009: ADRs

- Add the three decisions above.
- Record that the new entries supersede the planning half of the 2026-10-12 decision.
- Keep the 2026-10-28 one-branch decision for implementation.

AC: the decision store explains the change and preserves history.

### LLD-010: Release

- Add `docs/announcements/v5.5.1.md`.
- Add the `v5.5.1` section to `release-practices.md`.
- Point the README banner at the announcement.

AC: v5.5.1 is documented as a patch.

## Close Sequence

- Repos in scope: the project root repo only, `Simple-AI-Workflow`.
- Planning phase: the ticket stays in `ai/issues/open/`; the plan stays in `ai/plans/`; no branch and no commit.
- Implement trigger: the user says "implement the plan".
- Branch: `feature/planning-does-not-open-a-feature-branch`, created only on the implement trigger.
- Base ref: `master`, resolved at implementation.
- Ticket: move `ai/issues/open/planning-does-not-open-a-feature-branch.md` to `ai/issues/in-progress/` after the branch opens.
- Implementation review: run on the branch. Record each round and verdict in the plan's Peer Review Log. Fix every Critical and Major finding.
- Plan attachment: append the final plan under `## Implementation Plan` in the ticket.
- Plan link: replace the dated plan link with `Plan attached below.`.
- Plan file: delete `ai/plans/planning-does-not-open-a-feature-branch-plan.md`.
- Ticket close: move the ticket to `ai/issues/closed/` on the branch.
- Checkpoint: write the three state files and the daily checkpoint on the branch.
- Gate: confirm the branch is at least one commit ahead of `master` and the working tree is clean.
- Merge: squash merge to `master`.
- Branch deletion: delete the feature branch.
- Push: push `master`.
- Release: tag `v5.5.1`, push the tag, and publish the GitHub Release after approval.
- Review record: the plan's Peer Review Log. No separate report file.

## Files to Change

- `ai/policies/ai-policy-common.md`.
- `AGENTS.md`.
- `ai/shared/project-knowledge/issue-template.md`.
- `docs/workflow-guide.md`.
- `README.md`.
- `docs/simple-ai-workflow-slides.md`.
- `design-docs/protocol-decisions.md`.
- `docs/announcements/v5.5.1.md` (new).
- `ai/shared/project-knowledge/release-practices.md`.
- `ai/issues/open/planning-does-not-open-a-feature-branch.md` (plan link, then move at implementation).
- `ai/state/` and the daily checkpoint at close.

## Implementation Steps

0. Stop here until the user says to implement the plan. No branch is opened during planning.
1. On the implement request, open `feature/planning-does-not-open-a-feature-branch` from `master`.
2. Move the ticket from `open/` to `in-progress/`.
3. Update the two common-policy sections.
4. Update the three `AGENTS.md` steps.
5. Update the issue template, guide, README, and slides.
6. Add the three ADRs.
7. Add the announcement and the release-practices section; point the README banner at it.
8. Run the verification set.
9. Run the implementation review and fix every Critical and Major finding.
10. Attach the plan to the ticket, replace the link, delete the plan file, and close the ticket.
11. Run the checkpoint on the branch.
12. Commit on the branch.
13. Squash merge to `master`, delete the branch, and push.
14. Tag `v5.5.1` and publish the GitHub Release after approval.

## Verification

- Before the implement request: `git branch --show-current` returns `master`.
- Before the implement request: `git branch --list 'feature/planning-*'` returns nothing.
- Before the implement request: the ticket is in `ai/issues/open/`.
- Before the implement request: the plan file is untracked and no commit exists for this work.
- After the implement request: the feature branch exists and the ticket is in `in-progress/`.
- `bash support-files/validate-protocol.sh` passes 8/8.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md` passes.
- `bash support-files/test-protocol-references.sh` passes with 12 procedures and 95 steps.
- Markdownlint reports 0 issues on the changed markdown.
- No new script under `support-files/`.
- The guides and slides contain no "start work opens the branch" wording.
- The plan's close sequence names the branch created at implementation.

## Acceptance Criteria

- Ticket creation opens no branch.
- Planning leaves the ticket in `open/` and opens no branch.
- Plan review runs with no branch and no commit.
- The implement request opens the branch and moves the ticket to `in-progress/`.
- The common policy no longer requires a branch for planning.
- The branch-before-edit rule exempts planning artifacts and keeps the branch for code changes.
- The issue template, guide, README, and slides match the new timing.
- Three ADRs are recorded with context and consequences.
- The close sequence binds the branch created at implementation.
- All verification commands pass.
- No new script is added.
- v5.5.1 is released.

## Risks

- The plan file is untracked until implementation and can be lost by a reset or clean. Mitigation: the ticket links it, and the user can ask to implement it.
- The branch-before-edit exemption can widen by accident. Mitigation: limit it to the plan file and the ticket status or comment.
- The reference test can fail if a new step name is introduced. Mitigation: edit existing steps only.
- The docs can keep the old wording. Mitigation: search for "Start work" and "when work starts" in the changed set.
- The release is a patch. Mitigation: keep the change to the branch timing.

## Peer Review Log

- Round 1: CHANGES REQUESTED. 0 Critical, 2 Major, 2 Minor. Applied: fixed the `ai/policies/` path in the scope, added the supersession wording to the planning ADR, listed the ticket and state files in the file list, and recorded the captured no-branch state.
- Round 2: APPROVED. 0 Critical, 0 Major. The plan keeps the branch closed during planning and opens it only on the implement request.
- Implementation review round 1: CHANGES REQUESTED. 0 Critical, 1 Major, 1 Minor. Applied: scoped the common branch-and-merge bullet to implementation onward, and clarified the branch-name bullet.
- Implementation review round 2: APPROVED. 0 Critical, 0 Major. The authoring validator, reference test, and markdownlint pass.

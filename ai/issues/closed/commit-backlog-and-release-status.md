Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: S
Label:
URL:
Summary: Commit the uncommitted backlog and correct the release-status lines

Description:

The working tree holds prior-session records and five follow-up tickets that were parked during the v7.4.0 rename and restored after delivery. Commit them on a chore branch. Also correct the three release-practices lines that still say "prepared" for releases that are live.

Scope:

- Commit the backlog: `ai/notes/notes.md`, the 2026-11-23 checkpoint, the closed config ticket, the deleted config plan, the slide-deck review-speed ticket, the slide-deck visual-system lesson, and five open tickets.
- Change the v7.4.0, v7.3.0, and v7.2.1 release-practices lines from "prepared" to "Published" with their dates.
- Checkpoint: record the backlog commit, close this ticket, and update the state.

Out of scope:

- Any code or behavior change.
- Any release or tag.

Acceptance criteria:

- The backlog files are committed on the chore branch.
- The three lines read "Published 2026-11-25", "Published 2026-11-24", and "Published 2026-11-24".
- The suite, validator, markdownlint, and shellcheck pass.
- The branch is squash-merged, pushed, and deleted; no tag and no release.

Source: the user's request on 2026-11-25.

## Implementation Plan: Commit the backlog and correct the release-status lines

## Evidence

- `git status` lists six modified or deleted tracked paths and five untracked tickets on `master` at `7cd5c04`.
- `ai/shared/project-knowledge/release-practices.md:47` says v7.4.0 was prepared; the release is live at `https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.4.0`.
- `release-practices.md:64` and `:74` say v7.3.0 and v7.2.1 were prepared; the progress entries record both releases as published.
- `git diff` shows no secrets; the backlog is prior session records and ticket text.
- Markdownlint passes on the backlog markdown; the notes and daily checkpoints are ignored by the config.
- Files read: the backlog diffs; the three untracked tickets; `ai/notes/notes.md`; `release-practices.md`; the three state files; the issue policy; the lint config.

## Context

The v7.4.0 rename parked the prior working tree to keep the branch clean. After delivery it was restored uncommitted. This chore records it and corrects the ledger. No behavior changes.

## Changes

- Commit the backlog: the notes, the 2026-11-23 checkpoint, the closed config ticket, the deleted config plan, the slide-deck review-speed ticket, the slide-deck visual-system lesson, and five open tickets.
- `ai/shared/project-knowledge/release-practices.md`: v7.4.0 line 47 to `Published 2026-11-25.`; v7.3.0 line 64 and v7.2.1 line 74 to `Published 2026-11-24.`
- Checkpoint: update the context release line, remove the two done next-steps items, add a progress entry, append a section to the 2026-11-25 checkpoint, close this ticket with the plan attached.
- Condense context lines to keep the three state files under the 30,720-byte shared budget.

## Acceptance criteria

- The backlog is committed on `chore/commit-backlog-and-release-status`.
- The three release-practices lines say "Published" with the correct dates.
- Suite 31/31; validator 8/8; markdownlint 0 on the changed markdown; shellcheck 0.
- The branch is squash-merged, pushed, and deleted; no tag and no release.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`; base: `master`; branch: `chore/commit-backlog-and-release-status`; merge: direct, one squash commit.
- Ticket: move to `in-progress/` at implementation; attach this plan under `## Implementation Plan`; delete this plan file; move the ticket to `closed/` in the closing commit.
- Validation: run the suite, the validator, markdownlint on the changed markdown, and shellcheck on the changed scripts.
- Review: one plan review and one implementation review; fix every Critical and Major finding.
- Checkpoint: write the state files and append to the 2026-11-25 checkpoint; the closing commit carries the state, the diary, the ticket close, and the plan attachment.
- Terminal gate: after the closing commit, resolve `master` to a SHA, confirm the branch is at least one commit ahead, confirm the tree is clean, and append the three results to the implementation review report.
- Ship: squash-merge to `master`, delete the branch, push `master`; no tag and no release.
- Done: ticket closed with the plan attached, branch merged and deleted, `master` pushed.

## Peer Review Log

- Round 1: `ai/code-review-reports/2026-11-25_09-20_review-132.md`; APPROVED; 3 Minor; the plan is ready for implementation.
- Round 2: `ai/code-review-reports/2026-11-25_10-20_review-133.md`; APPROVED on the implementation; the terminal gate waits for its step.

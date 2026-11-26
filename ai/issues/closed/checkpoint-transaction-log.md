Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: The checkpoint transaction log shows a stale [NEXT-STEPS] line that reads as the queue

Description:

The checkpoint report prints a plain `Next steps` queue and then a state-file transaction log. The log's `[NEXT-STEPS]` line records the next-steps file delta, for example `[NEXT-STEPS] Removed: "..."`, and the user reads it as the pending queue on every checkpoint. The marker collided with the queue label when the queue was renamed to a plain list; it now survives only as the delta.

The log's `[PROGRESS]` and `[CONTEXT]` lines are the progress and context deltas and stay. The fix removes the `[NEXT-STEPS]` line, keeps the log for those two files, and makes the plain `Next steps` section the only queue display. The procedure, the guide, the checkpoint test, and a new ADR change. The release is a PATCH.

---
2026-11-26
Plan attached below.

---
2026-11-26
Fixed. The procedure and guide describe the log as the progress and context delta; the checkpoint test asserts the marker is absent; the ADR records the change. Reviews 169 CHANGES REQUESTED and 170 APPROVED. Release v7.8.1.

## Implementation Plan

# Plan: Remove the stale [NEXT-STEPS] line from the checkpoint transaction log

## Goal

The checkpoint report's queue is the plain `Next steps` section. The transaction log carries only the progress and context deltas, so the user never reads a stale "Removed:" line as the pending queue.

## Evidence

- `ai/procedures/write-checkpoint.md:27` defines the log's `[NEXT-STEPS]` delta line; line 71 and `docs/workflow-guide.md:329` explain it is not the queue.
- `tests/test-issue-policy.sh:157,178,202,216` pins the marker and "marker only in the log."
- The two 2026-11-26 ADRs record the collision: the queue was first labeled `[NEXT-STEPS]`, then renamed to a plain list, and the log marker stayed.
- The user reports the stale "Removed:" line at every checkpoint.

## Depth

S. Light path: context, one ADR, acceptance criteria. No HLD or LLD.

## Context

The checkpoint report prints `Current position`, the plain `Next steps` queue, then the state-file transaction log. The log's `[NEXT-STEPS]` line is a state-file delta. After the queue became a plain list, the marker survives only in the log, where it reads as a stale queue. The fix removes the marker and keeps the log for the progress and context deltas.

## Decisions (ADR)

The checkpoint transaction log records only the progress and context deltas. The plain `Next steps` section is the only queue display. The `[NEXT-STEPS]` marker is removed from the procedure, the guide, and the tests. The ADR is appended to `design-docs/protocol-decisions.md`.

## Deltas

1. `ai/procedures/write-checkpoint.md`: remove the `[NEXT-STEPS]` line from STEP-TRANSACTION-LOG; reword STEP-CHECKPOINT-REPORT so the log carries no next-steps line.
2. `docs/workflow-guide.md:329`: the same wording.
3. `tests/test-issue-policy.sh`: drop the fixture's `[NEXT-STEPS]` line; assert the marker is absent; keep the order `Current position` < `Next steps` < `[PROGRESS]`; the log is the delta.
4. `design-docs/protocol-decisions.md`: the new ADR; `tests/test-docs-audit.sh` pins its title.
5. `docs/announcements/v7.8.1.md` and `README.md`: the PATCH announcement and banner; `tests/test-readme-shape.sh` and `tests/test-docs-audit.sh` pins.

## Acceptance Criteria

- AC-1: The procedure's log format has no `[NEXT-STEPS]` line; the guide matches. Assertion: `test-issue-policy.sh`.
- AC-2: The checkpoint test fails if the marker returns and passes with the plain queue; the order assertion holds. Assertion: `test-issue-policy.sh`.
- AC-3: The ADR is present and the docs-audit pins it. Assertion: `test-docs-audit.sh`.
- AC-4: The announcement and README banner name v7.8.1; the release URL is recorded after publishing. Assertion: `test-docs-audit.sh`; `test-readme-shape.sh`.
- AC-5: The full gate passes: suite 33/33; validator 8/8; index 26/16/59; markdownlint 0; shellcheck 0; the authoring validator. Assertion: the commands.
- AC-6: One independent peer review APPROVED. Assertion: the review report.

## Verification

- `bash tests/test-issue-policy.sh`; `bash tests/test-docs-audit.sh`; `bash tests/test-readme-shape.sh`.
- `bash tests/run-all.sh`; `bash support-files/validate-protocol.sh`; `bash support-files/index-protocol.sh`; `markdownlint-cli2 "**/*.md" "#node_modules"`; `shellcheck -S warning support-files/*.sh tests/*.sh`.
- The review report under `ai/code-review-reports/`.

## Peer Review Log

- Pending.

## Risks and Rollback

- Risk: the log loses the next-steps delta. Mitigation: the plain queue is the display and the state-file write is in the daily checkpoint; the log keeps the progress and context deltas. Rollback: revert the squash commit; the marker returns.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`; base `master`; merge mode `direct`.
- Approval: the implementation request plus this Close Sequence approves the protected-branch baseline, the branch commits and push, the direct squash merge, the v7.8.1 tag and GitHub Release, and the local ticket close. The release announcement text is approved by the user before publishing.
- Baseline: on `master`, commit the new ticket and this plan as `chore: record the checkpoint transaction log plan`.
- Branch: `fix/checkpoint-transaction-log` from the baseline; implementation commit `fix(checkpoint): remove the stale next-steps log line`.
- Implementation: the procedure, the guide, the test, the ADR, the announcement, and the README; run the gate; the review; attach this plan to the ticket; close it; delete the plan file; the checkpoint on the branch.
- Terminal gate: branch at least one commit ahead; clean tree; protocol 8/8; authoring; suite 33/33; index 26/16/59 with 0 conflicts and 0 errors; markdownlint 0; shellcheck 0; no new test script.
- Merge: squash to `master`, delete the branch, push.
- Release: the user approves the announcement text; tag `v7.8.1`; push the tag; publish the GitHub Release from the scrubbed announcement; verify the public URL.
- Checkpoint: after the release; the ticket at `closed/`; the map and state counts unchanged; no post-merge commits.
- Evidence: the commands and results in the daily checkpoint.

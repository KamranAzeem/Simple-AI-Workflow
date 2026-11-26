# Plan: Use a plain checkpoint next-steps list

## Goal

Replace the `[NEXT-STEPS]` queue section and the count-only remaining list with a plain `Next steps` section that lists every open item and its ticket path. Keep the transaction log separate and use `[NEXT-STEPS]` only in that log.

## Evidence

- The user reviewed the new checkpoint report and rejected the doubled `[NEXT-STEPS]` label and the `Remaining: 14 more open items` line as ugly.
- The user chose "Plain list, no cap" on 2026-11-26.
- The current procedure `ai/procedures/write-checkpoint.md` (Steps section) prints `[NEXT-STEPS]` with `Active` and `Remaining`, and applies the ten-item cap.
- The current guide `docs/workflow-guide.md` documents the same `[NEXT-STEPS]` section and cap.
- The current ADR `design-docs/protocol-decisions.md` records the `[NEXT-STEPS]` layout from 2026-11-26.
- The current fixture `tests/test-issue-policy.sh` pins the `[NEXT-STEPS]` queue and the ten/eleven-item branches.
- Review-160 approved the original implementation. This follow-up supersedes the report format only; the transaction log and state model stay unchanged.
- The queue has 15 open items, so the next report must list all 15.

## Depth

**S, light path.** Context plus acceptance criteria; no HLD, LLD, or full design set.

## Context

- The original ticket wanted a distinct next-steps section and a separate delta log. The first implementation used the same bracketed marker for both, and the count fallback hid the queue.
- The user wants the queue readable. A plain list of all open items is acceptable at the current size.
- The transaction log remains a separate delta. Its `[NEXT-STEPS]` line stays; the queue no longer uses that label.
- The change is report format only. The state model, budget, issue count, and queue do not change.
- No release: report-only fix.

## Decisions (ADR)

- **ADR-001**: The queue section is headed `Next steps`, not `[NEXT-STEPS]`.
- **ADR-002**: List every open item. No count fallback. The `ai/state/next-steps.md` order is preserved.
- **ADR-003**: A ticket-backed item names its ticket path relative to the project root.
- **ADR-004**: The transaction log stays separate and keeps the `[NEXT-STEPS]` delta line. The queue and the log are distinct.
- **ADR-005**: No release; the merge to `master` carries the report-only fix.

The ADR entry to add is `## 2026-11-26: The checkpoint next steps are a plain list`, superseding the `[NEXT-STEPS]` queue layout.

## Deltas

- `ai/procedures/write-checkpoint.md`: rewrite `STEP-CHECKPOINT-REPORT` with a plain `Next steps` list, all open items, ticket paths, and the separate log.
- `docs/workflow-guide.md`: match the procedure.
- `design-docs/protocol-decisions.md`: add the ADR entry.
- `tests/test-issue-policy.sh`: replace the `[NEXT-STEPS]` and ten/eleven-item assertions with a plain list fixture that renders all 15 items, checks a ticket path, and checks the log marker.
- `tests/test-docs-audit.sh`: assert the guide and ADR text.

## Acceptance Criteria

1. The report has a plain `Next steps` section that lists every open item.
   - Behavioral assertion: the fixture renders 15 items and asserts the first, middle, and last items appear, and that `Remaining:` does not appear in the queue.
2. A ticket-backed item names its ticket path.
   - Behavioral assertion: the fixture includes `ai/issues/open/checkpoint-next-steps-reporting.md` and asserts that exact path appears next to its item.
3. The transaction log remains separate and uses `[NEXT-STEPS]` only as a delta.
   - Behavioral assertion: the fixture asserts the `Next steps` heading appears before the `[PROGRESS]` log, and the only `[NEXT-STEPS]` line is the log line.
4. The next checkpoint report shows the full list.
   - Behavioral assertion: the implementation checkpoint report is inspected and recorded in the diary.
5. The suite passes and the change lands when the plan says so.
   - Behavioral assertion: suite 33/33, validator 8/8, markdownlint 0, shellcheck 0, squash merge to `master`, no release.

## Verification

- `bash tests/test-issue-policy.sh`
- `bash tests/test-docs-audit.sh`
- `bash tests/run-all.sh` 33/33
- `bash support-files/validate-protocol.sh` 8/8
- `markdownlint-cli2 "**/*.md" "#node_modules"` 0
- `shellcheck -S warning` on the changed shell scripts
- Inspect the implementation checkpoint report.

## Peer Review Log

- 2026-11-26, follow-up plan review, APPROVED.

## Risks and Rollback

- **Long report**: listing every item grows with the queue. The user chose no cap at 15 items; a future cap can be a separate decision.
- **Marker ambiguity**: `[NEXT-STEPS]` now appears only in the log; the plain heading removes the duplication.
- **Rollback**: revert the procedure, guide, ADR, and fixture changes as one squash revert.

## Close Sequence

- **Repo**: `KamranAzeem/Simple-AI-Workflow`.
- **Base ref**: `master`.
- **Approval**: the user's "Plain list, no cap" answer of 2026-11-26 plus this Close Sequence is the implementation request and protected-branch baseline approval.
- **Baseline**: commit the reopened ticket and this plan as `chore: record checkpoint-report plain-queue plan` on `master`; verify a clean tree and only those paths.
- **Branch**: `checkpoint-report-plain-queue`.
- **Checkpoint**: run the implementation checkpoint before the commit and record the new report.
- **Merge**: squash merge to `master`; delete the local branch; push `master`.
- **Ticket**: close `ai/issues/open/checkpoint-next-steps-reporting.md` with both plans attached; delete this plan file.
- **Release**: none.
- **Verification**: the suite, validator, markdownlint, shellcheck, and the checkpoint report pass.
- **No post-merge commits.**

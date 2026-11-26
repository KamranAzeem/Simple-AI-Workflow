# Plan: Separate the checkpoint queue from the current position

## Goal

Make the checkpoint report show a status-only `Current position` block and a distinct `[NEXT-STEPS]` section that names ticket-backed items, lists the remaining queue, and keeps the transaction log as a separate delta.

## Evidence

- The ticket is `ai/issues/open/checkpoint-next-steps-reporting.md` (52 lines after the plan entry). It records the v7.6.1 layout defect, the desired outcome, and six acceptance criteria.
- The user instructed on 2026-11-26: "I want next steps to show [NEXT-STEPS]." The queue section therefore uses the `[NEXT-STEPS]` marker as its heading, not only in the transaction log.
- `ai/procedures/write-checkpoint.md:68` (76 lines) puts `Next up` and the remaining items inside `Current position`.
- `docs/workflow-guide.md:329` describes the same layout: `Current position` names the active step, the remaining items, and the last active item.
- `design-docs/protocol-decisions.md:1428` records the v7.6.1 layout: the queue lives in `Current position`.
- `tests/test-issue-policy.sh:156-161` pins the old text: `Current position`, `Next up`, `Last active`, the ten-item cap, the count fallback, and the delta log.
- `tests/test-docs-audit.sh:184,188` pins the guide's `Current position` text and the ADR entry.
- The last checkpoint used the old layout. Its `Current position` block carried `Next up` and `Remaining`, and the active item paraphrased the ticket instead of naming its path.
- The ticket's example names `ai/issues/open/global-to-workflow-policy-terminology.md`. That ticket closed with v7.7.0; the concrete path is the active ticket at report time, which is this ticket while it is in progress.
- The live queue has 16 open items, so the next checkpoint exercises the over-ten branch. The fixture must also cover the ten-or-fewer branch.
- The suite has 33 test scripts; the fixture is extended inside `tests/test-issue-policy.sh`, so the count stays 33.
- Review-158 requested changes: add the checkpoint before the commit and either add the release approval gate or drop the release. This revision adds the checkpoint and drops the release; it also adopts the user's `[NEXT-STEPS]` label.
- The user's "continue working" on 2026-11-26 is the implementation request for this revised Close Sequence.

## Depth

**S, light path.** Context plus acceptance criteria; no HLD, LLD, or full design set.

## Context

- The v7.6.1 ADR introduced `Current position` and placed the whole queue inside it. The user found that the queue disappeared under a status block and that ticket names were paraphrased.
- This change is report format only. It does not change the state model, the budget, the issue count, or the queue.
- The report is produced in chat from `ai/state/next-steps.md`, `ai/state/progress.md`, and the ticket files. The state files stay canonical.
- The checkpoint procedure prints the report; the workflow guide explains it; the ADR records the decision; the fixture pins the contract.
- The transaction log is a delta and remains separate. Its `[NEXT-STEPS] Removed/Added` line is not the queue display. The queue display is the `[NEXT-STEPS]` section.
- The next checkpoint after implementation is the demonstration and must show the new layout.
- No release: this is a report-only defect fix. The merge carries the fix; the ticket closes without a tag or GitHub Release.

## Decisions (ADR)

- **ADR-001**: `Current position` carries status, milestone, and `Last active` only. It carries no `Next up` and no remaining queue. The distinct `[NEXT-STEPS]` section owns the queue.
- **ADR-002**: The active next step is listed first. A ticket-backed item names its ticket path relative to the project root, for example `ai/issues/open/checkpoint-next-steps-reporting.md`. The next-steps label is not a substitute for the path.
- **ADR-003**: When ten or fewer open items remain, list all of them. When more than ten remain, list the active item plus a count and the `ai/state/next-steps.md` pointer. Never reduce the active item to a paraphrase.
- **ADR-004**: Keep the transaction log separate. Its `[NEXT-STEPS]` line is a delta; the queue display is the `[NEXT-STEPS]` section. The two use the same marker for two different jobs, and the headings make the job clear.
- **ADR-005**: No release. The change is a report-format defect fix with no state-model change; the merge to `master` carries it. A release is a separate user decision.

The ADR entry to add to `design-docs/protocol-decisions.md` is `## 2026-11-26: The checkpoint queue is separate from the current position`, and it supersedes the layout in the 2026-11-25 entry.

## Deltas

- `ai/procedures/write-checkpoint.md`: rewrite `STEP-CHECKPOINT-REPORT` so `Current position` is status-only, add a distinct `[NEXT-STEPS]` section with `Active` and `Remaining`, name the ticket path, keep the ten-item rule, and keep the transaction log separate.
- `docs/workflow-guide.md`: rewrite Atomic Write Protocol item 2 to match the procedure and explain the two sections.
- `design-docs/protocol-decisions.md`: add the ADR entry that supersedes the v7.6.1 layout.
- `tests/test-issue-policy.sh`: replace the old checkpoint anchors with the new contract and add a local report-contract fixture function. The function builds the report from a fixed queue and checks the distinct sections, the `[NEXT-STEPS]` queue heading, the active ticket path, the ten-or-fewer list, the over-ten count and pointer, and the transaction-log order.
- `tests/test-docs-audit.sh`: assert the guide text and the new ADR entry.
- `ai/state/*`, `ai/daily-checkpoints/2026-11-26.md`, and the ticket close record are checkpoint and close records, not part of the format implementation.

## Acceptance Criteria

1. A checkpoint report has distinct `Current position` and `[NEXT-STEPS]` sections; `Current position` does not carry the queue.
   - Behavioral assertion: `tests/test-issue-policy.sh` extracts the `STEP-CHECKPOINT-REPORT` paragraph and asserts `Current position` appears before `[NEXT-STEPS]`, that the `Current position` clause names `Last active`, and that it contains neither `Next up` nor `Remaining`. `tests/test-docs-audit.sh` asserts the same order in the guide.
2. The active next step names its ticket path or slug when one exists.
   - Behavioral assertion: the report-contract fixture builds `Active: ai/issues/open/checkpoint-next-steps-reporting.md` and asserts that exact path appears before the remaining queue.
3. The remaining queue is listed; all open items when ten or fewer, otherwise the active item plus a count and the `ai/state/next-steps.md` pointer.
   - Behavioral assertion: the fixture renders a ten-item queue and asserts all ten appear; it renders an eleven-item queue and asserts the active item, the count, and the pointer appear, and the tenth non-active item is replaced by the count.
4. The transaction log is visibly separate; the `[NEXT-STEPS]` entry is a delta only.
   - Behavioral assertion: the fixture asserts the order `Current position`, `[NEXT-STEPS]` queue, then `[PROGRESS]` and the transaction-log `[NEXT-STEPS]` delta, and asserts the queue section exists independently of the delta line.
5. The next checkpoint report shows the new layout and names the active ticket.
   - Behavioral assertion: the implementation checkpoint report is inspected against the contract and recorded in the chat report and the diary section; the active item is `ai/issues/open/checkpoint-next-steps-reporting.md` while this ticket is open.
6. The suite passes and the change lands when the plan says so.
   - Behavioral assertion: `bash tests/run-all.sh` passes 33/33, `bash support-files/validate-protocol.sh` passes 8/8, markdownlint reports 0, shellcheck reports 0, and the squash merge lands on `master`. The plan says no release, so no tag or GitHub Release is required.

## Verification

- Run `bash tests/test-issue-policy.sh`; the checkpoint contract and the ten/eleven-item branches pass.
- Run `bash tests/test-docs-audit.sh`; the guide and ADR anchors pass.
- Run `bash tests/run-all.sh`; 33/33.
- Run `bash support-files/validate-protocol.sh`; 8/8.
- Run `markdownlint-cli2 "**/*.md" "#node_modules"`; 0 issues.
- Run `shellcheck -S warning` on the changed shell scripts; 0 warnings.
- Run the implementation checkpoint and inspect the report: `Current position` has no queue, `[NEXT-STEPS]` names the active ticket, the remaining branch matches the queue size, and the transaction log follows.
- Confirm no release is expected; the plan says no tag or GitHub Release.

## Peer Review Log

- Round 1, 2026-11-26 09:40, `ai/code-review-reports/2026-11-26_09-40_review-158.md`: CHANGES REQUESTED. Findings: the checkpoint was missing before the commit, and the release publishing skipped the user approval gate. Minor: state the fixture location and the AC-5 diary evidence. Suggestion: add the `Next up`/`Remaining` negative assertion.
- Round 2, 2026-11-26, delta review after the fixes and the user's `[NEXT-STEPS]` instruction: APPROVED.

## Risks and Rollback

- **Marker ambiguity**: `[NEXT-STEPS]` now labels both the queue section and the transaction-log delta. The headings and the "delta only" wording distinguish them; the fixture asserts both.
- **False confidence**: the report is AI prose, so the fixture pins the contract but a human must inspect the next report. The plan requires that inspection.
- **Ticket path drift**: the active ticket can close between planning and the checkpoint. The report uses the active ticket at report time, not a hardcoded path.
- **Queue size**: the live queue has 16 items, so the next report uses the count and pointer branch. The fixture must keep the ten-or-fewer branch covered.
- **Rollback**: revert the procedure, guide, ADR, and fixture changes as one squash revert. No state migration is involved.

## Close Sequence

- **Repo**: `KamranAzeem/Simple-AI-Workflow`.
- **Base ref**: `master`. The clone has no `main`; the v7.7.0 baseline and release used `master`.
- **Approval**: the user's `continue working` instruction of 2026-11-26 plus this Close Sequence is the implementation request and the approval for the protected-branch baseline commit.
- **Baseline**: commit the plan and the ticket's dated plan entry as `chore: record checkpoint-report plan` on `master`. Verify the tree is clean and only those paths are staged before opening the branch.
- **Branch**: `checkpoint-next-steps-reporting`.
- **Checkpoint**: after the ticket close is staged and before the commit, run `checkpoint` on the branch. The report demonstrates the new `Current position` and `[NEXT-STEPS]` layout, and the diary records it.
- **Merge**: squash merge to `master`; delete the local branch; push `master`.
- **Ticket**: `ai/issues/open/checkpoint-next-steps-reporting.md`; close it with the plan attached, then delete the plan file.
- **Release**: none. The report-only fix lands on `master`; no tag and no GitHub Release.
- **Verification**: the suite, validator, markdownlint, shellcheck, and the checkpoint report pass the acceptance criteria.
- **Evidence**: review reports, test output, the checkpoint report, and the merge commit.
- **No post-merge commits.** Any change after the merge reopens work on a new branch.

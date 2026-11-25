Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Show the current queue and last active item in the checkpoint report

Description:

The checkpoint report's transaction log uses `[NEXT-STEPS] Nothing to add` when `ai/state/next-steps.md` did not change. That line is a delta, so it hides the current pending queue and the last active item. The user observed this on 2026-11-25: the report said `Nothing to add` while `next-steps.md` held nine items and the active item was "Plan the scope normalization; settle the release and alias window; presets next; init after."

Proposed change: add a `Current position` block to `STEP-CHECKPOINT-REPORT` in `ai/procedures/write-checkpoint.md`, before the state-file transaction log.

- `Next up`: list the active item first, then the remaining open items from `ai/state/next-steps.md`. List all when there are ten or fewer; otherwise list the active item plus a count and the `next-steps.md` pointer.
- `Last active`: name the newest progress entry, or the work item just completed.
- Keep the transaction log as the delta; the block does not replace it.

The state files remain canonical. The report is a chat summary, not a new state file.

Evidence:

- `STEP-CHECKPOINT-REPORT` in `ai/procedures/write-checkpoint.md` (line 67) currently requires only the grouped step summary and the transaction log.
- `STEP-TRANSACTION-LOG` (lines 24-27) is the delta format.
- `next-steps.md` is "open items only, oldest first"; `progress.md` is "newest at bottom."
- The 2026-11-25 checkpoint is the observed example.

Acceptance criteria:

- `STEP-CHECKPOINT-REPORT` requires the `Current position` block before the transaction log.
- The block lists `Next up` with the active item first and all open items when ten or fewer; otherwise the active item plus a count and the `next-steps.md` pointer. `Last active` names the newest progress entry.
- The transaction log remains the delta.
- The change has an ADR in `design-docs/protocol-decisions.md`; the procedure-text assertion, validator, suite, and markdownlint pass; no new test file.
- No state-file change.

Open questions: None. The block name is `Current position`; the ten-or-fewer rule is settled. The release level is a planning decision.

2026-11-25

Plan attached below.

## Close

2026-11-25: Implemented and reviewed; review-149 APPROVED. Protocol 8/8, authoring PASSED, triggers PASSED, suite 31/31, markdownlint 0 on 5 files, shellcheck 0, index 25 policies / 16 procedures / 54 triggers / 0 conflicts / 0 errors. Release target: v7.6.1.

## Implementation Plan

# Plan: Checkpoint Current Position

## Goal

Show the current queue and the last active item in every checkpoint report. Release v7.6.1.

## Evidence

- `ai/issues/open/checkpoint-report-current-position-block.md` records the problem, the proposed `Current position` block, the ten-or-fewer rule, and the acceptance criteria.
- `STEP-CHECKPOINT-REPORT` in `ai/procedures/write-checkpoint.md` currently requires only the grouped step summary and the state-file transaction log.
- `STEP-TRANSACTION-LOG` is the delta format; the 2026-11-25 checkpoint printed `[NEXT-STEPS] Nothing to add` while `next-steps.md` held nine items and the active item was "Plan the scope normalization."
- `next-steps.md` is "open items only, oldest first"; `progress.md` is "newest at bottom."
- The guide's checkpoint transaction-log section is `docs/workflow-guide.md:329`.
- Baseline: protocol 8/8, suite 31/31, markdownlint 0, index 25 policies / 16 procedures / 54 triggers / 0 conflicts / 0 errors.
- Open questions: none.

## Depth

S, light path: context, acceptance criteria, and the ADR below.

## Context

This is a report-only change: one procedure step, one guide sentence, one ADR, two fixture assertions, and a patch release. No state-file change and no protocol behavior change.

## Decisions (ADR)

- ADR: add a `Current position` block before the transaction log. `Next up` lists the active item first, then the remaining open items from `ai/state/next-steps.md`; list all when ten or fewer, otherwise the active item plus a count and the `next-steps.md` pointer. `Last active` names the newest progress entry. The transaction log remains the delta, and the state files remain canonical. Release v7.6.1 (PATCH) because the report is presentation, not protocol behavior.

## Deltas

- `ai/procedures/write-checkpoint.md` step 8: add "Before the transaction log, print a `Current position` block. `Next up` lists the active item first, then the remaining open items from `ai/state/next-steps.md`; list all when there are ten or fewer, otherwise list the active item plus a count and the `next-steps.md` pointer. `Last active` names the newest progress entry. The transaction log remains the delta."
- `docs/workflow-guide.md:329`: add "Before the log, a `Current position` block names the active next step, the remaining open items when ten or fewer (otherwise the active item and a count), and the last active item."
- `design-docs/protocol-decisions.md`: add `## 2026-11-25: The checkpoint report shows the current position` with the decision.
- `tests/test-issue-policy.sh`: add a `CHECKPOINT` variable and assertions for `Current position`, `Next up`, `Last active`, the ten-or-fewer rule, the count fallback, and "The transaction log remains the delta."
- `tests/test-docs-audit.sh`: add the guide `Current position` assertion, the v7.6.1 announcement, the README v7.6.1 pointer, and the announcement URL; keep the v7.6.0 announcement checks and change the README pointer to v7.6.1.
- `docs/announcements/v7.6.1.md` and `README.md`: write the patch announcement and point the banner at it.
- No new policy, procedure, trigger, or test file; counts stay 25/16/54 and suite 31.

## Acceptance Criteria

- AC-1: `STEP-CHECKPOINT-REPORT` requires the `Current position` block before the transaction log, with `Next up`, `Last active`, the ten-or-fewer list rule, and the count fallback. Assertion: `tests/test-issue-policy.sh` fails unless the procedure contains those phrases.
- AC-2: The workflow guide describes the block. Assertion: `tests/test-docs-audit.sh` fails unless the guide contains the `Current position` sentence.
- AC-3: The transaction log remains the delta, and the state files remain canonical. Assertion: the procedure text contains "The transaction log remains the delta"; no state-file change is made.
- AC-4: The change has the ADR, the v7.6.1 announcement, the README banner, passing protocol/authoring/triggers, suite 31/31, markdownlint 0, and index 25/16/54/0/0. Assertion: the test-docs-audit checks the release surface; the verification commands pass; `git diff --diff-filter=A --name-only master...HEAD` lists no `tests/test-*.sh`.

## Verification

- `bash support-files/validate-protocol.sh` passes 8/8.
- `./support-files/validate-policy-authoring.sh` on the changed procedure passes.
- `./support-files/validate-policy-authoring.sh --triggers` passes.
- `bash tests/run-all.sh` reports `PASSED: 31 test scripts.`
- `markdownlint-cli2` reports 0 issues on the changed markdown.
- `bash support-files/index-protocol.sh` reports 25 policies, 16 procedures, 54 triggers, 0 conflicts, 0 errors.
- No new test file is added.

## Peer Review Log

- Round 1: review-148; the report is the binding verdict. The plan is not edited after an APPROVED verdict.

## Risks and Rollback

- Risk: the report grows on every checkpoint. Mitigation: the ten-or-fewer cap and the active-first order.
- Risk: a stale active item. Mitigation: `Next up` reads `next-steps.md`, and `Last active` reads the newest progress entry.
- Rollback: revert the branch; no state-file change and no protocol behavior change.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `master`, from a clean tree after the baseline commit.
- Branch: `feature/checkpoint-current-position-block`.
- Merge mode: `direct` from `## Merge Policy`; `auto` behaves as `direct`.
- Ticket: `ai/issues/open/checkpoint-report-current-position-block.md`.
- Baseline: the current planning records, including the state and diary updates, the scope ticket, this ticket, and this plan; the AI commits it after the implementation request; that request plus this block is the explicit approval for the protected-branch commit.
- Release: v7.6.1 (PATCH), annotated tag and GitHub Release.
- External writes: none to an external tracker or PR/MR; the trunk push, the tag push, and the GitHub Release are the only remote writes.
- Evidence: the pre-merge Verification results and the Peer Review Log verdict are recorded in the branch checkpoint; the merge outcome and the tag are in git history and the GitHub Release body; the deterministic release URL `https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.6.1` is in the announcement; no git metadata is written to a state file.
- Mechanics: `PROCEDURE IMPLEMENT-PLAN` owns the order; this block holds the decisions.

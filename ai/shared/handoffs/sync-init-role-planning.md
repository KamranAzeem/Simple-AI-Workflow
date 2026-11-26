# Handoff: Plan the Sync Init Role Presets

## Objective

Produce an approved plan for the `sync --init --role` task on `ai/issues/open/sync-script-init-scaffolding.md`, and stop before implementation.

- Created: 2026-11-26.
- Author session: the main Kilo session in `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Receiver: a separate Kilo session with read, write, and bash tools in the same project.
- Claim instruction: reply `claim and execute the handoff at ai/shared/handoffs/sync-init-role-planning.md`.
- Claim: cleared (Kilo handoff-executor session, completed 2026-11-26T15:26Z).

## Authorization

The claim approves:

- Reading the ticket, policies, procedures, presets, scripts, tests, and docs named in `## Read first`.
- Writing the plan to `ai/plans/sync-script-init-scaffolding.md`.
- Appending one dated plan entry to `ai/issues/open/sync-script-init-scaffolding.md`.
- Running the plan peer review and writing review reports under `ai/code-review-reports/`.
- Reporting back and appending the `## Completion` note to this handoff.

The claim does not approve:

- Implementation, branch creation, commits, merges, tags, or releases.
- Writing the three state files.
- Editing presets, scripts, tests, docs, README, or ADRs.
- Filing new issues, including the deferred TSV manifest.
- External writes.

## Read first

Read these in full, in order:

1. `ai/policies/ai-policy-handoff.md`.
2. `ai/issues/open/sync-script-init-scaffolding.md`.
3. `ai/procedures/manage-issues.md`.
4. `ai/policies/ai-policy-issue-management.md`.
5. `ai/policies/ai-policy-design-docs.md`.
6. `ai/policies/ai-policy-code-review.md`.
7. `ai/policies/ai-policy-common.md`.
8. `ai/policies/ai-policy-thinking-modes.md`, only if the plan needs grilling. The settled decisions should make this unnecessary.
9. `ai/issues/closed/customization-presets-per-role.md`.
10. Every file in `docs/examples/customization-presets/`.
11. `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1`.
12. `tests/test-sync-agents-md.sh` and `tests/verify-powershell-scripts.ps1`.
13. `docs/setup.md`, `docs/ai-customization-guide.md` section 11, and `docs/ai-customization.md`.
14. `README.md`, `tests/test-readme-shape.sh`, `tests/test-docs-audit.sh`, and `tests/run-all.sh`.
15. The 2026-11-26 `Documentation-only additions ship as a PATCH` entry in `design-docs/protocol-decisions.md`, and `ai/knowledge/release-practices.md`.
16. `ai/state/context.md` and `ai/state/next-steps.md` for context only. Do not modify them.

## Scope

In scope:

- The plan file `ai/plans/sync-script-init-scaffolding.md`.
- One dated plan entry appended to `ai/issues/open/sync-script-init-scaffolding.md`.
- Peer review reports under `ai/code-review-reports/`.
- The `## Completion` note in this handoff.

Out of scope:

- The three state files: `ai/state/context.md`, `ai/state/next-steps.md`, and `ai/state/progress.md`.
- `support-files/`, `docs/`, `tests/`, `README.md`, `design-docs/`, and `ai/knowledge/`.
- Implementation, branch, commit, merge, tag, release, and external writes.
- Filing the deferred TSV manifest issue.
- The author's uncommitted files: `ai/daily-checkpoints/2026-11-26.md`, `ai/state/context.md`, `ai/state/progress.md`, and the ticket. The ticket is in scope for the plan entry only.
- Other sessions' files. None are present now; if one appears, do not touch it.

## Starting facts

Measured 2026-11-26. Verify each before relying on it.

- Branch `master`, HEAD `5f6808b`, and v7.8.2 is live. The presets feature branch is deleted.
- The working tree already has uncommitted checkpoint changes: `ai/daily-checkpoints/2026-11-26.md`, `ai/issues/open/sync-script-init-scaffolding.md`, `ai/state/context.md`, and `ai/state/progress.md`. Do not revert, commit, or add to the state files.
- The ticket has the settled decisions at `## Settled decisions (2026-11-26)` and the deferred manifest at `### Deferred`.
- The eight presets are in `docs/examples/customization-presets/`. Each carries `**Default Shell**: bash` at line 13, except `platform-engineer.md` at line 14. `docs/ai-customization.md` carries the key at line 13 and an advertising comment at line 21.
- `support-files/sync-agents-md.sh` is 588 lines; `support-files/sync-agents-md.ps1` is 520 lines. Sync requires `--source` and `--target-path`, searches for `AGENTS.md`, and has no init mode. Both refuse a symlinked root `ai-customization.md`; neither checks a symlinked `AGENTS.md`.
- `tests/test-sync-agents-md.sh` has 14 cases in 279 lines; `tests/verify-powershell-scripts.ps1` is 149 lines. The suite has 34 scripts.
- `docs/setup.md` line 51 says the sync script does not create `AGENTS.md` for a new project. That sentence must change.
- `docs/ai-customization-guide.md` section 11 starts at line 274.
- The 2026-11-26 entry `Documentation-only additions ship as a PATCH` is at `design-docs/protocol-decisions.md:1526`, and `ai/knowledge/release-practices.md:14` states the rule. This init feature is a behavior change, so it takes MINOR under that rule unless the user directs otherwise.
- `ai/plans/sync-script-init-scaffolding.md` does not exist.
- No other handoff is currently in `ai/shared/handoffs/`.

## Steps

1. Claim this handoff and record the claim in `## Objective`.
2. Load context if this is a new session. If the session is already loaded, confirm the operational files are current.
3. Read `## Read first` in full, in order.
4. Verify the starting facts. Record the starting `git rev-parse HEAD` and `git status --short` output.
5. Run PROCEDURE MANAGE-ISSUES for the plan:
   - Load `ai-policy-issue-management.md` and `ai-policy-design-docs.md`.
   - Write `ai/plans/sync-script-init-scaffolding.md` with the Plan Template sections and L depth: HLD, LLD, ADRs, decisions, deltas, acceptance criteria with behavioral assertions, verification, peer review log, risks and rollback, and close sequence.
   - Cover every item in the ticket's `## Settled decisions (2026-11-26)`, including: `--init --target-path <dir> --role <slug>`; reject `--source` in init; the preset whitelist and path-traversal rejection; the exact unknown-role and refusal messages; the post-init bootstrap hint; workflow path substitution; no Default Shell in the presets or the generated customization, while the optional key stays documented in the guide for manual use; the target and refusal rules; exit codes; write safety; idempotence (a second init refuses); the symlink refusal tests; docs in `docs/setup.md` plus the guide link; Bash and PowerShell parity; dry run; unknown role; missing preset; target inside the workflow clone; and the acceptance cleanup. No TSV; the manifest is deferred.
   - Include the removal of the `Default Shell` line from the eight presets and `docs/ai-customization.md`, and the template comment sentence, as deltas.
   - State the release under the 2026-11-26 `Documentation-only additions ship as a PATCH` entry and `release-practices.md:14`: this is a behavior change, so MINOR unless the user directs otherwise.
   - Append one dated plan entry to `ai/issues/open/sync-script-init-scaffolding.md`.
   - Run PROCEDURE RUN-PEER-REVIEW on the plan, fix every finding, and re-review until APPROVED. Record every round in the plan's `## Peer Review Log`.
6. Confirm the plan covers every settled decision and no deferred TSV work is in scope.
7. Stop. Do not implement, branch, commit, merge, release, or write state.
8. Report back, append `## Completion` to this handoff, and clear the claim.

## Binding rules

- `ai-policy-handoff.md`, `ai-policy-common.md`, `ai-policy-issue-management.md`, `ai-policy-design-docs.md`, and `ai-policy-code-review.md`.
- The settled decisions in the ticket are binding. Do not reopen them.
- No TSV manifest in this plan. It is deferred.
- No `Default Shell` in the presets or the generated customization.
- The three state files are single-writer and out of scope.
- No branch, commit, merge, tag, release, or external write.
- No em dashes, no AI-tell words, and no tables in protocol files. Keep the humanized output rules.
- No secrets.
- The plan is L depth and must name the repo, baseline, base ref, branch, merge mode, ticket, release, and evidence in its close sequence.

## Shared output paths

- Plan: `ai/plans/sync-script-init-scaffolding.md`. Unique; do not overwrite.
- Ticket: append one dated plan entry to `ai/issues/open/sync-script-init-scaffolding.md`.
- Review reports: `ai/code-review-reports/<YYYY-MM-DD_HH-MM>_review-<next>.md`. The handoff reviews are 177 and 178; use the next free number above the highest existing review report for the plan reviews. List the directory first and do not overwrite.
- Completion: append `## Completion` to `ai/shared/handoffs/sync-init-role-planning.md`.
- No other file.

## Report back

- Return a final message with the plan path, the final plan review number and verdict, a one-paragraph summary, and any open questions. The expected open questions are none.
- Append `## Completion` to this handoff with the date, the plan path, the review number and verdict, and the files touched.
- Clear the claim.
- Do not commit. The original orchestrator owns the baseline commit and the state files, records this handoff in the state files at the next checkpoint, and deletes it then.

## Review

- Reviewer: Kilo (Strict Peer Reviewer), `deepseek-flash`.
- Date: 2026-11-26.
- Verdict: APPROVED (review-178). Round 1 review-177 returned CHANGES REQUESTED; the fixes are in this final handoff.
- Report: `ai/code-review-reports/2026-11-26_15-14_review-178.md` and `ai/code-review-reports/2026-11-26_15-10_review-177.md`.

## Verification

Read-only checks:

- `git branch --show-current` prints `master`.
- `git rev-parse HEAD` equals the value recorded at claim.
- `git branch --list 'feature/*'` prints nothing.
- `git status --short` shows the plan as untracked and the ticket as modified, plus the pre-existing checkpoint files and the untracked final handoff at `ai/shared/handoffs/sync-init-role-planning.md`. It shows no change under `support-files/`, `docs/`, `tests/`, `README.md`, `design-docs/`, `ai/knowledge/`, or the three state files.
- The plan review reports are under the git-ignored `ai/code-review-reports/`, so they do not appear in `git status`; verify them with `ls ai/code-review-reports/`.
- `git diff --name-only -- ai/state` matches the starting list.

Execution checks:

- `test -f ai/plans/sync-script-init-scaffolding.md` exits 0.
- `grep -q '^## Goal' ai/plans/sync-script-init-scaffolding.md` exits 0, and the same command exits 0 for `## Evidence`, `## Depth`, `## Context`, `## Decisions (ADR)`, `## Deltas`, `## Acceptance Criteria`, `## Verification`, `## Peer Review Log`, `## Risks and Rollback`, and `## Close Sequence`.
- `grep -q 'Peer Review Log' ai/plans/sync-script-init-scaffolding.md` exits 0, and the last round line contains `APPROVED`.
- `grep -q 'init' ai/plans/sync-script-init-scaffolding.md` exits 0 and `grep -q 'role' ai/plans/sync-script-init-scaffolding.md` exits 0.
- `grep -q 'Default Shell' ai/plans/sync-script-init-scaffolding.md` exits 0, and the line is a removal delta.
- `grep -q 'docs/setup.md' ai/plans/sync-script-init-scaffolding.md` exits 0.
- `grep -q 'TSV' ai/plans/sync-script-init-scaffolding.md` exits 0, and the context is deferred only.
- `grep -qE 'MINOR|PATCH' ai/plans/sync-script-init-scaffolding.md` exits 0 and the release statement is present.
- `grep -q 'sync-script-init-scaffolding.md' ai/issues/open/sync-script-init-scaffolding.md` exits 0.
- `grep -q '## Completion' ai/shared/handoffs/sync-init-role-planning.md` exits 0.
- `ls ai/code-review-reports/` shows the new plan review report or reports.

## Completion

- Date: 2026-11-26.
- Plan: `ai/plans/sync-script-init-scaffolding.md`.
- Review: review-181 APPROVED (review-179 and review-180 CHANGES REQUESTED).
- Files touched: `ai/plans/sync-script-init-scaffolding.md`, `ai/issues/open/sync-script-init-scaffolding.md`, `ai/shared/handoffs/sync-init-role-planning.md`, `ai/code-review-reports/2026-11-26_15-24_review-179.md`, `ai/code-review-reports/2026-11-26_15-25_review-180.md`, `ai/code-review-reports/2026-11-26_15-25_review-181.md`.
- Claim cleared. No implementation, branch, commit, merge, tag, release, or state-file change.

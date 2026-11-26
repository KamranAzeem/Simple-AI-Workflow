<!-- STATE-FILE-HEADER: context.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** the present, in `## Current Status` and `## Active Working Context`, edited in place.
- **Never write:** history, completed work, plans, runbooks, ledgers, commands, implementation steps, investigation notes, transcripts, or git metadata. Completed work goes to `progress.md`, pending work to `next-steps.md`, and durable detail to Project Knowledge.
- **Brevity:** at most three short bullets per item, with a pointer to Project Knowledge for detail.
- **Size:** counted in the shared state-file budget in `ai-policy-common.md`. Move resolved items to the diary first; if the shared budget is still exceeded, keep live items and report the overage.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: context.md END -->

# Project Context

## Current Status

- **Milestone**: v7.7.0 live; plain checkpoint list.
- **Validation**: validator 8/8 with two user-subdir warnings until the live sync; suite 33/33; markdownlint 0; shellcheck 0; PowerShell not run because `pwsh` is absent.
- **Stores**: project 17 files, user 28, team when configured; `ai/shared/` keeps coordination and handoffs.
- **Issues**: 11 open, 0 in-progress, 144 closed; the scope and checkpoint-report tickets are closed.
- **Release**: v7.7.0 is live; release notes carry review-157; the report split has no release.

## Active Working Context

- **Objective**: migrate the live User AI Directory, sync downstream projects, then repair the state files and continue the open queue.
- **Live user store**: old layout; run the sync with `--dry-run`, then for real; the accidental test backup remains under `~/.ai/backups/scope-migration-2026-11-25/`.
- **Open queue**: toolchain retirement, presets and init, young learner, and deferred slide work.
- **Skills**: 1 workflow package (`kanban-board`), 0 project packages, user root live; team skills only when configured.

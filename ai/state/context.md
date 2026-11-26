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

- **Milestone**: v7.8.0 live; presentation standard.
- **Validation**: validator 8/8; suite 33/33; index 26/16/59; markdownlint 0; shellcheck 0; PowerShell not run because `pwsh` is absent.
- **Stores**: project 16 files, user 27, team when configured; `ai/shared/` keeps coordination and handoffs.
- **Issues**: 8 open, 0 in-progress, 148 closed; the slide pipeline, presentation policy, and slide review speed are closed.
- **Release**: v7.8.0 is live; v7.7.1 is the prior release.

## Active Working Context

- **Objective**: migrate the live User AI Directory, sync downstream projects, then continue the open queue.
- **Live user store**: old layout; run the sync with `--dry-run`, then for real; the accidental test backup remains under `~/.ai/backups/scope-migration-2026-11-25/`.
- **Open queue**: presets and init, and young learner.
- **Skills**: 1 workflow package (`kanban-board`), 0 project packages, user root live; team skills only when configured.

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

- **Milestone**: v7.11.0 live; the four v7.7.x trigger aliases are retired.
- **Validation**: validator 8/8; suite 35/35; index 26/16/55; markdownlint 0; shellcheck 0; PowerShell not run because `pwsh` is absent.
- **Stores**: project 18 files, user 27, team when configured; `ai/shared/` keeps coordination and handoffs.
- **Issues**: 7 open, 0 in-progress, 157 closed; F2 to F5 are closed, F6 is open.
- **Release**: v7.11.0 is live; v7.10.0 is the prior release.

## Active Working Context

- **Objective**: land F6, then the young learner plan and the User AI Directory migration.
- **Live user store**: active store `~/.ai/knowledge/` (27 files); no old-layout fallback present; confirm the migration item is done.
- **Open queue**: F6, then the young learner and the migration.
- **Alias retirement**: 4 v7.7.x triggers removed; the index reports 55 triggers; details in the closed F1 ticket and the 2026-11-26 diary.
- **Docs batch**: F2 to F5 closed; the validation doc and spec use `workflow`; the map is refreshed; docs-only changes may land without a release.
- **State repair**: 83 progress entries condensed into the 2026-11-26 diary; the shared budget is clear.
- **Young learner design**: distribution policy plus lesson skill, dialect-first, Python-target transpiler, explicit types; decisions in the 2026-11-26 diary.
- **Skills**: 1 workflow package (`kanban-board`), 0 project packages, user root live; team skills only when configured.

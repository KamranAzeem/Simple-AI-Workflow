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

- **Milestone**: v7.12.0 prepared; grilling uses frontier rounds and numbered questions.
- **Validation**: validator 8/8; suite 35/35; index 26/16/55; markdownlint 0; shellcheck 0; PowerShell not run because `pwsh` is absent.
- **Stores**: project 18 files, user 27, team when configured; `ai/shared/` keeps coordination and handoffs.
- **Issues**: 7 open, 0 in-progress, 159 closed; the grilling ticket is closed, the Azure idea is open.
- **Release**: v7.12.0 prepared; v7.11.1 is the prior release.

## Active Working Context

- **Objective**: grill the Azure companion-architect exercises idea, then plan it; the young learner is parked; the migration items remain.
- **Live user store**: active store `~/.ai/knowledge/` (27 files); no old-layout fallback present; confirm the migration item is done.
- **Open queue**: Azure exercises grilling; young learner parked; migration items.
- **Grilling**: frontier rounds, numbered questions, facts/decisions; details in the closed grilling ticket.
- **Young learner design**: distribution policy plus lesson skill, dialect-first, Python-target transpiler, explicit types; decisions in the 2026-11-26 diary.
- **Skills**: 1 workflow package (`kanban-board`), 0 project packages, user root live; team skills only when configured.

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

- **Milestone**: v7.7.0 is live; scope normalization, the unprefixed knowledge layout, the sync migration, and the four skill roots are implemented.
- **Stores**: project `ai/knowledge/` (16 files), user `knowledge/` (28 files), team `knowledge/` when configured; `ai/shared/` keeps coordination and handoffs.
- **Validator**: 8/8; authoring passes; suite 33/33; 25 policies, 16 procedures, 58 triggers including the v7.7.x aliases, 0 conflicts, 0 errors.
- **State files**: shared budget 30,720 bytes; today's 2026-11-25 exists; the shared total is over budget and needs `repair state files`.
- **Project issues**: 12 open, 0 in-progress, 143 closed; the scope ticket is closed; checkpoint next-steps, toolchain retirement, presets, and init follow.
- **Release**: v7.7.0; the tag and release URL are in the v7.7.0 announcement.

## Active Working Context

- **Objective**: sync downstream projects to v7.7.0, then fix the checkpoint next-steps reporting, retire the verification toolchain note, and audit the Project Knowledge the protocol relies on.
- **Toolchain retirement (open, P3/M)**: consume only necessary content into the protocol, delete the note, update the two fixtures and the map.
- **Checkpoint next steps (open, P2/S)**: separate Current position from Next steps, name the active ticket, show the queue, and keep the transaction log separate.
- **Presets and init (open)**: the customization presets ticket owns the role switch name; init follows the sync hardening.
- **Team store**: optional; no production store is configured; the local fixture is `~/Projects/infrastructure-team-alpha/`.
- **Skills**: 1 workflow package (`kanban-board`), 0 project packages, user skills live; team skills are indexed only when configured.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the implementation request approves the plan's close sequence.
- **Slide tickets (deferred)**: the presentation policy needs layout and type-control design first; the review-speed ticket keeps its trimmed S scope.

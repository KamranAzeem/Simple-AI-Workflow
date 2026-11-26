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

- **Milestone**: v7.12.1 live; the Azure exercise pack is implemented and reviewed, awaiting the merge.
- **Validation**: validator 8/8; suite 36/36; index 26/16/55; markdownlint 0; shellcheck 0; PowerShell not run; Bicep build `[PENDING]`.
- **Stores**: project 18 files, user 27, team when configured; `ai/shared/` keeps coordination and handoffs.
- **Issues**: 6 open, 0 in-progress, 161 closed; the Azure exercises ticket is closed with the plan attached.
- **Release**: v7.12.1 is live; the pack is docs-only with no release.

## Active Working Context

- **Objective**: merge the reviewed Azure exercise pack after approval; then plan the young learner; the migration items remain.
- **Live user store**: active store `~/.ai/knowledge/` (27 files); no old-layout fallback present; confirm the migration item is done.
- **Open queue**: Azure pack merge; young learner plan; migration items.
- **Azure pack**: labs 1-3 are cloud-free; lab 3 is a static Bicep review; the what-if gate is in lab 4; details in the attached plan.
- **Plan review**: a policy or procedure change carries the protocol ADR entry; a missing entry is Major.
- **Young learner design**: distribution policy plus lesson skill, dialect-first, Python-target transpiler, explicit types; decisions in the 2026-11-26 diary.
- **Skills**: 1 workflow package (`kanban-board`), 0 project packages, user root live; team skills only when configured.

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

- **Milestone**: v7.0.1 is implemented on `fix/backup-scripts-hardening`; the merge, tag, release, and ticket close follow.
- **Validator**: 8/8; authoring PASSED; 27 test scripts; 24 policies, 15 procedures, 50 triggers, 0 conflicts, 0 errors; markdownlint 0; shellcheck 0.
- **Policy count**: 24 modular policies and 15 procedure modules; the policy floor is 24.
- **State files**: the three files share a 30,720-byte budget; headers are number-free; today's file exists; sizes are under budget.
- **Project knowledge**: 12 lessons plus the template; global knowledge 29 files; the toolchain note records 27 tests and the floor of 24.
- **Project issues**: 9 open, 0 in-progress; GitHub #13 is closed.
- **Skills**: 0 project and 0 global packages; the two-root model stays.

## Active Working Context

- **Objective**: maintain the protocol; the backlog is the issue tracker; 9 open tickets, none approved for work.
- **Backup scripts (implemented)**: both scripts stream progress, prune heavy directories, and keep good archives when the platform permission check cannot run.
- **Team knowledge store (open, XL)**: the shared-store idea and the full brainstorm are in `ai/issues/open/shared-team-knowledge-store.md`.
- **Release**: v7.0.1 is implemented; the merge, tag, and release follow.
- **State-file budget**: the shared 30,720-byte gate, the 300-character guard, the condense pipeline, and the repair fallback are live on master.
- **Migration**: one `repair state files` run per existing project refreshes the header block.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **GitHub tracker**: #8 through #13 are closed.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the checkpoint runs before the merge.
- **Release history**: v5.8.0 through v7.0.0 are published; v7.0.1 is pending.
- **Tool selection**: the built-in index boot is live; the runtime file-operation rule is unconditional.
- **Lint**: clean; the local-only directories and the daily checkpoints are exempt.
- **Stash guard**: a stash round-trip can delete empty mandatory directories; the validator catches the gap.

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

- **Milestone**: v7.2.1 is live; post-compaction recovery is documented as manual; the docs and slides batch is live.
- **Team knowledge**: the policy, publish procedure, boot index step, and 53 triggers are live.
- **Validator**: 8/8; authoring PASSED; suite 31/31; 25 policies, 16 procedures, 53 triggers, 0 conflicts, 0 errors.
- **Policy count**: 25 modular policies and 16 procedure modules; the floor is 25.
- **State files**: shared budget 30,720 bytes; number-free headers; today's file 2026-11-24 exists; sizes under budget.
- **Project knowledge**: 14 lessons plus the template; global knowledge 29 files.
- **Project issues**: 11 open, 0 in-progress; the docs and slides, manual-recovery, and Kanban tickets are closed.
- **Skills**: 1 global package (`kanban-board`); 0 project packages; a team root is indexed only when configured.

## Active Working Context

- **Objective**: maintain the protocol; the backlog is the issue tracker; 11 open, 0 in-progress; the idea-intake flow is next.
- **Documentation and slides batch (live)**: the seven notes items are in the guide and the deck; review-97 APPROVED.
- **Post-compaction recovery (manual)**: the procedure, `AGENTS.md`, the guide, the slides, the setup guide, the comparison table, the README, and the knowledge note state the manual run.
- **Release**: v7.2.1 is live at the GitHub Release; no release is pending.
- **State-file budget**: the shared 30,720-byte gate, the 300-character guard, and the condense pipeline are live.
- **Team store**: optional; indexed only when configured; no production store is configured.
- **Team skills**: the optional third root is live since v7.2.0.
- **Backup scripts**: both stream progress, prune heavy directories, and keep good archives when the permission check cannot run.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Kanban skill (live)**: the read-only board at `ai/skills/kanban-board/` is indexed as 1 global package.
- **Idea intake (open, next)**: the trigger and type design is settled; own branch.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the checkpoint runs before the merge.
- **Stash guard**: a stash round-trip can delete empty mandatory directories; the validator catches the gap.
- **Release note caveat**: the v7.2.1 release-practices entry says "prepared"; the GitHub Release is the publication record.
- **Lint**: clean; the local-only directories and the daily checkpoints are exempt.

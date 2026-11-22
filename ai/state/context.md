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

- **Milestone**: v7.1.0 is released and published; the optional team knowledge store is live; the ticket is closed.
- **Team knowledge**: the policy, publish procedure, boot index step, and 53 triggers are live; review-79 APPROVED.
- **Validator**: the last run passed 8/8; authoring PASSED; 28 test scripts; 25 policies, 16 procedures, 53 triggers, 0 conflicts, 0 errors.
- **Policy count**: 25 modular policies and 16 procedure modules; the policy floor is 25.
- **State files**: the three files share a 30,720-byte budget; headers are number-free; today's file 2026-11-22 exists; sizes are under budget.
- **Project knowledge**: 13 lessons plus the template; global knowledge 29 files; the release practices and toolchain notes are current.
- **Project issues**: 12 open, 0 in-progress; GitHub #8 through #13 are closed.
- **Skills**: 0 project and 0 global packages; the two-root model stays.

## Active Working Context

- **Objective**: maintain the protocol; the backlog is the issue tracker; 12 open tickets, none approved for implementation.
- **Team knowledge store (live)**: policy and publish procedure; the boot indexes the store only when configured; v7.1.0 is published.
- **Team skills (open, L)**: `ai/issues/open/team-skills-scope.md`; unblocked by the team knowledge store.
- **Documentation refresh (open)**: slide deck, README, and guide audit tickets; the source-of-truth decision is pending.
- **Backup scripts (live)**: both scripts stream progress, prune heavy directories, and keep good archives when the platform permission check cannot run.
- **Release**: v7.1.0 is released and published; no release is pending.
- **State-file budget**: the shared 30,720-byte gate, the 300-character guard, the condense pipeline, and the repair fallback are live.
- **Migration**: one `repair state files` run per existing project refreshes the header block.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **GitHub tracker**: #8 through #13 are closed.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the checkpoint runs before the merge.
- **Release history**: v5.8.0 to v7.1.0 are published.
- **Tool selection**: the built-in index boot is live; the runtime file-operation rule is unconditional.
- **Lint**: clean; the local-only directories and the daily checkpoints are exempt.
- **Stash guard**: a stash round-trip can delete empty mandatory directories; the validator catches the gap.
- **Peer review**: review-75 through review-79 are local reports; review-79 APPROVED.
- **Team store validation**: no live store is configured; the publish path and boot index are covered by fixtures only.

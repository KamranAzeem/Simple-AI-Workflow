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

- **Milestone**: v7.0.0 is implemented on `feature/state-file-total-budget`; the merge, tag, release, and GitHub #13 close follow the approved plan.
- **Validator**: 8/8; authoring PASSED; 27 test scripts; 24 policies, 15 procedures, 50 triggers, 0 conflicts, 0 errors; markdownlint 0 over 261 files; shellcheck 0.
- **Policy count**: 24 modular policies and 15 procedure modules; the policy floor is 24.
- **State files**: the three files share a 30,720-byte budget; headers are number-free; today's file exists; sizes are under budget.
- **Project knowledge**: 11 lessons plus the template; global knowledge 29 files; the toolchain note records 27 tests and the floor of 24.
- **Project issues**: 8 open, 0 in-progress; GitHub #13 stays open until the release.
- **Skills**: 0 project and 0 global packages; the two-root model stays.

## Active Working Context

- **Objective**: maintain the protocol; the backlog is the issue tracker; 8 open tickets, none approved for work.
- **Release**: v7.0.0 is the active release; the announcement and the README banner are in the branch.
- **State-file budget**: the shared 30,720-byte gate, the 300-character guard, the condense pipeline, and the repair fallback are live on the branch.
- **Migration**: one `repair state files` run per existing project refreshes the header block.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **GitHub tracker**: #8, #9, #10, #11, and #12 are closed; #13 closes with v7.0.0.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the checkpoint runs before the merge.
- **Release history**: v5.8.0 through v6.11.0 are published; v7.0.0 is pending.
- **Tool selection**: the built-in index boot is live; the runtime file-operation rule is unconditional.
- **Lint**: clean; markdownlint 0 over 261 files; the local-only directories and the daily checkpoints are exempt.
- **Stash guard**: a stash round-trip can delete empty mandatory directories; the validator catches the gap.

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

- **Milestone**: v7.3.0 is live; the full deck review is approved (review-115); v7.3.1 is prepared on the review branch and awaits delivery.
- **Team knowledge**: the policy, publish procedure, boot index step, and 54 triggers are live.
- **Validator**: 8/8; the authoring check passes; suite 31/31; the slide audit reports 0 overflow; 25 policies, 16 procedures, 54 triggers, 0 conflicts, 0 errors.
- **Policy count**: 25 modular policies and 16 procedure modules; the floor is 25.
- **State files**: shared budget 30,720 bytes; number-free headers; today's file 2026-11-24 exists; sizes under budget.
- **Project knowledge**: 14 lessons plus the template; global knowledge 29 files.
- **Project issues**: 11 open, 0 in-progress; the token ticket is closed as superseded; the full deck review ticket is closed with the plan; the slide-deck review speed issue is open.
- **Skills**: 1 global package (`kanban-board`); 0 project packages; a team root is indexed only when configured.

## Active Working Context

- **Objective**: deliver v7.3.1: merge the review branch, tag, publish, and delete the branches; the backlog is 11 open, 0 in-progress.
- **Documentation and slides batch (live)**: the seven notes items are in the guide and the deck; review-97 APPROVED.
- **Full deck review (approved)**: the token work is on the held base; 2.4rem body with 84/98vh diagrams; the fixture is green; the notes and arrow fixes are in; review-115 APPROVED; the ticket is closed; v7.3.1 is prepared.
- **Notes 93+ (live)**: the ladder has six levels with level 2 marked and 3-5 unlabelled; the multi-repo root is `customer-joe/`; the Idea bullet is gone; the quality loop runs test first, implement, peer review; the model card is centered.
- **Post-compaction recovery (manual)**: the procedure, `AGENTS.md`, the guide, the slides, the setup guide, the comparison table, the README, and the knowledge note state the manual run.
- **Release**: v7.3.0 is live; v7.3.1 is prepared and confirmed; delivery is pending.
- **State-file budget**: the shared 30,720-byte gate, the 300-character guard, and the condense pipeline are live.
- **Team store**: optional; indexed only when configured; no production store is configured.
- **Team skills**: the optional third root is live since v7.2.0.
- **Backup scripts**: both stream progress, prune heavy directories, and keep good archives when the permission check cannot run.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Kanban skill (live)**: the read-only board at `ai/skills/kanban-board/` is indexed as 1 global package.
- **Idea intake and close-sequence clarity (live)**: the `Idea` type, the `file an idea` trigger, the dated `Won't fix` close, and the two-step wording are live; the plan is attached to the idea ticket.
- **Customization tracking (committed)**: the fix is committed on its own change and awaits review and merge; the tracked customization, the loader acceptance, and the ADR are recorded.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the implementation request approves the plan's close sequence.
- **Stash guard**: a stash round-trip can delete empty mandatory directories; the validator catches the gap.
- **Lint**: clean; the local-only directories and the daily checkpoints are exempt.

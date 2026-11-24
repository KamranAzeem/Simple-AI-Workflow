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

- **Milestone**: v7.4.0 is prepared on `feature/team-knowledge-directory-rename`; the team store is renamed to `team-knowledge/`; the release awaits the terminal gate and publication.
- **Team knowledge**: the policy, publish procedure, boot index, docs, deck, fixture, guard, validator anchors, and ADR are updated; the repository naming convention and the report-only check are a separate open ticket.
- **Validator**: 8/8; authoring passes; suite 31/31; slide audit 0 overflow; 25 policies, 16 procedures, 54 triggers, 0 conflicts, 0 errors.
- **State files**: shared budget 30,720 bytes; today's file 2026-11-25 exists; sizes under budget.
- **Project knowledge**: 14 lessons plus the template; global knowledge 29 files.
- **Project issues**: 13 open after the parked tickets restore; 0 in-progress; the rename ticket closes in the branch; the naming-convention and review-budget tickets are open.
- **Skills**: 1 global package (`kanban-board`); 0 project packages; a team root is indexed only when configured.

## Active Working Context

- **Objective**: deliver v7.4.0: commit the checkpoint, pass the terminal gate, merge, tag, and publish; restore the pre-work stash afterward.
- **Release**: v7.4.0 prepared; the announcement, banner, release-practices entry, and GitHub body are approved; publication follows the gate.
- **Pre-work stash**: `pre-rename park 2026-11-24`; restore it in the working tree after delivery; the deleted config plan stays deleted; recreate `ai/pending/` if the round-trip removes it.
- **Terminal gate**: base `306c3eb`; branch `feature/team-knowledge-directory-rename`; direct squash merge.
- **Team store**: optional; no production store is configured; the local fixture is `~/Projects/infrastructure-team-alpha/`.
- **Team skills**: the optional third root is live since v7.2.0.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the implementation request approves the plan's close sequence.
- **Stash guard**: a stash round-trip can delete empty mandatory directories; the validator catches the gap.
- **Lint**: `markdownlint-cli2` printed `Linting: 11 files` and `0 issues in 0 files`; the exit code and the linting count are the signal.
- **Slide tickets (deferred)**: the presentation policy needs layout and type-control design first; the review-speed ticket keeps its trimmed S scope.
- **Slide audit limit**: `audit-slides.sh` checks HTML overflow only; SVG-internal defects need the PNG pass.

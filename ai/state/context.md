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

- **Milestone**: v7.6.2 is implemented and reviewed; the review-sequencing rules are policy/ADR-owned; v7.6.2 ship is next.
- **Team knowledge**: the rename to `team-knowledge/` is live; the repository naming convention was dropped as Won't fix; the in-repo layout is currently `team-knowledge/` and its sibling `skills/`.
- **Validator**: 8/8; authoring passes; suite 31/31; 25 policies, 16 procedures, 54 triggers, 0 conflicts, 0 errors.
- **State files**: shared budget 30,720 bytes; today's file 2026-11-25 exists; twenty-eight progress items condensed.
- **Project knowledge**: 16 files (14 lessons, the template, the codebase map); global knowledge 28 files; both under the 50-file threshold.
- **Project issues**: 11 open, 0 in-progress, 142 closed; plan-quality, the follow-up, the checkpoint report, and the review-sequencing issue are closed; scope-naming, presets, and init follow.

## Active Working Context

- **Objective**: ship v7.6.2; then the scope vocabulary, the presets, and the init script.
- **Plan-quality (closed, P2/M)**: the uniform gate is live at review-145; the closed tickets carry the template, assertion floor, depth, and clean-tree decisions.
- **Plan-quality follow-up (closed, P2/M)**: implemented at review-147; the plan is attached; v7.6.0 is live.
- **Review sequencing (closed, P3/S)**: the code-review policy owns the hash binding, delta verification, post-approval invalidation, and follow-up; the ADR records the decision; v7.6.2 is ready.
- **Checkpoint report (closed, P3/S)**: the Current position block is live at review-149; v7.6.1 is live.
- **Scope vocabulary (open, P2/XL)**: the owner-prefix model, directory layout, no-symlink migration, sync/init, and the future same-root read/write and worktree-sharing scenario are recorded.
- **Scope vocabulary open items**: release level, alias window, legacy alias, backup target, role switch name, and handoff directory remain open.
- **Release**: v7.6.1 is live; v7.6.2 is ready to ship.
- **Team store**: optional; no production store is configured; the local fixture is `~/Projects/infrastructure-team-alpha/`.
- **Team skills**: the optional third root is live since v7.2.0.
- **Skills**: 1 global package (`kanban-board`); 0 project packages; a team root is indexed only when configured.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the implementation request approves the plan's close sequence.
- **Slide tickets (deferred)**: the presentation policy needs layout and type-control design first; the review-speed ticket keeps its trimmed S scope.

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

- **Milestone**: v7.4.0 is live; the core uniform review gate plan is APPROVED at review-143; no implementation and no branch.
- **Team knowledge**: the rename to `team-knowledge/` is live; the repository naming convention was dropped as Won't fix; the in-repo layout is currently `team-knowledge/` and its sibling `skills/`.
- **Validator**: 8/8; authoring passes; suite 31/31; 25 policies, 16 procedures, 54 triggers, 0 conflicts, 0 errors.
- **State files**: shared budget 30,720 bytes; today's file 2026-11-25 exists; five progress items condensed; overage remains.
- **Project knowledge**: 16 files (14 lessons, the template, the codebase map); global knowledge 28 files; both under the 50-file threshold.
- **Project issues**: 13 open, 0 in-progress; the plan-quality gate is the next implementation; the scope-naming, presets, and init follow.

## Active Working Context

- **Objective**: implement the approved uniform review gate plan; then the scope vocabulary, the customization presets, and the init script.
- **Plan-quality (open, P2/M)**: the core gate plan is APPROVED at review-143; the plan template, assertion floor, depth, and clean-tree rules are deferred to plan-quality-follow-up-rules.md.
- **Review sequencing**: bind the verdict to the artifact hash; approve only with no open findings; run one delta verification after fixes; pointer to protocol-verification-toolchain.md.
- **Scope vocabulary (open, P2/XL)**: the owner-prefix model, directory layout, no-symlink migration, and sync/init behavior are recorded; release level, alias window, legacy alias, backup target, role switch name, and handoff directory proposal remain open.
- **Release**: v7.4.0 is live; the next MINOR is v7.5.0 for plan-quality if it lands first.
- **Team store**: optional; no production store is configured; the local fixture is `~/Projects/infrastructure-team-alpha/`.
- **Team skills**: the optional third root is live since v7.2.0.
- **Skills**: 1 global package (`kanban-board`); 0 project packages; a team root is indexed only when configured.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the implementation request approves the plan's close sequence.
- **Slide tickets (deferred)**: the presentation policy needs layout and type-control design first; the review-speed ticket keeps its trimmed S scope.

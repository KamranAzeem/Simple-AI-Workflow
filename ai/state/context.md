<!-- STATE-FILE-HEADER: context.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** the present, in `## Current Status` and `## Active Working Context`, edited in place.
- **Never write:** history, completed work, plans, runbooks, ledgers, commands, implementation steps, investigation notes, transcripts, or git metadata. Completed work goes to `progress.md`, pending work to `next-steps.md`, and durable detail to Project Knowledge.
- **Brevity:** at most three short bullets per item, with a pointer to Project Knowledge for detail.
- **Size:** 8 KB soft target. Move resolved items to the diary first; if live items still exceed the target, keep them and report the overage.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: context.md END -->

# Project Context

## Current Status

- **Milestone**: v5.5.1 (2026-10-31) implemented: planning stays in `open/` with no branch, only the implement request opens the branch, and the branch-before-edit rule is narrowed for planning artifacts.
- **Validator**: v6.1, 8/8; authoring validator PASSED; reference test PASS; markdownlint 0.
- **Policy count**: 18 modular policies.
- **State files**: canonical headers in place; daily checkpoints under `ai/daily-checkpoints/` are the only archive; today's file exists.
- **Project knowledge**: 9 lesson files plus the template; global knowledge 24 files; JIT-indexed; ADR store `design-docs/protocol-decisions.md`; ticket background lives in Project Knowledge; `ai/notes/` holds `notes.md`.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 22 open, 0 in-progress, 60 closed.

## Active Working Context

- **Objective**: release v5.5.1.
- **Live decisions**: planning files and reviews the issue in `open/` with no branch and no commit; only the implement request opens the feature branch and moves the ticket to `in-progress/`; the branch-before-edit rule exempts planning artifacts; a work item has a terminal state and a bound close sequence; plan review checks the close sequence; the terminal gate requires at least one commit ahead of the resolved base and a clean tree; feature-branch approval covers commits and pushes, while trunk merge, tags, releases, and external writes stay gated; AI state lives only under the project root `ai/`, tracked or not; an uncommitted branch is unfinished work. See `design-docs/protocol-decisions.md`.
- **Work-item lifecycle**: planning stays in `open/` with no branch; implementation uses one branch and one squash commit; the final plan is attached to the closed ticket and the plan file is deleted; the checkpoint runs on the branch.
- **Knowledge standards**: v5.4.1 rules stand: 10 KB soft and 15 KB review, no split, self-standing files, no-question repair, project/global sensitive scope.
- **Release**: v5.5.0 is published; v5.5.1 is implemented and its release remains open.
- **Next actions**: release v5.5.1.
- **Lint**: clean on the v5.5.1 set and `ai/notes/notes.md`; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, and `ai/daily-checkpoints/` are exempt.

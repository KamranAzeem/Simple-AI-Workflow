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

- **Milestone**: v5.6.0 (2026-11-03) implemented: work-item delivery runs through `MANAGE-ISSUES` and `IMPLEMENT-PLAN`, with merge modes from `## Merge Policy`. The release is pending.
- **Validator**: 8/8; authoring validator PASSED; reference test PASS at 13 procedures and 96 steps; shellcheck clean; markdownlint 0.
- **Policy count**: 18 modular policies.
- **State files**: canonical headers in place; daily checkpoints under `ai/daily-checkpoints/` are the only archive; today's file exists.
- **Project knowledge**: 9 lesson files plus the template; global knowledge 26 files; JIT-indexed; ADR store `design-docs/protocol-decisions.md`; ticket background lives in Project Knowledge; `ai/notes/` holds `notes.md`.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 23 open, 0 in-progress, 62 closed.

## Active Working Context

- **Objective**: finish and release v5.6.0; the backlog is the issue tracker.
- **Live decisions**: a policy file named without a directory resolves from the Global AI Policies Directory; the meta policy's maintainer paths resolve from the workflow directory; the reference test guards hardcoded policy paths; user-facing docs that speak to a project name the directory anchor, while clone-layout docs keep the clone paths; work-item delivery runs through `MANAGE-ISSUES` and `IMPLEMENT-PLAN`, with the merge mode from `## Merge Policy`; planning files and reviews the issue in `open/` with no branch and no commit; only the implement request opens the feature branch; a work item has a terminal state and a bound close sequence; the approved plan and implement request cover the branch, commit, merge, push, release, and external writes the plan names; AI state lives only under the project root `ai/`. See `design-docs/protocol-decisions.md`.
- **Work-item lifecycle**: `MANAGE-ISSUES` files and plans, and stops at each request; `IMPLEMENT-PLAN` delivers. A branch may hold several commits; trunk receives one squash commit. Merge mode comes from `## Merge Policy`. The final plan is attached to the ticket and the plan file is deleted; the checkpoint runs on the branch.
- **Knowledge standards**: 10 KB soft and 15 KB review, no split, self-standing files, no-question repair, project/global sensitive scope.
- **Release**: v5.5.2 is published; the v5.6.0 tag and GitHub Release are pending.
- **Next actions**: finish the v5.6.0 close.
- **Lint**: clean on the v5.5.2 set and `ai/notes/notes.md`; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, and `ai/daily-checkpoints/` are exempt.

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

- **Milestone**: v5.7.0 (2026-11-07) implemented and approved: load context reports workflow-clone freshness; release pending.
- **Validator**: 8/8; authoring PASSED; reference test PASS at 13 procedures, 97 steps, 10 items; shellcheck warning-clean; markdownlint 0.
- **Policy count**: 18 modular policies.
- **State files**: canonical headers in place; daily checkpoints under `ai/daily-checkpoints/` are the only archive; today's file exists.
- **Project knowledge**: 9 lesson files plus the template; global knowledge 27 files; JIT-indexed; ADR store `design-docs/protocol-decisions.md`; ticket background lives in Project Knowledge; `ai/notes/` holds `notes.md`.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 24 open, 0 in-progress, 63 closed.

## Active Working Context

- **Objective**: release v5.7.0; the backlog is the issue tracker.
- **Live decisions**: the read-only update check compares local `HEAD` with the remote `HEAD` of the **Global AI Workflow Directory** clone and reports up to date, updates available with the pull command, ahead, diverged, or skipped; it runs at load context only; full SHAs compare and seven characters display; credential helpers are disabled, stderr is never emitted, and the remote call is capped at about three seconds. See `design-docs/protocol-decisions.md`.
- **Work-item lifecycle**: `MANAGE-ISSUES` files and plans and stops at each request; `IMPLEMENT-PLAN` delivers. The final plan is attached to the ticket and the plan file is deleted; the checkpoint runs on the branch.
- **Knowledge standards**: 10 KB soft and 15 KB review, no split, self-standing files, no-question repair, project/global sensitive scope.
- **Release**: v5.6.0 is published at <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v5.6.0>.
- **Next actions**: merge `feature/load-context-workflow-update-check`, tag v5.7.0, publish the release, and close issue #3.
- **Lint**: clean on the changed set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, and `ai/daily-checkpoints/` are exempt.

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

- **Milestone**: v5.3.0 (2026-10-27) released: canonical state-file headers, exact boot verification, repair restoration, and soft targets.
- **Validator**: v6.1, 8/8; authoring validator PASSED; reference test PASS; markdownlint 0.
- **Policy count**: 18 modular policies.
- **State files**: canonical headers in place; daily checkpoints under `ai/daily-checkpoints/` are the only archive.
- **Project knowledge**: JIT-indexed; ADR store `design-docs/protocol-decisions.md`; ticket background lives in Project Knowledge; `ai/notes/` holds `notes.md`.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 25 open, 0 in-progress, 54 closed.

## Active Working Context

- **Objective**: maintain v5.3.0; the backlog is the issue tracker.
- **Live decisions**: state-file headers are canonical, visible, and exactly compared; repair is the only writer of an existing block; historical checkpoints are not backfilled; the KB figures are soft targets; designated literal artifacts are exempt from the Rule Structure shape. See `design-docs/protocol-decisions.md`.
- **AGENTS.md banner**: the file opens with a visible protocol banner inside the immutable block; the HTML comment stays first in raw text and keeps the validator anchor.
- **Release**: v5.3.0 is published at <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v5.3.0>. The README banner and announcement are in the squash commit.
- **Next actions**: none; the backlog is the issue tracker.
- **Lint**: clean across the linted set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, and `ai/daily-checkpoints/` are exempt.

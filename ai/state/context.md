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
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 23 open, 0 in-progress, 57 closed.

## Active Working Context

- **Objective**: v5.4.0 implementation is complete on `feature/knowledge-file-standards-and-repair`; commit, merge, and release await approval.
- **Live decisions**: state-file headers are canonical, visible, and exactly compared; repair is the only writer of an existing block; historical checkpoints are not backfilled; the KB figures are soft targets; designated literal artifacts are exempt from the Rule Structure shape. See `design-docs/protocol-decisions.md`.
- **AGENTS.md banner**: the file opens with a visible protocol banner inside the immutable block; the HTML comment stays first in raw text and keeps the validator anchor.
- **Work-item lifecycle**: local ticket work uses one branch and one squash commit; plans carry evidence and automatic review; the final plan is attached to the closed ticket and the plan file is deleted; the checkpoint runs on the branch.
- **Knowledge standards**: implemented on the branch: shared standards and header, one capture pass, project-first promotion, conservation-gated `repair knowledge files`, project corpus 9 lessons plus the exempt template, global corpus 23 files, docs, ADRs, and the v5.4.0 release section.
- **Release**: v5.3.0 is published at <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v5.3.0>. v5.4.0 is implemented on the branch; no tag, push, or GitHub Release yet.
- **Next actions**: get approval to commit, squash merge, push, tag v5.4.0, and publish the release.
- **Lint**: clean on the implementation set; the user's `ai/notes/notes.md` carries a pre-existing MD012; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, and `ai/daily-checkpoints/` are exempt.

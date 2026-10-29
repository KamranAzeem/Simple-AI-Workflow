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

- **Milestone**: v5.4.1 (2026-10-29) prepared: the knowledge-repair correction with 10 KB soft and 15 KB review limits, no split, self-standing files, and the no-question repair.
- **Validator**: v6.1, 8/8; authoring validator PASSED; reference test PASS; markdownlint 0.
- **Policy count**: 18 modular policies.
- **State files**: canonical headers in place; daily checkpoints under `ai/daily-checkpoints/` are the only archive.
- **Project knowledge**: 9 lesson files plus the template; global knowledge 23 files; JIT-indexed; ADR store `design-docs/protocol-decisions.md`; ticket background lives in Project Knowledge; `ai/notes/` holds `notes.md`.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 23 open, 0 in-progress, 58 closed.

## Active Working Context

- **Objective**: commit, squash merge, push, tag v5.4.1, and publish the release.
- **Live decisions**: state-file headers are canonical, visible, and exactly compared; repair is the only writer of an existing block; historical checkpoints are not backfilled; the KB figures are soft targets; designated literal artifacts are exempt from the Rule Structure shape. v5.4.1 uses 10 KB soft and 15 KB review, never splits, keeps files self-standing, asks no repair question, keeps project names, removes global names, and bans raw secrets. See `design-docs/protocol-decisions.md`.
- **AGENTS.md banner**: the file opens with a visible protocol banner inside the immutable block; the HTML comment stays first in raw text and keeps the validator anchor.
- **Work-item lifecycle**: local ticket work uses one branch and one squash commit; plans carry evidence and automatic review; the final plan is attached to the closed ticket and the plan file is deleted; the checkpoint runs on the branch.
- **Knowledge standards**: v5.4.1 prepared: 10 KB soft and 15 KB review, no split, self-standing files, no-question repair, project/global sensitive scope, project corpus 10 files, global corpus 23 files, docs, ADRs, and the fixture test.
- **Release**: v5.4.0 is published at <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v5.4.0>. v5.4.1 is prepared on the branch; the tag and GitHub Release follow the merge.
- **Next actions**: commit, squash merge, push, tag v5.4.1, and publish the release.
- **Lint**: clean on the v5.4.1 set; the user's `ai/notes/notes.md` carries a pre-existing MD012; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, and `ai/daily-checkpoints/` are exempt.

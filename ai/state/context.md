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

- **Milestone**: v6.6.0 is prepared for release; the live test passed; the program and its 12 children are closed.
- **Validator**: 8/8; authoring PASSED; all 19 test scripts pass; `--index` 37/23/14, 47 triggers, 0 conflicts, 0 errors; markdownlint 0.
- **Policy count**: 23 modular policies and 14 procedure modules.
- **State files**: canonical headers in place; daily checkpoints are the only archive; today's file exists; the three files are under the 20 KB target.
- **Project knowledge**: 10 lesson files plus the template; global knowledge 27 files; the release record gained v6.6.0; ADR store `design-docs/protocol-decisions.md`.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 26 open, 0 in-progress, 84 closed; the tool-selection, common-policy prose-shape, and AGENTS.md audit tickets are open; the young-learner ticket is open XL.
- **Skills**: 0 project and 0 global packages; no new package.

## Active Working Context

- **Objective**: maintain the protocol; the backlog is the issue tracker; the v6.6.0 release is in flight.
- **Release**: the plug-in extraction is complete, reviewed, and live-tested; merge, tag, publish, and branch deletion remain.
- **Common policy prose shape (open, L)**: the read-only audit found 90 multi-sentence rules, 16 rationale bullets, 6 banned words, and 8 prose sections; the debt is recorded; the rewrite is a separate unit after the program release.
- **AGENTS.md thinness (open)**: the peer review verdict is CHANGES REQUESTED; the report is `2026-11-17_22-19_review-01.md`; the router is at 157/160 lines and 2,399/2,400 words; the refactor order is AGENTS.md first, then the common policy, then the other flagged policies.
- **Tool selection (open)**: the common-policy ladder and the git-ignore rewrite are a separate unit; the shell preference stays with GitHub #9; no shell fixture; the ticket and design record are in Project Knowledge.
- **GitHub tracker**: #10 has the design rewrite and the refined user-facing section; #9 is parked; #8 is open.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15; ticket filed; no branch or policy change.
- **Test location**: `tests/` holds the dev-time scripts; `support-files/` holds the sync scripts and validators.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the checkpoint runs before the merge.
- **Release history**: v5.8.0 through v6.5.0 are published; v6.6.0 is next.
- **Lint**: clean on the changed set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, `ai/daily-checkpoints/`, and `ai/notes/` are exempt.

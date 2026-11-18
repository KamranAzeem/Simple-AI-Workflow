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

- **Milestone**: v6.6.3 is prepared; the AGENTS.md refactor follow-ups are fixed; `AGENTS.md` is 135 lines and 1,617 words.
- **Validator**: 8/8; authoring PASSED; all 20 test scripts pass; 23 policies, 14 procedures, 47 triggers, 0 conflicts, 0 errors; markdownlint 0.
- **Policy count**: 23 modular policies and 14 procedure modules.
- **State files**: canonical headers in place; daily checkpoints are the only archive; today's file exists; the three files are under the 20 KB target.
- **Project knowledge**: 10 lesson files plus the template; global knowledge 27 files; the release practices carry the voice, draft-first, plain-words, and no-invented-events rules; the ADR records the loading decision.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 25 open, 0 in-progress, 89 closed.
- **Skills**: 0 project and 0 global packages.

## Active Working Context

- **Objective**: maintain the protocol; the backlog is the issue tracker; the next unit is the common-policy prose rewrite at v6.6.4.
- **Release**: v6.6.2 is released and published; the v6.6.3 follow-up fixes are prepared; the common-policy rewrite follows at v6.6.4.
- **Common policy prose shape (open, L)**: 90 multi-sentence rules, 16 rationale bullets, 6 banned words, and 8 prose sections; the rewrite is the next big unit.
- **Tool selection (open)**: the common-policy ladder and the git-ignore rewrite; the shell preference stays with GitHub #9; no shell fixture.
- **GitHub tracker**: #10 has the design rewrite and the short prompt; #9 is parked; #8 is open.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Test location**: `tests/` holds the dev-time scripts; `support-files/` holds the sync scripts and validators.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the checkpoint runs before the merge.
- **Release history**: v5.8.0 through v6.6.2 are published; v6.6.3 is next.
- **Lint**: clean on the changed set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, `ai/daily-checkpoints/`, and `ai/notes/` are exempt.

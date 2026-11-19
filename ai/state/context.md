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

- **Milestone**: v6.8.0 is released and published; the configurable global user directory, early whole-settings read, and `Default Shell` are implemented and reviewed; `AGENTS.md` carries the configurable user-directory anchor.
- **Validator**: 8/8; authoring PASSED; all 23 test scripts pass; 23 policies, 14 procedures, 47 triggers, 0 conflicts, 0 errors; markdownlint 0; shellcheck 0.
- **Policy count**: 23 modular policies and 14 procedure modules.
- **State files**: canonical headers in place; daily checkpoints are the only archive; today's file exists; the three files are under the 20 KB target.
- **Project knowledge**: 10 lesson files plus the template; global knowledge 27 files; the release practices carry the voice, draft-first, plain-words, and no-invented-events rules; the ADR records the loading, prose-rewrite, tool-selection, design-docs trigger, and config decisions; the toolchain record says 22 test scripts.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 24 open, 0 in-progress, 93 closed.
- **Skills**: 0 project and 0 global packages; the user-global skills root ticket is open.

## Active Working Context

- **Objective**: maintain the protocol; the backlog is the issue tracker; open units include the codebase examination over `docs/`, `tests/`, and `support-files/` and the skills-root plan.
- **Release**: v6.8.0 is released and published; no release is pending.
- **GitHub tracker**: #10 is postponed; #9 is closed as absorbed; #8 is open.
- **Config unit (closed)**: `ai/issues/closed/configurable-global-user-ai-directory-early-settings-and-shell.md`; the plan is attached; the design is in the ADR.
- **Idea tracking**: the checkpoint adds one next-steps line for each discussed problem or solution; no mid-session next-steps writes.
- **Design docs**: `design-docs/` holds the ADRs; the `update design documents` trigger is user-side; the developer-mode ADR entry is part of the change.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Test location**: `tests/` holds 23 dev-time scripts; `support-files/` holds the sync scripts and validators.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the checkpoint runs before the merge.
- **Release history**: v5.8.0 through v6.8.0 are published.
- **Lint**: clean on the changed set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, `ai/daily-checkpoints/`, and `ai/notes/` are exempt.

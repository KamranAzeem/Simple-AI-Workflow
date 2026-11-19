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

- **Milestone**: v6.10.2 is released and published; GitHub #12 is merged and closed; the #8 backup scripts are implemented and await merge and the v6.11.0 release; the user-global skills root plan is parked behind #8.
- **Validator**: 8/8; authoring PASSED; all 26 test scripts pass; 24 policies, 15 procedures, 50 triggers, 0 conflicts, 0 errors; markdownlint 0; shellcheck 0.
- **Policy count**: 24 modular policies and 15 procedure modules; the policy floor is 24.
- **State files**: canonical headers in place; daily checkpoints are the only archive; today's file exists; the three files are under the 20 KB target.
- **Project knowledge**: 10 lesson files plus the template; global knowledge 27 files; the release practices carry the voice, draft-first, plain-words, and no-invented-events rules; the ADR records the loading, prose-rewrite, tool-selection, design-docs trigger, config, v6.10.2 index, and backup-script scope decisions; the toolchain record says 26 test scripts; the tool-selection file records the v6.10.2 resolution.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 24 open, 0 in-progress, 97 closed.
- **Skills**: 0 project and 0 global packages; the user-global skills root ticket is open.

## Active Working Context

- **Objective**: maintain the protocol; the backlog is the issue tracker; the open units include the #8 merge and release, the user-global skills root implementation, the young-learner policy, and GitHub #8; GitHub #11, #12, and #10 are closed.
- **Release**: v6.11.0 is prepared for the backup scripts; the skills root is planned for v6.12.0.
- **GitHub tracker**: #8 implementation is ready, merge and v6.11.0 release pending approval; #12 is merged and closed; #10 is closed as not planned; #11 is closed and released; #9 is closed as absorbed.
- **Config unit (closed)**: `ai/issues/closed/configurable-global-user-ai-directory-early-settings-and-shell.md`; the plan is attached; the design is in the ADR.
- **Settings repair (closed)**: `ai/issues/closed/repair-global-settings-procedure-consolidation-key-names-and-tool-verification.md`; the plan is attached; the design is in the ADR; v6.9.0 is released.
- **Settings repair run (2026-11-19)**: the user's global settings consolidated to 5,257 bytes; 22 tools verified; the sensitive names are counted only; the paths are in the daily checkpoint; `Default Shell Path` is now `/usr/bin/bash`.
- **Idea tracking**: the checkpoint adds one next-steps line for each discussed problem or solution; no mid-session next-steps writes.
- **Design docs**: `design-docs/` holds the ADRs; the `update design documents` trigger is user-side; the developer-mode ADR entry is part of the change.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15.
- **Built-in-first rewrite (closed, P1/XL)**: `ai/issues/closed/built-in-first-execution-rewrite.md`; the plan is attached; review-49 approved the plan and review-50 approved the implementation; v6.10.0 is released.
- **Codebase examination (closed, P3)**: `ai/issues/closed/codebase-examination-docs-tests-support.md`; six findings fixed, F5 withdrawn; v6.10.1 is released.
- **User-global skills root (open, L)**: `ai/plans/user-global-skills-root.md`; review-52 APPROVED; the implementation is parked behind #8.
- **Report anomalies docs (closed, P3/S)**: GitHub #12 is merged and closed; docs only, no release.
- **Out-of-band backup scripts (open, P2/L)**: GitHub #8; the plan is attached; review-63 APPROVED; merge and v6.11.0 release pending approval.
- **Test location**: `tests/` holds 26 dev-time scripts; `support-files/` holds the sync and backup scripts, the validators, the optional index helper, and its contract.
- **Work-item lifecycle**: MANAGE-ISSUES files and plans; IMPLEMENT-PLAN delivers; the checkpoint runs before the merge.
- **Release history**: v5.8.0 through v6.10.2 are published; v6.11.0 is prepared.
- **Tool selection**: the v6.10.2 built-in index boot is live; the runtime file-operation rule is unconditional, the index helper is optional, and the harness permission is the hard stop.
- **Lint**: clean on the changed set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, `ai/daily-checkpoints/`, and `ai/notes/` are exempt.

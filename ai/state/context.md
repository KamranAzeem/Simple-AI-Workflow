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

- **Milestone**: v6.4.0 is implemented and reviewed; the outbound content scrub and the test-location move are complete; the release follows the merge.
- **Validator**: 8/8; authoring default and changed-set 0 failures; reference 13/101/4/12; trigger fixture 50/50; boot fixture PASS; knowledge fixture PASS; skills fixture PASSED; outbound scrub fixture PASSED; `--index` 31/18/13, 39 triggers, 0 conflicts, 0 errors; shellcheck clean; markdownlint 0.
- **Policy count**: 18 modular policies and 13 procedure modules.
- **State files**: canonical headers in place; daily checkpoints under `ai/daily-checkpoints/` are the only archive; today's file exists.
- **Project knowledge**: 9 lesson files plus the template; global knowledge 27 files; JIT-indexed; ADR store `design-docs/protocol-decisions.md`; the verification-toolchain file records the new test paths and fixtures.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 22 open, 0 in-progress, 69 closed; the outbound scrub ticket is closed with the plan attached; GitHub issue #7 stays open until the merge.
- **Skills**: 0 project and 0 global packages; no new package.

## Active Working Context

- **Objective**: ship v6.4.0, then return to the backlog.
- **Outbound content scrub (v6.4.0)**: two destination classes; Class A keeps names and infrastructure detail, Class B removes names and internal detail; secrets are unconditional; private IPs stay; public IPs become documentation addresses; the category report stays in chat; no helper script. The contract is `## Outbound Content Scrub` in `ai-policy-common.md`; `MANAGE-ISSUES` defines `STEP-SCRUB-OUTBOUND`; `IMPLEMENT-PLAN` references it. The ADR is in `design-docs/protocol-decisions.md`; the fixture is `tests/test-outbound-content-scrub.sh`.
- **Test location**: the six dev-time scripts live in the project-root `tests/`; `support-files/` holds the sync scripts and the validators.
- **Work-item lifecycle**: `MANAGE-ISSUES` files and plans and stops at each request; `IMPLEMENT-PLAN` delivers. The final plan is attached to the ticket and the plan file is deleted; the checkpoint runs before the merge.
- **Knowledge standards**: 10 KB soft and 15 KB review, six-segment task names, topic-only splits, a 3,000-byte merge floor, a 50-file review threshold, evidence deletion, one lesson in one place, the task lookup, and report-only retirement; self-standing files; no-question repair; project/global sensitive scope.
- **Release**: v5.8.0 through v6.3.0 are published on the GitHub releases page; v6.4.0 follows the merge.
- **Next actions**: ship the approved outbound scrub change, tag v6.4.0, and close GitHub #7 after the merge.
- **Lint**: clean on the changed set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, `ai/daily-checkpoints/`, and `ai/notes/` are exempt.

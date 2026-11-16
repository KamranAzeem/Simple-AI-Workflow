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

- **Milestone**: v6.5.0 is released; the handoff policy and procedure are on `master`; GitHub issue #6 is closed.
- **Validator**: 8/8; authoring PASSED; reference 14/108/4/12; trigger fixture 51 cases; boot, skills, knowledge, sync, scrub, and handoff fixtures pass; `--index` 33/19/14, 41 triggers, 0 conflicts, 0 errors; shellcheck clean; markdownlint 0.
- **Policy count**: 19 modular policies and 14 procedure modules.
- **State files**: canonical headers in place; daily checkpoints under `ai/daily-checkpoints/` are the only archive; today's file exists.
- **Project knowledge**: 9 lesson files plus the template; global knowledge 27 files; JIT-indexed; ADR store `design-docs/protocol-decisions.md`; the verification-toolchain file records the new counts and fixtures.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 24 open, 0 in-progress, 70 closed; the handoff ticket is closed with the plan attached; GitHub issue #6 is closed; the common-policy extraction ticket and the young-learner policy ticket are open and XL.
- **Skills**: 0 project and 0 global packages; no new package.

## Active Working Context

- **Objective**: maintain the released protocol; the backlog is the issue tracker.
- **Policy extraction (open, XL)**: the design is settled; the ticket records the 12 units, the boundary child first, the TDD prerequisite, the trigger discovery, the legacy boot default, the opt-in plugin, the clean refusal, the one-branch delivery, and the docs plan. The TDD parent exists; its policy-configuration child, the `## Loading` shape, and the load-path test do not. All work stays on `feature/plugin-extraction` until the user's live test passes.
- **Young-learner policy (open, XL)**: a teacher-only programming policy for ages 10 to 15, starting with a pinned executable pseudocode dialect, then Python, Go, or JavaScript. Ticket filed with the design review; no branch or policy change.
- **Outbound content scrub (released v6.4.0)**: two destination classes; Class A keeps names and infrastructure detail, Class B removes names and internal detail; secrets are unconditional; private IPs stay; public IPs become documentation addresses; the category report stays in chat; no helper script. The contract is `## Outbound Content Scrub` in `ai-policy-common.md`; `MANAGE-ISSUES` defines `STEP-SCRUB-OUTBOUND`; `IMPLEMENT-PLAN` references it. The ADR is in `design-docs/protocol-decisions.md`; the fixture is `tests/test-outbound-content-scrub.sh`.
- **Handoff (released v6.5.0)**: a dedicated `ai-policy-handoff.md` owns the Valid Handoff definition, the ordered template, the creation review, the lifecycle, the authorization, and the conditional autonomy. The common policy keeps the always-on pointer. The draft lives in `ai/artifacts/handoffs/<handoff-slug>/`; the final handoff is `ai/shared/handoffs/<handoff-slug>.md`. `CREATE-HANDOFF` loads the policy explicitly; no `LOAD-CONTEXT` auto-load; no `AGENTS.md` change. The receiver merges, and the original orchestrator records the state. The scrub applies only when the handoff leaves the project.
- **Test location**: the six dev-time scripts live in the project-root `tests/`; `support-files/` holds the sync scripts and the validators.
- **Work-item lifecycle**: `MANAGE-ISSUES` files and plans and stops at each request; `IMPLEMENT-PLAN` delivers. The final plan is attached to the ticket and the plan file is deleted; the checkpoint runs before the merge.
- **Knowledge standards**: 10 KB soft and 15 KB review, six-segment task names, topic-only splits, a 3,000-byte merge floor, a 50-file review threshold, evidence deletion, one lesson in one place, the task lookup, and report-only retirement; self-standing files; no-question repair; project/global sensitive scope.
- **Release**: v5.8.0 through v6.5.0 are published on the GitHub releases page.
- **Next actions**: file the TDD policy-configuration child, open and push `feature/plugin-extraction`, then plan the prerequisite and the boundary child on that branch.
- **Lint**: clean on the changed set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, `ai/daily-checkpoints/`, and `ai/notes/` are exempt.

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

- **Milestone**: v6.2.0 is implemented on the feature branch; the merge and release follow.
- **Validator**: 8/8; authoring default 0 failures; aggregate PASSED; reference 13/98/4/11; trigger fixture 50/50; boot fixture PASS; knowledge fixture PASS; `--index` 31/18/13, 39 triggers, 0 conflicts, 0 errors; shellcheck warning-clean; markdownlint 0.
- **Policy count**: 18 modular policies and 13 procedure modules.
- **State files**: canonical headers in place; daily checkpoints under `ai/daily-checkpoints/` are the only archive; today's file exists.
- **Project knowledge**: 9 lesson files plus the template; global knowledge 27 files; JIT-indexed; ADR store `design-docs/protocol-decisions.md`; ticket background lives in Project Knowledge; `ai/notes/` holds `notes.md`.
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 23 open, 0 in-progress, 66 closed; GitHub issue #5 is open until the merge; issue #4 and the legacy shape ticket are closed.

## Active Working Context

- **Objective**: maintain the released protocol; the v6.2.0 knowledge work is implemented and awaits the merge and release.
- **Trigger model**: policies and procedures declare `## Triggers` in one normalized namespace; one shared `STEP-PROTOCOL-INDEX`; an ephemeral index in the AI's context; script-free runtime; the policy plugin and the procedure modules are released. INV-001..INV-016 and the change rule are in `design-docs/protocol-decisions.md`; the v6.2.0 plan is attached to issue #5.
- **Boot discovery**: load context lists only the boot roots, applies the Boot Scan Exclusions, and keeps the output under 16 KB; the latest checkpoint is read once; the proof is compact; the runtime module index is inline; the developer `--index` oracle is separate.
- **Live decisions**: the read-only update check compares local `HEAD` with the remote `HEAD` of the **Global AI Workflow Directory** clone and reports up to date, updates available with the pull command, ahead, diverged, or skipped; it runs at load context only; full SHAs compare and seven characters display; credential helpers are disabled, stderr is never emitted, and the remote call is capped at about three seconds. See `design-docs/protocol-decisions.md`.
- **Work-item lifecycle**: `MANAGE-ISSUES` files and plans and stops at each request; `IMPLEMENT-PLAN` delivers. The final plan is attached to the ticket and the plan file is deleted; the checkpoint runs on the branch.
- **Knowledge standards**: 10 KB soft and 15 KB review, six-segment task names, topic-only splits, a 3,000-byte merge floor, a 50-file review threshold, evidence deletion, one lesson in one place, the task lookup, and report-only retirement; self-standing files; no-question repair; project/global sensitive scope.
- **Release**: v5.8.0 at <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v5.8.0>, v6.0.0 at <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v6.0.0>, and v6.1.0 at <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v6.1.0> are published; v6.2.0 is pending the merge.
- **Next actions**: merge the branch, tag v6.2.0, publish the release, and close issue #5.
- **Lint**: clean on the changed set; `ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`, `ai/daily-checkpoints/`, and `ai/notes/` are exempt.

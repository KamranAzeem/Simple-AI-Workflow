# Code Authoring Policy Plan

## Context

- Ticket: `ai/issues/in-progress/code-authoring-policy-and-policy-plugin.md`.
- Background: `ai/shared/project-knowledge/code-authoring-policy-design-analysis-2026-10-20.md`.
- Scope decision: ship the policy now as an opt-in Active Expertise policy.
- Non-goals for this pass: `## Triggers`, the plugin dispatch, `AGENTS.md` changes, `ai-policy-meta.md` changes, and trigger-validator changes.
- Telemetry decision: the AI classifies the work as production or non-production. Telemetry is on by default for production code, with a clear recommendation and an easy opt-out; non-production code is telemetry-free by default. The infrastructure stack stays optional.
- Operational baseline: all ten gaps are operationalized in the policy, with domain detail delegated and mapped in the reconciliation note.

## HLD

- `HLD-001`: Add `ai/policies/ai-policy-coding-baseline.md`, expertise token `coding-baseline`, language-neutral, on-demand only.
- `HLD-002`: Activation is opt-in through `## Active Expertise` or an explicit request by name. The policy lasts for the session and never changes code on activation.
- `HLD-003`: The policy owns the telemetry gate and the code-level emission rules when telemetry is enabled. `ai-policy-observability.md` keeps the signal definitions, thresholds, retention, sampling, and alerting.
- `HLD-004`: The policy references rules owned by `ai-policy-common.md` instead of restating them.
- `HLD-005`: One ADR entry records the opt-in-first decision and the deferred plugin, and a follow-up entry records the rename and the telemetry gate.

## LLD (with AC)

- `LLD-001`: Policy structure follows the authoring standard: guard, READ-ONLY markers, title, purpose sentence, `## Scope`, domain sections, `## References`.
  - AC: `validate-policy-authoring.sh` passes on the new file.
  - AC: `validate-protocol.sh` includes the policy in its baseline.
- `LLD-002`: Existing-code discipline forbids out-of-scope changes, mass rewrites, unrelated reformatting, and drive-by cleanup.
  - AC: every existing-code rule names the requested scope as its boundary.
- `LLD-003`: Telemetry defaults on for production code.
  - AC: the AI analyzes the scope and classifies it as production or non-production.
  - AC: an ambiguous scope is treated as production.
  - AC: the AI states the classification and the recommendation before writing code.
  - AC: it adds telemetry for production unless the user declines, and records a decline.
  - AC: non-production code is telemetry-free by default.
  - AC: when telemetry is enabled, applications emit latency, traffic, errors, and saturation, and command-line tools emit structured logs only.
  - AC: metric labels stay bounded, trace context appears in logs, export failure never fails a request, and no specific backend is assumed.
- `LLD-004`: Owning rules are referenced, not duplicated.
  - AC: SOLID, DRY, YAGNI, Twelve-Factor, TDD, and secure development point to `ai-policy-common.md`; signal definitions point to `ai-policy-observability.md`.
- `LLD-005`: Tracking is consistent.
  - AC: the ticket is in `in-progress/` and carries the plan filename as a dated comment.
  - AC: the ADR entries are self-contained and record the deferred plugin, the rename, and the telemetry gate.
- `LLD-006`: The coding policy is a thin core with pointers, not a restatement of cross-cutting rules.
  - AC: the policy keeps only its own code-construction rules and the telemetry gate.
  - AC: each cross-cutting concern is one line that names its owner policy.
  - AC: the owner loads when that concern is touched, so the coding policy does not burn context with duplicated detail.
  - AC: `coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md` records the model change.

## ADR

- `ADR-001`: Ship the coding policy as an opt-in policy before the plugin v0. A policy with `## Triggers` cannot pass the authoring validator, and adding the dispatch touches authoritative protocol files. The policy content is independent of the dispatch, so it ships first and the plugin lands separately. Consequence: activation is via Active Expertise or by name until the plugin lands.

## Verification

- `support-files/validate-policy-authoring.sh ai/policies/ai-policy-coding-baseline.md`
- `support-files/validate-protocol.sh`
- `support-files/test-protocol-references.sh`
- `markdownlint-cli2` on the changed markdown files.
- Peer review rounds of the policy against the authoring standard, the telemetry gate, the operational baseline, and the no-disturbance rule.

## Change set

- New `ai/policies/ai-policy-coding-baseline.md`.
- New `ai/plans/code-authoring-policy-plan.md`.
- New `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.
- Move the ticket to `ai/issues/in-progress/` and add the dated plan and decision comments.
- Add the dated ADR entries to `design-docs/protocol-decisions.md`.
- Register `coding` in the `validate-protocol.sh` baseline and update the count.
- Align `docs/ai-customization-guide.md`, the slides, and the comparison doc with the new policy and the policy count.

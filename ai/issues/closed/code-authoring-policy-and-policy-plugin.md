Reported: 2026-10-20
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Add an opt-in, language-neutral code authoring policy backed by a minimal policy plugin mechanism

Description:

Two deliverables:

1. A minimal policy plugin mechanism. A policy declares its own trigger phrases in a `## Triggers` section. Boot, post-compaction recovery, and checkpoint re-affirmation index only policy filenames and trigger lines, never the body. A declared phrase loads that policy in full for the session. A policy without `## Triggers` keeps today's behavior.
2. A new policy, `ai/policies/ai-policy-code-authoring.md`, for writing program code in any language. It is on-demand only. It is not added to Active Expertise, so it never changes an existing user's session until they ask for it.

Why both: the plugin mechanism does not exist today. `## Triggers` is reserved and rejected by the authoring validator. The policy alone would be inert for users, and listing it under Active Expertise would force it on anyone who adds it.

The policy content must not disturb existing code. New code follows the policy. Existing code changes only within the requested scope. No mass rewrite, no unrelated reformatting, and no drive-by cleanup without explicit approval.

Telemetry is mandatory when the policy is active. Every app the AI writes or changes must emit the telemetry needed for the Four Golden Signals (latency, traffic, errors, saturation), using the project's standard instrumentation. The definitions and thresholds stay in `ai-policy-observability.md`; the code policy adds the obligation and the code-level rules, such as structured logs, trace context, bounded-cardinality labels, and telemetry failure never failing a request. Instrumentation follows the same scope rule: new or changed code paths emit telemetry, while a full instrumentation pass over existing code needs an explicit request.

Related: `ai/issues/open/self-contained-policy-triggers-and-heading-jit-index.md` is the broad plugin ticket. This ticket implements only the minimal v0 needed for the code authoring policy.

The full analysis, the evidence, the critique of the Gemini draft, the proposed policy outline, the change set, and the open decisions are in `ai/shared/project-knowledge/code-authoring-policy-design-analysis-2026-10-20.md`.

Blocked on the decisions in that file, especially activation lifetime, trigger phrases, telemetry scope, and whether to implement the plugin v0 now or ship the policy as an Active Expertise opt-in first.

---
2026-10-20
Added the telemetry requirement. When the policy is active, every app must emit the telemetry needed for the Four Golden Signals. Instrumentation follows the same no-disturbance scope rule. The analysis, policy outline, and open decisions were updated.

---
2026-10-21
Resolved the scope decision: ship the policy now as an opt-in Active Expertise policy, with session-scoped activation and the no-disturbance default. The plugin v0 and its trigger phrases are deferred. Telemetry is mandatory when the policy is active: services, APIs, workers, and scheduled jobs emit the four signals, and command-line tools and one-off scripts emit structured logs.
Plan: `ai/plans/code-authoring-policy-plan.md`.

---
2026-10-21
Renamed the policy to `coding` (`ai/policies/ai-policy-coding.md`) for a shorter Active Expertise token. Telemetry is now opt-in: the AI asks when the project has no telemetry standard or the code is non-production code (examples, exercises, one-off scripts, and throwaway prototypes), defaults to no for those programs, and defaults to yes for production applications. The plugin v0 remains deferred.

---
2026-10-21
Expanded the coding policy with operational rules for resilience, configuration, dependency supply chain, cryptography, time handling, test quality, caching, log levels, named constants, and public contracts. Domain detail stays in the owning policies. Added the coverage map `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md` for later reconciliation.

---
2026-10-21
Reorganized the coding policy to a thin core plus pointers: it keeps only its own code-construction rules and the telemetry gate, and points at the owner for every cross-cutting concern. This reverses the operational-baseline decision, so the policy no longer restates security, telemetry emission, testing, resilience, caching, encryption, accessibility, or IaC detail. The reconciliation note records the model change.

---
2026-10-21
Renamed to `coding-base` and added the domain dispatch. Scope states it is a base layer and not a replacement for a domain policy. The cross-cutting pointers are now read instructions, so enabling `coding-base` alone pulls the right domain policy on demand.

---
2026-10-21
Policy deliverable complete. `ai-policy-coding-baseline.md` (token `coding-baseline`) ships v5.2.0 with the thin-core rules, the production telemetry default, and the domain read pointers. The remaining plugin v0 work is split into `policy-plugin-v0-trigger-dispatch.md`. Closed before the squash merge.

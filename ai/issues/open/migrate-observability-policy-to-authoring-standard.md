Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Migrate the observability policy to the authoring standard

Description:

`ai/policies/ai-policy-observability.md` is out of shape against the authoring standard. A read-only review found:

- The authoring validator fails it: legacy title `# AI Assistant Policy - Observability & Reliability Architect`, no one-line purpose sentence, and no `## References` section.
- Mixed normative style: `MUST monitor`, `MUST be correlated`, `must include`, and `should`.
- Naming conflict: the policy describes the "Three Pillars" while `ai-policy-coding-baseline.md` and the common policy use the "Four Golden Signals". Reconcile the terms.
- Log correlation, retention, sampling, and alerting are the policy's domain and are referenced by `ai-policy-coding-baseline.md`. Align that ownership.

Goal: retitle, add a purpose sentence and `## References`, normalize the normative style, reconcile the naming, and confirm the cross-reference with the coding policy. No behavior change.

---
2026-10-21
The coding policy now points to this policy for telemetry emission, so this policy must own the emission rules it absorbs: structured logs with named fields, trace context in every log record, correlation identifiers, bounded metric label dimensions, the high-cardinality ban, log levels, health and readiness signals, a startup record, and the missing-signal defect rule. The two code-level rules "keep telemetry out of business logic" and "never fail a request or job on export" stay in the coding policy.

Related: `ai/issues/open/validator-checks-for-banned-modals-and-tables.md`, `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.

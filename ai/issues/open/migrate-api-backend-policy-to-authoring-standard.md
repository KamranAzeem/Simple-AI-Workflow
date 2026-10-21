Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Migrate the api-backend policy to the authoring standard

Description:

`ai/policies/ai-policy-api-backend.md` is out of shape against the authoring standard. A read-only review found:

- The authoring validator fails it: legacy title `# AI Assistant Policy for API and Backend Development`, no one-line purpose sentence, and no `## References` section.
- Banned modals: `Prefer` (engineering standards and data rules) and `consider` (persistence logic).
- Bare coverage metrics: `Aim for 90%+` (unit) and `Aim for 80%+` (integration), contradicting intent-over-metrics.
- A TDD mandate that restates the rule owned by `ai-policy-common.md`.
- Idempotency, timeouts, retries, and caching now have a general owner in `ai-policy-coding-baseline.md` (`## Resilience`, `## Concurrency and Performance`). Keep the API-specific detail and reference the coding policy.
- The Observability section overlaps the coding policy's telemetry rules. Reference `ai-policy-observability.md`.

Goal: retitle, add a purpose sentence and `## References`, convert modals to definitive rules, replace coverage with intent, reference TDD, and align the resilience and observability sections with their owners. No behavior change.

Related: `ai/issues/open/validator-checks-for-banned-modals-and-tables.md`, `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.

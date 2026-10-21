Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Migrate the mobile-apps policy to the authoring standard

Description:

`ai/policies/ai-policy-mobile-apps.md` is the largest domain policy (197 lines) and the most out of shape. A read-only review found:

- The authoring validator fails it: legacy title `# AI Assistant Policy for Mobile App Development`, no one-line purpose sentence, and no `## References` section.
- Many banned modals: repeated `Prefer`, plus `when possible`, `when necessary`, and `where possible`.
- A bare coverage metric, `Aim for 90%+ coverage on business logic`.
- A TDD mandate that restates the rule owned by `ai-policy-common.md`.
- The most duplication with `ai-policy-coding-baseline.md`: retry and resilience, dependency injection, secrets and personal data, and caching. Keep the platform detail and reference the coding policy.

Goal: retitle, add a purpose sentence and `## References`, convert modals to definitive rules, replace coverage with intent, reference TDD, and split the shared concerns so the coding policy owns the general rule and this policy owns the iOS, Android, and cross-platform detail. No behavior change.

Related: `ai/issues/open/validator-checks-for-banned-modals-and-tables.md`, `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.

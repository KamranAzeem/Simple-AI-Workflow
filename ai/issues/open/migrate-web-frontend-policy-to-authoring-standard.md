Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Migrate the web-frontend policy to the authoring standard

Description:

`ai/policies/ai-policy-web-frontend.md` was written before the authoring standard and is now out of shape. A read-only review found:

- The authoring validator fails it: legacy title `# AI Assistant Policy for Web Frontend Development`, no one-line purpose sentence, and no `## References` section.
- Banned modals: `Prefer` (component and styling rules), `when appropriate`, and `should` in the interactive-states and state-persistence sections.
- A bare coverage metric, `Aim for 80%+ coverage on business logic`, which contradicts the common policy's intent-over-metrics rule.
- A TDD mandate that restates the rule owned by `ai-policy-common.md` (`Universal Testing Standards`).
- Accessibility detail is this policy's domain and should be referenced by the coding policy, not duplicated.

Goal: retitle to `# AI Policy: Web Frontend`, add a purpose sentence and `## References`, convert the modals to definitive rules with a named default, replace the coverage percentage with intent, and replace the TDD mandate with a reference. No behavior change.

Related: `ai/issues/open/validator-checks-for-banned-modals-and-tables.md`, `ai/issues/open/policies-to-skills-rename.md`, and `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.

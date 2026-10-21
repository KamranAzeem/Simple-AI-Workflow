Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Migrate the cloud policy to the authoring standard

Description:

`ai/policies/ai-policy-cloud.md` is out of shape against the authoring standard. A read-only review found:

- The authoring validator fails it: legacy title `# AI Assistant Policy for Cloud and Platform Engineering`, no one-line purpose sentence, and no `## References` section.
- Banned modals: `Prefer` (managed services), `Always consider` (cost), and the banned phrase `and similar tools` (IaC tools).
- The infrastructure-security and IaC rules are good and are referenced by `ai-policy-coding-baseline.md`. Align that ownership so the cloud policy stays the owner of the detail.

Goal: retitle, add a purpose sentence and `## References`, convert modals to definitive rules, and confirm the cross-reference with the coding policy. No behavior change.

Related: `ai/issues/open/validator-checks-for-banned-modals-and-tables.md`, `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.

---
2026-10-21
Migrated to the authoring standard. Removed the banned modals and the `and similar tools` phrase, made the cost and managed-service rules definitive, and kept the IaC and security rules. Validation: authoring PASSED, main 8/8, reference test PASS, markdownlint 0; reviews review-24 and review-25 APPROVED. Closed before the merge.

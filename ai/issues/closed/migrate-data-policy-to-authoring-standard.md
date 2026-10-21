Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Migrate the data policy to the authoring standard

Description:

`ai/policies/ai-policy-data.md` is out of shape against the authoring standard. A read-only review found:

- The authoring validator fails it: legacy title `# AI Assistant Policy for Data and AI Architecture`, no one-line purpose sentence, and no `## References` section.
- Banned modals: `Prefer` (data as code, contract-first) and other soft wording.
- The Role section has odd parenthetical spellings: `Data bricks`, `Snowflakes`, `Azure fabric`, `Synapsis`, and `Kinesis`. Review and correct them.
- Encryption, key management, and schema validation are referenced by `ai-policy-coding-baseline.md`; align that ownership.

Goal: retitle, add a purpose sentence and `## References`, convert modals to definitive rules, fix the vendor spellings, and confirm the cross-reference with the coding policy. No behavior change.

Related: `ai/issues/open/validator-checks-for-banned-modals-and-tables.md`, `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.

---
2026-10-21
Migrated to the authoring standard. Fixed the vendor names, defined PII, and split the multi-action rules. Validation: authoring PASSED, main 8/8, reference test PASS, markdownlint 0; reviews review-20 and review-21 APPROVED. Closed before the merge.

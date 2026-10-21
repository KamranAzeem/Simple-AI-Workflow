Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Migrate the DBA policy to the authoring standard

Description:

`ai/policies/ai-policy-dba.md` is otherwise well-formed but out of shape against the authoring standard. A read-only review found:

- The authoring validator fails it: legacy title `# AI Assistant Policy - Database Administration (DBA)`, no one-line purpose sentence, and no `## References` section.
- Numbered headings (`## 1.`, `## 2.`) where the standard expects domain-named headings.
- Mixed uppercase normative style (`MUST NOT`, `NEVER`) instead of the lowercase `must not` and `never`.
- The destructive-operation protocol and the SQL example block are good and should be kept.
- Encryption detail is referenced by `ai-policy-coding-baseline.md`; align that ownership.

Goal: retitle, add a purpose sentence and `## References`, rename the numbered headings, normalize the normative style, and keep the destructive-operation protocol. No behavior change.

Related: `ai/issues/open/validator-checks-for-banned-modals-and-tables.md`, `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.

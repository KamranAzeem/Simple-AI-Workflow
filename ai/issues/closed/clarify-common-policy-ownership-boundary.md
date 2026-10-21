Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P4)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Clarify the common policy ownership boundary with the coding policy

Description:

The common policy is the always-on baseline. Its role is now split with `ai-policy-coding-baseline.md`:

- The common policy owns the principles: SOLID, DRY, YAGNI, Twelve-Factor, TDD, secure development, and generated file validation.
- The coding policy owns the operational rules for code construction.

A read-only review found:

- The split is not explicit in either file. The common policy should state that code-construction operations live in the coding policy, and the coding policy should state that the principles live in the common policy.
- The domain policies still repeat the TDD mandate and hardcode coverage metrics. Decide whether they reference the common policy instead.
- The common policy's `Generated File Validation` list covers non-code files; the coding policy covers code tools. Confirm that boundary.

Goal: add explicit cross-references, keep the common policy the always-on baseline, and do not move its rules. No behavior change.

Related: `ai/issues/open/tier2-vs-non-negotiables-consolidation.md`, `ai/shared/project-knowledge/coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`.

---
2026-10-21
Added the `## Scope` and `## References` sections to the common policy and the ownership pointers in both common and coding-baseline. The domain migrations reference common for TDD and express coverage by intent. Validation: authoring PASSED, main 8/8, reference test PASS, markdownlint 0; reviews review-14 and review-15 APPROVED. Closed before the merge.

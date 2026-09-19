Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: S
URL:
Summary: Add an agent-facing documentation dimension to the peer-review policy

Description:

Decision (2026-09-19): fold agent-document review into the peer-review policy as one extra review dimension, instead of adding a separate procedure and policy. A dedicated procedure is deferred unless the dimension proves too narrow in practice.

What it checks: six aspects of any document an AI consumes (`AGENTS.md`, policy files, handoff templates, skill files): hierarchy, completion criteria, leading words, negation, sediment, and sprawl. Each finding is reported with a before/after suggestion.

Use case: review a policy file or an `AGENTS.md` section for agent readability before merge, to catch drift, bloat, and steps with no checkable completion condition. It complements the existing Documentation dimension, which targets human-facing docs.

Implemented in `ai/policies/ai-policy-code-review.md`, dimension 6, with one example per check.

Origin: the mattpocock/skills writing-for-agents analysis in `ai/shared/project-knowledge/mattpocock-skills-codebase-analysis-2026-08-27.md`.

Acceptance criteria:
- The peer-review policy lists the dimension with the six checks and one example each.
- The dimension is scoped to agent-facing documents, so source-code reviews are unaffected.
- Validator stays green; markdownlint clean.

---
2026-09-19
Folded into the peer-review policy instead of a standalone procedure; implemented dimension 6 with examples. Pending commit and merge.

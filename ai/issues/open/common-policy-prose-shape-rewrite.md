Reported: 2026-11-17
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: L
Label:
URL:
Summary: Rewrite the common policy to the authoring standard's prose shape without losing a rule

Description:

- The common policy passes the structural authoring validator but does not meet `### Policy Structure`, `### Rule Structure`, or `### Normative Language` in `ai-policy-meta.md`.
- The exact audit is the 2026-11-17 entry in `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`.
- Summary: 90 rules carry more than one sentence or action, 16 rule bullets carry rationale, 6 lines use a banned normative word, and 8 sections use prose rule content.
- This unit rewrites `ai-policy-common.md` only. It does not change behavior, move a rule to another policy, or touch the canonical state-file header literal.
- It moves rationale to design documents or decision records, splits multi-sentence rules, replaces banned modal words, and turns prose rule content into flat bullets.
- It keeps the guard, READ-ONLY markers, title, purpose sentence, `## Scope`, `## References`, and READ-ONLY END.
- It records a rule-coverage matrix for every current rule, in the legacy-rewrite style.
- It adds a shape fixture or a review checklist so the prose shape cannot regress silently.
- It runs after the plugin-extraction program merges, on a branch cut from master.
- It has its own release note.

## Acceptance Criteria

- Every rule is one sentence in one flat bullet, with no rationale.
- No banned modal or vague word remains in normative text.
- No prose rule block remains. Examples are non-normative fenced blocks.
- The rule-coverage matrix accounts for every current rule. No rule is lost or weakened.
- The canonical state-file header literal is byte-identical.
- The validators, markdownlint, the full suite, and peer review pass.
- The boot payload size is reported.
- The shape fixture or review checklist fails on the old shape.

## Open Decisions

- Whether to split the rewrite into section-level child tickets.
- The release that carries it.

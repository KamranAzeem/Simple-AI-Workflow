Reported: 2026-10-18
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Add an ADR and one authoring standard for procedures and policies

Description:

## Problem

Writing a procedure or policy through the AI needs repeated ad hoc instructions. The rules are spread across `ai-customization.md`, the common policy, and habit, so each new file can take a different shape.

## Required rules

- Short, direct instructions in a few bullets or numbered steps.
- State the "what", not the "why". Rationale belongs in design docs or knowledge.
- Minimal prose. Simple, plain English.
- No tables and no em dashes in protocol files.
- Stable all-caps names for procedures, steps, and tiers.
- Verbose, unambiguous procedure names and trigger phrases that JIT indexing can match.
- A predictable heading shape, so the AI can find triggers and the right policy without reading the whole file.

## Resolved decisions

- Home: `ai-policy-meta.md` under `## Procedure and Policy Authoring`.
- Scope: `AGENTS.md` and `ai/policies/*`.
- The common policy remains authoritative for markdown mechanics and writing style.
- New and touched files follow the standard; no bulk rewrite.
- Procedures keep the existing header and `**Aliases**` line, have no `**Loads**` line, and use at most three aliases for a new or touched procedure.
- The `## Triggers` heading is reserved for the plugin model.
- Enforcement is peer review plus a new structure validator; banned-modal and table checks are a separate ticket.
- The meta policy rewrite corrects the stale state-file update rule and the automatic backup rule.

## Acceptance criteria

- One ADR records the authoring decision and is self-contained.
- One authoritative standard exists; other rule homes point to it and do not repeat its text.
- The standard defines the required heading and trigger shape.
- The next new procedure or policy follows it.
- Validator and markdownlint stay green.

## Notes

- Related: `policies-to-skills-rename.md` (naming), `tier2-vs-non-negotiables-consolidation.md` (single source of truth).
- Existing rule homes: `ai-customization.md` (`## Development Workflow`), `ai-policy-common.md` (`## Markdown Output`, `## Humanized Output`, `## Communication Standards`), and `design-docs/protocol-decisions.md`.

---

2026-10-18
Plan: `ai/plans/procedure-and-policy-authoring-standard-plan.md`. Branch: `feature/procedure-and-policy-authoring-standard`. Work started.

---

2026-10-18
Closed as part of the branch closure. Implemented the standard in `ai/policies/ai-policy-meta.md`, added `support-files/validate-policy-authoring.sh`, added the ADR entry, and replaced the customization rule with the approved pointer. Verification: markdownlint 0, authoring validator PASSED, main validator 8/8, reference test PASS. Peer review review-04 APPROVED. The squash merge includes this ticket.

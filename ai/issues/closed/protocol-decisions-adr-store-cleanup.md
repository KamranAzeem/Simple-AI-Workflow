Reported: 2026-10-12
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Clean the protocol ADR store so it holds design decisions only
Label:

Description:

`ai/shared/project-knowledge/protocol-decisions.md` is a per-session logbook. Rework it to hold genuine design decisions only.

Requirements:

- Keep entries that are genuine design decisions; each states the decision, its context, and its consequences.
- Remove session bookkeeping (status, merge record, what was implemented, review counts, validator results). That content belongs in the daily checkpoints.
- When the design-docs location change lands, the ADR store moves to the protocol repo's own `design-docs/`.
- Direct what-only rules; no markdown tables.

Acceptance criteria:

- The ADR store holds only design decisions, in the decision/context/consequences shape.
- Session records live in the daily checkpoints, not duplicated in the store.
- Validator green; markdownlint 0.

---
2026-10-12
Plan: `ai/plans/protocol-decisions-cleanup-plan.md`. Relocation is done; this is the content pass.

---
2026-10-12
Closed on branch `feature/adr-store-cleanup`. Reduced `design-docs/protocol-decisions.md` from 1763 lines and 73 dated entries to a decisions-only record (469 lines); no bookkeeping, em dashes, or tables remain. Verified: markdownlint 0, validator v6.0 8/8, reference test PASS. Peer review review-27 APPROVED.

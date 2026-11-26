Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: P3
Size: M
URL:
Summary: Consolidate the TIER READ-FIRST-RULES and Non-Negotiables always-on rule homes into one source of truth

Description:

Two places claim to hold always-on rules: the TIER READ-FIRST-RULES MANDATORY ACTIONS in `AGENTS.md` and the Non-Negotiables list at the top of `ai-policy-common.md`. Both are always loaded, and several rules appear in both (evidence-based investigation, full file reads). This creates two sources of truth and a drift risk.

Decide and execute one canonical home:

- Option A: keep TIER READ-FIRST-RULES canonical and reduce the common-policy Non-Negotiables to a pointer.
- Option B: move always-on mechanics into the always-loaded common policy and keep `AGENTS.md` thin and structural.
- Option C: keep both with a strict division, for example TIER READ-FIRST-RULES holds only rules needed before policy files load.

Constraints:

- Apply the 2026-08-31 routing principle (AGENTS.md is a router, not a catalog).
- Historical records stay byte-identical.

Acceptance criteria:

- One canonical home per always-on mechanic; no rule duplicated in both places.
- `AGENTS.md` and the common policy both stay lean.
- Validator anchors updated as needed and green.

Background: `ai/knowledge/protocol-routing-principle.md`.

---

2026-11-26
The project knowledge audit reconfirmed this gap: the caveat in `ai/knowledge/protocol-routing-principle.md` still records that the two always-on layers lack consolidation. No duplicate ticket was filed; the stale background pointer above is corrected.

---
2026-11-26
Closed as obsolete. The 2026-08-31 ADRs (`design-docs/protocol-decisions.md:587-593`) chose the two-layer division, and the Level 0 precedence (`AGENTS.md:139`) confirms it. The residual index drift is tracked in `ai/issues/open/non-negotiables-index-enforcement.md`. The earlier "reconfirmed this gap" note relied on a stale caveat; the new ticket corrects the caveat and the record.

---

2026-11-19
The `policies-to-skills` rename is closed; no sequencing dependency remains.

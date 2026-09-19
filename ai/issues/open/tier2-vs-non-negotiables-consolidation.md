Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: P3
Size: M
URL:
Summary: Consolidate the TIER 2 and Non-Negotiables always-on rule homes into one source of truth

Description:

Two places claim to hold always-on rules: the TIER 2 MANDATORY ACTIONS in `AGENTS.md` and the Non-Negotiables list at the top of `ai-policy-common.md`. Both are always loaded, and several rules appear in both (evidence-based investigation, full file reads). This creates two sources of truth and a drift risk.

Decide and execute one canonical home:
- Option A: keep TIER 2 canonical and reduce the common-policy Non-Negotiables to a pointer.
- Option B: move always-on mechanics into the always-loaded common policy and keep `AGENTS.md` thin and structural.
- Option C: keep both with a strict division, for example TIER 2 holds only rules needed before policy files load.

Constraints:
- Apply the 2026-08-31 routing principle (AGENTS.md is a router, not a catalog).
- This affects the policies-to-skills rename ticket, so sequence the two together.
- Historical records stay byte-identical.

Acceptance criteria:
- One canonical home per always-on mechanic; no rule duplicated in both places.
- `AGENTS.md` and the common policy both stay lean.
- Validator anchors updated as needed and green.

Background: `ai/shared/project-knowledge/protocol-routing-principle-and-consolidation-follow-up.md`.

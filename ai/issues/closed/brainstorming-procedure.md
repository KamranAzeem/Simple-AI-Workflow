Reported: 2026-09-19
Reporter: Kamran Azeem
IssueType: Feature
Severity: P3
Size: M
URL:
Summary: Add an on-demand Brainstorming procedure and policy

Description:

Brainstorming is the generative complement to grilling (`grilling-procedure.md`). Grilling converges; brainstorming diverges. Brainstorming widens the option space before a design exists.

Shape (revised 2026-10-12; supersedes the earlier on-demand-policy proposal):

- Put the rules in the common policy (`ai/policies/ai-policy-common.md`), not a separate policy file.
- Role: generative partner. No criticism during divergence; capture every idea; no premature convergence.
- Method: diverge on the problem and options; cluster related ideas; hand the shortlist to grilling or a design doc.
- Output: a grouped list of ideas plus a short recommended shortlist, saved to a note or a design doc.
- Write the rules as direct what-only statements, concise, no why prose.
- Open decision: whether to add a trigger in `AGENTS.md` (none, a trigger only, or a full procedure). Resolve during the pre-work analysis.

Relationship to the Pre-Work Gate: brainstorming covers the earlier divergent phase; grilling covers the convergent shared-understanding phase.

Acceptance criteria:

- The common policy carries a Brainstorming section with the role, divergence rules, and output as direct what-only rules.
- The trigger decision is resolved and reflected (in `AGENTS.md` or the policy alone).
- Validator green; docs updated.

---
2026-10-12
Plan: `ai/plans/brainstorming-policy-plan.md`. Pre-work decision: same as grilling, brainstorming lives in the common policy with a trigger phrase; no AGENTS.md procedure.

---
2026-10-12
Closed on branch `feature/brainstorming-policy`. Added the `## Brainstorming` section to the common policy next to Grilling. Verified: markdownlint 0, validator v6.0 8/8, reference test PASS. Peer review review-19 APPROVED. ADR recorded in `protocol-decisions.md`.

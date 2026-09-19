Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: M
URL:
Summary: Add an on-demand Brainstorming procedure and policy

Description:

Brainstorming is the generative complement to grilling (tracked separately in `grilling-procedure.md`). They are two distinct modes:
- Grilling converges: the AI interviews the user, challenges assumptions, and drives decisions to closure.
- Brainstorming diverges: both sides generate options freely and defer judgment, to widen the option space before a design exists.

Proposed shape, mirroring the on-demand procedure pattern (dedicated policy loaded by a trigger phrase, zero always-loaded bloat):
- Trigger: "brainstorm this" or "let's brainstorm [topic]".
- Role: generative partner. No criticism during divergence, capture every idea, no premature convergence.
- Method: diverge on the problem and options, cluster related ideas, then hand the shortlist to grilling or a design doc.
- Output: a grouped list of ideas plus a short recommended shortlist, saved to a note or a design doc.
- Policy size: small, comparable to the grilling policy (about 50 lines).

Relationship to the Pre-Work Gate: brainstorming covers the earlier divergent phase; grilling covers the convergent shared-understanding phase.

Acceptance criteria:
- A new procedure is registered in AGENTS.md with a trigger phrase.
- A new on-demand policy defines role, divergence rules, and output.
- Validator stays green; docs updated.

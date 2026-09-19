Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: M
URL:
Summary: Add an on-demand Grilling procedure and policy to stress-test a design before work begins

Description:

Grilling is the convergent mode in a two-mode pair. Grilling is adversarial: the AI interviews the user, challenges every assumption, and proposes a recommended answer per question so the user reacts instead of inventing. Brainstorming is the divergent counterpart, tracked separately in `brainstorming-procedure.md`. Both are kept. Grilling serves the Pre-Work Gate's shared-understanding clause, which needs convergence on decisions.

Proposed shape:
- Trigger: "grill me on this" or "grill this [plan/design/idea]".
- Pattern: same as code review (Procedure D) and codebase examination (Procedure G): a dedicated on-demand policy loaded by a trigger phrase, zero always-loaded bloat.
- Method: map the idea as a design tree, work in rounds, ask all pending branches, process answers, find new branches, repeat until none remain. End with a one-paragraph gist that can feed a design doc or a next-steps entry.
- Role: interviewer, not a yes-man. Propose a recommended answer for each question before asking.
- Policy size: about 50 lines.

Origin: the mattpocock/skills analysis in `ai/shared/project-knowledge/mattpocock-skills-codebase-analysis-2026-08-27.md`. The original `ai/notes/grilling-procedure-design-note.md` was captured into this ticket and removed.

Acceptance criteria:
- A new procedure is registered in AGENTS.md with a trigger phrase.
- A new on-demand policy defines role, method, rounds, and output.
- Validator stays green; docs updated.

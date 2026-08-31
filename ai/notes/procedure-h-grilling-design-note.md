# Procedure H: Grilling (design note)

> Split from `ai/notes/notes.md` (mattpocock repo analysis, 2026-08-27) on 2026-08-31 for independent work.

Examined three repos: `mattpocock/skills`, `mattpocock/dictionary-of-ai-coding`, `mattpocock/sandcastle`. Full analysis saved to project knowledge (three files dated 2026-08-27). The recommendation below is the design output — save here and revisit in a day or two.

**Core idea**: add two new on-demand procedures, following the exact same pattern as Procedure D (code review) and Procedure G (codebase examination): a dedicated `ai-policy-*.md` loaded on demand via a trigger phrase in a new AGENTS.md Procedure. AI adopts a specific role, does the work, exits the role. Zero always-loaded bloat.

## Proposed Procedure H: Grilling

Trigger: user says "grill me on this" or "grill this [plan/design/idea]"

From the `mattpocock/skills` grilling skill. The AI becomes a relentless interviewer to stress-test an idea, plan, or design before work begins. Maps decisions as a **design tree** — every decision branches into the decisions that hang off it. Works in **rounds**: ask all pending branches, process answers, find new branches, repeat until no unexplored branches remain. Ends with a one-paragraph gist that can feed a design doc or next-steps entry.

Role: the AI is an interviewer, not a yes-man. Pushes on every assumption. Proposes a recommended answer for each question before asking, so the user can react rather than invent.

This gives the Pre-Work Gate's "shared understanding" clause an actual, replicable process.

No external tools needed. Policy size: ~50 lines.

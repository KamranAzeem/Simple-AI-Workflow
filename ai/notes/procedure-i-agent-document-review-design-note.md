# Procedure I: Agent Document Review (design note)

> Split from `ai/notes/notes.md` (mattpocock repo analysis, 2026-08-27) on 2026-08-31 for independent work.

Examined three repos: `mattpocock/skills`, `mattpocock/dictionary-of-ai-coding`, `mattpocock/sandcastle`. Full analysis saved to project knowledge (three files dated 2026-08-27). The recommendation below is the design output — save here and revisit in a day or two.

**Core idea**: add two new on-demand procedures, following the exact same pattern as Procedure D (code review) and Procedure G (codebase examination): a dedicated `ai-policy-*.md` loaded on demand via a trigger phrase in a new AGENTS.md Procedure. AI adopts a specific role, does the work, exits the role. Zero always-loaded bloat.

## Proposed Procedure I: Agent Document Review

Trigger: user says "review this document for agents" or "agent document review"

From the `mattpocock/skills` `writing-for-agents` skill. The AI audits an agent-consumed document (AGENTS.md sections, policy files, handoff templates, skill files) against a quality bar:

- **Information hierarchy**: in-file steps → in-file reference → disclosed reference. Content that applies to every branch is inline; content that applies to only some branches is behind a context pointer.
- **Completion criteria**: every step ends on a condition the agent can check. Vague bounds ("understanding reached") are flagged.
- **Leading words**: compact pretrained concepts that anchor behavior cheaply. Opportunities to collapse a three-word phrase into a single token are surfaced.
- **Negation patterns**: "don't do X" makes X more available. All prohibitions that can be rephrased as a positive are flagged.
- **Sediment**: stale or no-longer-relevant lines. No-ops (instructions the model already follows by default). Duplication.
- **Sprawl**: document too long even when every line is live. Disclose more; split by branch.

Output: report in the same format as code review (findings by severity, verdict).

This is the "verify AI work" use case — can be run on any protocol doc to catch drift and bloat before it accumulates.

No external tools needed. Policy size: ~60 lines.

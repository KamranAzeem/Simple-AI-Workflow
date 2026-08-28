## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it.
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---

## Pending

### Kilo Code documentation
Document Kilo Code support in the post-compaction reload trigger setup guide and the compaction-trigger-problem note.
- Add a Kilo Code row to the per-assistant table in `docs/post-compaction-reload-trigger-setup.md` and a short section below the Copilot hooks section.
- Add a Kilo Code answer block to `ai/notes/compaction-trigger-problem.md`.
- Key facts: AGENTS.md is always-on as system instructions in Kilo Code (survives compaction by architecture, no trigger file needed); compaction summary is visible in chat; human backstop ("Run Post-Compaction Recovery") is sufficient.
- No workflow slash command; no new files.

### Design docs for the protocol itself
The protocol is quite developed now, but the HLD, LLD, PRD, DECISIONS.md, delivery ledger, etc are still not created. Analyze the protocol and create the necessary documents under `docs/`, but do not push them to the repo at the moment. Analyze and polish them first. (Tracked in next-steps.md: drafts in `ai/notes/` — vision/PRD/HLD; formalize protocol-decisions.md entries into ADR format; create delivery ledger.)

### Multi-assistant workflow + build AI team (design)
- **Status: pending.** Combined design saved to `ai/notes/multi-assistant-workflow-design.md`.
- Source: `feature/multi-assistant-workflow` branch (design doc) + the AI-team runtime/role model from `ai/shared/project-knowledge/multi-agent-state-ownership-and-checkpoint-model.md` (watch-spawned roles, dispatcher/watcher, per-agent status files for Scenario B).
- Before resuming: reconcile the draft's older paths (`ai/progress.md`, `ai/tasks/`, `.ai-lock`) and advisory-lock model against the current protocol (state files in `ai/state/`, single-writer ownership, `ai/shared/coordination.md`), so it does not introduce a second, competing multi-agent design. Keep the AI-team runtime as a separate project on top of the contract.

### Refactoring / codebase-upgrade policy (considering)
- **Status: pending.** Research note saved to `ai/notes/refactoring-and-upgrading-best-practices-2026-08-25.md`.
- Considering a policy for when the user asks to refactor or upgrade a codebase. Key distinction: refactoring (internal quality, no behavior change) vs upgrading (language/platform/dependency bump). Golden rule from the research: never do both at once — upgrade first until tests pass, then refactor. Also: establish a test baseline before refactoring, and clarify goal (bugs / features / security) before choosing refactor vs upgrade vs rewrite.


---

I want to improve the readability of this protocol by using proper procedure names (kebab-style) instead of procedure A, B .., X,Y,Z

---

the ubiquous language thing (point 11 from our previous discussion that we abandonded), can it be implemented as an on-demand policy. Those who want to use it can enable it, and the AI starts using it, and those who cannot be bothered, can just leave it out? 

---

mattpocock/skills - AI Engineer

https://github.com/mattpocock/skills.git

---

### New procedures from mattpocock repo analysis (2026-08-27)

Examined three repos: `mattpocock/skills`, `mattpocock/dictionary-of-ai-coding`, `mattpocock/sandcastle`. Full analysis saved to project knowledge (three files dated 2026-08-27). The recommendation below is the design output — save here and revisit in a day or two.

**Core idea**: add two new on-demand procedures, following the exact same pattern as Procedure D (code review) and Procedure G (codebase examination): a dedicated `ai-policy-*.md` loaded on demand via a trigger phrase in a new AGENTS.md Procedure. AI adopts a specific role, does the work, exits the role. Zero always-loaded bloat.

#### Proposed Procedure H: Grilling

Trigger: user says "grill me on this" or "grill this [plan/design/idea]"

From the `mattpocock/skills` grilling skill. The AI becomes a relentless interviewer to stress-test an idea, plan, or design before work begins. Maps decisions as a **design tree** — every decision branches into the decisions that hang off it. Works in **rounds**: ask all pending branches, process answers, find new branches, repeat until no unexplored branches remain. Ends with a one-paragraph gist that can feed a design doc or next-steps entry.

Role: the AI is an interviewer, not a yes-man. Pushes on every assumption. Proposes a recommended answer for each question before asking, so the user can react rather than invent.

This gives the Pre-Work Gate's "shared understanding" clause an actual, replicable process.

No external tools needed. Policy size: ~50 lines.

#### Proposed Procedure I: Agent Document Review

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

#### What to skip / defer

- **Wayfinding** (large fog-of-war planning) — compelling but needs an issue tracker. Simplified file-based version duplicates what next-steps.md + plans/ already provides. Defer.
- **Sandcastle parallel-planner** — the concrete implementation of the deferred multi-agent work. Needs Docker + Node.js. Already in next-steps.md (deferred). Revisit when that work resumes; the three project-knowledge files explain how it works.
- **Dictionary vocabulary** — use the concepts where they sharpen documentation (smart zone, compaction, progressive disclosure, secondary source, vibe coding) but no new policy needed.

#### Small README note (no protocol change)

One sentence explaining *why* AGENTS.md is kept short — anything that applies to every session is inline; everything else is behind a context pointer. Points to the dictionary's "progressive disclosure" entry for background. No additions to AGENTS.md itself.
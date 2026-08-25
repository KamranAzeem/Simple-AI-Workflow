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

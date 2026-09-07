# Local-First Knowledge Retrieval — proposal (discussion)

Discussed 2026-09-07. Status: idea, not yet a change or a plan. Captured here so it isn't lost.

## Idea
Have the AI always search the local knowledge base (Project Knowledge + Global Knowledge) and other local sources of truth first (project files, live environment, cloned repos), and only go out to the model's own knowledge / web / official docs **after** local sources are exhausted. Could be surfaced in the protocol as a source-precedence rule.

## Where the protocol already does this
- Project Knowledge is already a retrievable corpus: indexed (filename-only) at boot, loaded on demand; verbose filenames are the JIT lookup key.
- Global Knowledge is loaded in full at boot.
- The Investigation Contract (`ai-policy-common.md:23`) lists allowed sources but **does not order them** — this is the real gap.

## Decisions / open points
- **Terminology**: not "RAG." No embedding store / vector DB / chunking is intended. Prefer "local-first knowledge retrieval" or "JIT knowledge index." Calling it RAG misleads (infra it doesn't use) and misses the point.
- **Source precedence**: the valuable change is adding an explicit local-first ordering to the Investigation Contract / Evidence-Based Investigation (1–2 sentence addition).
- **Staleness at boot vs JIT**: a real staleness check that reads files at boot defeats the JIT/token-saving goal. Use heuristic staleness at boot (filename/domain match + existing bloat/order check); confirm deep staleness only when a file is loaded for a task.
- **Bound the local probe**: "local first" must be bounded (index → open likely candidates → escalate), or it becomes a new token sink.

## Proposed next steps
- Draft the one-paragraph Investigation Contract addition (local-first precedence).
- Optionally add a bounded boot-time staleness note.
- Record the decision in `ai/shared/project-knowledge/protocol-decisions.md` once approved.

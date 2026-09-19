# Local-First Knowledge Retrieval — proposal (discussion)

Discussed 2026-09-07. Status: the source-precedence part shipped on 2026-09-19 (Investigation Contract, `ai/policies/ai-policy-common.md`); the bounded staleness heuristic remains open and is tracked as deferred in `ai/state/next-steps.md`. Captured here so the open part isn't lost.

## Idea
Have the AI always search the local knowledge base (Project Knowledge + Global Knowledge) and other local sources of truth first (project files, live environment, cloned repos), and only go out to the model's own knowledge / web / official docs **after** local sources are exhausted.

## Where the protocol already does this
- Project Knowledge is already a retrievable corpus: indexed (filename-only) at boot, loaded on demand; verbose filenames are the JIT lookup key.
- Global Knowledge is loaded in full at boot.
- The Investigation Contract used to list allowed sources without ordering them. That gap is now closed by the local-first source-precedence paragraph added on 2026-09-19.

## Decisions
- **Terminology**: not "RAG." No embedding store / vector DB / chunking is intended. Prefer "local-first knowledge retrieval" or "JIT knowledge index."
- **Source precedence**: shipped 2026-09-19 as a short paragraph in the Investigation Contract, with a bounded probe (index, then open likely candidates, then escalate).
- **Staleness at boot vs JIT**: open. A real staleness check that reads files at boot defeats the JIT/token-saving goal. Prefer heuristic staleness at boot (filename/domain match plus the existing bloat/order check), and confirm deep staleness only when a file is loaded for a task.
- **Bound the local probe**: closed by the shipped wording.

## Remaining open item
- The bounded boot-time staleness heuristic. Tracked as deferred in `ai/state/next-steps.md`.

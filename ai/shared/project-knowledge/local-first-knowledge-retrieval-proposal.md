> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Local-First Knowledge Retrieval

## Context

The workflow prefers local sources before the model's own recall, the web, or official docs. Project Knowledge is indexed by filename at boot and loaded on demand. Global Knowledge follows the same model. The source-precedence rule is part of this lesson.

## Rule or Fix

- Search the project files, Project Knowledge, Global Knowledge, the live environment, and cloned repositories first.
- Use a bounded probe: read the index, open the likely candidates, then escalate.
- Use filename and domain matching, not embeddings, vector stores, or chunking.
- Load a knowledge file in full only when a task needs it.
- Keep the file together with a descriptive name for its dominant domain.

## Why

- Local sources reflect the project and the live environment.
- A bounded probe avoids a token sink.
- Filename indexing keeps boot context small.
- Project Knowledge takes precedence over Global Knowledge.

## Verify

- Confirm the AI reads the local index before searching the web.
- Confirm the AI opens the likely local files before escalating.
- Confirm no vector database or embedding index is in use.
- Confirm a task loads only the knowledge files it needs.

## Caveats

- The boot-time flag is metadata-only; verify a candidate against current state when a task loads it.
- A vague filename is invisible to the index.

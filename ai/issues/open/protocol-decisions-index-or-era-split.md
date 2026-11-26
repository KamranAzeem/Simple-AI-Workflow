Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: The 184 KB protocol decision store has no index or era split and is full-loaded before every protocol change.

Description:

- `design-docs/protocol-decisions.md` is 1,600 lines and 184,582 bytes with 260 dated entries.
- There is no table of contents, index, or era split.
- `ai-policy-meta.md:42` requires a full load before any protocol change, so every protocol edit pays roughly 46K tokens to read the store.
- The store is append-only and internally consistent, with no duplicate dated headings.
- This is an observation and a design decision, not a defect.

Resolution options:

- Add a table of contents of dated entries at the top.
- Split by year or era into linked files, preserving the append-only history.
- Keep one file and accept the load cost.

Acceptance criteria:

- The chosen structure keeps every decision reachable and the append-only rule intact.
- A maintainer can find a decision without reading the whole store.

---
2026-11-26
Filed from the 2026-11-26 codebase examination. Evidence group O1. No secret or identifying name present.

---
2026-11-26
Plan: `ai/plans/protocol-decisions-index.md` (M). Decision: in-file checked index, no generator, no era split, PATCH v7.11.1 for the meta-policy line. Peer review pending; no branch yet.

Reported: 2026-10-06
Reporter: Kamran Azeem (via Kilo)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Move Global Knowledge from full-load-at-boot to the same JIT filename indexing already used for Project Knowledge, across boot, context reload, and Post-Compaction Recovery, without breaking the validator.

Description:

## Problem

`~/.ai/global-knowledge/` is fully loaded into the context window at every session start, and again on every context reload and Post-Compaction Recovery. It was designed as "intentionally small", but the set is growing. A full load of a growing set wastes context memory and tokens on every boot.

Project Knowledge already solves this with JIT filename indexing: index at boot, read a file in full only when a task needs it. Global Knowledge should use the same model.

## Request

Apply the Project Knowledge JIT indexing model to Global Knowledge, everywhere Global Knowledge is read:

- Boot (Procedure A).
- Context reload after checkpoint (Procedure C, Context Re-affirmation).
- Post-Compaction Recovery (Procedure E).

Index Global Knowledge and Project Knowledge in the same step, report them as separate lines in the Proof-of-Load report, and (for consistency) extend the same bounded staleness check (metadata-only, 90 days) to Global Knowledge.

## Prior-decision context (this reverses a documented decision)

This change reverses a decision recorded in `protocol-decisions.md`, so it needs a dated ADR entry there.

- 2026-06-18-03: JIT indexing was first extended to Global Knowledge (Step 5 covered both directories).
- 2026-06-30-01: reversed to full-load for Global Knowledge and active policies, re-scoping Token Rationing to Project Knowledge only. Rationale: "an AI cannot map a task to a policy or lesson by name alone", and Global Knowledge was deemed intentionally small, so a full load was cheap.
- 2026-08-09-01: the writing-style guide was deliberately kept in Global Knowledge at ~40 lines precisely because Global Knowledge is fully loaded at every boot, so the AI sees the style rules before writing.

The 2026-06-30 rationale rested on "too small to matter". The set is now growing, so that premise no longer holds. The policy portion of the 2026-06-30 decision (policies stay full-load) is correct and should NOT change: policies are operational rules, not on-demand lessons.

## Exact locations that read Global Knowledge

`AGENTS.md`:
- Procedure A Step 4 note: "Global Knowledge files ... are NOT loaded here — they are loaded in full in Step 5."
- Procedure A Step 5 "Knowledge Loading": the Global Knowledge full-text bullet.
- Procedure A Step 7 bullet (b): "Global Knowledge files fully loaded ... line counts".
- Procedure A Step 7 bullet (e): Project Knowledge index; add Global Knowledge indexed (separately shown).
- Procedure C "Context Re-affirmation After Checkpoint": "all files in the Global AI Knowledge Directory" full text.
- Procedure E Step 4: "Every file in the Global AI Knowledge Directory (full text)".
- Procedure E Step 6 and the closing confirmation line: shared-directory index plus the "knowledge files loaded" count wording.

`ai/policies/ai-policy-common.md`:
- A2A Coordination Proof-of-Load: "loaded Global Knowledge files".
- Global Knowledge Protocol: the "Full Load" bullet.
- Source-of-Truth Order note: the "loaded during bootstrap" wording.
- Bounded staleness: currently Project Knowledge only.

`support-files/validate-protocol.sh`:
- Must keep (or update in lockstep, with a version bump) the `Knowledge Loading`, `Global AI Knowledge Directory`, and `Token Rationing` anchors.

Docs:
- `docs/workflow-guide.md` sections 2, 7, and 13 (including the section 13 heading and the "Global Knowledge — full load" step).
- `docs/simple-ai-workflow-slides.md` (session resume, token rationing shield, Proof-of-Load, and Global Knowledge slides).

## Open questions to decide before implementing

1. **Filename-key risk.** JIT works only if the filename states the domain (the filename is the lookup key). The current `engineering-lessons-and-conventions.md` bundles unrelated topics (Azure CLI, naming conventions, writing style, shell scripting), so its domain cannot be inferred from its name. A task like "write an email" or "run an az deploy" would not match it and would miss its lessons. Either split it into per-domain, descriptively named files, or accept the miss risk. This is the exact failure mode the 2026-06-30 decision used to justify full-load.
2. **Step name.** Procedure A Step 5 is already one step covering both Global and Project Knowledge, so "one step instead of two" is already true at boot. Renaming "Knowledge Loading" back to "Knowledge Indexing" is optional and needs a matching validator bump.
3. **Staleness heuristic.** Extend the 90-day metadata-only staleness flag to Global Knowledge? Recommended for consistency; otherwise Global Knowledge is the only indexed set with no freshness signal.
4. **Policies unchanged.** Active policies stay full-load (operational rules). Confirm this stays out of scope.

---

2026-10-06
Filed by Kilo after a read-only protocol investigation (Protocol Developer Mode; `protocol-decisions.md` loaded in full). No protocol files changed. Awaiting a decision on the open questions before implementation on a feature branch.

---

2026-10-06
Implemented on branch `feature/global-knowledge-jit-indexing`. Decisions taken: JIT-index Global Knowledge (all three read points); index Global and Project Knowledge in one step and list them as separate sets in the Proof-of-Load; extend the 90-day bounded staleness flag to Global Knowledge; add per-domain naming/split guidance so the filename lookup key works. Active policies and Global Settings stay full-load. Reverses the Global Knowledge portion of the 2026-06-30 decision; ADR recorded in `protocol-decisions.md`. Validator 8/8, markdownlint 0, no validator anchor change. Peer review review-03 CHANGES REQUESTED, review-04 APPROVED. Closed by the squash merge into `master`.

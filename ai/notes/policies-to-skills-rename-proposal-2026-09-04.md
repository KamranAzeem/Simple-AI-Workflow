# Policies → Skills rename proposal (2026-09-04)

Status: **proposed, under consideration. Not started.** This is the analysis /
groundwork for the future change-request + HLD. The original request is captured
verbatim in `ai/notes/notes.md`.

## Motivation
- "Active Expertise" lists "policies" — a taxonomy mismatch.
- "skills" is the industry-standard term (matches the third-party `SKILL.md`
  drop-in convention).
- Files become `dba.md`, `cloud.md`, etc. — the `ai-policy-` prefix is dropped.
- Heading `## Active Expertise` → `## Active Skills`.

## Proposed change surface
- `ai/policies/` → `ai/skills/` **(Project AI Policies Directory; also the Global
  AI Policies Directory, since this repo is the workflow / distribution tree)**.
- `ai-policy-<name>.md` → `<name>.md` (16 files).
- `AGENTS.md`: TIER 1 directory names; TIER 2 mandates; Procedure A Step 6,
  Procedure C Step 4, Procedure E Step 5 loader fallback (`ai-policy-<name>.md`
  then `<name>.md` → `<name>.md`); the 4 Protocol Developer Mode Exception notes.
- `ai-customization.md`: `## Active Skills`.
- `support-files/validate-protocol.sh`: anchors + a new guard against the
  `ai-policy-` prefix.
- sync scripts `support-files/sync-agents-md.sh` + `.ps1`.
- User-facing docs (README, workflow-guide, customization guide, slides, guides).

## Blast radius (measured 2026-09-04)
- 16 policy files on disk; **30 files** reference the `ai-policy-` prefix.
- "Active Expertise" in ~13 active files; "Policies Directory" in 7 files.
- `ai-policy-common` referenced in 21+ files.

## Scoping: freeze historical records (do NOT rewrite)
- `protocol-decisions.md`, `context-archive.md`, `ai/daily-checkpoints/*` are the
  audit/decision record and must remain **byte-identical** — do not edit them.

## Taxonomy nuance (decide before HLD)
- `common.md` / `meta.md` are core guardrails (Non-Negotiables), not really
  "skills". Options: (a) uniform skills dir including common/meta (simplest);
  (b) split core (`ai/core/`) vs domain (`ai/skills/`); (c) uniform + document
  the core role. This overlaps the open **TIER 2 vs Non-Negotiables
  consolidation** item.

## Sequencing recommendation
- Coordinate the rename **with** the TIER 2 vs Non-Negotiables consolidation to
  avoid a second rename pass.

## Proposed process
- change-request/ticker → HLD → review gate → LLD → ACs → Delivery Ledger +
  ADR in `protocol-decisions.md` — the repo's own Document Flow, so the refactor
  is itself a validated example.

## Draft acceptance criteria
- All `ai-policy-<name>.md` renamed to `<name>.md`; no dangling references in
  AGENTS.md / validator / sync scripts / docs.
- `ai-customization.md` uses `## Active Skills`; loader resolves `<name>.md`
  (optionally accepts third-party `SKILL.md`).
- `validate-protocol.sh` anchors updated + green; new guard forbids `ai-policy-`.
- Historical records byte-identical (untouched).
- Downstream sync verified green via the existing sync scripts.

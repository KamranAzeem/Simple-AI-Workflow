# Implementation Plan: Global Knowledge JIT Indexing

## Metadata

- **Issue**: `ai/issues/open/global-knowledge-jit-indexing.md`
- **ADR**: `ai/shared/project-knowledge/protocol-decisions.md`, entry "2026-10-06: Global Knowledge moves to JIT indexing"
- **Branch (planned)**: `feature/global-knowledge-jit-indexing`
- **Author**: Kilo
- **Date**: 2026-10-06
- **Status**: Approved (review-02) and implemented on branch `feature/global-knowledge-jit-indexing`; pending merge

## Goal

Stop loading `~/.ai/global-knowledge/` in full at boot, at checkpoint context reload, and at Post-Compaction Recovery. Index it instead, using the same JIT Token Rationing model already used for Project Knowledge. Index both sets in the same Step 5 at load context (Procedure A). Report them as two separate lists in the Proof-of-Load. Extend the 90-day bounded staleness check to Global Knowledge. Add guidance that Global Knowledge files must be per-domain and descriptively named.

## Non-goals

- Active policies stay full-load. They are operational rules, not on-demand lessons, and the 2026-06-30 rationale for them still holds.
- Global Settings stay full-load. Settings are small, authoritative, and needed before the first task.
- No change to how Project Issues are indexed.
- Splitting the existing bundled `~/.ai/global-knowledge/engineering-lessons-and-conventions.md` is a user-space action, not part of this protocol change. This plan only adds the naming/split guidance that makes JIT work.

## Why this is safe

The existing validator anchors are all preserved by the wording below:

- `Knowledge Loading` — kept as the Step 5 title.
- `Global AI Knowledge Directory` — still referenced in `AGENTS.md` (TIER 1 and the new Step 5 text).
- `Token Rationing` — kept, and now covers both knowledge sets.

No validator anchor string changes, so no validator version bump is required. The validator must be re-run to confirm 8/8.

## Change set

### 1. `AGENTS.md`

#### 1a. Procedure A Step 4 note (the sentence that says Global Knowledge is not loaded here)

Current:

> ... and **load their full contents into the active context**. **Global Knowledge files** (from the **Global AI Knowledge Directory**) are NOT loaded here — they are loaded in full in Step 5.

New:

> ... and **load their full contents into the active context**. **Global Knowledge files** (from the **Global AI Knowledge Directory**) and **Project Knowledge files** are NOT loaded here — they are indexed in Step 5.

#### 1b. Procedure A Step 5 (Knowledge Loading)

Current:

> 5. **Knowledge Loading**: This is a dedicated required step — do NOT merge it with Step 4.
>    - **Global Knowledge** (from **Global AI Knowledge Directory**): Load the FULL TEXT of every file. This set is intentionally small, so a full load is cheap and removes the risk of the AI guessing at lessons it never read. Do NOT index-only.
>    - **Project Knowledge** (from **Project AI Knowledge Directory**, including any subdirectories): Project Knowledge remains subject to **Token Rationing** — these files can be large (e.g. historical repo-scan snapshots or archives). Run a shell command (`find` or `ls -R`) to discover all filenames and record paths, filenames, and apparent technical domains as a reference index. Record each file's age from metadata only: the last-commit date for tracked files, or the modified time otherwise. **DO NOT** load the full text of any Project Knowledge file at boot time; load it on demand when an active task requires it.
>    - **Project Issues** (from **Project Issues Directory**): Index `open/` and `in-progress/` by filename + line count only. Files under `closed/` are not indexed at boot.
>    If a directory is completely empty, explicitly note it in your state tracking.

New:

> 5. **Knowledge Loading (JIT Index)**: This is a dedicated required step — do NOT merge it with Step 4. The title keeps the words "Knowledge Loading" to preserve the `Knowledge Loading` validator anchor; the content is index-only. Both knowledge sets are indexed, never fully loaded at boot.
>    - **Global Knowledge** (from **Global AI Knowledge Directory**) and **Project Knowledge** (from **Project AI Knowledge Directory**, including any subdirectories) are both subject to **Token Rationing**. Index both in this one step: run a shell command (`find` or `ls -R`) over both directories, and record paths, filenames, and apparent technical domains as a reference index. Record each file's age from metadata only: the last-commit date for tracked files, or the modified time otherwise. **DO NOT** load the full text of any Global Knowledge or Project Knowledge file at boot time; load a file in full on demand when an active task requires it. The filename is the lookup key, so a vague or bundled name is invisible to the index.
>    - **Project Issues** (from **Project Issues Directory**): Index `open/` and `in-progress/` by filename + line count only. Files under `closed/` are not indexed at boot.
>    If a directory is completely empty, explicitly note it in your state tracking.

#### 1c. Procedure A Step 7 bullet (b)

Current: reports Global Settings, **Global Knowledge**, and policy files all as fully loaded.

New: drop the Global Knowledge sentence; keep Global Settings and policy files fully loaded.

> (b) Global Settings files fully loaded from **Global AI Settings Directory** (list filenames with line counts). Policy files **fully loaded**, referenced by the Project Customization File from **Global AI Policies Directory** (list filenames with line counts), and custom policies discovered in **Project AI Policies Directory** (list filenames with line counts). Line counts are proof of a full read from line 1 to EOF.

#### 1d. Procedure A Step 7 bullet (e)

Current:

> (e) All files **indexed** from the **Project AI Knowledge Directory** (filenames and apparent domains — not read in full), or an explicit confirmation that it was empty.

New:

> (e) All files **indexed** from the **Global AI Knowledge Directory** and the **Project AI Knowledge Directory** (filenames and apparent domains — not read in full), listed as two separate sets, or an explicit confirmation that each was empty.

#### 1e. Procedure A Step 7 bullet (h)

Current: "Possibly-stale Project Knowledge".

New:

> (h) Possibly-stale Global Knowledge and Project Knowledge: files whose indexed domain matches a `## Active Expertise` domain and whose age exceeds 90 days, listed with their age, or an explicit confirmation that none are flagged. This is advisory and never blocks work.

#### 1f. Procedure C, Context Re-affirmation After Checkpoint

Current step 1 loads "all files in the **Global AI Knowledge Directory**" in full text, then step 2 runs a shell find on the **Project AI Knowledge Directory**.

New: remove Global Knowledge from the full-text list and index it instead.

- Full-text list becomes: `ai-policy-common.md`, every policy referenced in the **Project Customization File**, and all custom policies discovered in **Project AI Policies Directory**.
- Add after that list: "Index the **Global AI Knowledge Directory** (JIT, no full read), the same way Step 5 of the load-context procedure does."
- The shell find sentence becomes: "Run a shell `find` or `ls -R` on the **Global AI Knowledge Directory** and the **Project AI Knowledge Directory**, and record the filename index from live discovery (not from memory)."

#### 1g. Procedure E (Post-Compaction Recovery)

Procedure E has no intro paragraph that lists Global Knowledge; only step 4 and the closing confirmation line mention loading it. Two edits:

Current Step 4: "Every file in the **Global AI Knowledge Directory** (full text)."
New Step 4: "Index the **Global AI Knowledge Directory** (filenames only, JIT); do not read file contents here."

Current closing confirmation: "the count of settings, knowledge, and policy files loaded, and the count of shared-directory files indexed."
New closing confirmation: "the count of settings and policy files loaded, the count of Global Knowledge files indexed, and the count of shared-directory files indexed."

Step 6 is unchanged: it already builds a filename-only index of the **Project Shared Directory**, which includes Project Knowledge. Procedure E indexes both knowledge sets, but at its existing points (Global Knowledge at step 4, Project Knowledge at step 6). The "same step" consolidation is a Procedure A property only.

### 2. `ai/policies/ai-policy-common.md`

#### 2a. Global Knowledge Protocol

Current:

> - **Bootstrapping & Load Context — Knowledge (Full Load)**: Files in the **Global AI Knowledge Directory** are loaded in FULL at boot. This set is intentionally small, so Token Rationing does NOT apply to it — a full load is cheap and prevents the agent from guessing at lessons it never read. (Token Rationing still governs large Project Knowledge files — see the Project Knowledge Protocol.)

New:

> - **Bootstrapping & Load Context — Knowledge (JIT Index)**: Files in the **Global AI Knowledge Directory** are indexed at boot, not read in full. Indexing records filenames, paths, and apparent technical domains; a file is read in full only when a task needs it. Keep each file to a single domain with a descriptive name, and split a file that mixes domains, because the filename is the JIT lookup key. This mirrors the Project Knowledge Protocol; Token Rationing governs both.

#### 2b. Bounded staleness

Current opens with "Flag a Project Knowledge file at boot...". New opens with "Flag a Global Knowledge or Project Knowledge file at boot...". The rest of the bullet is unchanged.

#### 2c. A2A Coordination, Proof-of-Load line

Current: "This summary must explicitly list active traits, loaded Global Knowledge files, and pending tasks."
New: "This summary must explicitly list active traits, indexed Global Knowledge and Project Knowledge files, and pending tasks."

#### 2d. Source-of-Truth Order note

Current: "Knowledge bases (Global Knowledge and Project Knowledge) are loaded during the `AGENTS.md` bootstrap procedure..."
New: "...are indexed during the `AGENTS.md` bootstrap procedure and read on demand...". (Wording only; keep short.)

### 3. `support-files/validate-protocol.sh`

Expected: no change. Anchor strings are preserved. Re-run to confirm 8/8. If a check fails, fix the wording in `AGENTS.md` rather than the anchor, unless the anchor itself is now semantically wrong.

### 4. `docs/workflow-guide.md`

- Section 2, line ~17: change "Loaded in full at initialization" to index-at-boot, load-on-demand, same model as Project Knowledge.
- Section 2, line ~18: the filename lookup key applies to both knowledge directories.
- Section 7, line ~110: the recovery step re-reads settings and policies and indexes Global and Project Knowledge.
- Section 13, intro (line ~217): Token Rationing applies to both Global and Project Knowledge; only settings and active policies load in full.
- Section 13 step 1 (line ~220): "Global Knowledge — full load" becomes "Global Knowledge — index only".
- Section 13 benefits (line ~226): "Large Knowledge files" (both sets).
- Section 13 staleness (line ~230): applies to both sets.

### 5. `README.md`

- "What's included", line ~265: replace "Small global files are always loaded in full." with the index-at-boot, load-on-demand, freshness-flag wording for both Global and Project Knowledge.
- "File naming for knowledge and notes" (line ~233-240): the section already covers `ai/shared/project-knowledge/`; add `~/.ai/global-knowledge/` so the naming/split guidance is visible to users.

### 6. `docs/simple-ai-workflow-slides.md`

- "Session resume" bullet (line ~36): re-reads the standing rules and active policies, and re-indexes Global Knowledge and the shared directory.
- "Token rationing shield" bullet (line ~38): settings and active policies load in full; Global and Project Knowledge are indexed, loaded on demand, and freshness-flagged.
- Proof-of-Load bullet (line ~177): lists the Settings and policy files fully loaded, and the Global and Project Knowledge files indexed.
- Token rationing slide (lines ~235-238): "Global Knowledge loaded in full" becomes "indexed at boot"; "Project Knowledge indexed at boot" becomes "Global and Project Knowledge indexed at boot".
- Post-Compaction Recovery slide (lines ~346-375): the "standing rules" list drops Global Knowledge as a loaded file; the diagram box label "Global Knowl." under the reloaded-rules area should be relabeled to "Global Knowl. (indexed)" or removed, so the diagram matches the new model.
- Use verbose file names slide (line ~281): unchanged; already covers `~/.ai/global-knowledge/`.

### 7. `docs/ai-agent-collaboration.md`

- Global Knowledge Source bullet (line ~36): state that it is indexed at session start (JIT), not fully loaded, unlike Global Settings.

### 8. Checked, no change required

- `docs/protocol-validation-system.md` — describes the validator checks; anchor strings are unchanged, so it stays accurate.
- `docs/how-policies-work-in-this-workflow.md`, `docs/policy-influence-on-ai-work.md` — grep found no Global Knowledge loading references.
- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md` — mentions the directory as a feature, not its loading semantics.
- `ai/policies/ai-policy-meta.md`, `docs/global-user-settings.md`, `docs/ai-customization-guide.md` — no Global Knowledge loading references.

## Acceptance criteria

- AC1: Procedure A indexes Global Knowledge; no full-load of Global Knowledge remains in `AGENTS.md`.
- AC2: Proof-of-Load reports Global and Project Knowledge indexed, as two separate sets; bullet (b) no longer claims a Global Knowledge full-load.
- AC3: Procedure C and Procedure E index Global Knowledge; neither full-loads it.
- AC4: Bounded staleness covers Global Knowledge and Project Knowledge. Limitation: the check matches on a `## Active Expertise` domain, and cross-project Global Knowledge domains may not match the current project, so flags may be sparse. The flag stays advisory.
- AC5: `ai-policy-common.md` carries the Global Knowledge JIT rule plus the per-domain naming/split guidance.
- AC6: `README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, and `docs/ai-agent-collaboration.md` describe the new model with no stale "Global Knowledge full load" text.
- AC7: `support-files/validate-protocol.sh` passes 8/8.
- AC8: markdownlint is clean on changed markdown.
- AC9: the retired phrasing is gone. Expect zero matches for: `grep -rniE "global knowledge[^.]*loaded in full|global knowledge files .*fully loaded|loaded in full at (boot|initialization)" .`

## Verification steps

1. `bash support-files/validate-protocol.sh` → expect 8/8.
2. `markdownlint-cli2 "AGENTS.md" "ai/policies/ai-policy-common.md" "README.md" "docs/workflow-guide.md" "docs/simple-ai-workflow-slides.md" "docs/ai-agent-collaboration.md"` → expect 0 issues.
3. `grep -rniE "global knowledge[^.]*loaded in full|global knowledge files .*fully loaded|loaded in full at (boot|initialization)" .` → expect zero matches.
4. Trace the six `AGENTS.md` locations from the ticket to confirm each reads as indexed.

## Process

1. Open branch `feature/global-knowledge-jit-indexing` before the first commit.
2. Apply changes 1-7.
3. Run verification steps 1-3.
4. Peer review the implementation; iterate until APPROVED.
5. Move the ticket to `ai/issues/in-progress/` when work starts, and close it on the branch before the squash merge.
6. Append the implementation, verification, and merge record to the ADR entry in `protocol-decisions.md`.
7. After merge, remove this executed plan from `ai/plans/`, matching the pattern used for prior executed plans.

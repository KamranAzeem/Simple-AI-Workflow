<!-- START_IMMUTABLE_PROTOCOL -->
<!-- 
  ========================================================================
  ⚠️ STOP: READ-ONLY PROTOCOL - DO NOT MODIFY OR REGENERATE THIS FILE ⚠️
  ========================================================================
  1. THIS IS A PROTOCOL FILE, NOT A CONTEXT STORAGE FILE.
  2. AI ASSISTANTS ARE STRICTLY PROHIBITED FROM MODIFYING THIS FILE.
  3. ALL MODIFICATIONS MUST BE PERFORMED MANUALLY BY THE HUMAN USER.
  4. EXCEPTION: IN PROTOCOL DEVELOPER MODE (WORKING INSIDE THE SIMPLE-AI-WORKFLOW REPO), THE AI MAINTAINER MAY EDIT PROTOCOL FILES AFTER LOADING protocol-decisions.md AND WITH HUMAN APPROVAL BEFORE COMMITTING.
  ========================================================================
-->

> **Protocol file. Not a context storage file.** This file tells AI assistants how to work and where the context lives. AI assistants must follow it as a protocol, not as project context, and must not modify it.

# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

## TIER CONFIGURATION

**Path Normalization & Inference Rules**:

- **[HOME] Resolution**: AI MUST resolve `[HOME]` to the absolute home directory of the current user (e.g., `/home/username` on Linux, `/c/Users/username` on Gitbash, `C:\Users\username` on Windows CMD or PowerShell ).
- **Dynamic Paths**: All paths below are derived from **Global AI Workflow Directory** (resolved at boot from **Project Customization File**) and **Global User AI Directory**. AI MUST concatenate the Base Directory with the relative path to form absolute paths.

<!-- Human user must not touch/modify the lines below -->

**Global AI Workflow Directory**: resolved from **Project Customization File** at boot
**Global User AI Directory**: `[HOME]/.ai/`
**Global AI Policies Directory**: (Global AI Workflow Directory)/ai/policies/
**Global AI Knowledge Directory**: (Global User AI Directory)/global-knowledge/
**Global AI Backups Directory**: (Global User AI Directory)/backups/
**Global AI Settings Directory**: (Global User AI Directory)/settings/

**Project Artifacts Directory**: `ai/artifacts/`
**Project Code Review Reports Directory**: `ai/code-review-reports/`
**Project Compliance Policies Directory**: `ai/policies/compliance/`
**Project Coordination File**: `ai/shared/coordination.md`
**Project Customization File**: `ai-customization.md`
**Project Daily Checkpoints Directory**: `ai/daily-checkpoints/`
**Project Handoffs Directory**: `ai/shared/handoffs/`
**Project Issues Directory**: `ai/issues/`
**Project AI Knowledge Directory**: `ai/shared/project-knowledge/`
**Project Notes Directory**: `ai/notes/`
**Project Pending Directory**: `ai/pending/`
**Project Plans Directory**: `ai/plans/`
**Project AI Policies Directory**: `ai/policies/`
**Project Secrets Directory**: `ai/secrets/`
**Project Shared Directory**: `ai/shared/`
**Project AI State Files**: `ai/state/`

### Canonical Names & Short Forms

The following short forms are recognized as equivalents to their canonical directives:

- "Global Knowledge" ↔ **Global AI Knowledge Directory**
- "Project Knowledge" ↔ **Project AI Knowledge Directory**

---

## TIER READ-FIRST-RULES

### 🛑 PROHIBITED ACTIONS

- **Self-Modification**: **STRICTLY PROHIBITED** in ordinary projects. Do not rewrite, regenerate, or edit this file. **Exception**: in **Protocol Developer Mode** (see MANDATORY ACTIONS), when the current working directory is the **Global AI Workflow Directory**, the AI is the protocol maintainer and may edit `AGENTS.md` and other protocol files, but only after fully loading `protocol-decisions.md` and with explicit human approval before committing.
- **Unprompted Exploration**: **STRICTLY PROHIBITED** from scanning or ingesting directories outside the `ai/` folder (e.g., `src/`, `logs/`, `tmp/`) unless explicitly directed by a specific task. Indexing directories named `design-docs` by name is the one standing exception.
- **Local State Creation**: **STRICTLY PROHIBITED** from creating tool-specific dot-directories (e.g., `.cursor/`, `.copilot`, `.gemini/`, `.claude/`, etc.). All AI state must live in `ai/`.
- **PWD-Only Scope**: Strictly load `AGENTS.md` and scan the `ai/` directory from the **current working directory (PWD) only**. Honor `AGENTS.md` and `ai-customization.md` only from the project root: do not scan subdirectories for additional `AGENTS.md` files, and do not read or load any `AGENTS.md` or `ai-customization.md` file from any other location in the directory tree. If `AGENTS.md` is not found in PWD, report it missing and stop. Do not read or scan files that belong to various AI assistants, such as `CLAUDE.md`, `GEMINI.md`, etc.

### ✅ MANDATORY ACTIONS

- **OS-Sensitive Execution**: Identify the active shell (Bash, PowerShell, etc.) and adapt command syntax accordingly (e.g., `mkdir -p` vs `New-Item`).
- **Surgical Git-Ignore Exception**: `AGENTS.md` and the entire `ai/` directory (including ALL subdirectories and every file within them) are git-ignored by design. **Git-ignored does NOT mean forbidden.** You MUST use shell tools (`cat`, `ls -la`, `find`) to read and list their contents, and add their contents to active context where permitted. Never refuse to read a file or directory solely because it is git-ignored.
- **Full File Reads (No Partial Reads)**: Read every file you reason about in full, line 1 to EOF, re-reading from disk when a task needs it again. This holds at boot, at load context, at Post-Compaction Recovery, and mid-work. The only exception is log-like bulk data you are searching rather than comprehending (logs, dumps, large JSON or CSV), which you may slice by filter. Never truncate investigation command output with `head`, `tail`, or `-N` limits, since truncated output is fabricated evidence. When a read drives a decision or change, state the file and its line count so the read is auditable. (Evidence-Based Investigation)
- **Evidence-Based Investigation**: Investigate before you assert. No claim without a source; no assumptions or guesses. If you cannot verify, write "not verified" and ask. Wide-scope the subject read-only over its cone of influence. See the Investigation Contract in `ai-policy-common.md`.
- **Context Protection**: Treat **Project AI State Files** as read-only during bootstrap and context loading. During **PROCEDURE POST-COMPACTION-RECOVERY**, these files must not be read at all.
- **State File Single-Writer Ownership**: **Project AI State Files** are the canonical project narrative and are written by the **project-root orchestrator only**: the single AI session that owns this project root. **Ownership is by session/process identity, not by role**: if that one owning session changes hats mid-session (e.g. manager → developer → document-controller), it is still the orchestrator and still writes the state files normally: switching roles does not create a second writer. The prohibition targets **separate** agents that run as their own session/process: sub-agents and role-based team members (developer, security, document-controller, etc.) that are **not** the owning session, whether long-running or spawned per handoff, **MUST NOT write Project AI State Files**. They obtain awareness by **reading** the coordination board, and they report their own work by updating the **Project Coordination File**, their handoff file, and role-scoped **Project Knowledge** files (single-writer per role). The orchestrator folds those reports into the state files at checkpoint (PROCEDURE WRITE-CHECKPOINT). This keeps the canonical narrative single-writer and free of multi-agent write contention. Awareness = read the board; canonical narrative = orchestrator writes.
- **Branch Gating**: Obtain explicit human approval before any state-changing Git operation on `master` or `main`.
- **Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory** (TIER CONFIGURATION), you are operating as a protocol developer on this repository itself. This is the sanctioned exception to the Self-Modification prohibition in PROHIBITED ACTIONS: here you maintain these files, not merely read them. Before making any change to any protocol file (`AGENTS.md`, policy files, `validate-protocol.sh`, or any file under `ai/`), you MUST fully load `protocol-decisions.md` from the protocol repo's `design-docs/`: it records authoritative past decisions and must not be treated as JIT-optional. All paths and file references written into policy files must be authored from the **end-user's project root perspective** (the directory where the user has their own project), not from this repository's internal directory structure. See the "No markdown hyperlinks in policy files" entry in `protocol-decisions.md` for the full rule. **Policy loading**: during context loading and post-compaction recovery, load ONLY `ai-policy-common.md` plus the policy files explicitly listed under `## Active Expertise` in the **Project Customization File**. Do NOT scan and load all files from the **Project AI Policies Directory**: that directory is the protocol's full distribution tree, not your working policy set.
- **Session Resume (Compacted Context)**: When a session begins from a compacted conversation summary, or the conversation is compacted mid-session, AI MUST run **PROCEDURE POST-COMPACTION-RECOVERY** before responding to the user's first request. Concrete signals: the literal text "Compacted conversation" in the transcript; a `<conversation-summary>` XML block in the active context; or the session opening with a machine-generated multi-section summary the AI did not write.
- **Git Workspace Detection**: Before offering git operations on the project root, scan for `.git` subdirectories within the project tree (excluding `ai/`). If any `.git` directory is found, the root is part of a larger git workspace, do not treat it as a git repo itself. Do not offer `git init`, run `git log` on the project root, or propose git operations that assume the project root is independently tracked. Users may also define explicit workspace rules in the **Project Customization File**.
- **Archive File Exclusion**: All `find` and `ls` commands in this protocol must exclude compressed and archive files. Use `! -name '*.tar*' ! -name '*.zip'` with `find`, or filter with `grep -v '\.tar\|\.zip'` when piping `ls` output.
- **Backup Directory Exclusion**: Never scan, list, read, or reference files inside the **Global AI Backups Directory** (`~/.ai/backups/`). Backups are user-space artifacts and are not part of the active project state.

---

## TIER TRIGGERED-PROCEDURES

### PROCEDURE LOAD-CONTEXT: When the user says "load context"

**Aliases**: load context; load context using AGENTS.md protocol

**Safety Barrier**: This procedure is read-only with one narrow, deterministic exception. AI must not modify the content of any existing file during this phase. The only permitted writes are the idempotent creation of missing mandatory directories and the missing issue template described in STEP-STRUCTURAL-AUDIT. Every other action is read-only.

0. **STEP-CUSTOMIZATION-DISCOVERY**: Check for **Project Customization File** at project root (`ai-customization.md`):
    - If found → load the `## AI Workflow Configuration` section and extract `**Global AI Workflow Directory`**. If the section is missing, inform the user and stop.
    - If the old `ai/ai-customization.md` exists instead → inform the user: "Your customization file is in the old `ai/` directory. Add a `## AI Workflow Configuration` section with a `**Global AI Workflow Directory**` entry, then move it to the project root as `ai-customization.md`." Then **stop**, do not proceed with context loading.
    - If neither exists → inform the user that the customization file is missing, show a template, explain what to configure, and optionally suggest cloning the Simple-AI-Workflow repo to `~/Projects/Simple-AI-Workflow` from its GitHub URL. Then **stop**, do not proceed with context loading.
1. **STEP-WORKFLOW-ACCESS**: Read `ai-policy-common.md` from the **Global AI Policies Directory**.
2. **STEP-STRUCTURAL-AUDIT (Existence-First)**: Silently verify the existence of the mandatory directories:
    - **Project Artifacts Directory**, **Project Code Review Reports Directory**, **Project Compliance Policies Directory**, **Project Daily Checkpoints Directory**, **Project Handoffs Directory**, **Project Issues Directory**, **Project AI Knowledge Directory**
    - **Project Notes Directory**, **Project Pending Directory**, **Project Plans Directory**, **Project AI Policies Directory**, **Project Secrets Directory**, **Project Shared Directory**, **Project AI State Files**
    - Global: **Global AI Settings Directory**, **Global AI Knowledge Directory**, **Global AI Backups Directory**
    Verify **Project Coordination File** exists.
    Then ensure the mandatory directories exist. Run one idempotent `mkdir -p` over this fixed path list, and report any directory that had to be created:
    - `ai/artifacts/`, `ai/code-review-reports/`, `ai/daily-checkpoints/`, `ai/issues/`, `ai/issues/open/`, `ai/issues/in-progress/`, `ai/issues/closed/`, `ai/notes/`, `ai/pending/`, `ai/plans/`, `ai/policies/`, `ai/policies/compliance/`, `ai/secrets/`, `ai/shared/`, `ai/shared/handoffs/`, `ai/shared/project-knowledge/`, `ai/state/`
    - Do not branch, prompt, or stall on silent output. `mkdir -p` is safe and silent when the directory already exists.
    Then ensure `ai/shared/project-knowledge/issue-template.md` exists. If and only if it is missing, create it from the compact field list in `ai-policy-common.md`. Never overwrite it.
    Then check `.gitignore` for `ai-customization.md`. If absent, inform the user: "ai-customization.md is not in .gitignore. Add it to prevent accidental commits of your local configuration."
3. **STEP-DISCOVERY**: Run `ls -R` or `find` (or other OS equivalents) on **Global User AI Directory** and the project `ai/` directory to list its contents: excluding compressed and archive files per the **Archive File Exclusion** rule in TIER READ-FIRST-RULES. The **Global User AI Directory** contains settings, and **Global AI Knowledge**. **Important**: `ai/` is git-ignored: use shell commands (`ls -la -R` or `find ai/`) to list its contents. **Do not skip this step**, and do not treat the directory as unreadable just because it is git-ignored.
4. **STEP-LOADING**: Read the **Project Customization File**, all discovered **Global Settings** files (from the **Global AI Settings Directory**), **Project AI State Files**, the latest checkpoint file (from **Project Daily Checkpoints Directory**), and the **Project Coordination File**; and **load their full contents into the active context**. If the latest checkpoint is today's file, the proof-of-read reuses that full read; otherwise it reads today's checkpoint fresh. **Global Knowledge files** (from the **Global AI Knowledge Directory**) and **Project Knowledge files** are NOT loaded here; they are indexed in STEP-KNOWLEDGE-INDEXING. **Author identity**: resolve the author identity (project git identity, then global `~/.gitconfig`, then the global settings file) and offer the git config setup if it is missing or inadequate; offer only, do not write (the read-only safety barrier still applies). If design documents exist under the old `ai/shared/project-knowledge/` location and no `design-docs/` exists, offer to migrate; offer only, do not move files without approval. Design documents are written or updated only through the `"update design documents"` trigger, never at load context; `"migrate design docs"` is the only cross-location mover.
    - **STEP-STATE-FILE-PROOF-OF-READ**: After loading **Project AI State Files**, read them fresh and check them without writing: each state file carries the canonical header block for its type from `ai-policy-common.md` (`### Canonical State-File Headers`), and today's checkpoint carries the daily-checkpoint block and one `# Daily Checkpoint YYYY-MM-DD` H1 outside fenced code blocks whose date matches the filename; entries are in chronological order with no duplicates; items are at most three short bullets; and the newest `ai/state/progress.md` entry date matches the newest daily-checkpoint file date. Compare the block after normalizing a UTF-8 BOM, CRLF, and trailing whitespace; any other difference is a mismatch. Verify exactly one START and END marker per type, the block starts at line 1, and exactly one blank line follows END. Do not use filesystem metadata. Do not summarise from memory. A missing state file is `[FAILED]`; stop and report it before continuing. A missing today's checkpoint is `[PENDING]`; advise running a checkpoint and continue. A header or title mismatch is `[FAILED]`; warn that state-file health is degraded and work quality is at risk, and instruct the user to run `repair state files` now. The load remains read-only. Report the findings under ITEM STATE-FILE-HEALTH of STEP-PROOF-OF-LOAD, and repair only via `repair state files`. Report each file's size and the total against the soft targets; overage is advisory and never fails the load.
5. **STEP-KNOWLEDGE-INDEXING (JIT Index)**: This is a dedicated required step; do NOT merge it with STEP-LOADING. Both knowledge sets are indexed, never fully loaded at boot.
    - **Global Knowledge** (from **Global AI Knowledge Directory**) and **Project Knowledge** (from **Project AI Knowledge Directory**, including any subdirectories) are both subject to **Token Rationing**. Index both in this one step: run a shell command (`find` or `ls -R`) over both directories, and record paths, filenames, and apparent technical domains as a reference index. Record each file's age from metadata only: the last-commit date for tracked files, or the modified time otherwise. **DO NOT** load the full text of any Global Knowledge or Project Knowledge file at boot time; load a file in full on demand when an active task requires it. The filename is the lookup key, so a vague or bundled name is invisible to the index.
    - **Project Issues** (from **Project Issues Directory**): Index `open/` and `in-progress/` by filename + line count only. Files under `closed/` are not indexed at boot.
    - **Design Docs** (every `design-docs/` directory under the project root): Index by filename and a short domain, read-only and never loaded in full. Scan at most 5 levels deep, prune `.git`, `node_modules`, `vendor`, and `target`, and skip archives. Scanning `design-docs` by name is permitted.
    If a directory is completely empty, explicitly note it in your state tracking.
6. **STEP-POLICY-LOADING**: Scan the **Project Customization File** for the `## Active Expertise` section.
    - For each listed expertise name, try `ai-policy-<name>.md` first, then `<name>.md` as fallback.
    - Locate matching files in the **Global AI Policies Directory** using a recursive shell command (`find` or equivalent).
    - Load the FULL TEXT of every matched file.
    Do NOT defer policy loading to "on demand": the AI cannot follow a rule it has not read.
    Then run a recursive shell command (`find` or equivalent) on **Project AI Policies Directory** to discover all `.md` files the user placed there. Load the FULL TEXT of every discovered file. These are user-created custom policies that must be loaded at boot even though they are not listed in the Project Customization File.
    **Exception: Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory**, skip this recursive scan. Load ONLY `ai-policy-common.md` and the policy files explicitly listed under `## Active Expertise` in the **Project Customization File**. The **Project AI Policies Directory** is the protocol's full distribution tree: all domain policies live there, but most do not apply to protocol development work.

    > **Design note (deliberate exception to Token Rationing)**: Loading referenced policy files in full at boot is an intentional exception to the Token-Rationing principle. The cost of a few hundred lines of policy text is far lower than the cost of the AI applying wrong or missing rules because it guessed at policy content. Token Rationing still applies to large Project Knowledge files (repo-scan snapshots, historical archives), never to the operational policy files that govern AI behaviour.
7. **STEP-PROOF-OF-LOAD**: Submit a detailed Markdown summary containing:
    - **ITEM CUSTOMIZATION-SECTIONS**: Every section found in the **Project Customization File**: report each one explicitly, whatever sections the file contains. If a section is absent, say so. Do not stop at any particular section; cover the entire file, and report its line count as proof of a full read.
    - **ITEM SETTINGS-AND-POLICIES**: Global Settings files fully loaded from **Global AI Settings Directory** (list filenames with line counts). Policy files **fully loaded**, referenced by the Project Customization File from **Global AI Policies Directory** (list filenames with line counts), and custom policies discovered in **Project AI Policies Directory** (list filenames with line counts). Line counts are proof of a full read from line 1 to EOF.
    - **ITEM HANDOFFS**: All discovered pending handoffs in **Project Handoffs Directory**.
    - **ITEM STATE-FILE-HEALTH**: State-file health from STEP-LOADING: any order, soft-target size, canonical header, or brevity finding for the **Project AI State Files**, or an explicit confirmation that all are in order.
    - **ITEM KNOWLEDGE-INDEX**: All files **indexed** from the **Global AI Knowledge Directory** and the **Project AI Knowledge Directory** (filenames and apparent domains, not read in full), listed as two separate sets, or an explicit confirmation that each was empty.
    - **ITEM DESIGN-DOCS-INDEX**: The index of every `design-docs/` directory under the project root (file names and short domains), or a confirmation that none were found.
    - **ITEM STATE-FILE-COUNTS**: For each **Project AI State File**: line count, and for `ai/state/progress.md` its newest entry date, read fresh from file content.
    - **ITEM ISSUES-INDEX**: Open and in-progress issue filenames with line counts from the `open/` and `in-progress/` directories under the **Project Issues Directory**, or an explicit confirmation that none are open.
    - **ITEM STALE-KNOWLEDGE**: Possibly-stale Global Knowledge and Project Knowledge: files whose indexed domain matches a `## Active Expertise` domain and whose age exceeds 90 days, listed with their age, or an explicit confirmation that none are flagged. This is advisory and never blocks work.

### PROCEDURE BOOTSTRAP-PROJECT: Empty repository

**Aliases**: bootstrap; bootstrap using AGENTS.md protocol

1. **STEP-ENSURE-DIRECTORIES**: Run PROCEDURE LOAD-CONTEXT, STEP-STRUCTURAL-AUDIT. It audits and idempotently creates the mandatory directories and the issue template.
2. **STEP-CREATE-MISSING-FILES**: Create the **Project Coordination File** if it is missing.
3. **STEP-INITIALIZE-CUSTOMIZATION**: Create `ai-customization.md` at the project root with a `## AI Workflow Configuration` section containing a `**Global AI Workflow Directory**` entry pointing to the workflow repository. See `docs/ai-customization.md` for the template.
4. **STEP-INITIALIZE-STATE-FILES**: Create `ai/state/next-steps.md`, `ai/state/progress.md`, and `ai/state/context.md` in the v2 shape (the canonical block for each file copied verbatim from `ai-policy-common.md` (`### Canonical State-File Headers`); progress and next-steps chronological; context a dashboard plus an `## Active Working Context` section), and an initial daily checkpoint with the canonical daily-checkpoint block and the `# Daily Checkpoint YYYY-MM-DD` heading.
5. **STEP-GIT-SETUP**: Ensure `ai/**`, `ai-customization.md`, and `AGENTS.md` are in `.gitignore`.
6. **STEP-AUTHOR-IDENTITY**: Resolve the author identity (project git identity, then global `~/.gitconfig`, then the global settings file). If no global `~/.gitconfig` exists, offer to create one from the common policy template. If the current directory is a git repository with an inadequate config, suggest creating one. If `git` is not available, use the settings fallback and skip the offer. Offer only; never write without approval.
7. **STEP-FINALIZE-BOOTSTRAP**: Proceed to PROCEDURE LOAD-CONTEXT.

### PROCEDURE WRITE-CHECKPOINT: When the user says "checkpoint" or "save checkpoint"

**Aliases**: checkpoint; save checkpoint; update project knowledge; update global knowledge

**Single-step aliases**: when the trigger is `"update project knowledge"` or `"update global knowledge"`, run only the matching step (STEP-PROJECT-KNOWLEDGE-UPDATE or STEP-GLOBAL-KNOWLEDGE-UPDATE) and skip the rest.

**Boundaries**: this procedure never reads or writes design documents; a separate, confirmation-gated procedure handles those. It never runs git or suggests a commit.

**Failure rule**: the state-file write and the diary are the core and run first and always. If a later step fails, run the remaining steps, report the failure loudly in the checkpoint report, and never let a failure prevent the state-file write or the diary.

1. **STEP-ATOMIC-WRITE (The Atomic Write Protocol)**: Sync **Project AI State Files**. To prevent Context Drift, you must treat these state updates as a single atomic transaction. Never update one file without immediately synchronizing the others.
    - **STEP-WRITE-DIRECTION (memory → disk)**: Your active in-memory context is the freshest source of truth for what was accomplished this session. A checkpoint **serialises that fresh in-memory state into Project AI State Files**: it is a write-down, not a re-read to discover what is current. The on-disk files are the stale targets being updated.
    - **STEP-FRESH-READ-BEFORE-WRITE (reconcile, do NOT overwrite fresh work)**: Read the current on-disk content of **Project AI State Files** immediately before writing: but treat this as a **reconcile**, not a memory refresh. Purpose of the read: (a) preserve the append-only history in `ai/state/progress.md` so a write never drops existing entries, and (b) detect drift introduced by another agent or by context compaction since you last saw the files. **Precedence**: your fresh in-memory deltas are authoritative for new or changed content; the disk read must never overwrite fresh work with a stale cached or summarised version. If disk and memory genuinely conflict on the *same* item, **stop and flag it**, do not silently pick one.
    - **STEP-INBOUND-RECONCILE (multi-agent)**: Before writing, also read the **Project Coordination File** and any new or updated handoffs in **Project Handoffs Directory**, so you fold in work completed by other agents since the last checkpoint. **Project AI State Files** are written by the project-root orchestrator only (see TIER READ-FIRST-RULES "State File Single-Writer Ownership"); other agents report via the coordination board, handoffs, and role-scoped Project Knowledge.
    - **STEP-HEADER-PRE-WRITE**: Before writing, verify each state-file header. If one does not match, stop and run `repair state files` first. Preserve each header verbatim when writing the body.
    - **STEP-SEQUENTIAL-WRITE-ORDER**: Stage your changes in memory and write them to disk in this strict sequence:
        1. 📂 `ai/state/progress.md` (The Past): Log the completed activity, architectural decisions, or milestone reached first.
        2. 📂 `ai/state/next-steps.md` (The Future): Delete each completed task from the backlog entirely. Never leave a ticked, checked, or struck-through entry. Append new atomic actions at the tail, keeping the order oldest at top and newest at the bottom. Work oldest-first by default, but delete a finished item wherever it sits. Keep every open item to at most three short bullets, with no command transcripts and no rationale. Condense any item that grows longer before writing the checkpoint.
        3. 📂 `ai/state/context.md` (The Present): Maintain a `## Current Status` dashboard and an `## Active Working Context` section, both edited in place, with no chronological history and no git metadata. Keep live decisions and findings to short one-liners with a pointer to Project Knowledge. Do not duplicate completed tasks (`ai/state/progress.md`) or pending tasks (`ai/state/next-steps.md`). Remove a resolved item only after its record is in the diary.
    - **STEP-TRANSACTION-LOG**: Every time you save state or finish a checkpoint execution loop, append a standardized transaction summary directly into your chat output using this exact text format:
        - [PROGRESS] Added: "[Brief description of what was completed]"
        - [NEXT-STEPS] Removed: "[Task]" | Added: "[New immediate actionable items]"
        - [CONTEXT] Updated: "variable_name: old_value" -> "variable_name: new_value"
    - **STEP-ABORT-ON-MISSING-DATA**: If you lack the required information to accurately align all three files, abort the write transaction entirely. Halt execution, roll back the proposed memory state, and flag the missing variable to the human user.
2. **STEP-DAILY-CHECKPOINT-FILE**: In the same transaction as the state files above, append this checkpoint to **Project Daily Checkpoints Directory**. This is the write side of the Source-of-Truth Order and the State File Proof-of-Read check in `ai-policy-common.md`: both already expect a current checkpoint file at this point; this step is what keeps it current.
    - **One file per day**: Use `YYYY-MM-DD.md` (today's calendar date). If today's file does not exist yet, create it with the canonical daily-checkpoint block, one blank line, and a top-level `# Daily Checkpoint YYYY-MM-DD` heading.
    - **Append, never overwrite**: Before appending, verify today's header. Add a new `## <short title>` section at the tail of today's file. Multiple checkpoints on the same day append multiple sections; never edit, delete, or reorder an earlier section. Leave legacy `## CP-<ID>: <title>` sections untouched.
    - **Content**: Record what was done, what is being done, and what needs doing, in short bullets, expanded with whatever detail belongs to the fuller narrative (files touched, validator or review outcomes). Nothing is dropped; the diary is the record.
    - **This is the only archive**: No separate archive file is created. Old `ai/state/progress.md` entries and resolved `ai/state/context.md` items move here.
3. **STEP-STATE-FILE-TRIMMING**: Keep the three state files small enough to load cheaply. There is no separate archive file; the daily checkpoints are the archive.
    - **Soft targets**: Total for the three state files is a 20 KB soft target: `ai/state/context.md` 8 KB, `ai/state/progress.md` 7 KB, `ai/state/next-steps.md` 5 KB. Measure bytes; overage is advisory.
    - **Progress trim**: If `ai/state/progress.md` is over 7 KB, or holds completed entries older than 14 days, move the oldest completed entries to the diary. Move completed entries first. If the file is still over target, let it exceed and report the overage.
    - **Next-steps trim**: Never drop an unfinished item. Remove only completed, duplicate, or explicitly-dropped items, and record a dropped item in the diary first. If every item is live and the backlog exceeds 5 KB, let the file exceed the soft target and report the overage.
    - **Context trim**: Remove resolved items from `## Active Working Context` only after their record is in the diary. Keep live items to short one-liners with pointers. If live items keep the file over 8 KB, keep them and report the overage.
    - **Header preservation**: Preserve each header verbatim. Verify each header before and after trimming.
    - **Ordering rule**: An entry leaves a state file only after its content is in the diary, in the same checkpoint.
    - **No git metadata**: The state files never record a branch, hash, or push status, and the AI does not prompt the user to commit them.
    - **Gate scope**: The atomic-write and same-day-append header gates run before their writes. A gate failure aborts the checkpoint intentionally. The checkpoint failure rule, that the state files and diary run first and always, applies after the gate passes and the write starts. A trimming header failure stops the trim only, after the core writes.
4. **STEP-PROJECT-KNOWLEDGE-UPDATE**: Review all work done since the last checkpoint. For any findings, decisions, or discoveries not yet written into the **Project AI Knowledge Directory**, update or create the relevant files now. This step is **mandatory**: even when no new material exists, you must explicitly confirm that the knowledge base is current before proceeding. This applies to all project types. Capture any of the following that occurred since the last checkpoint:
    - Decisions made and the rationale behind them
    - Resolved issues and their root causes
    - Investigation and research conclusions (technical findings, confirmed values, analysis outcomes)
    - New constraints, blockers, or dependencies identified
    - Key identifiers, configuration values, or reference data confirmed during the session (e.g., resource IDs, API endpoints, library versions, schema names, environment variables: **never raw secrets**)
    - Updates posted to external systems such as issue trackers, project management tools, or communication channels (include timestamp and channel)
5. **STEP-GLOBAL-KNOWLEDGE-UPDATE**: Capture only lessons that are genuinely reusable across projects (a tool's behavior, a pattern that generalizes, a portable fix) into the **Global AI Knowledge Directory**. This step is mandatory like the project-knowledge step: when nothing qualifies, explicitly confirm "nothing to add" instead of forcing an entry. Project-specific material belongs in the **Project AI Knowledge Directory**. If the Global AI Knowledge Directory does not exist, confirm and skip; do not create user-space directories unprompted.
6. **STEP-HOUSEKEEPING-AND-STALE-SCAN (report-only)**: Report, never act. Flag, without changing anything:
    - An `in-progress/` ticket with no live branch (it may be finished or abandoned). Closing a ticket stays tied to its merge (PROCEDURE MANAGE-ISSUES), so the checkpoint never moves tickets.
    - An executed plan left in the **Project Plans Directory**.
    - Knowledge files flagged by the staleness heuristic (older than 90 days whose domain matches an active expertise): list them, do not edit them.
7. **STEP-CHECKPOINT-REPORT**: Print one grouped summary of the checkpoint, one line per step, using `updated`, `nothing to add`, or `failed`, followed by the state-file transaction log from STEP-TRANSACTION-LOG. The report is printed in chat only; the diary keeps the narrative.
8. **STEP-CONTEXT-RE-AFFIRMATION (condition-gated)**: A checkpoint normally runs mid-session when policies and knowledge are already in context, so a blanket reload is unnecessary and wasteful. Perform a reload **only** when the active context has been compacted since the last full load, or when you are otherwise unsure the operational files are still loaded. This is the same reload that **PROCEDURE POST-COMPACTION-RECOVERY** performs:
    - Announce: **[Re-affirming key files into context after checkpoint...]**
    - Load the FULL TEXT of `ai-policy-common.md`, every policy file referenced in the **Project Customization File**, and all custom policies discovered in **Project AI Policies Directory**.
      **Exception: Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory**, skip the custom-policy scan. Load ONLY `ai-policy-common.md` and the policies explicitly listed under `## Active Expertise` in the **Project Customization File**.
    - Index the **Global AI Knowledge Directory**, the **Project AI Knowledge Directory**, and every `design-docs/` directory under the project root, up to five levels deep (JIT, no full read, the same way STEP-KNOWLEDGE-INDEXING of PROCEDURE LOAD-CONTEXT does): run a shell `find` or `ls -R` and record the filename index from live discovery (not from memory).
    - Announce on completion: **[Context re-affirmation complete.]**
    If context is still healthy and the operational files are already loaded, skip the reload and state explicitly that it was not needed.

### PROCEDURE RUN-PEER-REVIEW: When the user says "peer review", "code review", or "PR review"

**Aliases**: peer review; code review; PR review

1. **STEP-ADOPT-REVIEWER-ROLE**: Switch to Strict Peer Reviewer mode. You are now an objective reviewer: your only job is to find and report issues. Do not write or fix code. Read `ai/policies/ai-policy-code-review.md` for the full role definition and report format.
2. **STEP-RESOLVE-PR (PR review only)**: When the trigger is a named PR (a PR number, URL, or branch), first fetch the latest remote refs (`git fetch --all --prune` or equivalent), then resolve the PR's source and target branches. Diff source against target, not the local working tree, before doing anything else. If the source branch is not found locally, fetch it explicitly by name.
3. **STEP-SCAN-SCOPE**: Review the diffed files (PR review) or the files the user specifies (general review). If no scope is given for a general review, review all non-generated, non-dependency source files in the repository (exclude `ai/`, `tmp/`, git-ignored, and vendor/dependency files and directories). In both cases, follow the Scope Discipline section of `ai-policy-code-review.md`, do not stop at the diff.
4. **STEP-WRITE-REVIEW-REPORT**: Write the review report to **Project Code Review Reports Directory**/YYYY-MM-DD_HH-MM_review-NN.md. Follow the report format in `ai-policy-code-review.md`. End with a clear verdict: **APPROVED** or **CHANGES REQUESTED**. Never overwrite a previous report.
5. **STEP-ITERATE-REVIEW**: After fixes are applied, locally or as new commits pushed to the PR branch, and another review is requested, re-fetch first if reviewing a PR, then create a new numbered report. Note which previous issues were resolved.
6. **STEP-EXIT-REVIEW-ROLE**: Return to your normal role when the user says "done reviewing", when the verdict is APPROVED, when a commit is made, or, for a PR review, when the PR is merged or closed.

### PROCEDURE POST-COMPACTION-RECOVERY: Automatic after conversation compaction

**Aliases**: post-compaction recovery; run post-compaction recovery procedure

**Stable identifier**: The title "Post-Compaction Recovery" is the maintained contract referenced by the `validate-protocol.sh` anchor, the setup guide, and any hook configurations. Never rename this procedure without updating those in lockstep.

**Trigger**: Run this whenever the conversation is compacted, that is, whenever the harness replaces the live history with a summary. Concrete signals: the literal text "Compacted conversation" in the transcript; a `<conversation-summary>` XML block in the active context; or the session opening with a machine-generated multi-section summary you did not write. It is also safe to run on explicit user request. This procedure only re-reads standing rule and config files and re-indexes the knowledge bases; it never deletes or overwrites the working context, so running it when in doubt is safe.

**The one hard rule**: Do NOT read the three **Project AI State Files** (`ai/state/progress.md`, `ai/state/context.md`, `ai/state/next-steps.md`) or any daily checkpoint during this procedure. The compaction summary already in context is the source of truth for task state; the on-disk state files may be older than the summary and would inject stale state. This procedure reloads rules, not state. It therefore never runs the state-file health check and never runs `repair state files`.

**Steps**: Announce **[Reloading key files into context...]** as the literal first line of your reply, then re-read, in this order:

1. **STEP-READ-AGENTS**: `AGENTS.md` from the current working directory: the **TIER CONFIGURATION** section plus all procedures.
2. **STEP-READ-CUSTOMIZATION**: The **Project Customization File**: active Expertise, Traits, and Development Workflow rules.
3. **STEP-READ-SETTINGS**: Every file in the **Global AI Settings Directory** (full text).
4. **STEP-INDEX-KNOWLEDGE**: Index, filenames only (JIT, never reading file contents), the **Global AI Knowledge Directory**, the **Project AI Knowledge Directory**, and every `design-docs/` directory under the project root (scan at most five levels deep, prune heavy trees, skip archives). This is the same index that STEP-KNOWLEDGE-INDEXING of PROCEDURE LOAD-CONTEXT builds.
5. **STEP-LOAD-POLICIES**: `ai-policy-common.md` from the **Global AI Policies Directory**, every policy referenced in the **Project Customization File**, and every `.md` found by a recursive scan of the **Project AI Policies Directory** (full text).
   **Exception: Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory**, skip the recursive scan. Load ONLY `ai-policy-common.md` and the policies explicitly listed under `## Active Expertise` in the **Project Customization File**. The **Project AI Policies Directory** is the protocol's full distribution tree: most files in it do not apply to protocol development work.
6. **STEP-READ-COORDINATION**: Read the **Project Coordination File** in full (multi-agent awareness). Then build a filename-only index (no file contents) of everything else under the **Project Shared Directory**, recursively, including the **Project AI Knowledge Directory** and **Project Handoffs Directory**. Load those contents later, on demand, only when a task needs them.

**STEP-RELOAD-REPORT**: Then confirm in one or two lines: the Active Expertise and Traits reloaded, the count of settings and policy files loaded, the count of Global Knowledge files indexed, the count of project knowledge files indexed, the count of design docs indexed, and the count of shared-directory files indexed. Do not quote or summarise any state file. If any file failed to load, say so and stop.

### PROCEDURE CREATE-BACKUP: When the user says "backup ai" or "backup ai state"

**Aliases**: backup ai; backup ai state

1. **STEP-BACKUP-MANDATE**: Run the native backup command for your OS, substituting variables for resolved absolute paths:
    - **Linux/Bash**: `tar -czf [Global AI Backups Directory]/$(basename $(dirname $(pwd)))_$(basename $(pwd))_$(date +%Y-%m-%d_%H-%M).tar.gz ai/ ai-customization.md`
    - **Windows/PS**: `Compress-Archive -Path ai/, ai-customization.md -DestinationPath "[Global AI Backups Directory]/$(Split-Path -Leaf (Split-Path -Parent $PWD))_$(Split-Path -Leaf $PWD)_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').zip"`
2. **STEP-REPORT-BACKUP-PATH**: Confirm the backup file path.

### PROCEDURE EXAMINE-CODEBASE: When the user says "examine this codebase" or "codebase examination"

**Aliases**: examine this codebase; codebase examination

1. **STEP-LOAD-EXAMINATION-POLICY**: Load `ai/policies/ai-policy-codebase-examination.md` for the full role definition and four-phase workflow (Map → Plan → Perform → Reconcile).
2. **STEP-RUN-EXAMINATION-WORKFLOW**: Follow the workflow defined in the policy. All Branch-Gating, TDD, and Peer Review guardrails from `ai-policy-common.md` apply.
3. **STEP-EXIT-EXAMINATION**: Return to normal role when the examination session concludes.

### PROCEDURE MANAGE-ISSUES: When the user says "manage issues", "file an issue", "close issue", or "list issues"

**Aliases**: manage issues; file an issue; close issue; list issues

1. **STEP-LOAD-ISSUE-MECHANISM**: The issue-management rules live in `ai-policy-common.md`, which is always loaded. There is no separate policy file and no extra load step.
2. **STEP-LOCATE-TICKET**: Tickets live under `ai/issues/` in exactly three status directories: `open/`, `in-progress/`, and `closed/`. A ticket's directory is its status. No file sits directly under `ai/issues/`.
3. **STEP-ACT-ON-ISSUE-REQUEST**:
    - **Create**: write a new ticket under `ai/issues/open/` using the format in `ai/shared/project-knowledge/issue-template.md`. AI-initiated creation is immediate and never waits on a human; set `Severity`/`Size` to `Human-to-decide (AI estimate: ...)` when the user has not chosen them, and leave `Label` empty.
    - **Start work**: open the feature branch, then move the ticket file from `open/` to `in-progress/` (for example `git mv` in a repository that tracks `ai/`).
    - **Close local**: attach the plan, close the ticket on the branch before the squash merge, and update related project knowledge.
    - **Close external**: merge the PR/MR first, then attach the plan, delete the plan file, and close the ticket.
    - **Reopen local**: open a new branch and move the ticket from `closed/` back to `open/`.
    - **Reopen external**: reopen the ticket in its tracker.
    - **List**: read `ai/issues/open/` and `ai/issues/in-progress/` and report filenames. This action is read-only.
4. **STEP-ANALYZE-ISSUE**: analyze the ticket for missing information, inconsistencies, and gaps; fill every gap through brainstorming or grilling with the user. If it is not workable, set `Label: Insufficient Information` or `Label: Unworkable` and refuse to work it, even if the user insists.
5. **STEP-PLAN-MANDATE**: create the plan under `ai/plans/` with an `## Evidence` section and the depth from the common policy. Append the plan file name as a dated comment on the ticket. Write the failing test first when the project uses TDD.
6. **STEP-PLAN-REVIEW**: run independent peer review automatically. Fix every Critical finding. Fix every Major finding. Re-review after each fix. Announce the plan ready only after an `APPROVED` verdict. Record each round in the plan's Peer Review Log.
7. **STEP-BRANCH-REVIEW**: implement on the feature branch. Include tests, documentation, release announcement, ADRs, and the checkpoint. Run the implementation peer review. Fix every Critical finding. Fix every Major finding. Re-review until no Critical or Major finding remains.
8. **STEP-MERGE-SEQUENCE**: append the final plan under `## Implementation Plan`. Replace the plan link with `Plan attached below.`. Delete the plan file. Close the local ticket. Run the checkpoint on the branch. Squash-merge to trunk. Delete the branch. Push. Do not make post-merge commits for a local work item. For external work, merge the PR/MR first, then attach the plan, delete the plan file, and close the ticket. Tag the release commit after the merge. Publish the GitHub Release after the tag.
9. **STEP-EXIT-ISSUE-MODE**: Return to normal role when the issue action is complete.

### PROCEDURE REPAIR-STATE-FILES: When the user says "repair state files", "tidy state files", or "heal state files"

**Aliases**: repair state files; tidy state files; heal state files

1. **STEP-LOAD-STATE-RULES**: Load `ai-policy-common.md` and read `### Canonical State-File Headers`. Verify exactly one block for each type. If the policy or subsection is unavailable, stop and ask. Do not write a header without the policy text present.
2. **STEP-DIAGNOSE-STATE**: Run the same read-only checks as the STEP-STATE-FILE-PROOF-OF-READ of PROCEDURE LOAD-CONTEXT: canonical header match, chronological order, duplicates, soft-target size, brevity, the diary mirror, and today's H1 form and date.
3. **STEP-REPAIR-STATE**:
    - Check that the state file exists before reading it. If it is missing, stop and report; do not create it.
    - Read the file. Strip a UTF-8 BOM, convert CRLF to LF, and trim trailing whitespace before marker detection. Write UTF-8 without a BOM and with LF endings.
    - Detect the marker state immediately after normalization. Count exact START and END lines.
    - If there is no START and no END, use the insertion path:
      - If line 1 is a recognized legacy header, remove that line and any leading blank lines. The remaining content is the body.
      - Otherwise, the existing content with its leading blank lines removed is the body.
      - For the diary, apply the same H1 rule to the body: exactly one H1 outside fenced code blocks of the form `# Daily Checkpoint YYYY-MM-DD`, with only the date token corrected if needed. Stop on any other shape.
      - Save the full original file and the body as the expected body.
      - Write the canonical block, exactly one blank line, and the body.
      - Compare the new body with the expected body and restore on failure.
    - If exactly one START and one END exist and START precedes END, use the replacement path:
      - If START is not line 1, and every preceding line is a recognized legacy header or a blank line, remove those lines so the block starts at line 1. Stop and ask on any other preceding content.
      - Define the body as the content after END with all leading blank lines removed.
      - If the first body line is a recognized legacy header, remove it and any following leading blank lines. This is an allowed correction.
      - For the diary, require exactly one H1 outside fenced code blocks of the form `# Daily Checkpoint YYYY-MM-DD`. Replace only the date token if it differs from the filename. Stop on zero or multiple H1 headings, or on any other H1 shape. This is an allowed correction.
      - Save the full original file and the expected body, after the allowed legacy-line and H1 date corrections.
      - Replace the inclusive START-to-END range with the canonical block, exactly one blank line, and the expected body.
      - Compare the new body with the expected body and restore on failure.
    - If the markers are partial (START without END, END without START, duplicates, or out of order), stop and ask. Do not guess at the boundary.
    - Recognized legacy headers: the actual HTML-comment forms `<!-- State file (present). ... -->`, `<!-- State file (past). ... -->`, `<!-- State file (future). ... -->`, and `<!-- Daily checkpoint (diary). ... -->`, plus the bare forms that start with `State file (` or `Daily checkpoint (`. Match only the known prefixes; never remove arbitrary content.
    - The existing reorder, trim, and diary-mirror repairs still run. Move completed progress entries and resolved context items to the latest checkpoint before removing them. Never drop an unfinished next-steps item.
4. **STEP-REPORT-REPAIR**: List each header replaced or inserted, each title date fixed, the body checksum result, and every other change, then confirm the state files are in order.
5. **STEP-EXIT-REPAIR-MODE**: Return to normal role when the repair is complete.

### PROCEDURE UPDATE-DESIGN-DOCS: When the user says "update design documents"

**Aliases**: update design documents; update design docs; update design-docs

**Boundaries**: handles design documents only. It never updates project knowledge or global knowledge, and never writes operational bookkeeping into a design document. The checkpoint never invokes it. The rules live in `ai/policies/ai-policy-design-docs.md`, loaded at STEP-LOAD-DESIGN-DOCS-POLICY.

**Failure rule**: refuse rather than corrupt. When the scope is ambiguous, a design statement lacks evidence, or content conflicts, stop and ask.

1. **STEP-LOAD-DESIGN-DOCS-POLICY**: Load `ai/policies/ai-policy-design-docs.md` in full.
2. **STEP-DETERMINE-LOCATION**: Read the `## Design Docs` `**Location**:` entry from the **Project Customization File** if it is present. Detect the current location: a `design-docs/` directory means migrated, otherwise the `ai/shared/project-knowledge/` fallback.
3. **STEP-RESOLVE-SCOPE**: Parse the qualifier that follows the trigger, for example "related to the payment gateway app". Match it to a component directory, a repo, or a document scope. No qualifier means the session's design context. An ambiguous or unmatched qualifier is resolved with the user before any write.
4. **STEP-FIND-DOCS**: Find candidate documents using the boot design-docs index, the doc-type vocabulary, and the fallback location.
5. **STEP-GATHER-DELTAS**: Collect candidate design deltas from the session, and from project knowledge only when the user points at it or a design file is found there. Never invent content.
6. **STEP-PROPOSE-CHANGESET**: Present the change set: which documents, which sections, and whether each change is an add or a modify.
7. **STEP-CHALLENGE**: Challenge every substantive design decision with one to three sharp questions, each carrying a recommended answer.
8. **STEP-CONFIRM**: Show a per-document diff. Get approval per document or as a batch. A dry run writes nothing.
9. **STEP-WRITE**: Create a missing document from its per-type skeleton only when the discussion names its content, or update an existing one. Dedupe by ID. Keep it concise, with no bookkeeping.
10. **STEP-UPDATE-LEDGER**: Update the Delivery Ledger for the documents touched. Create the ledger when the first design document lands.
11. **STEP-OFFER-MIGRATION**: When the project is not migrated, offer migration once per session, state the benefits, and acknowledge any choice. The trigger `"migrate design docs"` performs the move when the user accepts.
12. **STEP-REPORT**: Summarize the documents created or updated, the location used, and any deferral.

### PROCEDURE MIGRATE-DESIGN-DOCS: When the user says "migrate design docs"

**Aliases**: migrate design docs; migrate design documents

**Boundaries**: moves existing design documents only, from the fallback location into `design-docs/` beside the code. It never edits content and never updates project knowledge. It is the only cross-location mover.

1. **STEP-LOAD-MIGRATION-POLICY**: Load `ai/policies/ai-policy-design-docs.md` in full.
2. **STEP-FIND-UNMIGRATED-DOCS**: Search `ai/shared/project-knowledge/`, including subdirectories, for the doc-type vocabulary.
3. **STEP-CONFIRM-MIGRATION**: List every file to move, its target `design-docs/` path, and the git impact (the files become tracked). Get approval before writing.
4. **STEP-MOVE-FILES**: Move each approved file to `design-docs/`, renaming it to the simple lowercase doc name. Move, never copy.
5. **STEP-REPORT-MIGRATION**: Report the files moved, the target location, and any file left behind.

---

## TIER APPENDIX

### Path Format Requirements (Windows)

File-manipulation tools on Windows require absolute paths (`C:\path\to\file`).

- Git Bash POSIX: `/c/Users/` → `C:\Users\`
- WSL POSIX: `/mnt/c/Users/` → `C:\Users\`

### FOR THE HUMAN: Manual Setup

- Manually create your **Global User AI Directory** structure.
- Create a personal settings file (e.g., `global-user-settings.md`) in the `settings/` subfolder. This file holds your personal preferences, tool configurations, and cross-project context that the AI fully loads at every session start.
- **The Bootstrap Wedge**: If the AI refuses to read the protocol because it is git-ignored, tell it: *"Use the `cat` command to read AGENTS.md in the current directory and follow its protocol."*

<!-- END_IMMUTABLE_PROTOCOL -->

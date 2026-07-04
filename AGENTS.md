<!-- START_IMMUTABLE_PROTOCOL -->
<!-- 
  ========================================================================
  ⚠️ STOP: READ-ONLY PROTOCOL - DO NOT MODIFY OR REGENERATE THIS FILE ⚠️
  ========================================================================
  1. THIS IS A PROTOCOL FILE, NOT A CONTEXT STORAGE FILE.
  2. AI ASSISTANTS ARE STRICTLY PROHIBITED FROM MODIFYING THIS FILE.
  3. ALL MODIFICATIONS MUST BE PERFORMED MANUALLY BY THE HUMAN USER.
  ========================================================================
-->

# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

## TIER 1: CONFIGURATION

**Path Normalization & Inference Rules**:
- **[HOME] Resolution**: AI MUST resolve `[HOME]` to the absolute home directory of the current user (e.g., `/home/username` on Linux, `C:\Users\username` on Windows, `/c/Users/username` on Gitbash ).
- **Dynamic Paths**: All paths below are derived from **Global AI Workflow Directory** (resolved at boot from **Project Customization File**) and **Global User AI Directory**. AI MUST concatenate the Base Directory with the relative path to form absolute paths.

<!-- Human user must not touch/modify the lines below -->

**Global AI Workflow Directory**: resolved from **Project Customization File** at boot
**Global User AI Directory**: `[HOME]/.ai/`
**Global AI Policies Directory**: (Global AI Workflow Directory)/ai/policies/
**Global AI Knowledge Directory**: (Global User AI Directory)/global-knowledge/
**Global AI Backup Directory**: (Global User AI Directory)/backups/
**Global AI Settings Directory**: (Global User AI Directory)/settings/

**Project Artifacts Directory**: `ai/artifacts/`
**Project Code Review Reports Directory**: `ai/code-review-reports/`
**Project Compliance Policies Directory**: `ai/policies/compliance/`
**Project Coordination File**: `ai/shared/coordination.md`
**Project Customization File**: `ai-customization.md`
**Project Daily Checkpoints Directory**: `ai/daily-checkpoints/`
**Project Handoffs Directory**: `ai/shared/handoffs/`
**Project AI Knowledge Directory**: `ai/shared/project-knowledge/`
**Project Notes Directory**: `ai/notes/`
**Project Pending Directory**: `ai/pending/`
**Project Plans Directory**: `ai/plans/`
**Project AI Policies Directory**: `ai/policies/`
**Project Secrets Directory**: `ai/secrets/`
**Project Shared Directory**: `ai/shared/`
**Project AI State Files**: `ai/progress.md`, `ai/context.md`, `ai/next-steps.md`

### Canonical Names & Short Forms
The following short forms are recognized as equivalents to their canonical directives:
- "Global Knowledge" ↔ **Global AI Knowledge Directory**
- "Project Knowledge" ↔ **Project AI Knowledge Directory**

---

## TIER 2: AI READ-FIRST RULES (Rules of Engagement)

### 🛑 PROHIBITED ACTIONS
- **Self-Modification**: **STRICTLY PROHIBITED**. Do not rewrite, regenerate, or edit this file.
- **Unprompted Exploration**: **STRICTLY PROHIBITED** from scanning or ingesting directories outside the `ai/` folder (e.g., `src/`, `logs/`, `tmp/`) unless explicitly directed by a specific task.
- **Local State Creation**: **STRICTLY PROHIBITED** from creating tool-specific dot-directories (e.g., `.cursor/`, `.copilot`, `.gemini/` `.claude/`, etc.). All AI state must live in `ai/`.
- **PWD-Only Scope**: Strictly load `AGENTS.md` and scan the `ai/` directory from the **current working directory (PWD) only**. Do not scan subdirectories for additional `AGENTS.md` files, and do not read or load any other `AGENTS.md` files from any other locations. If `AGENTS.md` is not found in PWD, report it missing and stop. Do not read or scan files that belong to various AI assistants, such as `CLAUDE.md`, `GEMINI.md`, etc.

### ✅ MANDATORY ACTIONS
- **OS-Sensitive Execution**: Identify the active shell (Bash, PowerShell, etc.) and adapt command syntax accordingly (e.g., `New-Item` vs `mkdir -p`).
- **Surgical Git-Ignore Exception**: `AGENTS.md` and the entire `ai/` directory (including ALL subdirectories and every file within them) are git-ignored by design. **Git-ignored does NOT mean forbidden.** You MUST use shell tools (`cat`, `ls -la`, `find`) to read and list their contents, and add their contents to active context where permitted. Never refuse to read a file or directory solely because it is git-ignored.
- **Context Protection**: Treat **Project AI State Files** as read-only during bootstrap and context loading. During post-condensation recovery (Procedure E), these files must not be read at all.
- **State File Single-Writer Ownership**: **Project AI State Files** are the canonical project narrative and are written by the **project-root orchestrator only** — the single AI session that owns this project root. **Ownership is by session/process identity, not by role**: if that one owning session changes hats mid-session (e.g. manager → developer → document-controller), it is still the orchestrator and still writes the state files normally — switching roles does not create a second writer. The prohibition targets **separate** agents that run as their own session/process: sub-agents and role-based team members (developer, security, document-controller, etc.) that are **not** the owning session, whether long-running or spawned per handoff, **MUST NOT write Project AI State Files**. They obtain awareness by **reading** the coordination board, and they report their own work by updating the **Project Coordination File**, their handoff file, and role-scoped **Project Knowledge** files (single-writer per role). The orchestrator folds those reports into the state files at checkpoint (Procedure C). This keeps the canonical narrative single-writer and free of multi-agent write contention. Awareness = read the board; canonical narrative = orchestrator writes.
- **Branch Gating**: Obtain explicit human approval before any state-changing Git operation on `master` or `main`.
- **Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory** (TIER 1), you are operating as a protocol developer on this repository itself. Before making any change to any protocol file (`AGENTS.md`, policy files, `validate-protocol.sh`, or any file under `ai/`), you MUST fully load `protocol-decisions.md` from the **Project AI Knowledge Directory** — it records authoritative past decisions and must not be treated as JIT-optional. All paths and file references written into policy files must be authored from the **end-user's project root perspective** (the directory where the user has their own project), not from this repository's internal directory structure. See the "No markdown hyperlinks in policy files" entry in `protocol-decisions.md` for the full rule.
- **Session Resume (Compacted Context)**: When a session begins from a compacted conversation summary (rather than a fresh "load context"), AI MUST run **Procedure E** immediately before responding to the user's first request. This fully loads standing rules (`ai-policy-common.md`), the Project Customization File, all Global Knowledge files, and every policy file referenced in the Project Customization File, and builds a live shell-discovered index of Project Knowledge files. If the summary indicates a module was completed without TDD or peer review, raise this gap with the user before continuing.
- **Git Workspace Detection**: Before offering git operations on the project root, scan for `.git` subdirectories within the project tree (excluding `ai/`). If any `.git` directory is found, the root is part of a larger git workspace — do not treat it as a git repo itself. Do not offer `git init`, run `git log` on the root, or propose git operations that assume the root is independently tracked. Users may also define explicit workspace rules in the **Project Customization File**.
- **Archive File Exclusion**: All `find` and `ls` commands in this protocol must exclude compressed and archive files. Use `! -name '*.tar*' ! -name '*.zip'` with `find`, or filter with `grep -v '\.tar\|\.zip'` when piping `ls` output.
- **Backup Directory Exclusion**: Never scan, list, read, or reference files inside the **Global AI Backup Directory** (`~/.ai/backups/`). Backups are user-space artifacts and are not part of the active project state.

---

## TIER 3: TRIGGERED PROCEDURES

### PROCEDURE A: When User says "load context"

**Safety Barrier**: This procedure is strictly READ-ONLY. AI is forbidden from modifying any file content during this phase.

0.  **Customization Discovery**: Check for **Project Customization File** at project root (`ai-customization.md`):
    - If found → load the `## AI Workflow Configuration` section and extract `**Global AI Workflow Directory`**. If the section is missing, inform the user and stop.
    - If the old `ai/ai-customization.md` exists instead → inform the user: "Your customization file is in the old `ai/` directory. Add a `## AI Workflow Configuration` section with a `**Global AI Workflow Directory**` entry, then move it to the project root as `ai-customization.md`." Then **stop** — do not proceed with context loading.
    - If neither exists → inform the user that the customization file is missing, show a template, explain what to configure, and optionally suggest cloning the Simple-AI-Workflow repo to `~/Projects/Simple-AI-Workflow` from its GitHub URL. Then **stop** — do not proceed with context loading.
1.  **Workflow Access**: Read `ai-policy-common.md` from the **Global AI Policies Directory**.
2.  **Structural Audit (Existence-First)**: Silently verify the existence of the mandatory directories:
    - **Project Artifacts Directory**, **Project Code Review Reports Directory**, **Project Compliance Policies Directory**, **Project Daily Checkpoints Directory**, **Project Handoffs Directory**, **Project AI Knowledge Directory**
    - **Project Notes Directory**, **Project Pending Directory**, **Project Plans Directory**, **Project AI Policies Directory**, **Project Secrets Directory**, **Project Shared Directory**
    - Global: **Global AI Settings Directory**, **Global AI Knowledge Directory**, **Global AI Backup Directory**
    Verify **Project Coordination File** exists. Only propose `mkdir -p` or file creation for **missing** items.
    Then check `.gitignore` for `ai-customization.md`. If absent, inform the user: "ai-customization.md is not in .gitignore. Add it to prevent accidental commits of your local configuration."
3.  **Discovery**: Run `ls -R` or `find` (or other OS equivalents) on **Global User AI Directory** and the project `ai/` directory to list its contents — excluding compressed and archive files per the **Archive File Exclusion** rule in TIER 2. The **Global User AI Directory** contains settings, and **Global AI Knowledge**. **Important**: `ai/` is git-ignored — use shell commands (`ls -la -R` or `find ai/`) to list its contents. **Do not skip this step**, and do not treat the directory as unreadable just because it is git-ignored.
4.  **Loading**: Read the **Project Customization File**, all discovered **Global Settings** files (from the **Global AI Settings Directory**), **Project AI State Files**, the latest checkpoint file (from **Project Daily Checkpoints Directory**), and the **Project Coordination File**; and **load their full contents into the active context**. **Global Knowledge files** (from the **Global AI Knowledge Directory**) are NOT loaded here — they are loaded in full in Step 5.
    *   **State File Proof-of-Read**: After loading **Project AI State Files**, record the line count and the most recent checkpoint identifier (`CP-YYYY-MM-DD-NN`) as read from each file's content — this serves as the date marker. The CP identifier must be consistent across all three state files and the latest checkpoint file. Do not use filesystem metadata. Do not summarise from memory — read the files fresh. If any file cannot be read, stop and report it before continuing.
5.  **Knowledge Loading**: This is a dedicated required step — do NOT merge it with Step 4.
    - **Global Knowledge** (from **Global AI Knowledge Directory**): Load the FULL TEXT of every file. This set is intentionally small, so a full load is cheap and removes the risk of the AI guessing at lessons it never read. Do NOT index-only.
    - **Project Knowledge** (from **Project AI Knowledge Directory**, including any subdirectories): Project Knowledge remains subject to **Token Rationing** — these files can be large (e.g. historical repo-scan snapshots or archives). Run a shell command (`find` or `ls -R`) to discover all filenames and record paths, filenames, and apparent technical domains as a reference index. **DO NOT** load the full text of any Project Knowledge file at boot time; load it on demand when an active task requires it.
    If a directory is completely empty, explicitly note it in your state tracking.
6.  **Policy Loading**: Scan the **Project Customization File** for the `## Active Expertise` section.
    - For each listed expertise name, try `ai-policy-<name>.md` first, then `<name>.md` as fallback.
    - Locate matching files in the **Global AI Policies Directory** using a recursive shell command (`find` or equivalent).
    - Load the FULL TEXT of every matched file.
    Do NOT defer policy loading to "on demand" — the AI cannot follow a rule it has not read.
    Then run a recursive shell command (`find` or equivalent) on **Project AI Policies Directory** to discover all `.md` files the user placed there. Load the FULL TEXT of every discovered file. These are user-created custom policies that must be loaded at boot even though they are not listed in the Project Customization File.

    > **Design note (deliberate exception to Token Rationing)**: Loading referenced policy files in full at boot is an intentional exception to the Token-Rationing principle. The cost of a few hundred lines of policy text is far lower than the cost of the AI applying wrong or missing rules because it guessed at policy content. Token Rationing still applies to large Project Knowledge files (repo-scan snapshots, historical archives) — never to the operational policy files that govern AI behaviour.
7.  **REPORT: Proof-of-Load**: Submit a detailed Markdown summary containing:
    - (a) Active Expertise modules and Traits found in customization.
    - (b) Global Settings files fully loaded from **Global AI Settings Directory** (list filenames). Global Knowledge files **fully loaded** from **Global AI Knowledge Directory** (list filenames). Policy files **fully loaded** — referenced by the Project Customization File from **Global AI Policies Directory** (list filenames), and custom policies discovered in **Project AI Policies Directory** (list filenames).
    - (c) All discovered pending handoffs in **Project Handoffs Directory**.
    - (d) Git delta check since the last hash recorded in `context.md`.
    - (e) All files **indexed** from the **Project AI Knowledge Directory** (filenames and apparent domains — not read in full), or an explicit confirmation that it was empty.
    - (f) For each **Project AI State File**: line count and most recent checkpoint identifier (`CP-YYYY-MM-DD-NN`), read fresh from file content.

### PROCEDURE B: When Repo is Empty (Bootstrap)

1.  **Execute Procedure A, Step 2** (Audit/Create directories and **Project Coordination File**).
2.  **Initialize Customization**: Create `ai-customization.md` at the project root with a `## AI Workflow Configuration` section containing a `**Global AI Workflow Directory**` entry pointing to the workflow repository. See `docs/ai-customization.md` for the template.
3.  **Initialize State Files**: Create `ai/next-steps.md`, `ai/progress.md`, `ai/context.md`, and an initial daily checkpoint.
4.  **Git Setup**: Ensure `ai/**`, `ai-customization.md`, and `AGENTS.md` are in `.gitignore`.
5.  **Finalize**: Proceed to Procedure A.

### PROCEDURE C: When performing a Checkpoint (Save State)

1.  **Update State (The Atomic Write Protocol)**: Sync **Project AI State Files**. To prevent Context Drift, you must treat these state updates as a single atomic transaction. Never update one file without immediately synchronizing the others.
    *   **Write Direction (memory → disk)**: Your active in-memory context is the freshest source of truth for what was accomplished this session. A checkpoint **serialises that fresh in-memory state into Project AI State Files** — it is a write-down, not a re-read to discover what is current. The on-disk files are the stale targets being updated.
    *   **Fresh-Read Before Write (reconcile, do NOT overwrite fresh work)**: Read the current on-disk content of **Project AI State Files** immediately before writing — but treat this as a **reconcile**, not a memory refresh. Purpose of the read: (a) preserve the append-only history in `progress.md` so a write never drops existing entries, and (b) detect drift introduced by another agent or by context condensation since you last saw the files. **Precedence**: your fresh in-memory deltas are authoritative for new or changed content; the disk read must never overwrite fresh work with a stale cached or summarised version. If disk and memory genuinely conflict on the *same* item, **stop and flag it** — do not silently pick one.
    *   **Inbound Reconcile (multi-agent)**: Before writing, also read the **Project Coordination File** and any new or updated handoffs in **Project Handoffs Directory**, so you fold in work completed by other agents since the last checkpoint. **Project AI State Files** are written by the project-root orchestrator only (see TIER 2 "State File Single-Writer Ownership"); other agents report via the coordination board, handoffs, and role-scoped Project Knowledge.
    *   **Sequential Execution Order**: Stage your changes in memory and write them to disk in this strict sequence:
        1. 📂 `ai/progress.md` (The Past): Log the completed activity, architectural decisions, or milestone reached first.
        2. 📂 `ai/next-steps.md` (The Future): Instantly pop the completed task off the backlog and append/sequence the next atomic actions.
        3. 📂 `ai/context.md` (The Present): Maintain a `## Current Status` section at the top of the file as the living dashboard for the next session. Populate it with the active branch, current milestone, key identifiers, environment state, and open questions — without duplicating completed tasks (`progress.md`) or pending task lists (`next-steps.md`). Append the completed checkpoint entry below the status section. If the entry count below `## Current Status` triggers the horizon shield threshold (Step 2), archive older entries.
    *   **Transaction Log Requirement**: Every time you save state or finish a checkpoint execution loop, append a standardized transaction summary directly into your chat output using this exact text format:
        *   [PROGRESS] Added: "[Brief description of what was completed]"
        *   [NEXT-STEPS] Removed: "[Task]" | Added: "[New immediate actionable items]"
        *   [CONTEXT] Updated: "variable_name: old_value" -> "variable_name: new_value"
    *   **Failure Mode Constraint**: If you lack the required information to accurately align all three files, abort the write transaction entirely. Halt execution, roll back the proposed memory state, and flag the missing variable to the human user.
2.  **Log Condensation (The Sliding Horizon Shield)**: To prevent long-term token bloat inside your active context window, you must actively police the size of `ai/progress.md` and the checkpoint history in `ai/context.md`.
    *   **Threshold Trigger**: If `ai/progress.md` grows to exceed 50 completed task items or 200 lines of historical text, you must perform an automated log condensation routine during this checkpoint.
    *   **Truncation Execution**: Move all entries older than the 10 most recent completions out of `ai/progress.md` and append them permanently into a historical archive file named `ai/shared/project-knowledge/progress-archive.md`. 
    *   **The Horizon Anchor**: Leave a single, high-level 3-sentence summary block titled `## Archive Horizon Context` at the absolute top of `ai/progress.md`. This summary must capture the cumulative milestones achieved in the archived history so active project continuity is never lost.
    *   **Context.md horizon**: If `ai/context.md` accumulates more than 10 historical checkpoint entries below the `## Current Status` section, keep the 5 most recent entries and move the rest to `ai/shared/project-knowledge/context-archive.md`. This bulk-archive approach prevents the one-entry-at-a-time burden.
3.  **Update Project Knowledge**: Review all work done since the last checkpoint. For any findings, decisions, or discoveries not yet written into the **Project AI Knowledge Directory**, update or create the relevant files now. This step is **mandatory** — even when no new material exists, you must explicitly confirm that the knowledge base is current before proceeding. This applies to all project types. Capture any of the following that occurred since the last checkpoint:
    - Decisions made and the rationale behind them
    - Resolved issues and their root causes
    - Investigation and research conclusions (technical findings, confirmed values, analysis outcomes)
    - New constraints, blockers, or dependencies identified
    - Key identifiers, configuration values, or reference data confirmed during the session (e.g., resource IDs, API endpoints, library versions, schema names, environment variables — **never raw secrets**)
    - Updates posted to external systems such as issue trackers, project management tools, or communication channels (include timestamp and channel)
4.  **Context Re-affirmation After Checkpoint (condition-gated)**: A checkpoint normally runs mid-session when policies and knowledge are already in context, so a blanket reload is unnecessary and wasteful. Perform a reload **only** when the active context has been condensed/compacted since the last full load, or when you are otherwise unsure the operational files are still loaded:
    - Announce: **[Re-affirming key files into context after checkpoint...]**
    - Load the FULL TEXT of `ai-policy-common.md`, all files in the **Global AI Knowledge Directory**, every policy file referenced in the **Project Customization File**, and all custom policies discovered in **Project AI Policies Directory**.
    - Run a shell `find` or `ls -R` on the **Project AI Knowledge Directory** and record the filename index from live discovery (not from memory).
    - Announce on completion: **[Context re-affirmation complete.]**
    If context is still healthy and the operational files are already loaded, skip the reload and state explicitly that it was not needed.

### PROCEDURE D: When User says "peer review" or "code review"

1.  **Adopt Reviewer Role**: Switch to Strict Peer Reviewer mode. You are now an objective reviewer — your only job is to find and report issues. Do not write or fix code. Read `ai/policies/ai-policy-code-review.md` for the full role definition and report format.
2.  **Scan**: Review the files the user specifies. If no scope is given, review all non-generated, non-dependency source files in the repository (exclude `ai/`, `tmp/`, git-ignored, and vendor/dependency files and directories).
3.  **Report**: Write the review report to **Project Code Review Reports Directory**/YYYY-MM-DD_HH-MM_review-NN.md. Follow the report format in `ai-policy-code-review.md`. End with a clear verdict: **APPROVED** or **CHANGES REQUESTED**. Never overwrite a previous report.
4.  **Iterate**: After the user applies fixes and asks for another review, create a new numbered report. Note which previous issues were resolved.
5.  **Exit**: Return to your normal role when the user says "done reviewing", when the verdict is APPROVED, or when a commit is made.

### PROCEDURE E: Post-Condensation Recovery (Auto-Triggered)

**Trigger**: Runs automatically when a session resumes from a condensed/compacted conversation summary. Before responding to the user's first message, perform this self-check:

1. Scan the beginning of the conversation for a structured multi-section summary. Look for headings such as "Conversation Summary", "What was accomplished", "Active state", "Next steps", "Conversation Overview", "Technical Foundation", "Codebase Status", or similar.
2. If such a summary exists, condensation has occurred — run this procedure **unconditionally**, regardless of what the user's first message contains. If the first message is a direct task request, run the procedure silently (suppress the report output) and then respond to the task. Do NOT skip this procedure because the first message looks operational.

**Safety Barrier**: This procedure is strictly READ-ONLY. Do not create, modify, or delete any file.

**Precedence Rule**: The condensed summary is the **sole authoritative source** for current task state, progress, and next steps. It supersedes **Project AI State Files** and checkpoints. AI MUST NOT read these state files during this procedure — not to verify, not to cross-reference, not for any reason. Reading them would inject stale pre-compaction data and silently corrupt the fresh context.

1. **Load settings from the "TIER 1: CONFIGURATION" section.**
2. **Load the Project Customization File** to restore active Traits, Expertise modules, and Development Workflow rules. This is the only customization file you may read in this procedure besides project knowledge and policies.
3. **Load standing rules and knowledge**:
    - Announce to the user: **[Reloading key files into context...]**
    - Load the FULL TEXT of `ai-policy-common.md` from the **Global AI Policies Directory** — the base common policy, always loaded unconditionally.
    - Load the FULL TEXT of every file in the **Global AI Knowledge Directory**. This set is intentionally small, so a full load is required — not index-only.
    - Load the FULL TEXT of every Global Settings file in the **Global AI Settings Directory**.
    - Load the FULL TEXT of every policy file referenced in the **Project Customization File**. Load only referenced policies — not the entire policy directory.
    - Run a recursive shell command (`find` or equivalent) on **Project AI Policies Directory** to discover all `.md` files. Load the FULL TEXT of every discovered file. These are user-created custom policies — not referenced by the customization file — that must be loaded even on recovery.
    - Run a shell command (`find` or `ls -R`) on the **Project AI Knowledge Directory** and record the complete filename list as the Project Knowledge index from live discovery — not recalled from memory. Do NOT load the full text of Project Knowledge files; some can be large repo-scan snapshots. **CRITICAL EXCEPTION**: if any file's apparent topic area relates to active environment variables, configuration states, or runtime values that conflict with the condensed conversation summary, the summary takes absolute precedence.
    - Read the **Project Coordination File** to re-establish awareness of what other agents are doing or have completed. The coordination board is **not** a state file — reading it here is required precisely because a lossy summary cannot be trusted to contain concurrent multi-agent work. The board is authoritative for *other agents'* work; for *this* agent's own in-flight task, the condensed summary still takes precedence. (**Project AI State Files** themselves remain off-limits in this procedure.)
    - Announce on completion: **[Context reload complete — N files fully loaded, M Project Knowledge files indexed.]** (substitute the actual counts).
    - **Do NOT perform structural audits, directory discovery beyond the Project Knowledge index above, or read any state files or checkpoints.** Those are off-limits for this procedure.
4. **Re-read `AGENTS.md` from disk**: Read `AGENTS.md` from the current working directory. The on-disk `AGENTS.md` is the sole authoritative source for all procedure definitions. Any protocol text embedded in the condensed summary is informational only and must not be used in place of the on-disk file.
5. **REPORT before first response**: Before addressing the user's first request, output a brief confirmation block sourced exclusively from the condensed summary and the files loaded in steps 1–4:
   - Active Traits and Expertise now loaded (source: Project Customization File)
   - Development Workflow standing rules now active (list each rule name)
   - Count of Global Knowledge files and policy files **fully loaded**, and Project Knowledge files **indexed via shell**, or explicit confirmation that the directories were empty.
   - Any gaps identified: if the condensed summary shows a module was completed without TDD or peer review, name it explicitly and ask the user how to proceed before touching any code.
   - **Do NOT reference or quote any state file content in this report.**
   - **If the first message is a direct task request**: suppress the full report but always output this one line before responding to the task: **[Reloading key files into context... done. Proceeding with task.]** If any path resolution or file load failed, report the failure instead and do NOT proceed to the task.
   
### PROCEDURE F: When the user says "backup ai", or "backup ai state"
1.  **Backup Mandate**: Run the native backup command for your OS, substituting variables for resolved absolute paths:
    - **Linux/Bash**: `tar -czf [Global AI Backup Directory]/$(basename $(dirname $(pwd)))_$(basename $(pwd))_$(date +%Y-%m-%d_%H-%M).tar.gz ai/ ai-customization.md`
    - **Windows/PS**: `Compress-Archive -Path ai/, ai-customization.md -DestinationPath "[Global AI Backup Directory]/$(Split-Path -Leaf (Split-Path -Parent $PWD))_$(Split-Path -Leaf $PWD)_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').zip"`
2.  **Reporting**: Confirm checkpoint ID and backup file path.

### PROCEDURE G: When the user says "examine this codebase" or "codebase examination"

1.  Load `ai/policies/ai-policy-codebase-examination.md` for the full role definition and four-phase workflow (Map → Plan → Perform → Reconcile).
2.  Follow the workflow defined in the policy. All Branch-Gating, TDD, and Peer Review guardrails from `ai-policy-common.md` apply.
3.  Return to normal role when the examination session concludes.

---

## TIER 4: APPENDIX (Reference & Human Setup)

### Path Format Requirements (Windows)
File-manipulation tools on Windows require absolute paths (`C:\path\to\file`).
- Git Bash POSIX: `/c/Users/` → `C:\Users\`
- WSL POSIX: `/mnt/c/Users/` → `C:\Users\`

### FOR THE HUMAN: Manual Setup
- Manually create your **Global User AI Directory** structure.
- Create a personal settings file (e.g., `global-user-settings.md`) in the `settings/` subfolder. This file holds your personal preferences, tool configurations, and cross-project context that the AI fully loads at every session start.
- **The Bootstrap Wedge**: If the AI refuses to read the protocol because it is git-ignored, tell it: *"Use the `cat` command to read AGENTS.md in the current directory and follow its protocol."*


<!-- END_IMMUTABLE_PROTOCOL -->

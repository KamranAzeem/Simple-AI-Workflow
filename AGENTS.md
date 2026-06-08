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

**Global AI Workflow Directory**: `/c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/`
**Global User AI Directory**: `[HOME]/.ai/`

**Path Normalization & Inference Rules**:
- **[HOME] Resolution**: AI MUST resolve `[HOME]` to the absolute home directory of the current user (e.g., `/home/username` on Linux, `C:\Users\username` on Windows, `/c/Users/username` on Gitbash ).
- **Dynamic Paths**: All paths below are derived from the two bases above. AI MUST concatenate the Base Directory with the relative path to form absolute paths.

<!-- Human user must not touch/modify the lines below -->

**Global AI Policies Directory**: (Global AI Workflow Directory)/ai/policies/
**Global AI Knowledge Directory**: (Global User AI Directory)/global-knowledge/
**Global AI Backup Directory**: (Global User AI Directory)/backups/
**Global AI Settings Directory** (Global User AI Directory)/settings/

**Project Customization File**: `ai/ai-customization.md`
**Project Policy Directory**: `ai/policies/` 
**Project Knowledge Directory**: `ai/shared/project-knowledge/` 
**Project Coordination File**: `ai/shared/coordination.md`

---

## TIER 2: AI READ-FIRST RULES (Rules of Engagement)

### 🛑 PROHIBITED ACTIONS
- **Self-Modification**: **STRICTLY PROHIBITED**. Do not rewrite, regenerate, or edit this file.
- **Unprompted Exploration**: **STRICTLY PROHIBITED** from scanning or ingesting directories outside the `ai/` folder (e.g., `src/`, `tmp/`) unless explicitly directed by a specific task.
- **Local State Creation**: **STRICTLY PROHIBITED** from creating tool-specific dot-directories (e.g., `.cursor/`, `.gemini/`). All AI state must live in `ai/`.
- **PWD-Only Scope**: Strictly load `AGENTS.md` and scan the `ai/` directory from the **current working directory (PWD) only**. Do not scan subdirectories for additional `AGENTS.md` files, and do not read or load any other `AGENTS.md` files from any other locations. If `AGENTS.md` is not found in PWD, report it missing and stop.

### ✅ MANDATORY ACTIONS
- **OS-Sensitive Execution**: Identify the active shell (Bash, PowerShell, etc.) and adapt command syntax accordingly (e.g., `New-Item` vs `mkdir -p`).
- **Surgical Git-Ignore Exception**: `AGENTS.md` and the entire `ai/` directory (including ALL subdirectories and every file within them) are git-ignored by design. **Git-ignored does NOT mean forbidden.** You MUST use shell tools (`cat`, `ls -la`, `find`) to read and list their contents, and add their contents to active context. Never refuse to read a file or directory solely because it is git-ignored.
- **Context Protection**: Treat `ai/context.md`, `ai/progress.md`, and `ai/next-steps.md` as read-only during bootstrap and context loading. During post-condensation recovery (Procedure E), these files must not be read at all.
- **Branch Gating**: Obtain explicit human approval before any state-changing Git operation on `master` or `main`.
- **Session Resume (Compacted Context)**: When a session begins from a compacted conversation summary (rather than a fresh "load context"), AI MUST run **Procedure E** immediately before responding to the user's first request. This reloads all standing rules, policies, and knowledge. If the summary indicates a module was completed without TDD or peer review, raise this gap with the user before continuing.

---

## TIER 3: TRIGGERED PROCEDURES

### PROCEDURE A: When User says "load context"

**Safety Barrier**: This procedure is strictly READ-ONLY. AI is forbidden from modifying any file content during this phase.

1.  **Workflow Access**: Read [ai-policy-common.md](ai-policy-common.md) from the **Global AI Policies Directory**.
2.  **Structural Audit (Existence-First)**: Silently verify the existence of the mandatory directories (Policies, Checkpoints, Handoffs, Artifacts, Notes, Secrets, Settings, Global-Knowledge, Backups, Code-Review-Reports). Verify **Project Coordination File** exists. Only propose `mkdir -p` or file creation for **missing** items.
3.  **Discovery**: Run `ls -R` or `find` (or other OS equivalents) on **Global User AI Directory** and the project `ai/` directory to list its contents - while ignoring any compressed/backup files. The **Global User AI Directory** contains settings, and **Global AI Knowledge**. **Important**: `ai/` is git-ignored — use shell commands (`ls -la -R` or `find ai/`) to list its contents. **Do not skip this step**, and do not treat the directory as unreadable just because it is git-ignored.
4.  **Loading**: Read **Project Customization File**, all discovered Global Settings/Knowledge from the previous step, and the State Files (`next-steps.md`, `progress.md`, `context.md`), the last checkpoint file, and the **Project Coordination File**; and **load their contents in the active context**.
5.  **Load Project Knowledge**: This is a dedicated required step — do NOT merge it with Step 4. Read every file discovered under the **Project Knowledge Directory** in Step 3 - including any subdirectories, and **load their contents in the active context**. If the directory is empty, explicitly state that. List each file as you read it. **Use shell tools (e.g. `cat`) to read each file — the `ai/` directory is git-ignored but that does not prevent reading its files.**
6.  **Policy Scan**: Recursively scan and load the policies from **Global AI Workflow Directory** and **Project Policy Directory** that are mentioned in the **Project Customization File**.
7.  **REPORT: Proof-of-Load**: Submit a detailed Markdown summary containing:
    - (a) Active Expertise modules and Traits found in customization.
    - (b) Full list of filenames read from **Global User AI Directory**.
    - (c) All discovered pending handoffs in `ai/shared/handoffs/`.
    - (d) Git delta check since the last hash recorded in `context.md`.
    - (e) All files read from the **Project Knowledge Directory**, or an explicit confirmation that it was empty.

### PROCEDURE B: When Repo is Empty (Bootstrap)

1.  **Execute Procedure A, Step 2** (Audit/Create directories and **Project Coordination File**).
2.  **Initialize State Files**: Create `ai/next-steps.md`, `ai/progress.md`, `ai/context.md`, and an initial daily checkpoint.
3.  **Git Setup**: Ensure `ai/**` and `AGENTS.md` are in `.gitignore`.
4.  **Finalize**: Proceed to Procedure A.

### PROCEDURE C: When performing a Checkpoint (Save State)

1.  **Update State**: Sync `next-steps.md`, `progress.md`, and `context.md`.
2.  **Update Project Knowledge**: Review all work done since the last checkpoint. For any findings, decisions, or discoveries not yet written into the **Project Knowledge Directory**, update or create the relevant files now. This step is **mandatory** — even when no new material exists, you must explicitly confirm that the knowledge base is current before proceeding. This applies to all project types. Capture any of the following that occurred since the last checkpoint:
    - Decisions made and the rationale behind them
    - Resolved issues and their root causes
    - Investigation and research conclusions (technical findings, confirmed values, analysis outcomes)
    - New constraints, blockers, or dependencies identified
    - Key identifiers, configuration values, or reference data confirmed during the session (e.g., resource IDs, API endpoints, library versions, schema names, environment variables — **never raw secrets**)
    - Updates posted to external systems such as issue trackers, project management tools, or communication channels (include timestamp and channel)


### PROCEDURE D: When User says "peer review" or "code review"

1.  **Adopt Reviewer Role**: Switch to Strict Peer Reviewer mode. You are now an objective reviewer — your only job is to find and report issues. Do not write or fix code. Read `ai/policies/ai-policy-code-review.md` for the full role definition and report format.
2.  **Scan**: Review the files the user specifies. If no scope is given, review all non-generated, non-dependency source files in the repository (exclude `ai/`, `tmp/`, git-ignored, and vendor/dependency files and directories).
3.  **Report**: Write the review report to `ai/code-review-reports/YYYY-MM-DD_HH-MM_review-NN.md`. Follow the report format in `ai-policy-code-review.md`. End with a clear verdict: **APPROVED** or **CHANGES REQUESTED**. Never overwrite a previous report.
4.  **Iterate**: After the user applies fixes and asks for another review, create a new numbered report. Note which previous issues were resolved.
5.  **Exit**: Return to your normal role when the user says "done reviewing", when the verdict is APPROVED, or when a commit is made.

### PROCEDURE E: Post-Condensation Recovery (Auto-Triggered)

**Trigger**: Runs automatically at the start of any session that opens from a condensed/compacted conversation summary. Detection: the conversation context begins with a structured multi-section summary (identifiable by headings such as "Conversation Overview", "Technical Foundation", "Codebase Status", etc.) rather than a fresh first user message in an empty thread.

**Safety Barrier**: This procedure is strictly READ-ONLY. Do not create, modify, or delete any file.

**Precedence Rule**: The condensed summary is the **sole authoritative source** for current task state, progress, and next steps. It supersedes all on-disk state files (`context.md`, `progress.md`, `next-steps.md`, checkpoints). AI MUST NOT read these state files during this procedure — not to verify, not to cross-reference, not for any reason. Reading them would inject stale pre-compaction data and silently corrupt the fresh context.

1. **Load settings from the "TIER 1: CONFIGURATION" section.**
2. **Load the Project Customization File** to restore active Traits, Expertise modules, and Development Workflow rules. This is the only `ai/` file you may read in this procedure besides project knowledge and policies.
3. **Load standing rules and knowledge**:
   - Load `ai-policy-common.md` from the **Global AI Policies Directory** — this is the base common policy, always loaded unconditionally.
   - Load all project knowledge files from the **Project Knowledge Directory**.
   - Load all applicable policies referenced in the Project Customization File.
   - **Do NOT perform structural audits, directory discovery, or read any state files or checkpoints.** Those are off-limits for this procedure.
4. **REPORT before first response**: Before addressing the user's first request, output a brief confirmation block sourced exclusively from the condensed summary and the files loaded in steps 1–3:
   - Active Traits and Expertise now loaded (source: Project Customization File)
   - Development Workflow standing rules now active (list each rule name)
   - Count of project knowledge files loaded, or explicit confirmation that the directory was empty
   - Any gaps identified: if the condensed summary shows a module was completed without TDD or peer review, name it explicitly and ask the user how to proceed before touching any code.
   - **Do NOT reference or quote any state file content in this report.**

### PROCEDURE F: When the user says "backup ai", or "backup ai state"
1.  **Backup Mandate**: Run the native backup command for your OS, substituting variables for resolved absolute paths:
    - **Linux/Bash**: `tar -czf [Global AI Backup Directory]/$(basename $(dirname $(pwd)))_$(basename $(pwd))_$(date +%Y-%m-%d_%H-%M).tar.gz ai/`
    - **Windows/PS**: `Compress-Archive -Path ai/ -DestinationPath "[Global AI Backup Directory]/$(Split-Path -Leaf (Split-Path -Parent $PWD))_$(Split-Path -Leaf $PWD)_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').zip"`
2.  **Reporting**: Confirm checkpoint ID and backup file path.
---

## TIER 4: APPENDIX (Reference & Human Setup)

### Path Format Requirements (Windows)
File-manipulation tools on Windows require absolute paths (`C:\path\to\file`).
- Git Bash POSIX: `/c/Users/` → `C:\Users\`
- WSL POSIX: `/mnt/c/Users/` → `C:\Users\`

### FOR THE HUMAN: Manual Setup
- Manually create your **Global User AI Directory** structure.
- Copy `docs/about-human.md` and `docs/tools-preferences.md` to the `settings/` subfolder.
- **The Bootstrap Wedge**: If the AI refuses to read the protocol because it is git-ignored, tell it: *"Use the `cat` command to read AGENTS.md in the current directory and follow its protocol."*


<!-- END_IMMUTABLE_PROTOCOL -->

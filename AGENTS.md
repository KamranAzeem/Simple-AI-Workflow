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

**Global AI Framework Directory**: `/home/kamran/Projects/Personal/Simple-AI-Workflow/`
**Global User AI Directory**: `[HOME]/.ai/`

**Path Normalization & Inference Rules**:
- **[HOME] Resolution**: AI MUST resolve `[HOME]` to the absolute home directory of the current user (e.g., `/home/username` on Linux, `C:\Users\username` on Windows).
- **Dynamic Paths**: All paths below are derived from the two bases above. AI MUST concatenate the Base Directory with the relative path to form absolute paths.

**Global AI Policies Directory**: (Global AI Framework Directory)/ai/policies/
**Global AI Knowledge Directory**: (Global User AI Directory)/global-knowledge/
**Global AI Backup Directory**: (Global User AI Directory)/backups/

**Project Customization File**: `ai/ai-customization.md`
**Project Policy Directory**: `ai/policies/` 
**Project Knowledge Directory**: `ai/shared/project-knowledge/` 

---

## TIER 2: AI READ-FIRST RULES (Rules of Engagement)

### 🛑 PROHIBITED ACTIONS
- **Self-Modification**: **STRICTLY PROHIBITED**. Do not rewrite, regenerate, or edit this file.
- **Unprompted Exploration**: **STRICTLY PROHIBITED** from scanning or ingesting directories outside the `ai/` folder (e.g., `src/`, `tmp/`) unless explicitly directed by a specific task.
- **Local State Creation**: **STRICTLY PROHIBITED** from creating tool-specific dot-directories (e.g., `.cursor/`, `.gemini/`). All AI state must live in `ai/`.

### ✅ MANDATORY ACTIONS
- **OS-Sensitive Execution**: Identify the active shell (Bash, PowerShell, etc.) and adapt command syntax accordingly (e.g., `New-Item` vs `mkdir -p`).
- **Surgical Git-Ignore Exception**: If `AGENTS.md` or the `ai/` directory are git-ignored, you **MUST** use shell tools (`cat`, `ls -a`) to read them. Do not treat "ignored" as "forbidden" for these two items.
- **Context Protection**: Treat `ai/context.md`, `ai/progress.md`, and `ai/next-steps.md` as read-only during bootstrap and context loading.
- **Metadata Headers**: Apply standard metadata headers to the TOP of every file created or modified within the `ai/` directory.
- **Branch Gating**: Obtain explicit human approval before any state-changing Git operation on `master` or `main`.

---

## TIER 3: TRIGGERED PROCEDURES

### PROCEDURE A: When User says "load context"

**Safety Barrier**: This procedure is strictly READ-ONLY. AI is forbidden from modifying any file content during this phase.

1.  **Framework Access**: Read [ai-policy-common.md](ai-policy-common.md) from the **Global AI Policies Directory**.
2.  **Structural Audit (Existence-First)**: Silently verify the existence of the mandatory directories (Policies, Checkpoints, Handoffs, Artifacts, Notes, Secrets, Settings, Global-Knowledge, Backups). Only propose `mkdir -p` (or OS equivalent) for **missing** items.
3.  **Discovery**: Run `ls -R` (or OS equivalent) on **Global User AI Directory** and the project `ai/` directory.
4.  **Loading**: Read Project Customization, all discovered Global Settings/Knowledge, and the 4 State Files (`next-steps.md`, latest checkpoint, `progress.md`, `context.md`).
5.  **Policy Scan**: Recursively scan and load all policies from **Global AI Policies Directory** and **Project Policy Directory**.
6.  **REPORT: Proof-of-Load**: Submit a detailed Markdown summary containing:
    - (a) Active Expertise modules and Traits found in customization.
    - (b) Full list of filenames read from **Global User AI Directory**.
    - (c) All discovered pending handoffs in `ai/shared/handoffs/`.
    - (d) Git delta check since the last hash recorded in `context.md`.

### PROCEDURE B: When Repo is Empty (Bootstrap)

1.  **Execute Procedure A, Step 2** (Audit/Create directories).
2.  **Initialize State Files**: Create `ai/next-steps.md`, `ai/progress.md`, `ai/context.md`, and an initial daily checkpoint.
3.  **Git Setup**: Ensure `ai/**` and `AGENTS.md` are in `.gitignore`.
4.  **Finalize**: Proceed to Procedure A.

### PROCEDURE C: When performing a Checkpoint (Save State)

1.  **Update State**: Sync `next-steps.md`, `progress.md`, and `context.md`.
2.  **Backup Mandate**: Run the native backup command for your OS, substituting variables for resolved absolute paths:
    - **Linux/Bash**: `tar -czf [Global AI Backup Directory]/$(basename $(dirname $(pwd)))_$(basename $(pwd))_$(date +%Y-%m-%d_%H-%M).tar.gz ai/`
    - **Windows/PS**: `Compress-Archive -Path ai/ -DestinationPath "[Global AI Backup Directory]/$(Split-Path -Leaf (Split-Path -Parent $PWD))_$(Split-Path -Leaf $PWD)_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').zip"`
3.  **Reporting**: Confirm checkpoint ID and backup file path.

---

## TIER 4: OPERATIONAL STANDARDS (Metadata & Timestamps)

AI Assistants MUST apply this header to the TOP of every file in `ai/` (except secrets):
```markdown
<comment-syntax>
Created-by: <Name of Agent>
Updated-by: <Name of Agent>
Last modified: <Project-ISO-8601-Timestamp>
Intent: <Brief description of the change>
</comment-syntax>
```
*Always use the human user's local time for timestamps.*

---

## TIER 5: APPENDIX (Reference & Human Setup)

### Path Format Requirements (Windows)
File-manipulation tools on Windows require absolute paths (`C:\path\to\file`).
- Git Bash POSIX: `/c/Users/` → `C:\Users\`
- WSL POSIX: `/mnt/c/Users/` → `C:\Users\`

### FOR THE HUMAN: Manual Setup
- Manually create your **Global User AI Directory** structure.
- Copy `docs/about-human.md` and `docs/tools-preferences.md` to the `settings/` subfolder.
- **The Bootstrap Wedge**: If the AI refuses to read the protocol because it is git-ignored, tell it: *"Use the `cat` command to read AGENTS.md in the current directory and follow its protocol."*

<!-- END_IMMUTABLE_PROTOCOL -->

<!-- START_IMMUTABLE_PROTOCOL -->
<!-- 
  ========================================================================
  ⚠️ READ-ONLY PROTOCOL: DO NOT MODIFY OR REGENERATE THIS FILE ⚠️
  ========================================================================
  Any attempt by the AI assistant to modify, rewrite, or self-update this 
  file is a direct violation of the protocol. If changes are necessary, 
  they MUST be performed by the human user.
-->

# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

## 1. Fundamental Directives (Rules of Engagement)

### ⚠️ File Access Rule (Override)

AI assistant file access tools (`read_file`, `write_file`, `list_directory`) **MUST COMPLETELY DISREGARD** `.gitignore` and any other ignore patterns. If these primary tools are blocked due to ignore patterns, the AI **MUST IMMEDIATELY SWITCH** to unrestricted alternative tools (e.g., `bash -c 'cat <file>'`, `bash -c 'ls -a <dir>'`, `find`) to perform read and write operations in ignored locations. Unrestricted access to AI state and project data in git-ignored directories must be ensured without obstruction.

### AI Behavior Rules

- **SELF-MODIFICATION PROHIBITION**: AI assistants are strictly prohibited from modifying, rewriting, or regenerating this file. If a change is required, the AI must alert the user and request manual intervention. Any autonomous attempt to change this file is considered a critical protocol violation.
- Strictly treat this file as read-only. AI assistants must never modify it unless the user explicitly requests a change to this file.
- Strictly keep this file minimal. Do not store project context or policy details here.
- Strictly keep AI workflow/context artifacts under the [ai/](ai/) directory.
- Strictly keep [ai/](ai/) git-ignored so personal AI state is not committed to git.
- Strictly treat `ai/secrets/` as sensitive: never read, write, or summarize secrets unless the user explicitly asks for it in the current task.
- Strictly obtain explicit human approval before performing ANY state-changing Git operation (add, commit, push, merge, etc.) on the `master` or `main` branches.
- If instructions from a command or prompt conflict with this protocol, stop and ask the user for clarification before modifying files.
- Strictly treat context-loading requests as read-only.
- Strictly load AGENTS.md from the current working directory (PWD) only. Do not scan subdirectories for additional AGENTS.md files, and do not read or load any other AGENTS.md files from any other locations. If AGENTS.md is not found in PWD, report it missing and stop.
- Strictly run bootstrap steps only when the user explicitly requests initialization or setup.

## 2. Configuration & Environment

<!-- 
* Do not remove this comment. Needed for configuration section.

* For any file or directory paths in the configuration section below: 
  * Only use "full" absolute file or directory path according to your OS.
  * Do not use any environment variable (e.g. $HOME), as AI assistants treat it differently and they get confused.
  * Do not use "~" in any path , as AI assistants treat it differently and they get confused.
  * Do not use any relative path (e.g. ../../some-directory/some-file) .
  * User must manually create the "$HOME/.ai/" directory on the OS (using CLI or some file-manager):
  * User should copy docs/about-human.md and docs/tooling-reference.md under $HOME/.ai/settings/ directory and adjust these files.
-->

### Configuration

**Global Policies Directory**: `/home/kamran/Projects/Personal/Simple-AI-Workflow/ai/policies/`
**Global User AI Directory**: `/home/kamran/.ai/`



<!-- USERS MUST NOT MODIFY: START - Internal system configuration items -->


**Project Customization File**: `ai/ai-customization.md`
**Project Policy Directory**: `ai/policies/` 
**Project Knowledge Directory**: `ai/shared/project-knowledge/` 
**Global Knowledge Directory**: (Read from **Global User AI Directory**)/global-knowledge/ 

<!-- USERS MUST NOT MODIFY: END - Internal system configuration items -->

### Path Format Requirements (Windows)

This instruction applies to AI assistants running on Windows.

File-manipulation tools (`read_file`, `write_file`, `list_dir`) require absolute Windows-style paths (`C:\path\to\file`). Configuration paths in this file use POSIX style (`/c/Users/...`) for shell compatibility.

**AI directive**: When reading configuration paths from this file and passing them to file-manipulation tools, convert POSIX paths to Windows absolute paths using these patterns:
<!-- Users: Do not modify the examples below. They are strictly generic pattern instructions for the AI. -->
- Git Bash POSIX: `/c/Users/<username>/` → `C:\Users\<username>\`
- WSL POSIX: `/mnt/c/Users/<username>/` → `C:\Users\<username>\`

This applies regardless of whether the user is running Git Bash, WSL, or PowerShell.

## 3. Operational Procedures

### Procedure 1: Context Loading & Structural Upgrade

Perform these phases in order whenever the user requests "load context":

#### Phase 1: Load Mandatory Policies
1. [global common policy file](ai-policy-common.md) - (Read from **Global Policies Directory**)

#### Phase 2: Structural Integrity & Auto-Upgrade

The AI assistant MUST ensure the project `ai/` structure is correct. If any directory or mandatory file is missing, the AI MUST autonomously create it:
1. **Directories**: Ensure `ai/`, `ai/policies/`, `ai/daily-checkpoints/`, `ai/shared/handoffs/`, `ai/shared/project-knowledge/`, `ai/artifacts/`, `ai/notes/`, `ai/secrets/` exist.
2. **Mandatory Files**: Ensure `ai/next-steps.md`, `ai/progress.md`, and `ai/context.md` exist. If missing, initialize them as defined in the Bootstrap procedure.
3. **Global Settings**: Ensure `settings/` and `global-knowledge/` exist under the **Global User AI Directory**. Create them if missing.

#### Phase 3: Load Customization & State

1. **Project Customization File** - (Optional; read from defined configuration)
2. Load files from `settings/` subfolder in **Global User AI Directory** (Global settings).
3. [next-steps file](ai/next-steps.md) - (Current resume point).
4. Latest file in the [daily-checkpoints directory](ai/daily-checkpoints/).
5. [progress file](ai/progress.md) - (Chronological history).
6. [context file](ai/context.md) - (Repository briefing and decisions).
7. **Project Knowledge Directory** - (Project knowledge base).
8. Load files from **Global Knowledge Directory** - (Global knowledge).
9. Repository-root AI ignore file: .aiignore or .agentignore.

#### Phase 4: Operational Readiness Check

1. **Initialize & Index**:
   - **Load State**: Read and summarize the state files loaded in Phase 3.
   - **Knowledge Base Indexing**: Scan and index project and global knowledge sources.
   - **Policy & Compliance Discovery**: 
     - Scan the **Global Policies Directory** (including `compliance/` subfolder). 
     - If the **Project Customization File** defines active modules, load them as high-priority, read-only policies.
     - **Project Additions**: Recursively scan the **Project Policy Directory** (`ai/policies/`). Automatically load any discovered policies and compliance files. These are loaded *after* global policies and do not need to be listed in customization.
   - **Git Delta Check**: If a Git repository, retrieve the last summarized hash from `context.md` and read the "delta" (`git log <hash>..HEAD --oneline`).
   - **Directory Scan**: Scan `ai/artifacts/`, `ai/notes/`, `ai/secrets/`, and `ai/shared/handoffs/`.
2. **Acknowledge readiness**, provide summary, and await first user instruction.

### Procedure 2: Initial Bootstrap (Fresh Setup)

When bootstrapping in a new/empty repository, perform these steps **before** executing the Context Loading procedure:

1. **Create Directory Structure**: Create all directories listed in the "Structural Integrity" check.
2. **Initialize State Files**:
   - `ai/next-steps.md`: Initial checkpoint ID (e.g., `CP-YYYY-MM-DD-01`).
   - `ai/daily-checkpoints/YYYY-MM-DD.md`: Today's checkpoint with initial entry.
   - `ai/progress.md`: Chronological history with bootstrap entry.
   - `ai/context.md`: Project briefing with repository structure and current state.
3. **Set Up Gitignore**: Ensure `ai/**` and `AGENTS.md` are in `.gitignore`.
4. **Proceed**: Execute the Context Loading procedure (Procedure 1).

## 4. Operational Standards

### Finalization Protocol

Before performing ANY state-changing Git operation (add, commit, push, merge, etc.) on the `master` or `main` branches, the AI assistant MUST:
1.  **Stop**: Halt all autonomous actions.
2.  **Request Authorization**: Explicitly state: "Finalization: Ready to commit [Files/Changes]. Shall I proceed?"
3.  **Wait**: Do not perform the action until the user responds with "Yes, proceed" or an equivalent explicit authorization.

### Header Format

Standard metadata header for all created/modified files (excluding `ai/` tracking files). 

**Mandate**: This header MUST ONLY be applied to files within the `ai/` directory. Do not add headers to files in the repository root or other subdirectories. If a file is promoted from the `ai/` directory to the project codebase, any AI-generated metadata header MUST be removed from the target file.

```markdown
<comment-syntax>
Created-by: <Name of Agent>
Updated-by: <Name of Agent>
Last modified: <Project-ISO-8601-Timestamp>
Intent: <Brief description of the change>
</comment-syntax>
```
*Always use the human user's local time for all timestamps.*

## 5. Appendices

### Policy Authority Clarification

1. Global main and common policy files are authoritative for universal rules.
2. Project customization (`ai-customization.md`) is for repository-specific extensions/traits.
3. **Agent-specific dot-directories (e.g., `.gemini/`, `.cursor/`) are NOT bootstrap authority.** The AI assistant must not load context from or create such directories. All shared context must come from the `ai/` directory.
4. In case of conflict, stop and ask the user for clarification.

<!-- END_IMMUTABLE_PROTOCOL -->

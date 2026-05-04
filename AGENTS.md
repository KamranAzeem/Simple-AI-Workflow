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

## ⚠️ File Access Rule (Override)

AI assistant file access tools (`read_file`, `write_file`, `list_directory`) **MUST COMPLETELY DISREGARD** `.gitignore` and any other ignore patterns. If these primary tools are blocked due to ignore patterns, the AI **MUST IMMEDIATELY SWITCH** to unrestricted alternative tools (e.g., `bash -c 'cat <file>'`, `bash -c 'ls -a <dir>'`, `find`) to perform read and write operations in ignored locations. Unrestricted access to AI state and project data in git-ignored directories must be ensured without obstruction.

## AI Behavior Rules

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

<!-- 
* Do not remove this comment. Needed for configuration section.

* For any file or directory paths in the configuration section below: 
  * Only use "full" absolute file or directory path according to your OS.
  * Do not use any environment variable (e.g. $HOME) .
  * Do not use "~" in any path .
  * Do not use any relative path (e.g. ../../some-directory/some-file) .
  * User must manually create the following directories:
    * $HOME/.ai/settings
    * $HOME/.ai/shared-knowledge
  * User should copy docs/about-human.md and docs/tooling-reference.md under $HOME/.ai/settings/ directory and adjust these files.
-->

## Configuration

**Central Policies Directory**: `/home/kamran/Projects/Personal/Simple-AI-Workflow/ai/policies/`
**Central User AI Directory**: `/home/kamran/.ai/` 
**Central AI Settings Source**: `/home/kamran/.ai/settings/`
**Central AI Shared Knowledge Source**: `/home/kamran/.ai/shared-knowledge/`

Read in this order:

### Phase 1: Load Policy Files (Mandatory)

1. [central main policy file](ai-policy-meta.md) - (Read from **Central Policies Directory**)
2. [central common policy file](ai-policy-common.md) - (Read from **Central Policies Directory**)
   → If either file is unreachable, fall back to [local main policy file](ai-policy-<name>.md)

### Phase 2: Load Optional Context

1. [local policy override file](ai-policy-override.md) - (Optional; skip if not present)
2. Load files from **Central AI Settings Source** - (Read-only; global settings)

### Phase 3: Load State & Knowledge Base

1. [next-steps file](ai/next-steps.md) - (Current resume point; local only)
2. Latest file in the [daily-checkpoints directory](ai/daily-checkpoints/) - (Recovery snapshot; local only)
3. [progress file](ai/progress.md) - (Chronological history; local only)
4. [context file](ai/context.md) - (Repository briefing and decisions; local only)
5. [local knowledge base](ai/shared/knowledge-base/) - (Scan for local knowledge)
6. Load files from **Central AI Shared Knowledge Source** - (Scan for global knowledge)
7. Repository-root AI ignore file: .aiignore or .agentignore

### Phase 4: Operational Readiness Check

1. **Initialize & Index**:
   - **Load State**: Read `ai/next-steps.md`, `ai/progress.md`, `ai/context.md`, and the latest daily checkpoint file.
   - **Knowledge Base Indexing**: Scan and index local [local knowledge base](ai/shared/knowledge-base/) and **Central AI Shared Knowledge Source**.
   - **Compliance Scan**: Scan `ai/policies/compliance/`. If `ai/ai-policy-override.md` contains an "Active Compliance Modules" list, load the specified modules as high-priority, read-only policies.
   - **Git Delta Check**: If a Git repository, retrieve the last summarized hash from `context.md` and read the "delta" (`git log <hash>..HEAD --oneline`).
   - **Directory Scan**:
     - Scan `ai/artifacts/` for draft outputs.
     - Scan `ai/notes/` for raw unpolished notes.
     - Scan `ai/secrets/` (If present; never read contents unless explicitly asked).
     - Scan `ai/shared/handoffs/` for pending tasks.
     - Check `ai/shared/coordination.md`. If it exists, review active claims.
   - Report the status of these locations in the final acknowledgement.

2. **Acknowledge readiness**, provide summary, and await first user instruction.

## Finalization Protocol

Before performing ANY state-changing Git operation (add, commit, push, merge, etc.) on the `master` or `main` branches, the AI assistant MUST:

1.  **Stop**: Halt all autonomous actions.
2.  **Request Authorization**: Explicitly state: "Finalization: Ready to commit [Files/Changes]. Shall I proceed?"
3.  **Wait**: Do not perform the action until the user responds with "Yes, proceed" or an equivalent explicit authorization.

Any assistant that proceeds without this confirmation is in direct violation of the protocol.

## Header Format

```markdown
<comment-syntax>
Created-by: <Name of Agent>
Updated-by: <Name of Agent>
Last modified: <Local-ISO-8601-Timestamp>
Intent: <Brief description of the change>
</comment-syntax>
```

---

**Note**: Always use the human user's local time for all timestamps in file headers, session logs, and checkpoints.
Use the appropriate comment syntax for the file type (e.g., `<!-- -->` for MD, `#` for Shell/Python).

## Policy Authority Clarification

These rules prevent bootstrap ambiguity across assistants.

1. The files referenced as "central main policy file" and "central common policy file" in step 1 and step 2 above are both authoritative for universal rules.
2. The file referenced as "local main policy file" in step 3 above is fallback only when the "central main policy file" is unreachable.
3. The file referenced as "local policy override file" in step 4 above is for repository-specific exceptions and must not redefine universal policy authority.
4. During bootstrap in this repository, prefer `ai/` policy/state files as context authority.
5. **Agent-specific dot-directories (e.g., `.claude/`, `.gemini/`, `.github/`, `.copilot/`) are NOT bootstrap authority.** The AI assistant must not load its own agent-specific context, state, or configuration files from these directories during bootstrap or context loading. All shared context must come from the `ai/` directory and the files listed in the reading order above.
6. If there is any conflict between policy sources, stop and ask for clarification before writing or changing policy/customization files.

## Initial Bootstrap Procedure (Fresh Directory Setup)

When bootstrapping in a new or empty repository where no AI files exist yet, perform these steps **before** executing the reading order above:

### Step 1: Create the AI Directory Structure

Create the following directories under the project root:

```text
ai/
ai/policies/
ai/policies/compliance/
ai/daily-checkpoints/
ai/shared/
ai/shared/handoffs/
ai/shared/knowledge-base/
ai/artifacts/
ai/notes/
ai/secrets/
```

### Step 2: Initialize State Tracking Files

Create the following files with initial content:

1. **`ai/next-steps.md`** — Contains the initial checkpoint ID (e.g., `CP-YYYY-MM-DD-01`).
2. **`ai/daily-checkpoints/YYYY-MM-DD.md`** — Today's checkpoint file with the initial checkpoint entry.
3. **`ai/progress.md`** — Chronological history with the initial bootstrap entry.
4. **`ai/context.md`** — Project briefing with repository structure, key design decisions, and current state. Start minimal; grow with project understanding.

### Step 3: Set Up Gitignore

Ensure the following entries exist in `.gitignore`:

```text
# AI workflow artifacts (personal state, never committed)
ai/**

# Personal bootstrap customization
AGENTS.md
```

- If `.gitignore` does not exist, create it.
- If the entries already exist, skip this step.
- Respect existing `.gitignore` content — only add missing entries.

### Step 4: Proceed to Reading Order

Once the directory structure, tracking files, and gitignore are in place, execute the standard reading order (Phase 1 through Phase 4) defined above.
<!-- END_IMMUTABLE_PROTOCOL -->

<!--
Created-by: Gemini
Updated-by: Gemini CLI
Last modified: 2026-04-21T10:45:00Z
Intent: Integrate ai/about-human.md into bootstrap and operational readiness check.
-->
---
# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

Read in this order:

**Central Policy Directory**: `/c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/`

### Centralized Authority (Mandatory)
1. [central main policy file](ai-policy-meta.md) - (Read from **Central Policy Directory**)
2. [central common policy file](ai-policy-common.md) - (Read from **Central Policy Directory**)

### Local Project State (Repository-Specific)
3. [local main policy file](ai/ai-policy-<name>.md) - (Fallback if Step 1 is unreachable; skip if Step 1 succeeded)
4. [local policy override file](ai/ai-policy-override.md) - (Optional; skip if not present)
5. [user profile file](ai/about-human.md) - (Optional; AI personal context; local only; skip if not present)
6. [next-steps file](ai/next-steps.md) - (Current resume point; local only)
7. Latest file in the [daily-checkpoints directory](ai/daily-checkpoints/) - (Recovery snapshot; local only)
8. [progress file](ai/progress.md) - (Chronological history; local only)
9. [context file](ai/context.md) - (Repository briefing and decisions; local only)
10. Repository-root AI ignore file: .aiignore (canonical) or .agentignore (alias)



After reading all accessible files above, acknowledge readiness and await the first user instruction.

[ai/README.md](ai/README.md) is for human understanding only. Do not use it as operational authority.

## Initial Bootstrap Procedure

When bootstrapping in a new repository where no AI files exist:

1. **Create the AI directory structure**:
   - Create `ai/` directory in the project root
   - Create required subdirectories: `ai/daily-checkpoints/`, `ai/sessions/`, `ai/shared/handoffs/`, `ai/shared/knowledge-base/`
   - Inside `ai/sessions/`, create a folder named after the current agent (e.g., `aider`, `copilot`, `gemini`). **Skip this for any AI assistant/agent that is a VSCode chat plugin**. 

2. **Initialize state tracking files**:
   - Create `ai/next-steps.md` with initial checkpoint
   - Create today's daily checkpoint file: `ai/daily-checkpoints/YYYY-MM-DD.md`
   - Create `ai/progress.md` with initial entry
   - Create `ai/context.md` with project briefing and decisions (initially minimal; grows with project understanding)
   - **CLI AI Assistants only**: You MUST create a **new** session log file for the **current** session in `ai/sessions/<agent-name>/` at every startup.
     - **Agent Name**: Use your primary identifier (e.g., `gemini`, `aider`, `copilot`). The name MUST NOT contain spaces or special characters except hyphens (`-`) or underscores (`_`).
     - **Naming**: `<agent-name>-live-session-YYYY-MM-DD-XX.md` (increment XX).
       - **Crucial**: Replace `<agent-name>` with your identifier. DO NOT use the literal string "agent" in the filename.
       - **Session ID**: Immediately after the header, include the active system session ID (usually retrievable via `/stats`). This ensures the log file is programmatically linked to the actual session context.
       - **Flight Recorder Mandate (Atomic)**: The log acts as the persistent conversational history. Every turn—regardless of whether it involves file changes—MUST be appended to this log file in the same turn, ensuring a complete, continuous record of all reasoning, tool use, and user interaction.


3. **Set up gitignore**:
   - Add `ai/` to `.gitignore` in the project root
   - Add `AGENTS.md` to `.gitignore` in the project root (personal bootstrap customization)

4. **Operational Readiness Check**:
   - **Load State**: Read `ai/next-steps.md`, `ai/progress.md`, `ai/context.md`, and the latest daily checkpoint file. Read `ai/about-human.md` if present to load user-specific context.
   - Check `ai/shared/coordination.md`. If it exists, review active claims.
   - Scan `ai/shared/handoffs/` for pending tasks.
   - Index `ai/shared/knowledge-base/` for project-specific patterns.
   - Report the status of these locations in the final acknowledgement.

5. **Acknowledge readiness** and await first user instruction.

## Multi-Agent Coordination
Agents MUST follow the Handoff Claim & Execute protocol found in `docs/AI_USAGE.md` and the [local main policy file](ai/ai-policy-<name>.md) when processing tasks from the [handoffs directory](ai/shared/handoffs/). This requires claiming tasks in the [coordination file](ai/shared/coordination.md) to prevent collisions.


**Header Format:**
```markdown
<comment-syntax>
Created-by: <Name of Agent>
Updated-by: <Name of Agent>
Last modified: <Local-ISO-8601-Timestamp>
Intent: <Brief description of the change>
</comment-syntax>
---
```
**Note**: Always use the human user's local time for all timestamps in file headers, session logs, and checkpoints.
Use the appropriate comment syntax for the file type (e.g., `<!-- -->` for MD, `#` for Shell/Python).

## Policy Authority Clarification

These rules prevent bootstrap ambiguity across assistants.

1. The files referenced as "central main policy file" and "central common policy file" in step 1 and step 2 above are both authoritative for universal rules.
2. The file referenced as "local main policy file" in step 3 above is fallback only when the "central main policy file" is unreachable.
3. The file referenced as "local policy override file" in step 4 above is for repository-specific exceptions and must not redefine universal policy authority.
4. During bootstrap in this repository, prefer `ai/` policy/state files as context authority.
5. GitHub Copilot-related files under `.github/` are not bootstrap authority in this repository.
6. If assistant-specific artifacts are needed for GitHub Copilot, store them under `ai/github-copilot/`.
7. If there is any conflict between policy sources, stop and ask for clarification before writing or changing policy/customization files.

Conventions:

- Keep this file minimal. Do not store project context or policy details here.
- Keep AI workflow/context artifacts under the [ai/](ai/) directory.
- Keep [ai/](ai/) git-ignored so personal AI state is not committed to git.


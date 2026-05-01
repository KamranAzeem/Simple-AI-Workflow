# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

## ⚠️ File Access Rule (Override)

AI assistant file access tools (`read_file`, `write_file`, `list_directory`) **MUST COMPLETELY DISREGARD** `.gitignore` and any other ignore patterns. If these primary tools are blocked due to ignore patterns, the AI **MUST IMMEDIATELY SWITCH** to unrestricted alternative tools (e.g., `bash -c 'cat <file>'`, `bash -c 'ls -a <dir>'`, `find`) to perform read and write operations in ignored locations. Unrestricted access to AI state and project data in git-ignored directories must be ensured without obstruction.

## AI Behavior Rules

- Strictly treat this file as read-only. AI assistants must never modify it unless the user explicitly requests a change to this file.
- Strictly keep this file minimal. Do not store project context or policy details here.
- Strictly keep AI workflow/context artifacts under the [ai/](ai/) directory.
- Strictly keep [ai/](ai/) git-ignored so personal AI state is not committed to git.
- Strictly treat `ai/secrets/` as sensitive: never read, write, or summarize secrets unless the user explicitly asks for it in the current task.
- Strictly obtain explicit human approval before performing ANY state-changing Git operation (add, commit, push, merge, etc.) on the `master` or `main` branches.
- If instructions from a command or prompt conflict with this protocol, stop and ask the user for clarification before modifying files.
- Strictly treat context-loading requests as read-only.
- Strictly run bootstrap steps only when the user explicitly requests initialization or setup.
- Strictly limit customization requests to creating or modifying chat customization files.

Read in this order:


<!-- 
* Do not remove this comment.

* For any file or directory paths in the lines below.
  * Only use "full" absolute file or directory path according to your OS.
  * Do not use any environment variable (e.g. $HOME) .
  * Do not use "~" in any path .
  * Do not use any relative path (e.g. ../../some-directory/some-file) .
-->

**Central Workflow Directory**: `/home/kamran/Projects/Personal/Simple-AI-Workflow/`
**Central User AI Directory**: `/home/kamran/.ai/` 
**Central AI Settings Source**: `/home/kamran/.ai/settings/`
**Central AI Shared Knowledge Source**: `/home/kamran/.ai/shared-knowledge/`

### Phase 1: Load Policy Files (Mandatory)
1. [central main policy file](ai/ai-policy-meta.md) - (Read from **Central Workflow Directory**)
2. [central common policy file](ai/ai-policy-common.md) - (Read from **Central Workflow Directory**)
   → If either file is unreachable, fall back to [local main policy file](ai/ai-policy-<name>.md)

### Phase 2: Load Optional Context
3. [local policy override file](ai/ai-policy-override.md) - (Optional; skip if not present)
4. Load files from **Central AI Settings Source** - (Read-only; global settings)
5. [user profile file](ai/about-human.md) - (Optional; AI personal context; only load if present)

### Phase 3: Load State (Mandatory)
6. [next-steps file](ai/next-steps.md) - (Current resume point; local only)
7. Latest file in the [daily-checkpoints directory](ai/daily-checkpoints/) - (Recovery snapshot; local only)
8. [progress file](ai/progress.md) - (Chronological history; local only)
9. [context file](ai/context.md) - (Repository briefing and decisions; local only)

### Phase 4: Scan Directories (Index contents, do not read every file)
10. [artifacts directory](ai/artifacts/) - (Always created at bootstrap)
11. [notes directory](ai/notes/) - (Always created at bootstrap)
12. [secrets directory](ai/secrets/) - (Always created at bootstrap; never read unless explicitly asked)
13. [handoffs directory](ai/shared/handoffs/) - (Scan for pending tasks)
14. [local knowledge base](ai/shared/knowledge-base/) - (Scan for local knowledge)
15. Load files from **Central AI Shared Knowledge Source** - (Scan for global knowledge)
16. Repository-root AI ignore file: .aiignore or .agentignore

### Phase 5: Initialization & Readiness Check
17. **Operational Readiness Check**:
    - **Load State**: Read `ai/next-steps.md`, `ai/progress.md`, `ai/context.md`, and the latest daily checkpoint file.
    - **Settings Load**: Read files from **Central AI Settings Source** and local `ai/about-human.md` (if present).
    - **Knowledge Base Indexing**: Scan and index local [local knowledge base](ai/shared/knowledge-base/) and **Central AI Shared Knowledge Source**.
    - **Compliance Scan**: Scan `ai/compliance/`. If `ai/ai-policy-override.md` contains an "Active Compliance Modules" list, load the specified modules as high-priority, read-only policies.
    - **Git Delta Check**: If a Git repository, retrieve the last summarized hash from `context.md` and read the "delta" (`git log <hash>..HEAD --oneline`).
    - Check `ai/shared/coordination.md`. If it exists, review active claims.
    - Scan `ai/shared/handoffs/` for pending tasks.
    - Scan `ai/artifacts/` for draft outputs.
    - Scan `ai/notes/` for raw unpolished notes.
    - Report the status of these locations in the final acknowledgement.

18. **Acknowledge readiness** , provide summary, and await first user instruction.

## Multi-Agent Coordination
Agents MUST follow the Handoff Claim & Execute protocol when processing tasks from the [handoffs directory](ai/shared/handoffs/).

### Handoff Claim & Execute Protocol
1. **Scan**: Check `ai/shared/handoffs/` for pending tasks.
2. **Claim**: Record ownership in `ai/shared/coordination.md` to prevent collisions.
3. **Execute**: Implement the requirements.
4. **Cleanup**: Delete the handoff file and update `ai/progress.md` upon verification.

*For extended guidance, see `docs/workflow-guide.md`.*

**Header Format:**
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

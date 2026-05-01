---
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

**Central Workflow Directory**: `/home/kamran/Projects/Personal/Simple-AI-Workflow/`

### Phase 1: Load Policy Files (Mandatory)
1. [central main policy file](ai/ai-policy-meta.md) - (Read from **Central Workflow Directory**)
2. [central common policy file](ai/ai-policy-common.md) - (Read from **Central Workflow Directory**)
   → If either file is unreachable, fall back to [local main policy file](ai/ai-policy-<name>.md)

### Phase 2: Load Optional Context
3. [local policy override file](ai/ai-policy-override.md) - (Optional; skip if not present)
4. All files in the [central settings directory](settings/) - (Read from **Central Workflow Directory**; optional; skip if directory is absent or empty)
5. [user profile file](ai/about-human.md) - (Optional; AI personal context; only load if present; do not create)

### Phase 3: Load State (Mandatory)
6. [next-steps file](ai/next-steps.md) - (Current resume point; local only)
7. Latest file in the [daily-checkpoints directory](ai/daily-checkpoints/) - (Recovery snapshot; local only)
8. [progress file](ai/progress.md) - (Chronological history; local only)
9. [context file](ai/context.md) - (Repository briefing and decisions; local only)

### Phase 4: Scan Directories (Index contents, do not read every file)
10. [artifacts directory](ai/artifacts/) - (Always created at bootstrap; scan/index for draft outputs from brainstorming/work sessions)
11. [notes directory](ai/notes/) - (Always created at bootstrap; scan/index for raw unpolished notes from human or AI)
12. [secrets directory](ai/secrets/) - (Always created at bootstrap; never read, write, or summarize unless explicitly asked)
13. Repository-root AI ignore file: .aiignore (canonical) or .agentignore (alias)


After reading all accessible files above, provide a comprehensive summary and acknowledge readiness. Your summary MUST include the items below. Use this template:

```
- **Progress so far**: <recently completed tasks from ai/progress.md>
- **Pending tasks**: <tasks listed in ai/next-steps.md>
- **Handoffs**: <active tasks from ai/shared/handoffs/>
- **Knowledge Base**: <documents found in ai/shared/knowledge-base/>
- **Notes**: <documents found in ai/notes/>
- **Artifacts**: <items found in ai/artifacts/>
- **What to do next?**: <proposed next step derived from ai/next-steps.md or general readiness>
```

Finally, await the first user instruction.

[ai/README.md](ai/README.md) is for human understanding only. Do not use it as operational authority.

## Initial Bootstrap Procedure

When bootstrapping in a new repository where no AI files exist:

1. **Create the AI directory structure**:
   - Create `ai/` directory in the project root
   - Create required subdirectories: `ai/daily-checkpoints/`, `ai/shared/handoffs/`, `ai/shared/knowledge-base/`, `ai/artifacts/` for draft outputs from brainstorming/work sessions, `ai/notes/` for raw unpolished notes from human or AI, `ai/secrets/` for user-managed sensitive local notes

   - **Note**: `ai/github-copilot/` is NOT a bootstrap directory. It is mentioned in the Policy Authority section as a *future storage location* only if GitHub Copilot customization artifacts are needed; create it on-demand, not by default.

2. **Initialize state tracking files**:
   - Create `ai/next-steps.md` with initial checkpoint
   - Create today's daily checkpoint file: `ai/daily-checkpoints/YYYY-MM-DD.md`
   - Create `ai/progress.md` with initial entry
   - Create `ai/context.md` with project briefing and decisions.
     - **Git History Distillation**: If the directory is a Git repository, run `git log -n 50 --oneline` (or similar), distill the history into major milestones, and record them in a `## Project Evolution & Git History` section in `context.md`. Include the current HEAD hash as a reference.

3. **Set up gitignore**:
   - Add `ai/` to `.gitignore` in the project root
   - Add `AGENTS.md` to `.gitignore` in the project root (personal bootstrap customization)
     - **Note**: If this is the source repository for the AGENTS.md protocol (e.g., Simple-AI-Workflow), do NOT ignore AGENTS.md.

4. **Operational Readiness Check**:
   - **Load State**: Read `ai/next-steps.md`, `ai/progress.md`, `ai/context.md`, and the latest daily checkpoint file. Read all files in the `settings/` directory of the **Central Workflow Directory** if present to load user-specific context. Read `ai/about-human.md` if present for local user-specific context.
   - **Git Delta Check**: If a Git repository, retrieve the last summarized hash from `context.md` and read the "delta" (`git log <hash>..HEAD --oneline`). Load these recent changes into the active session memory.
   - Check `ai/shared/coordination.md`. If it exists, review active claims.
   - Scan `ai/shared/handoffs/` for pending tasks.
   - Index `ai/shared/knowledge-base/` for project-specific patterns.
   - Scan `ai/artifacts/` for draft outputs from previous brainstorming/work sessions.
   - Scan `ai/notes/` for raw unpolished notes from human or AI.
   - Report the status of these locations in the final acknowledgement.

5. **Acknowledge readiness** and await first user instruction.

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
5. **Agent-specific dot-directories (e.g., `.claude/`, `.gemini/`, `.github/`, `.copilot/`) are NOT bootstrap authority.** The AI assistant must not load its own agent-specific context, state, or configuration files from these directories during bootstrap or context loading. All shared context must come from the `ai/` directory and the files listed in the reading order above.
6. If there is any conflict between policy sources, stop and ask for clarification before writing or changing policy/customization files.

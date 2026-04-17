<!--
Created-by: Gemini
Updated-by: Cline
Last modified: 2026-04-17T14:48:00Z
Intent: Clarify session log creation policy for VSCode plugin assistants
-->
---
# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

Read in this order:

1. [central main policy file](/home/kamran/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-meta.md) - operating rules and guardrails. If unreachable, then read the local policy file mentioned in the next point.
2. [local main policy file](ai/ai-policy-cloud.md) - fallback if step 1 is unreachable; skip if step 1 succeeded.
3. [local policy override file](ai/ai-policy-override.md) - rules to override the main policy. **(optional; skip if not present)**
4. [ai/next-steps.md](ai/next-steps.md) - current resume point and live queue. **(optional; skip if not present)**
5. Latest file in [ai/daily-checkpoints/](ai/daily-checkpoints/) - daily recovery snapshot. **(optional; skip if not present)**
6. [ai/progress.md](ai/progress.md) - chronological execution history. **(optional; skip if not present)**
7. [ai/context.md](ai/context.md) - repository briefing and decisions. **(optional; skip if not present)**
8. Repository-root AI ignore file: .aiignore (canonical) or .agentignore (alias) — Locate and strictly apply this file as a filtering mechanism. You MUST exclude all directories and files matched by patterns in this file from your awareness, exploration, indexing, and context-building processes.

After reading all accessible files above, acknowledge readiness and await the first user instruction.

[ai/README.md](ai/README.md) is for human understanding only. Do not use it as operational authority.

## Initial Bootstrap Procedure

When bootstrapping in a new repository where no AI files exist:

1. **Create the AI directory structure**:
   - Create `ai/` directory in the project root
   - Create required subdirectories: `ai/daily-checkpoints/`, `ai/sessions/`, `ai/shared/handoffs/`, `ai/shared/knowledge-base/`
   - Inside `ai/sessions/`, create a folder named after the current agent (e.g., `aider`, `gemini`). **Skip this for any AI assistant/agent that is a VSCode chat plugin**. 

2. **Initialize state tracking files**:
   - Create `ai/next-steps.md` with initial checkpoint
   - Create today's daily checkpoint file: `ai/daily-checkpoints/YYYY-MM-DD.md`
   - Create `ai/progress.md` with initial entry
   - **CLI AI Assistants only**: You MUST create a **new** session log file for the **current** session in `ai/sessions/<agent-name>/` at every startup, incrementing the sequence number (e.g., `aider-live-session-YYYY-MM-DD-01.md`, `-02.md`). (Do not create this directory or file if you are a VSCode chat plugin assistant like "Cline" or "Copilot Chat").

3. **Set up gitignore**:
   - Add `ai/` to `.gitignore` in the project root
   - Add `AGENTS.md` to `.gitignore` in the project root (personal bootstrap customization)

4. **Operational Readiness Check**:
   - Check `ai/shared/coordination.md`. If it exists, review active claims.
   - Scan `ai/shared/handoffs/` for pending tasks.
   - Index `ai/shared/knowledge-base/` for project-specific patterns.
   - Report the status of these locations in the final acknowledgement.

5. **Acknowledge readiness** and await first user instruction.

## Multi-Agent Coordination
Agents MUST follow the Handoff Claim & Execute protocol found in `docs/AI_USAGE.md` and `ai/ai-policy-cloud.md` when processing tasks from `ai/shared/handoffs/`. This requires claiming tasks in `ai/shared/coordination.md` to prevent collisions.


**Header Format:**
```markdown
<comment-syntax>
Created-by: <Name of Agent>
Updated-by: <Name of Agent>
Last modified: <ISO-8601-Timestamp>
Intent: <Brief description of the change>
</comment-syntax>
---
```
Use the appropriate comment syntax for the file type (e.g., `<!-- -->` for MD, `#` for Shell/Python).

## Policy Authority Clarification

These rules prevent bootstrap ambiguity across assistants.

1. The file referenced as "central main policy file" in step 1 above is authoritative for universal rules.
2. Local `ai/ai-policy-cloud.md` is fallback only when the central main policy is unreachable.
3. `ai/ai-policy-override.md` is for repository-specific exceptions and must not redefine universal policy authority.
4. During bootstrap in this repository, prefer `ai/` policy/state files as context authority.
5. GitHub Copilot-related files under `.github/` are not bootstrap authority in this repository.
6. If assistant-specific artifacts are needed for GitHub Copilot, store them under `ai/github-copilot/`.
7. If there is any conflict between policy sources, stop and ask for clarification before writing or changing policy/customization files.

Conventions:

- Keep this file minimal. Do not store project context or policy details here.
- Keep AI workflow/context artifacts under the [ai/](ai/) directory.
- Keep [ai/](ai/) git-ignored so personal AI state is not committed to git.


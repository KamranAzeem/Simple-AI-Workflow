<!--
Created-by: Gemini
Updated-by: Gemini
Last modified: 2026-04-17T20:00:00Z
Intent: Update AI usage guide to match current system state (git-ignored knowledge base)
-->
---
# AI Usage Guide: static-website

This guide explains how to interact with AI assistants in this repository and how to manage the AI state tracking files.

## 1. AI Knowledge Base (`ai/shared/knowledge-base/`)
All persistent AI reasoning, style guides, and project-specific patterns are stored here.
- **Location**: `/ai/shared/knowledge-base/` (Git-ignored)
- **Status**: Non-version-controlled. Each contributor builds their own local knowledge base.
- **Usage**: Add Markdown files for permanent guidance (e.g., `css-architecture.md`, `style-guide.md`).
- **Policy**: AI assistants treat this directory as the source of truth for repository standards.

## 2. Task Handoffs (`ai/shared/handoffs/`)
Used for transferring specific tasks and context between AI assistants or sessions.

### How to Create a Handoff Task
**Human Instructions**:
1. Create a Markdown file in `ai/shared/handoffs/` (e.g., `my-task-handoff.md`).
2. Use the following template:
```markdown
<!--
Created-by: Human
Updated-by: Human
Last modified: YYYY-MM-DDTHH:MM:SSZ
Intent: [Brief description]
-->
---
# Handoff: [Task Name]
- **Status**: Pending
- **Assigned To**: [Agent Name or leave blank]
- **Goal**: [Clear objective]
- **Requirements**: [List constraints or steps]
- **Reference**: [Relevant file paths]
```

**Instruction to AI**:
To have the AI generate and save a handoff for you:
> *"Create a handoff task for [task name] with [details] and save it to the handoffs directory."*

### How to Execute a Handoff Task
To tell the AI to start working on a handoff:
> *"Claim and execute [filename] from the handoffs directory."*

The AI will:
1. Verify and record ownership in `ai/shared/coordination.md`.
2. Implement the requirements.
3. Delete the handoff file and ownership claim upon successful verification.
4. Record the completion in `ai/progress.md`.

## 3. Git Context Enrichment (Automatic)
The protocol leverages the project's Git history to build a richer understanding of the codebase's evolution without manual data entry.

### How it Works
1. **Initial Distillation**: During the first bootstrap in a Git repository, the AI distills the last 50-100 commits into a `## Project Evolution & Git History` section in `ai/context.md`.
2. **Reference Point**: The AI records the latest commit hash (HEAD) in `context.md`.
3. **Delta Loading**: On every subsequent "load context" operation, the AI identifies new commits since the last recorded hash (`git log <hash>..HEAD`) and loads them into active memory.

### Benefits
- **Zero-Effort Context**: The AI "remembers" recent changes you made without you having to explain them.
- **Token Efficiency**: Distilled summaries in `context.md` are much smaller than raw Git logs.
- **Temporal Awareness**: AI understands the "why" behind architectural shifts by looking at commit messages.

## 4. Coordination & Safety
- **Coordination**: `ai/shared/coordination.md` prevents multiple agents from conflicting on the same task.
- **Checkpoints**: Use the command *"Issue a checkpoint"* to update all tracking logs (`next-steps.md`, `progress.md`, daily checkpoints).
- **Flight Recorder**: Every session is logged in `ai/sessions/gemini/` for traceability.

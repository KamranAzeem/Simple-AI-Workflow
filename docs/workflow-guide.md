<!--
Created-by: Gemini
Updated-by: Gemini CLI
Last modified: 2026-04-30T22:45:00+02:00
Intent: Add Expertise & Intent Alignment section (Inquiry vs Directive protocol).
-->
---
# AI Usage Guide: static-website

This guide explains how to interact with AI assistants in this repository and how to manage the AI state tracking files.

## 1. Project Knowledge (`ai/shared/project-knowledge/`)
All persistent AI reasoning, style guides, and project-specific patterns are stored here.
- **Location**: `/ai/shared/project-knowledge/` (Git-ignored)
- **Status**: Non-version-controlled. Each contributor builds their own project knowledge base.
- **Usage**: Add Markdown files for permanent guidance (e.g., `css-architecture.md`, `style-guide.md`).
- **Policy**: AI assistants treat this directory as the source of truth for repository standards.

## 2. Global Knowledge (Cross-Project)
Lessons learned, architectural patterns, and reusable snippets that apply across all your repositories.
- **Location**: `~/.ai/global-knowledge/` (Global in user's home directory)
- **Status**: Personal persistent memory that follow you into every project.
- **Usage**: Automatically loaded as read-only context during initialization.
- **Policy**: AI assistants use this to ensure consistency and reuse best practices from your previous work.

## 3. Task Handoffs (`ai/shared/handoffs/`)
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

## 4. Expertise & Intent Alignment (Review-First)
To prevent AI assistants from prematurely implementing code changes when you only wanted to ask a question, the workflow enforces a strict intent alignment protocol.

### Directive vs. Inquiry
The system distinguishes between two types of requests:
- **Inquiry**: Requests for analysis, advice, observations, or "how-to" explanations.
- **Directive**: Explicit instructions to perform a task, fix a bug, or implement a feature.

### The "Analyze-Plan-Stop" Rule
For all **Inquiries**, the AI is mandated to:
1.  **Analyze**: Share technical thoughts, opinions, and analysis of the problem.
2.  **Plan**: Propose a specific implementation strategy, including which files will be changed or created.
3.  **Pause and wait**: The AI MUST NOT proceed with code modifications until it receives an explicit **Directive** from you.

### Benefits
- **Full Control**: You review the plan before a single line of code is changed.
- **Token Efficiency**: Prevents wasted tokens on incorrect or unwanted implementations.
- **Higher Quality**: Forces the AI to "think" (plan) before it "acts," leading to more robust solutions.

## 6. AI-Driven Secure Development Practices
The AI assistant is designed to inherently apply secure coding and infrastructure best practices derived from threat modeling principles (e.g., STRIDE, OWASP Top 10). This ensures that generated code and configurations adhere to security standards by default, assisting developers, engineers, and security professionals in building safer applications and infrastructure. The AI uses the context of your requests to infer potential security concerns and generate appropriately secure outputs.

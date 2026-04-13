# Centralized Policy Management System for Simple AI Workflow

- Clone this repository at a central location in your home directory, and make a note of that location.
- Copy `AGENTS.md` from this repository into the root of the target project on your local computer.
- The `AGENTS.md` file (now in your project root directory) points to the central policy file-path used by this workflow. Update that path based on where you cloned this repository. (e.g. `/home/username/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md`). Make sure to follow the OS specific way of writing the path. 
- When an AI assistant reads `AGENTS.md`, it will access the central policy directly from that path.
- Available example policy files in this repository: `ai/ai-policy-cloud.md`, `ai/ai-policy-frontend-web.md`, `ai/ai-policy-backend-api.md`, etc.
- The AI assistant will create a local `ai/` directory in your project root directory for state tracking files such as checkpoints, progress, and context.
- For repository-specific policy adjustments, create `ai/ai-policy-override.md`.
- Example override template: `ai/ai-policy-override.example.md`.
- Both `AGENTS.md` and the `ai/` directory should be ignored by Git to keep personal AI state private.
- See `gitignore-example.txt` for entries that keep local AI workflow files out of the repository. Add them to the project's `.gitignore` file.

## Docs and Slides

- [Simple-AI-Workflow (GoogleSlides/Live/up-to-date)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link)
- Local docs directory: `docs/`
- Slide notes/examples in this repository: `docs/aider-token-usage.md`, `docs/MCP-and-its-benefits.md`

## Which policy should you choose?

- Use `ai-policy-cloud.md` when the project is mostly infrastructure, cloud automation, deployment, platform operations, or mixed cloud workflows.
- Use `ai-policy-frontend-web.md` when the project is mainly focused on frontend web applications, UI work, accessibility, design systems, and user-facing flows.
- Use `ai-policy-backend-api.md` when the project is mainly focused on backend services, APIs, data handling, jobs, workers, and operational correctness.
- Use `ai-policy-linux-system-admin.md` when the project is mainly focused on Linux system administration and SRE tasks.
- If the project spans multiple areas, start with the policy that matches the highest-risk work, then add a local override file for project-specific rules.

## How to initialize / bootstrap?

- After copying `AGENTS.md` into your project root, run `/init using AGENTS.md` in your AI assistant shell to build the context.
- If your AI assistant does not support `/init`, use this instruction for first time setup:
  - `bootstrap using AGENTS.md protocol`
- The AI assistant will follow the bootstrap procedure in `AGENTS.md`, and it will:
  - Create the `ai/` directory with the `daily-checkpoints/` subdirectory.
  - Initialize the state tracking files such as `next-steps.md`, the daily checkpoint, and `progress.md`.
  - Add `ai/` and `AGENTS.md` to `.gitignore`.
- The central policy is accessed directly from the path referenced in `AGENTS.md`, so local copying of policy files is not required.
- Optionally, you can override parts of the policy by adding `ai/ai-policy-override.md`.
- A ready example is available at `ai/ai-policy-override.example.md` (copy and adjust for your local setup).
- Ensure the `ai/` directory is ignored in `.gitignore`.
- You can use `gitignore-example.txt` as a guide when adding AI-related ignore rules.

## How to start working in an already initialized/bootstrapped project directory?

You can use any of the following:

- **"Load AI context from latest checkpoint"**
- **"Resume work"**
- **"load AI context"**
- **"Follow AGENTS.md reading order"**
- **"Show me the progress so far"**
- **"Where are we in this project?"**

This will save time, read all AI related files without creating new ones, avoid recreating checkpoints right at the start of your work.

**Note:** If you accidentally execute a `/init` or `bootstrap` command in a project directory that already has some context, then the bootstrap process will not overwrite them. It simply wastes a little bit time in creating new checkpoints. So nothing to worry about.

## AI Prompt Playbook (Simple Workflow)

Use these short prompts directly when interacting with AI assistants.

1. **"bootstrap with AGENTS.md protocol"** (first-time setup only)
2. **"load AI context from latest checkpoint and summarize current state"**
3. **"show me the pending items"**
4. **"checkpoint"**
5. **"update the necessary documentation in summarized form for what we just decided about ..."**
6. **"create the git branch for this fix: bugfix/..."**
7. **"commit the work done until now in git and then merge the branch into main, push main to remote, and delete the local branch"**

## Checkpoint System

Checkpoints save the state of your AI discussions, progress, todos, open questions, and daily work snapshots into tracking files inside the `ai/` directory. This system helps you resume your work from where you left off whenever you restart in a project directory.

Create checkpoints whenever you complete important activities that you want to track or resume from later. You can create them as often as needed using instructions like:

- **"create checkpoint"**
- **"update AI tracking"**
- **"perform checkpoint"** 
- Simply **"checkpoint"**

These commands generate a new checkpoint ID and update all tracking files, ensuring you can restart your session from the exact point where you left off.

While the checkpoint system primarily helps AI assistants maintain progress tracking, the simple markdown files are also easy for human users to read and understand what's happening in the project.

### Checkpoint Features:
- **Automatic Creation**: Checkpoints are created during significant workflow activities or when AI state tracking files change
- **Consistency Verification**: Each checkpoint verifies that all AI tracking files are synchronized
- **Daily Snapshots**: Daily checkpoint files are stored in `ai/daily-checkpoints/YYYY-MM-DD.md`
- **Progress Tracking**: The `ai/progress.md` file maintains a chronological log of all checkpoints
- **Resume Points**: The `ai/next-steps.md` file provides the current resume point for AI assistants

**Key benefits:**
- Track AI workflow progress and decisions
- Maintain state consistency across sessions
- Easy resume capability from any checkpoint
- Human-readable documentation of project activities

### Checkpoint Format:
Checkpoints follow the format `CP-YYYY-MM-DD-XX` where:
- `YYYY-MM-DD`: Date of the checkpoint
- `XX`: Sequential number for multiple checkpoints on the same day

### Usage:
- AI assistants automatically create checkpoints during significant workflow activities
- Users can request checkpoints at any time for state preservation
- Checkpoints ensure AI assistants can resume work from a known consistent state

## CLI Tools Used by AI Assistants

These tools can be used from inside VS Code chat or directly on the command line. They do not need admin rights and can be placed in your `~/bin/` directory. All are available for Linux, macOS, and Windows.

**AI-essential** — AI assistants actively invoke these:

- `git` — version control
- `gh` — GitHub CLI (issues, PRs, releases)
- `rg` — fast file search (ripgrep)
- `jq` — JSON querying and transformation
- `yq` — YAML querying and transformation (useful for IaC and cloud config work)

**Optional / human convenience** — useful at the command line but not typically called by AI:

- `fd` — faster alternative to `find`
- `bat` — syntax-highlighted `cat`
- `delta` — better `git diff` viewer
- `fzf` — interactive fuzzy finder
- `tldr` — simplified man pages


## Why should the `ai/` directory be ignored in `.gitignore`?

- When you interact with AI, the prompts, reasoning, notes, and session state are part of your private thinking/working process. Those do not belong in the repository.
- In team environments, each person may have different notes, reasoning, task lists, and session state. Committing those files would create noise and unnecessary conflicts.
- Keeping AI support files in a dedicated `ai/` directory helps keep local workflow files separate from the real project related files and directories.
- While interacting with AI assistant, the user may accidentally leak sensitive information to the AI Assistant, such as name of the client, or any other client-related sensitive information about their infrastructure, application design, weaknesses in the system, etc. These are part of normal interaction with the AI assistant during thinking and planning sessions. These must never be part of the repository though.

## Optional adjustment to VScode:

To make future `/init` simpler for new projects, instruct VSCode to honor and use `AGENTS.md` by default. You do it by adding the following section to the VSCode file: `{{VSCODE_USER_PROMPTS_FOLDER}}/init.instructions.md`

Location of this file on different OSes is as follows:

* Linux: `~/.config/Code/User/prompts/init.instructions.md`
* MacOS: `~/Library/Application Support/Code/User/prompts/init.instructions.md`
* Windows: `%USERPROFILE%\AppData\Roaming\Code\User\prompts\init.instructions.md`


```
---
description: Use when bootstrapping a new repository with /init. Always read AGENTS.md first as the single source of truth.
applyTo: "**"
---

# /init Bootstrap Guide

When running `/init`, always:
1. Read AGENTS.md first — it is the single source of truth for AI file locations and policy hierarchy
2. GitHub Copilot files must go under `ai/github-copilot/`, never workspace root
3. If policy conflicts with init task, STOP and ask for clarification

Do not create copilot-instructions.md, *.prompt.md, or other GitHub Copilot customizations in workspace root.
```

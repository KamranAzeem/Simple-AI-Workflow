<!--
Created-by: Gemini
Updated-by: Gemini
Last modified: 2026-04-16T15:15:00Z
Intent: Comprehensive feature update based on Git history analysis.
-->
---
# Centralized Policy Management System for Simple AI Workflow

Objective: **Instead of *chatting* with AI, start *working* with AI**

## Setup & prerequisites

- **Estimated setup time:** Less than five minutes.
- **Difficulty:** Very low.
- **AI assistant:** An AI assistant is required. Any pricing tier will work; prefer one integrated with the VS Code Chat extension for best user experience (examples: ChatGPT, Claude, DeepSeek, Gemini, GitHub Copilot).
- **Installation method:** No install scripts, no sudo, no admin, no pip, npm, no this, no that! Just *one* `git clone`, and *one* `copy` command.


## Quick start

* Clone this repository at a central location in your home directory.
* Copy AGENTS.md into the root of your project directory.
* Update the central policy path in AGENTS.md in your project directory.
* Start VScode; in the AI chat window:
  * “/init using AGENTS.md protocol”,
  * or,  “bootstrap using AGENTS.md protocol” 

## How it looks like

```text
+--------------------------------------+                +---------------------------------------+
| ( The central policy location view ) |                | ( Your project directory view)        |
| .                                    |                | .                                     |
| ├─ AGENTS.md                         |                | ├─ AGENTS.md                          |
| ├─ ai/                               |                | ├─ ai/                                |
| │  ├─ ai-policy-api-backend.md       |                | │  ├─ ai-policy-override.md           |
| │  ├─ ai-policy-cloud.md             | <------------- | │  ├─ context.md                      |
| │  ├─ ai-policy-common.md            |                | │  ├─ next-steps.md                   |
| │  ├─ ai-policy-meta.md              |                | │  └─ progress.md                     |
| │  ├─ ai-policy-web-frontend.md      |                | ├─ README.md        }    your         |
| │  └─ ai-policy-linux-system-admin.md|                | └─ src/             } -- application  |
| └─ README.md                         |                |    └─ main.go       }    code         |
+--------------------------------------+                +---------------------------------------+
``` 



## Key Features

This solution transforms AI from a chat-bot into a structured team member with clear boundaries and rigorous audit trails.

### 1. Centralized Policy Authority
- **Multi-Domain Support**: Specialized policies for Cloud/Infra, Frontend, Backend, and Linux System Administration.
- **Hierarchical Overrides**: Apply global rules via central policy while allowing repository-specific exceptions via `ai/ai-policy-override.md`.
- **Modular Personas**: Easily swap the assistant's role (e.g., Engineer, Mentor, Security Specialist) by applying persona templates from `docs/personas/` to your local override file. **Note**: Switching personas only changes the interaction style; all technical guardrails and domain knowledge from the main policies (Cloud, Backend, etc.) remain fully active.
- **Token Efficiency**: Explicit policies for efficient token usage, API rate-limit awareness (batching/surgical edits), and anti-polling (no assistant watch-loops).

### 2. Standardized Bootstrap Protocol
- **AGENTS.md Protocol**: A consistent entry point for any AI agent to understand its role, authorities, and reading order.
- **Explicit State Loading**: Mandates the loading of existing tracking files (`next-steps.md`, `progress.md`, `context.md`) during initialization to ensure session continuity.
- **Zero-Install Setup**: No scripts required; just one `git clone` and one `copy` command to initialize any project.
- **Operational Readiness Check**: Automatic scanning of `ai/shared/handoffs/` and `ai/shared/coordination.md` during initialization to pick up existing context.
- **Environment Parity**: Aligned synchronization scripts (Bash and PowerShell) to propagate `AGENTS.md` across local project directories.

### 3. Autonomous State & Context Management
- **Checkpoint System**: Persistent tracking of progress, todos, and daily work snapshots in `ai/` to resume work seamlessly.
- **Persistent Knowledge Base**: Local wiki in `ai/shared/knowledge-base/` for storing architectural decisions, style guides, and technical findings that persist across sessions.
- **Context Preservation**: Strategic resume points (`next-steps.md`, `progress.md`, `context.md`) ensure agents never "forget" the mission.
- **Personalization**: Support for `ai/about-human.md` allows you to provide the AI with a profile of your skills, experience, and communication preferences for more tailored assistance (see `docs/about-human.md` for a template).

### 4. Standardized Traceability (Metadata Headers)
- **Audit Trails**: Mandatory file-identification headers (Created-by, Updated-by, Intent) using native comment syntax for every AI-modified file.
- **Transparency**: Instantly identify the author and purpose of any AI-generated artifact.

### 5. AI Flight Recorder (CLI-Only)
- **Granular Session Logs**: Transaction-based persistence for CLI agents (AI Flight Recorder), following the strict naming and metadata protocols defined in `AGENTS.md`.
- **Plugin Exemption**: This overhead is automatically skipped for VSCode chat plugins (e.g., Cline, Copilot Chat) to maintain a lean workspace.
- **Audit Stability**: Provides a stable historical record that survives terminal buffer resets.

### 6. Multi-Agent Coordination (Shared Intelligence)
- **A2A Knowledge Sharing**: Dedicated `ai/shared/` directory structure:
    - `handoffs/`: Async task transfers between agents or sessions.
    - `knowledge-base/`: Persistent repository-specific wisdom and patterns.
    - `coordination.md`: Real-time status board for task locking and ownership.
- **Claim & Execute Protocol**: Standardized lifecycle for handoffs (Create -> Claim in coordination.md -> Execute -> Verify & Cleanup).
- **A2A Rules**: All agents must follow:
    - **Atomic Update Protocol**: Every interaction with `ai/` tracking files must be a fresh `read` followed by an immediate `write`.
    - **Conflict Resolution**: If an agent detects unauthorized changes, it must pause and ask for human clarification.
    - **Task Claiming**: Agents must record ownership in `ai/shared/coordination.md` before starting tasks in `ai/next-steps.md`.
- **Collaborative Intelligence**: Shared findings avoid redundant research across different agents (Gemini, Copilot, etc.).

### 7. Security & Governance
- **Proactive Secret Scanning**: Mandatory file validation before any Git commit or infrastructure operation.
- **Strict Boundary Control**: Enforcement of `.aiignore` / `.agentignore` to prevent AI leakage or unauthorized exploration.
- **Version Control Guardrails**: Policies for branch-gating, issue-labeling, and safe Git operations.

## Detailed instructions

- Clone this repository at a central location in your home directory, and make a note of that location.
- Copy `AGENTS.md` from this repository into the root of the target project on your local computer.
- The `AGENTS.md` file (now in your project root) points to the central policy path; update the path based on where you cloned this repo. Follow OS‑specific path syntax.
- When an AI assistant reads `AGENTS.md`, it will access the central policy directly from that path.
- Available example policy files in this repository: `ai/ai-policy-cloud.md`, `ai/ai-policy-web-frontend.md`, `ai/ai-policy-api-backend.md`, `ai/ai-policy-common.md`, etc.
- The AI assistant will create a local `ai/` directory in your project root directory for state tracking files such as checkpoints, progress, context, sessions, and shared handoffs.
- For repository-specific policy adjustments, create `ai/ai-policy-override.md`.
- Example override template: `ai/ai-policy-override.example.md`.
- Both `AGENTS.md` and the `ai/` directory should be ignored by Git to keep personal AI state private.
- See `gitignore-example.txt` for entries that keep local AI workflow files out of the repository. Add them to the project's `.gitignore` file.

- Repository-level AI ignore: this repo supports a repository-root `.aiignore` (canonical) and `.agentignore` (alias). Patterns in that file are honored by AI assistants and must be applied before indexing or loading other repository files. Place the `.aiignore` in the same directory where the `AGENTS.md` file you want to protect is located. See `.aiignore.example` for recommended patterns.
-- Helper scripts (optional): this repository provides `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1` as convenience helpers to propagate the canonical `AGENTS.md` into project directories. These tools are optional — you can instead copy `AGENTS.md` using your OS copy commands or GUI if you prefer. See `support-files/README.md` for usage.

- Always run helper scripts with `--dry-run`/`-WhatIf` first; on Windows you may need `-ExecutionPolicy Bypass`.

## Docs and Slides

- [Simple-AI-Workflow (GoogleSlides/Live/up-to-date)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link)
- Local docs directory: `docs/`
- Slide notes/examples in this repository: `docs/aider-token-usage.md`, `docs/MCP-and-its-benefits.md`

## Which policy should you choose?

- **`ai-policy-common.md`**: This is the **mandatory shared baseline** for all AI assistants. It contains universal guardrails (branch-gating, A2A coordination, checkpoint contracts) and is automatically loaded during the bootstrap process as the **central common policy file**.
- Use `ai-policy-cloud.md` when the project is mostly infrastructure, cloud automation, deployment, platform operations, or mixed cloud workflows.
- Use `ai-policy-web-frontend.md` when the project is mainly focused on frontend web applications, UI work, accessibility, design systems, and user-facing flows.
- Use `ai-policy-api-backend.md` when the project is mainly focused on backend services, APIs, data handling, jobs, workers, and operational correctness.
- Use `ai-policy-linux-system-admin.md` when the project is mainly focused on Linux system administration and SRE tasks.
- If the project spans multiple areas, start with the specialized policy that matches the highest-risk work; the **central common policy file** will handle the shared engineering standards automatically.

## How to initialize / bootstrap?

- After copying `AGENTS.md` into your project root, run `/init using AGENTS.md protocol` in your AI assistant shell to build the context.
- If your AI assistant does not support `/init`, use this instruction for first time setup:
  - `bootstrap using AGENTS.md protocol`
- The AI assistant will follow the bootstrap procedure in `AGENTS.md`, and it will:
  - Create the `ai/` directory with the `daily-checkpoints/` subdirectory.
  - Initialize state tracking files (`next-steps.md`, daily checkpoint, and `progress.md`).
  - **Start a unique Session Log**: Create a session-specific log file with a unique `Session-ID` for auditability.
  - Add `ai/` and `AGENTS.md` to `.gitignore`.
- The central policy is accessed directly from the path referenced in `AGENTS.md`, so local copying of policy files is not required.
- Optionally, you can override parts of the policy by adding `ai/ai-policy-override.md`.
- A ready example is available at `ai/ai-policy-override.example.md` (copy and adjust for your local setup).
- Ensure the `ai/` directory is ignored in `.gitignore`.
- You can use `gitignore-example.txt` as a guide when adding AI-related ignore rules.

## How to start working in an already initialized/bootstrapped project directory?

You can use the following simple instruction:

- **"Load context using AGENTS.md protocol"**

Then, ask any of the following questions:

- **"Show me the progress so far"**
- **"Show me the pending tasks"**
- **"Where are we in this project?"**

This will save time, read all AI related files without creating new ones, avoid recreating checkpoints right at the start of your work.

**Note:** If you accidentally execute a `/init` or `bootstrap` command in a project directory that already has some context, then the bootstrap process will not overwrite them. It simply wastes a little bit time in creating new checkpoints. So nothing to worry about.

## AI Prompt Playbook (Simple Workflow)

Use these short prompts directly when interacting with AI assistants.

- **"bootstrap with AGENTS.md protocol"** (first-time setup only)
- **"Load context using AGENTS.md protocol"**
- **"load AI context from latest checkpoint and summarize current state"**
- **"re-read policy override"** (to apply persona or shell priority changes)
- **"show me the pending items"**
- **"show me the handoff items"**
- **"checkpoint"**
- **"update the necessary documentation in summarized form for what we just decided about ..."**
- **"update the relevant documentation in summarized form for the tasks we did during this session"**
- **"create the git branch for this fix: bugfix/..."**
- **"commit the work done until now in the current git branch, and then merge the branch into main, push main to remote, and delete the local branch"**

> **Why use AI for git operations?** When you ask the AI to commit, it applies the security policy before touching git — scanning the files for secrets (passwords, tokens, keys) before running `git add`, and stopping if anything suspicious is found. This is enforced automatically on every commit, without you having to remember to do it manually.

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


```markdown
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


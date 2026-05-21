<!--
Created-by: Gemini
Updated-by: GitHub Copilot
Last modified: 2026-05-21T00:00:00+02:00
Intent: Replace protocol-section "TIER" references with plain language section names throughout README.
-->
---
# Global Policy Management System for Simple AI Workflow

Objective: **Instead of *chatting* with AI, start *working* with AI**

## Setup & prerequisites

- **Estimated setup time:** Less than five minutes.
- **Difficulty:** Very low.
- **AI assistant:** An AI assistant is required. Any pricing tier will work; prefer one integrated with the VS Code Chat extension for best user experience (examples: ChatGPT, Claude, DeepSeek, Gemini, GitHub Copilot).
- **Installation method:** No install scripts, no sudo, no admin, no pip, npm, no this, no that! Just *one* `git clone`, and *one* `copy` command. No brittle shell scripts or complex "song and dance" situations.


## Quick Start (Initial Setup)

* Clone this repository at a global location in your home directory.
* **Mandatory One-Time Setup**: Create the global AI directory structure on your machine:
  * Create `$HOME/.ai/`
  * Create `$HOME/.ai/settings/`
  * Create `$HOME/.ai/global-knowledge/`
  * (Optional) Copy `docs/about-human.md` and `docs/tools-preferences.md` into `$HOME/.ai/settings/` and personalize them.
* Copy `AGENTS.md` into the root of your project directory.
* Update the **CONFIGURATION** section in the project `AGENTS.md`:
  * Ensure `Global AI Workflow Directory` points to the absolute path of this cloned repository.
  * Ensure `Global User AI Directory` points to your `[HOME]/.ai/` path.
* Start VS Code; in the AI chat window, use one of these two prompts:
  * `"bootstrap using AGENTS.md protocol"`
  * `"init using AGENTS.md protocol"`
* **Important:** Do not use the built-in `/init` command. It behaves differently across AI tools. Use the text prompts above instead.


## Use this workflow with a new project?

You can use the following sequence to on-board an existing project with this workflow.

1. Copy `AGENTS.md` from the global workflow location to the root of your new project.
2. Open the copied `AGENTS.md` and update the **CONFIGURATION** section to match your environment.
3. *Optional, but useful*: Create `ai/ai-customization.md` file with the "Expertise", "Traits", or "Compliance" modules you want AI to use for this project. See [AI customization guide](docs/ai-customization-guide.md) .
4. In your project root, run the prompt: `"bootstrap using AGENTS.md protocol"` to set up the directory for AI.
5. After every important task, remember to perform a checkpoint; after any AI or computer restart, use `"load context using AGENTS.md protocol"` to resume.

### Updating the AI Protocol (`AGENTS.md`)

To keep your project's AI workflows synchronized with the latest features, follow these steps:

1.  **Checkpoint**: Before updating, perform a final "checkpoint" of your current work.
2.  **Pull Updates**: Pull the latest changes into your global `Simple-AI-Workflow` repository.
3.  **Update `AGENTS.md`**: Run the provided helper script in `support-files/` to copy the updated `AGENTS.md` to your project directory. 
    *   *Note: This script is designed to preserve your existing project-specific configuration. Please verify that your configuration remains intact after running the script.*
4.  **Load Context**: Re-open your IDE and initiate the session by typing: `"load context using AGENTS.md protocol"` in your AI chat extension. This will automatically align your project `ai/` directory structure with the updated protocol.


## What This Workflow Is, and What It Is Not

### What it is

This is a **personal starter kit** — built for **one developer** (you), not for a team.

It helps you:

- **Get more useful answers** from your AI assistant — because it now knows your project's rules and your preferences.
- **Centralized context** — the same setup works across all your projects, and across different AI tools (ChatGPT, Claude, Copilot, etc.).
- **Stay organized** — your AI conversations, notes, and progress are saved in the project directory so you can pick up where you left off.
- **Keep your private stuff private** — all AI-related notes stay in your project `ai/` folder, out of the repository.

In short: it turns AI from a chat buddy into a **reliable teammate** that follows your rules. Just for you.


### What it is not

- **Not an "Agent Router" or Orchestrator**: It doesn't automatically route tasks between different models or agents. You decide which AI tool to use; the workflow simply ensures they all share the same memory and follow the same rules.
- **Not an "Agent for Agents" (A4A)**: This isn't a meta-agent layer that manages other agents. It is a set of declarative rules that *any* agent can follow.
- **Not a "Black Box"**: There are no hidden scripts, complex background processes, or brittle "song and dance" setups. It is a transparent, instruction-based protocol.
- **Not an autonomous robot**: The AI remains an assistant; it does not run in autonomous loops or make decisions without a human-in-the-loop.
- **Not a team collaboration tool**: Designed specifically for individual developers to manage their own project context and history.
- **Not a replacement**: It complements—not replaces—your existing CI/CD pipelines, testing frameworks, and security scanners.
- **Not an AI training system**: It provides project-specific grounding for context; it does not train or fine-tune AI models.
- **Not a reporting dashboard**: It doesn't track token spend or generate manager-ready reports.

### Why this exists — the multi-assistant problem

If you use only one AI assistant, you probably don't need this workflow. Your AI assistant already keeps its own context, and that mostly works fine. But even with a single assistant, you still need to hunt for relevant files in its state directory and understand its file structure — and every AI assistant has a different layout. That's a problem.

The real problem starts when you use **two or more** AI assistants on the same project — either one after the other, or switching between them. Without a shared system:

- Each assistant stores its own state in its own `.agentname/` directory inside your project.
- After a few switches, you have no idea which context is the latest.
- Switching assistants means starting from scratch — the new one has no memory of what the previous one did.

This workflow solves that by forcing **every** AI assistant to follow the same protocol when creating or updating context, progress, and next-steps.

**Think of it like a road trip with multiple drivers:**

1. **Gemini** is driving. It uses its free tier, works on the task, and builds up context.
2. Gemini's quota runs out. Before stopping, it creates a **checkpoint** — saving the current state to `ai/next-steps.md`, `ai/progress.md`, and `ai/context.md`.
3. **DeepSeek** takes the wheel. You ask it to load context using the same protocol. It reads the same files and continues exactly where Gemini left off.
4. When you want to switch back, DeepSeek creates another checkpoint. Gemini takes over again.


No matter which assistant you use — ChatGPT, Claude, Gemini, DeepSeek, Copilot — they all read from and write to the **same shared context**. The protocol is the same. The files are the same. The state is always consistent.

The result? **Peace of mind.** You know exactly where the AI directory is, you know the file structure, and you can interact efficiently without guessing which assistant's context is current.

> **One protocol. One shared context. Any assistant picks up where the last one left off.**




## How it looks like


```text
+--------------------------------------+                +---------------------------------------+
| ( The global framework location )    |                | ( Your project directory view)        |
| .                                    |                | .                                     |
| ├─ AGENTS.md (Primary)               |                | ├─ AGENTS.md (Copy)                   |
| ├─ ai/                               |                | ├─ ai/                                |
| │  ├─ policies/                      | <------------- | │  ├─ ai-customization.md             |
| │  │  ├─ ai-policy-common.md         |                | │  ├─ context.md                      |
| │  │  ├─ ai-policy-cloud.md          |                | │  ├─ next-steps.md                   |
| │  │  └─ ...                         |                | │  └─ progress.md                     |
| │  └─ shared/                        |                | ├─ README.md        }    your         |
| └─ support-files/                    |                | └─ src/             } -- application  |
+--------------------------------------+                +---------------------------------------+


``` 

## How to initialize / bootstrap?

Use one of these two text prompts in your AI assistant:

- `"bootstrap using AGENTS.md protocol"`
- `"init using AGENTS.md protocol"`

**Important:** Do not use the built-in `/init` command. It is specific to each AI tool and behaves differently across assistants. The two text prompts above work the same way everywhere.

The AI assistant will follow **Procedure B** in `AGENTS.md`, and it will:

  - Create the `ai/` directory with the `daily-checkpoints/` subdirectory.
  - Initialize state tracking files (`next-steps.md`, daily checkpoint, and `progress.md`).
  - Add `ai/` and `AGENTS.md` to `.gitignore`.
- The global policies are accessed directly from the path referenced in `AGENTS.md`, so manual copying of policy files is not required.
- Optionally, you can customize the behavior by adding `ai/ai-customization.md`.
- Ensure the `ai/` directory is ignored in `.gitignore`.

## How to start working in an already initialized/bootstrapped project directory?

You can use the following simple instruction:

- **"Load context using AGENTS.md protocol"** (Executes **Procedure A**)

Then, ask any of the following questions:

- **"Show me the progress so far"**
- **"Show me the pending tasks"**
- **"Where are we in this project?"**

This will save time, read all AI related files without creating new ones, avoid recreating checkpoints right at the start of your work.

**Note:** If you accidentally run `"bootstrap using AGENTS.md protocol"` in a project that already has context, the bootstrap process won't overwrite anything — it just performs an existence audit.

## How to upgrade

Use this when a newer version of this repository adds new protocol features.

### Step A: Get the latest AGENTS.md in this global repository

1. Pull the latest changes in this repository, using `git pull`.
2. Verify that `AGENTS.md` contains the new sections or procedures you want to roll out.

### Step B: Propagate AGENTS.md to your other projects

Use the helper scripts in `support-files/` to update `AGENTS.md` across your project folders while preserving each target project's **CONFIGURATION** section.

Linux/macOS/Git Bash (dry-run first):

```bash
./support-files/sync-agents-md.sh --source ./AGENTS.md --target-path ~/Projects --dry-run
./support-files/sync-agents-md.sh --source ./AGENTS.md --target-path ~/Projects
```

Windows PowerShell (dry-run first):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\support-files\sync-agents-md.ps1 -Source '.\AGENTS.md' -TargetPath 'C:\Users\<you>\Projects' -WhatIf }"
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\support-files\sync-agents-md.ps1 -Source '.\AGENTS.md' -TargetPath 'C:\Users\<you>\Projects' }"
```

### Step C: Adjust Configuration (If needed)

If the new protocol introduced new base variables in the **CONFIGURATION** section, manually update them in your project `AGENTS.md`.

### Step D: Update each project's context

Inside each target project, ask your AI assistant to run:

- `"load context using AGENTS.md protocol"`

This ensures the AI is aware of the new protocol rules and triggers.

## Unified AI Customization (`ai-customization.md`)

This is the **"Single Dial"** for tailoring the AI to your specific project needs. It uses a flexible, list-based format for project customization.

Use `ai-customization.md` to:
1.  **Compose Expertise**: Mix and match technical domains (e.g., `Expertise: [cloud, api-backend]`).
2.  **Activate Traits**: Add functional personas (e.g., `Traits: [mentor, reviewer]`).
3.  **Enable Compliance**: Opt-in to regulatory standards (e.g., `Compliance: [gdpr, soc2]`).

See the **[AI Customization Guide](docs/ai-customization-guide.md)** for full instructions and multi-role examples.

The AI assistant reads this file during the context-loading phase (**Procedure A**) and automatically applies the corresponding policies and behaviors.


---

## Key Features

### 1. Structured Protocol
- **Outcome-Oriented Procedures**: Uses clear, linear instructions for "Load Context", "Bootstrap", and "Checkpoint".
- **Relocatable Configuration**: Uses dynamic path inference from two base directories (Workflow and User Home), making the system portable across machines and OSs.
- **Reliable Guardrails**: Structured structural cues and immutable mandates ensure even lower-capability models can safely bootstrap without destroying state.

### 2. Automated Protocol Validation
- **System Integrity**: A built-in validation suite (`support-files/validate-protocol.sh`) verifies the bootstrap protocol, path availability, and metadata adherence on demand.
- **Continuous Reliability**: Ensures the AI always operates from a known-good state.

### 3. Native Checkpoint Backups
- **Automatic State Archiving**: Native, cross-platform one-liners automatically archive the `ai/` directory to a global backup folder during every checkpoint.
- **Zero-Script Reliability**: Built directly into the protocol to ensure your project history is protected.

### 4. Surgical Git-Ignore Exceptions
- **Shell-Force Access**: Specifically authorizes the AI to use shell tools (`cat`, `ls`) to read `AGENTS.md` and the `ai/` folder even if they are git-ignored, bypassing common AI safety refusals while respecting ignore rules for the rest of the project.

### 5. Multi-Domain Global Policies
- **Modular Expertise**: Specialized policies for Cloud, Frontend, Backend, Data, DBA, Observability, and Linux SysAdmin.
- **Standardized Traceability**: Mandatory file-identification headers (Created-by, Updated-by, Intent) for every AI-modified file.

### 6. Multi-Agent Coordination
- **Handoff Lifecycle**: Standardized async task transfers between agents or sessions via `ai/shared/handoffs/`.
- **Coordination Board**: Real-time status board (`ai/shared/coordination.md`) for task locking and ownership in multi-agent environments.

### 7. AI-Driven Secure Development
- **Implicit Security**: The AI inherently applies secure coding and infrastructure best practices derived from threat modeling (STRIDE, OWASP Top 10).
- **Proactive Scanning**: Mandatory file validation before any Git commit or infrastructure operation.

### 8. Peer Review Mode
- **On-Demand Code Review**: Trigger a strict peer review at any time by saying `"peer review"`. The AI switches to an objective reviewer role — no code writing, analysis and reporting only.
- **Structured Reports**: Each review is saved to `ai/code-review-reports/` with a severity-classified report (Critical / Major / Minor / Suggestions) and a clear **APPROVED** or **CHANGES REQUESTED** verdict.
- **Iterative**: Run as many review rounds as needed. Each round produces a new numbered report; previous reports are never overwritten.

---

## Docs and Slides

- [Simple-AI-Workflow (GoogleSlides/Live/up-to-date)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link) - *The slides are available under Creative Commons license.*
- [Simple-AI-Workflow (Markdown slides)](docs/simple-ai-workflow-slides.md) - Project Markdown version of the presentation (Marp-compatible)
- Project docs directory: `docs/`
- AI usage guide (handoffs, knowledge base, coordination, git enrichment): [docs/workflow-guide.md](docs/workflow-guide.md)
- Protocol Validation System Guide: [docs/protocol-validation-system.md](docs/protocol-validation-system.md)
- Policy Influence on Quality & Safety: [docs/policy-influence-on-ai-work.md](docs/policy-influence-on-ai-work.md)
- Preferred AI tooling reference & installation: [docs/tools-preferences.md](docs/tools-preferences.md)
- Persona templates (Mentor, Architect, Security Specialist): `docs/personas/`
- About the human user template: `docs/about-human.md`
- Beginner setup guide: `docs/vscode-cline-provider-setup-for-beginners.md`
- Mobile app development policy guide: `docs/ai-policy-mobile-apps-guide.md`

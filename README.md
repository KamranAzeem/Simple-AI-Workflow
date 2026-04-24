<!--
Created-by: Gemini
Updated-by: Cline
Last modified: 2026-04-24T20:50:00+02:00
Intent: Add missing ai-policy-data.md to diagram and policy selection section; fix diagram duplicate line.





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
* Start VScode; in the AI chat window, use one of these two prompts:
  * `"bootstrap using AGENTS.md protocol"`
  * `"init using AGENTS.md protocol"`
* **Important:** Do not use the built-in `/init` command. It behaves differently across AI tools. Use the text prompts above instead.


## What This Workflow Is, and What It Is Not

### What it is

This is a **personal starter kit** — built for **one developer** (you), not for a team.

It helps you:

- **Get more useful answers** from your AI assistant — because it now knows your project's rules and your preferences.
- **Keep things consistent** — the same setup works across all your projects, and across different AI tools (ChatGPT, Claude, Copilot, etc.).
- **Stay organized** — your AI conversations, notes, and progress are saved locally so you can pick up where you left off.
- **Stay safe** — the AI checks for secrets (passwords, API keys) before committing anything to Git.
- **Keep your private stuff private** — all AI-related notes stay in your local `ai/` folder, out of the repository.

In short: it turns AI from a chat buddy into a **reliable teammate** that follows your rules. Just for you.


### What it is not

- **Not a team collaboration tool.** This is built for individual developers. If your whole team wants to share AI rules, you'd need something different.
- **Not an autonomous robot.** The AI won't run on its own, make decisions without asking, or push code without your approval.
- **Not a replacement** for your existing tools like CI/CD pipelines, testing frameworks, security scanners, or code reviews. Those still do their job.
- **Not a reporting dashboard.** It doesn't track how many tokens you spend or generate reports for your manager.
- **Not an AI training system.** It doesn't train or fine-tune AI models.




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
| │  ├─ ai-policy-data.md              |                | │  └─ progress.md                     |
| │  ├─ ai-policy-meta.md              |                | ├─ README.md        }    your         |
| │  ├─ ai-policy-web-frontend.md      |                | └─ src/             } -- application  |
| │  └─ ai-policy-linux-system-admin.md|                |    └─ main.go       }    code         |
+--------------------------------------+                +---------------------------------------+




``` 

## How to initialize / bootstrap?

Use one of these two text prompts in your AI assistant:

- `"bootstrap using AGENTS.md protocol"`
- `"init using AGENTS.md protocol"`

**Important:** Do not use the built-in `/init` command. It is specific to each AI tool and behaves differently across assistants. The two text prompts above work the same way everywhere.

The AI assistant will follow the bootstrap procedure in `AGENTS.md`, and it will:

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

**Note:** If you accidentally run `"bootstrap using AGENTS.md protocol"` in a project that already has context, the bootstrap process won't overwrite anything — it just wastes a little time creating new checkpoints. So nothing to worry about.

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
- **Local Knowledge Base**: Local workspace notes in `ai/shared/knowledge-base/` for personal or session-specific findings; these are not intended as the repository-level sharing channel.
- **Draft Outputs (`ai/artifacts/`)**: A staging area for draft documents, designs, and code snippets created during brainstorming sessions. Review and refine before promoting to `docs/` or the project codebase.
- **Raw Notes (`ai/notes/`)**: A low-friction place for unpolished thoughts, meeting notes, or random ideas from both humans and AI. No structure required — just dump and go.
- **Context Preservation**: Strategic resume points (`next-steps.md`, `progress.md`, `context.md`) ensure agents never "forget" the mission.
- **Personalization**: Support for `ai/about-human.md` allows you to provide the AI with a profile of your skills, experience, and communication preferences for more tailored assistance (see `docs/about-human.md` for a template).

### 4. Standardized Traceability (Metadata Headers)
- **Audit Trails**: Mandatory file-identification headers (Created-by, Updated-by, Intent) using native comment syntax for every AI-modified file.
- **Transparency**: Instantly identify the author and purpose of any AI-generated artifact.

### 5. AI Flight Recorder (CLI-Only)
- **Granular Session Logs**: Transaction-based persistence for CLI agents (AI Flight Recorder), following the strict naming and metadata protocols defined in `AGENTS.md`.
- **Plugin Exemption**: This overhead is automatically skipped for VS Code chat plugins (e.g., Cline, Copilot Chat) to keep your workspace lean. Some plugins may still create a session log despite this — if you notice one, just ask it to stop.
- **Audit Stability**: Provides a stable historical record that survives terminal buffer resets.

### 6. Multi-Agent Coordination (Local Workspace)
- **A2A Coordination**: Dedicated `ai/shared/` directory structure:
    - `handoffs/`: Async task transfers between agents or sessions.
  - `knowledge-base/`: Local notes and references for AI workflow continuity.
    - `coordination.md`: Real-time status board for task locking and ownership.
- **Claim & Execute Protocol**: Standardized lifecycle for handoffs (Create -> Claim in coordination.md -> Execute -> Verify & Cleanup).
- **A2A Rules**: All agents must follow:
    - **Atomic Update Protocol**: Every interaction with `ai/` tracking files must be a fresh `read` followed by an immediate `write`.
    - **Conflict Resolution**: If an agent detects unauthorized changes, it must pause and ask for human clarification.
    - **Task Claiming**: Agents must record ownership in `ai/shared/coordination.md` before starting tasks in `ai/next-steps.md`.
- **Team Sharing Note**: For team-shared, versioned guidance, use `docs/` in the repository.

### 7. Security & Governance
- **Proactive Secret Scanning**: Mandatory file validation before any Git commit or infrastructure operation. **Note:** This is basic scanning — not a replacement for proper security tooling. Your employer may have specific compliance requirements; make sure you follow them.
- **Strict Boundary Control**: Enforcement of `.aiignore` / `.agentignore` to prevent AI leakage or unauthorized exploration.
- **Version Control Guardrails**: Policies for branch-gating, issue-labeling, and safe Git operations.

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
- **Context Preservation**: The `ai/context.md` file stores project briefing and decisions for session continuity


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

## Optional: ai/artifacts/, ai/notes/, and ai/secrets/

These are labeled "Optional", but are extremely helpful if you develop a habit of using them.


### ai/notes/ — Raw Notes (Human or AI)

The `ai/notes/` directory is a low-friction place for raw, unpolished thoughts. It's for:

- Stream-of-consciousness notes, meeting notes, or random ideas.
- Quick observations that don't need structure or formatting.
- Both humans and AI can write here freely.

There's no workflow or promotion path — notes are meant to stay as-is. If a note evolves into something more structured, move it to `ai/artifacts/` or `docs/`.

### ai/artifacts/ — Draft Outputs from Work Sessions

The `ai/artifacts/` directory holds draft outputs and deliverables created during brainstorming and working sessions. This is an optional staging area where:

- AI and you collaborate to create draft versions of documents, designs, analyses, or code snippets.
- Outputs are not yet committed to the main project or documentation.
- You review and refine drafts before promoting them to `docs/` or the project codebase.
- Examples: draft slides, prototype architectures, brainstorming notes, experimental code samples.

**Workflow:**
1. Brainstorm in chat with AI.
2. Ask AI to save results to `ai/artifacts/[name].md`.
3. Review and iterate.
4. When ready, move approved artifacts to `docs/` or project source.


### ai/secrets/ — Sensitive Local Notes (Optional)

The `ai/secrets/` directory is intentionally excluded from automatic AI context loading. Use it for sensitive local notes such as:

- API keys, tokens, or credentials (temporary local use only).
- Client-specific or project-specific sensitive context.
- Personal notes on security concerns or vulnerabilities.

**Important Security Notes:**
- AI assistants **never automatically read** `ai/secrets/` during context loading.
- Only read it if you explicitly request it in a specific task (e.g., "use the API key from ai/secrets/ to test this endpoint").
- Do **not** commit `ai/secrets/` to Git. Add it to `.gitignore`.
- **Preferred alternative:** Use OS-level secret stores (e.g., macOS Keychain, Windows Credential Manager, `pass` on Linux) or environment variables for real credentials.
- Treat `ai/secrets/` as a temporary convenience, not as a secure vault.

## Which policy should you choose?

- **`ai-policy-common.md`**: This is the **mandatory shared baseline** for all AI assistants. It contains universal guardrails (branch-gating, A2A coordination, checkpoint contracts) and is automatically loaded during the bootstrap process as the **central common policy file**.
- Use `ai-policy-cloud.md` when the project is mostly infrastructure, cloud automation, deployment, platform operations, or mixed cloud workflows.
- Use `ai-policy-web-frontend.md` when the project is mainly focused on frontend web applications, UI work, accessibility, design systems, and user-facing flows.
- Use `ai-policy-api-backend.md` when the project is mainly focused on backend services, APIs, data handling, jobs, workers, and operational correctness.
- Use `ai-policy-data.md` when the project is mainly focused on data engineering, ETL pipelines, data processing, analytics, or database-heavy workloads.
- Use `ai-policy-linux-system-admin.md` when the project is mainly focused on Linux system administration and SRE tasks.

- If the project spans multiple areas, start with the specialized policy that matches the highest-risk work; the **central common policy file** will handle the shared engineering standards automatically.

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
- While interacting with an AI assistant, you may share sensitive information — client names, infrastructure details, application design, system weaknesses, etc. This is a normal part of thinking and planning sessions. But these details must never end up in the repository.


## Docs and Slides

- [Simple-AI-Workflow (GoogleSlides/Live/up-to-date)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link)
- Local docs directory: `docs/`
- Slide notes/examples in this repository: `docs/MCP-and-its-benefits.md`
- Hands-on prompt-first learning session runbook: `docs/example-learning-session-runbook.md`
- AI agent collaboration and coordination guide: `docs/ai-agent-collaboration.md`
- AI usage guide (handoffs, knowledge base, coordination): `docs/AI_USAGE.md`
- Persona templates (Mentor, Architect, Security Specialist): `docs/personas/`
- About the human user template: `docs/about-human.md`
- VSCode `/init` instructions: `docs/vscode-init-instructions.md`

## Optional: VSCode `/init` Instructions

If you prefer using the built-in `/init` command, see [docs/vscode-init-instructions.md](docs/vscode-init-instructions.md) for setup instructions. This is not recommended — text prompts (`"bootstrap using AGENTS.md protocol"` or `"init using AGENTS.md protocol"`) work the same way across all AI tools.


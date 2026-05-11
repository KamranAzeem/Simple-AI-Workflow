<!--
Created-by: Gemini
Updated-by: Cline
Last modified: 2026-04-26T22:43:00+02:00
Intent: Change multi-assistant example from relay race to road trip.

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
  * Create `$HOME/.ai/project-knowledge/`
  * (Optional) Copy `docs/about-human.md` and `docs/tooling-reference.md` into `$HOME/.ai/settings/` and personalize them.
* Copy `AGENTS.md` into the root of your project directory.
* Update the **Configuration** section in the project `AGENTS.md` (ensure `Global Policies Directory` and `Global User AI Directory` point to your global paths).
* Start VS Code; in the AI chat window, use one of these two prompts:
  * `"bootstrap using AGENTS.md protocol"`
  * `"init using AGENTS.md protocol"`
* **Important:** Do not use the built-in `/init` command. It behaves differently across AI tools. Use the text prompts above instead.


## Use this workflow with a new project?

You can use the following sequence to on-board an existing project with this workflow.

1. Copy `AGENTS.md` from the global workflow location to the root of your new project.
2. Open the copied `AGENTS.md` and update the **Configuration** section to match your environment.
3. *Optional, but useful*: Create ai/ai-customization.md file with the "policy"/"role" you want AI to use for this project. e.g. "cloud", "backend-api", etc. See [AI customization guide](docs/ai-customization-guide.md) .
4. In your project root, run the prompt: `"bootstrap using AGENTS.md protocol"` to set up the directory for AI.
5. After every important task, remember to perform a checkpoint; after any AI or computer restart, use `"load context using AGENTS.md protocol"` to resume.

### Updating the AI Protocol (`AGENTS.md`)

To keep your project's AI workflows synchronized with the latest features, follow these steps:

1.  **Checkpoint**: Before updating, perform a final "checkpoint" of your current work and close your IDE.
2.  **Pull Updates**: Pull the latest changes into your global `Simple-AI-Workflow` repository / directory.
3.  **Update `AGENTS.md`**: Run the provided helper script in `support-files/` to copy the updated `AGENTS.md` to your project directory. 
    *   *Note: This script is designed to preserve your existing project-specific configuration section. Please verify that your configuration remains intact after running the script.*
4.  **Load Context**: Re-open your IDE and initiate the session by typing: `"load context using AGENTS.md protocol"` in your AI chat extension. This will automatically align your project `ai/` directory structure with the updated protocol.


## What This Workflow Is, and What It Is Not

### What it is

This is a **personal starter kit** — built for **one developer** (you), not for a team.

It helps you:

- **Get more useful answers** from your AI assistant — because it now knows your project's rules and your preferences.
- **Keep things consistent** — the same setup works across all your projects, and across different AI tools (ChatGPT, Claude, Copilot, etc.).
- **Stay organized** — your AI conversations, notes, and progress are saved in the project directory so you can pick up where you left off.
- **Stay safe** — the AI checks for secrets (passwords, API keys) before committing anything to Git.
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
| ( The global policy location view ) |                | ( Your project directory view)        |
| .                                    |                | .                                     |
| ├─ AGENTS.md                         |                | ├─ AGENTS.md                          |
| ├─ ai/                               |                | ├─ ai/                                |
| │  ├─ ai-policy-api-backend.md       |                | │  ├─ ai-customization.md             |
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
  - Add `ai/` and `AGENTS.md` to `.gitignore`.
- The global policy is accessed directly from the path referenced in `AGENTS.md`, so manual copying of policy files is not required.
- Optionally, you can customize the policy by adding `ai/ai-customization.md`.
- A ready example is available at `ai-customization-example.md` (copy and adjust for your project setup).
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

## How to upgrade

Use this when a newer version of this repository adds new bootstrap features (for example, new directories under `ai/`).

### Step A: Get the latest AGENTS.md in this global repository

1. Pull the latest changes in this repository, using `git pull`.
2. Verify that `AGENTS.md` contains the new bootstrap rules you want to roll out.

### Step B: Propagate AGENTS.md to your other projects

Use the helper scripts in `support-files/` to update `AGENTS.md` across your project folders while preserving each target project's Global Policies Directory and global policy file references.

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

### Step C: Adjust Configuration

After copying the new `AGENTS.md`, manually open it in your project root and update the **Configuration** section:

1. Ensure the `Global Policies Directory` path correctly points to the global location on your machine.
2. Verify all other paths in the configuration match your current project structure.

### Step D: Update each project's ai/ structure

Inside each target project, ask your AI assistant to run these two prompts:

- `"load context using AGENTS.md protocol"`
- `"update the ai directory structure with new features in AGENTS.md without changing existing context/state files"`

This keeps existing files like `ai/context.md`, `ai/next-steps.md`, `ai/progress.md`, and existing checkpoints intact, while creating only missing required/optional directories introduced by newer AGENTS rules.

### Recommended safety check

After upgrade in a target project, quickly confirm:

- `ai/` contains the new directories you expected.
- Existing state files are still present and unchanged in purpose.
- No unexpected folders were added.

## Unified AI Customization (`ai-customization.md`)

This is the **"Single Dial"** for tailoring the AI to your specific project needs. It uses a flexible, list-based format for project customization.

Use `ai-customization.md` to:
1.  **Compose Expertise**: Mix and match technical domains (e.g., `Expertise: [cloud, api-backend]`).
2.  **Activate Traits**: Add functional personas (e.g., `Traits: [mentor, reviewer]`).
3.  **Enable Compliance**: Opt-in to regulatory standards (e.g., `Compliance: [gdpr, soc2]`).

See the **[AI Customization Guide](docs/ai-customization-guide.md)** for full instructions and multi-role examples.

The AI assistant reads this file during the context-loading phase and automatically applies the corresponding policies and behaviors.


---

## Key Features

This solution transforms AI from a chat-bot into a structured team member with clear boundaries and rigorous audit trails.

### 1. Automated Protocol Validation
- **System Integrity**: A built-in validation suite (`support-files/validate-protocol.sh`) verifies the bootstrap protocol, path availability, tracking file integrity, and metadata adherence on demand.
- **Compliance Coverage**: Automatically checks existence and readability of all mandatory core and compliance policies.
- **Continuous Reliability**: Ensures the AI always operates from a known-good state, preventing protocol drift as the repository evolves.

### 2. Global Policy Authority
- **Multi-Domain Support**: Specialized policies for Cloud/Infra, Frontend, Backend, and Linux System Administration.
- **Layered Customization**: Apply global rules via global policy while allowing repository-specific tailoring via `ai/ai-customization.md`.
- **Modular Personas**: Easily swap the assistant's role (e.g., Engineer, Mentor, Security Specialist) by applying persona templates from `docs/personas/` to your project customization file. **Note**: Switching personas only changes the interaction style; all technical guardrails and domain knowledge from the main policies (Cloud, Backend, etc.) remain fully active.
- **Token Efficiency**: Explicit policies for efficient token usage, API rate-limit awareness (batching/surgical edits), and anti-polling (no assistant watch-loops).

### 2. Standardized Bootstrap Protocol
- **AGENTS.md Protocol**: A consistent entry point for any AI agent to understand its role, authorities, and reading order.
- **Explicit State Loading**: Mandates the loading of existing tracking files (`next-steps.md`, `progress.md`, `context.md`) during initialization to ensure session continuity.
- **Zero-Install & Zero-Script Setup**: No brittle scripts or "song and dance" situation required; just one `git clone` and one `copy` command to initialize any project. The workflow is purely instruction-based and logic-driven.
- **Operational Readiness Check**: Automatic scanning of `ai/shared/handoffs/` and `ai/shared/coordination.md` during initialization to pick up existing context.
- **Environment Parity**: Aligned synchronization scripts (Bash and PowerShell) to propagate `AGENTS.md` across project directories.

### 3. Autonomous State & Context Management
- **Checkpoint System**: Persistent tracking of progress, todos, and daily work snapshots in `ai/` to resume work seamlessly.
- **Project Knowledge**: Project workspace notes in `ai/shared/project-knowledge/` for personal or session-specific findings; these are not intended as the repository-level sharing channel.
- **Draft Outputs (`ai/artifacts/`)**: A staging area for draft documents, designs, and code snippets created during brainstorming sessions. Review and refine before promoting to `docs/` or the project codebase.
- **Raw Notes (`ai/notes/`)**: A low-friction place for unpolished thoughts, meeting notes, or random ideas from both humans and AI. No structure required — just dump and go.
- **Context Preservation**: Strategic resume points (`next-steps.md`, `progress.md`, `context.md`) ensure agents never "forget" the mission.
- **Personalization**: Support for global user context files under `settings/` (plus project fallback `ai/about-human.md`) allows you to provide the AI with your skills, experience, and communication preferences for more tailored assistance (see `docs/about-human.md` for a template).

### 4. Standardized Traceability (Metadata Headers)
- **Audit Trails**: Mandatory file-identification headers (Created-by, Updated-by, Intent) using native comment syntax for every AI-modified file.
- **Transparency**: Instantly identify the author and purpose of any AI-generated artifact.

### 5. Multi-Agent Coordination (Project Workspace)
- **A2A Coordination**: Dedicated `ai/shared/` directory structure: [AI Agent Collaboration Guide](docs/ai-agent-collaboration.md)
    - `handoffs/`: Async task transfers between agents or sessions.
  - `project-knowledge/`: Project notes and references for AI workflow continuity.
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

### 8. Git Context Enrichment (Automatic)
- **Zero-Effort History**: Automatically distills project Git history into `context.md` during bootstrap.
- **Delta Awareness**: On every load, the AI identifies new commits since the last session, ensuring it's always up-to-date with your manual changes.
- **Token Efficiency**: Replaces raw Git logs with distilled summaries, maximizing your context window. [Workflow Guide](docs/workflow-guide.md)

### 9. Native Intelligence (Protocol over Plumbing)
- **Pure Protocol (No Tooling Lock-in)**: Unlike other frameworks that require specialized CLI tools, Python environments, or complex shell scripts, this workflow is purely instruction-based. It works natively with any LLM that can read files, meaning there’s no "song and dance" setup—just a protocol that the AI follows. [Workflow Guide](docs/workflow-guide.md)

### 10. AI-Driven Secure Development Practices
- **Implicit Security**: The AI inherently applies secure coding and infrastructure best practices derived from threat modeling principles (e.g., STRIDE, OWASP Top 10). This ensures generated code and configurations are secure by default, helping developers, engineers, and security professionals build safer applications and infrastructure.

### 11. Global Knowledge Architecture
- **Persistent Shared Intelligence**: Leverages `/home/kamran/.ai/` for global settings (`/settings/`) and **Global Knowledge** (`/global-knowledge/`) that follow you across all projects.
- **Bootstrapping**: Automatic read-only indexing of shared sources during session initiation.
- **Normalization**: **Global Knowledge** is treated as informative "lessons learned," maintaining clear boundaries from authoritative project source code.

### 12. Modular Compliance Framework
- **Decoupled Registry**: Opt-in regulatory and industry standards (ISO 27001, SOC2, GDPR, CCPA, PCI-DSS, HIPAA) stored in `ai/compliance/`. [Compliance Guide](docs/compliance-guide.md)
- **Policy Overrides**: Activates specific compliance rules per-project via `ai/ai-policy-override.md`.
- **Audit-Ready**: Clear documentation and global policy enforcement.


## AI Prompt Playbook (Simple Workflow)

> **Important**: For advanced patterns (Handoffs, Knowledge Base, Git Enrichment), see the **[Workflow Guide](docs/workflow-guide.md)**.

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
- **"commit the work done until now in the current git branch, and then merge the branch into main, push main to remote, and delete the project branch"**

> **Why use AI for git operations?** When you ask the AI to commit, it applies the security policy before touching git — scanning the files for secrets (passwords, tokens, keys) before running `git add`, and stopping if anything suspicious is found. This is enforced automatically on every commit, without you having to remember to do it manually.

## Git is Your Friend — Especially with AI

If you're new to Git or find it intimidating, here's the good news: **your AI assistant handles all the Git operations for you.** You just need to understand one simple strategy that will save you from heartache.

### The Golden Rule

> **No matter how small you perceive your change — make a branch, commit frequently, and squash-merge when done.**

### Why this matters

When working with an AI assistant, things can go wrong:
- Your editor or IDE might crash mid-edit.
- The AI might have a glitch while modifying your code files.
- A tool call could produce unexpected output that corrupts your work.

The result? **Unusable code.** And the pain of repairing it is far greater — and far more stressful — than simply following a disciplined Git workflow.

### The Branch → Commit → Squash-Merge Strategy

```
1. CREATE A BRANCH
   └── "AI, create a branch for this fix: feature/my-new-thing"

2. COMMIT FREQUENTLY
   └── Let the AI auto-commit as you go — no matter how small the step.
       Each commit is a safe checkpoint you can fall back to.

3. SQUASH-MERGE WHEN DONE
   └── "AI, commit the work, merge into main, push, and delete the branch"
       The AI squashes all those tiny commits into one clean,
       well-described commit on main/master.

4. DELETE THE PROJECT BRANCH
   └── The AI handles this automatically as part of the merge step.
```

### Why this works

| Step | Benefit |
|------|---------|
| **Branch** | Isolates your work. If something goes wrong, main/master stays clean. |
| **Frequent commits** | Creates recovery points. A crash loses at most one small step, not hours of work. |
| **Squash-merge** | Keeps main/master history clean — one feature = one commit. |
| **AI does it all** | You never type a Git command. Just ask the AI. |

### The one-liner prompt

When you're done with a feature or fix, just say:

> **"Commit the work done until now in the current git branch, and then merge the branch into main, push main to remote, and delete the project branch."**

The AI will:
1. ✅ Scan files for secrets before committing (security policy enforced automatically)
2. ✅ Commit all changes with a descriptive message
3. ✅ Squash-merge into main/master
4. ✅ Push to remote
5. ✅ Delete the project branch

### Bottom line

> **Git is your safety net. Let the AI be your Git driver. You just enjoy the ride.**

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


### ai/secrets/ — Sensitive Project Notes (Optional)

The `ai/secrets/` directory is intentionally excluded from automatic AI context loading. Use it for sensitive project notes such as:

- API keys, tokens, or credentials (temporary project use only).
- Client-specific or project-specific sensitive context.
- Personal notes on security concerns or vulnerabilities.

**Important Security Notes:**
- AI assistants **never automatically read** `ai/secrets/` during context loading.
- Only read it if you explicitly request it in a specific task (e.g., "use the API key from ai/secrets/ to test this endpoint").
- Do **not** commit `ai/secrets/` to Git. Add it to `.gitignore`.
- **Preferred alternative:** Use OS-level secret stores (e.g., macOS Keychain, Windows Credential Manager, `pass` on Linux) or environment variables for real credentials.
- Treat `ai/secrets/` as a temporary convenience, not as a secure vault.

## Docs and Slides

- [Simple-AI-Workflow (GoogleSlides/Live/up-to-date)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link) - *The slides are available under Creative Commons license.*
- [Simple-AI-Workflow (Markdown slides)](docs/simple-ai-workflow-slides.md) - Project Markdown version of the presentation (Marp-compatible)
- Project docs directory: `docs/`
- Hands-on prompt-first learning session runbook: `docs/example-learning-session-runbook.md`
- AI agent collaboration and coordination guide: `docs/ai-agent-collaboration.md`
- Compliance & Regulatory Framework Guide: `docs/compliance-guide.md`
- AI usage guide (handoffs, knowledge base, coordination, git enrichment): [docs/workflow-guide.md](docs/workflow-guide.md)
- Protocol Validation System Guide: [docs/protocol-validation-system.md](docs/protocol-validation-system.md)
- Policy Influence on Quality & Safety: [docs/policy-influence-on-ai-work.md](docs/policy-influence-on-ai-work.md)
- Preferred AI tooling reference & installation: [docs/tooling-reference.md](docs/tooling-reference.md)
- Persona templates (Mentor, Architect, Security Specialist): `docs/personas/`
- About the human user template: `docs/about-human.md`
- Beginner setup guide (install VS Code, set up Cline and GitHub Copilot examples, configure provider API keys): `docs/vscode-cline-provider-setup-for-beginners.md`
- AI provider selection guide (cost and usage decision helper): `docs/ai-provider-selection-guide.md`
- Mobile app development policy guide (iOS, Android, cross-platform): `docs/ai-policy-mobile-apps-guide.md`

## Which policy should you choose?

- **`ai-policy-common.md`**: This is the **mandatory shared baseline** for all AI assistants. It contains universal guardrails (branch-gating, A2A coordination, checkpoint contracts, generated file validation) and is automatically loaded during the bootstrap process as the **global common policy file**.

- Use `ai-policy-cloud.md` when the project is mostly infrastructure, cloud automation, deployment, platform operations, or mixed cloud workflows. Includes **Testing & Validation** (IaC validation, policy-as-code testing, drift detection).
- Use `ai-policy-web-frontend.md` when the project is mainly focused on frontend web applications, UI work, accessibility, design systems, and user-facing flows. Includes **Testing & Quality (TDD-First)** (unit, integration, E2E, visual regression).
- Use `ai-policy-api-backend.md` when the project is mainly focused on backend services, APIs, data handling, jobs, workers, and operational correctness. Includes **Testing & Quality (TDD-First)** (unit, integration, contract, performance/load).
- Use `ai-policy-data.md` when the project is mainly focused on data engineering, ETL pipelines, data processing, analytics, or database-heavy workloads. Includes **Testing & Validation** (pipeline testing, schema validation, data quality, contract testing).
- Use `ai-policy-linux-system-admin.md` when the project is mainly focused on Linux system administration and SRE tasks. Includes **Testing & Validation** (script testing, configuration testing, idempotency, DR testing).
- Use `ai-policy-mobile-apps.md` when the project is mainly focused on mobile app development (iOS, Android, or cross-platform). Includes **Testing & Quality (TDD-First)** (unit, UI, integration, snapshot). See the [mobile app policy guide](docs/ai-policy-mobile-apps-guide.md) for details.


- If the project spans multiple areas, start with the specialized policy that matches the highest-risk work; the **global common policy file** will handle the shared engineering standards automatically.


# Simple AI Workflow

> **⚠️ Important for existing users**: The customization file has moved from `ai/ai-customization.md` to `ai-customization.md` at the project root. Run the sync script (`support-files/sync-agents-md.sh` or `sync-agents-md.ps1`) against your projects — it will detect the old file, move it to root, inject the required config section, and update the workflow path automatically. Or, follow the [manual steps](docs/ai-customization-guide.md).

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
  * (Optional) Create `global-user-settings.md` in `$HOME/.ai/settings/` and personalize it with your skills, tool preferences, and cross-project context. Use `docs/about-human.md` and `docs/tools-preferences.md` in this repository as starting templates.
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
2. Copy `docs/ai-customization.md` to `ai-customization.md` at the project root and update the **Global AI Workflow Directory** to point to your workflow clone.
3. *Optional*: Add "Expertise", "Traits", or "Compliance" modules to `ai-customization.md` to tailor the AI to your project. See [AI customization guide](docs/ai-customization-guide.md).
4. In your project root, run the prompt: `"bootstrap using AGENTS.md protocol"` to set up the directory for AI.
5. After every important task, remember to perform a checkpoint; after any AI or computer restart, use `"load context using AGENTS.md protocol"` to resume.

### Updating the AI Protocol (`AGENTS.md`)

To keep your project's AI workflows synchronized with the latest features, follow these steps:

1.  **Checkpoint**: Before updating, perform a final "checkpoint" of your current work.
2.  **Pull Updates**: Pull the latest changes into your global `Simple-AI-Workflow` repository.
3.  **Run the sync script**: Execute the sync script from your workflow repository, pointing it at your projects directory:
    - **Linux**: `bash /path/to/Simple-AI-Workflow/support-files/sync-agents-md.sh --source /path/to/Simple-AI-Workflow/AGENTS.md --target-path ~/Projects`
    - **Windows**: `.\sync-agents-md.ps1 -Source C:\Simple-AI-Workflow\AGENTS.md -TargetPath C:\Users\You\Projects`
    The script copies the updated `AGENTS.md` to each project and ensures each has a properly configured `ai-customization.md` — migrating from the old `ai/` layout if needed.
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




## How it works

```
   Simple-AI-Workflow/              Your Project/
   |-- AGENTS.md                    |-- AGENTS.md
   |-- ai-customization.md          |-- ai-customization.md
   |-- ai/policies/          -->    |-- ai/
   |-- docs/                        |-- src/
   |-- support-files/               |-- ...
```

## How to initialize / bootstrap?

Use one of these two text prompts in your AI assistant:

- `"bootstrap using AGENTS.md protocol"`
- `"init using AGENTS.md protocol"`

**Important:** Do not use the built-in `/init` command. It is specific to each AI tool and behaves differently across assistants. The two text prompts above work the same way everywhere.

The AI assistant will follow the bootstrap instructions in `AGENTS.md`, and it will:

  - Create the `ai/` directory with the `daily-checkpoints/` subdirectory.
  - Initialize state tracking files (`next-steps.md`, daily checkpoint, and `progress.md`).
  - Add `ai/` and `AGENTS.md` to `.gitignore`.
- The global policies are accessed directly from the path referenced in `AGENTS.md`, so manual copying of policy files is not required.
- Optionally, you can customize the behavior by adding `ai-customization.md`.
- Ensure the `ai/` directory is ignored in `.gitignore`.

## How to start working in an already initialized/bootstrapped project directory?

You can use the following simple instruction:

- **"Load context using AGENTS.md protocol"** (runs the context-loading sequence)

Then, ask any of the following questions:

- **"Show me the progress so far"**
- **"Show me the pending tasks"**
- **"Where are we in this project?"**

This will save time, read all AI related files without creating new ones, avoid recreating checkpoints right at the start of your work.

**Note:** If you accidentally run `"bootstrap using AGENTS.md protocol"` in a project that already has context, the bootstrap process won't overwrite anything — it just performs an existence audit.

## Keeping Context Healthy (Avoiding Context Rot)

Over a long session, an AI assistant's working knowledge gradually degrades. State files describe completed work that was never cleaned up, the context window fills up and pushes out older decisions, and rules that were clearly in view at the start of the session become invisible by the end. This is called **context rot**.

### The "load context" command — which form to use

There are two forms:

- **`"load context using AGENTS.md protocol"`** — full form. Explicitly names the protocol file. Use this at the start of every new session, after a restart, or after switching to a different AI tool. Reliable across all models and capability tiers.
- **`"load context"`** — shorthand. Fine once the AI already knows about AGENTS.md (e.g. mid-session), but a fresh or weaker model may not connect those words to the correct procedure without the explicit anchor.

**Rule of thumb**: always use the full form at the start of a session.

### What this workflow already protects against

| Rot type | Built-in defence |
|---|---|
| Stale state files | Atomic Write Protocol — all 3 state files sync together or not at all |
| Progress log bloat | Sliding Horizon Shield — archives `progress.md` when it exceeds 50 items or 200 lines |
| Compacted summary drift | Post-Condensation Recovery (Procedure E) — reloads rules from disk, not from the summary |
| Protocol amnesia | Proof-of-Load at every "load context"; AGENTS.md re-read mandated in Procedure E |
| Knowledge base staleness | Mandatory project-knowledge sync at every checkpoint |

### Habits that prevent the rest

- **Checkpoint frequently.** After each logical unit of work — a feature, a fix, a review cycle — run a checkpoint. Don't wait until end of day.
- **Keep sessions shorter.** When you notice the AI repeating questions it already answered or losing track of earlier constraints, that's the signal: checkpoint and start a fresh session with `"load context using AGENTS.md protocol"`.
- **Use the full load-context form at every restart.** Even with automatic Post-Condensation Recovery, the explicit `"load context using AGENTS.md protocol"` command runs the full procedure and is more reliable.
- **Keep `context.md` lean.** It should hold the current operating state, not a history log. History belongs in `progress.md` and `ai/shared/project-knowledge/`.
- **Review `next-steps.md` at session start.** It should contain the current checkpoint ID and any immediate next action — not a long list of stale items.

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

The AI assistant reads this file during the context-loading phase and automatically applies the corresponding policies and behaviors.


---

## Use Verbose File Names for Knowledge and Notes

When you (or the AI) create files under `ai/shared/project-knowledge/`, `~/.ai/global-knowledge/`, `ai/notes/`, `ai/artifacts/`, `ai/shared/handoffs/`, or `docs/`, **use long, descriptive kebab-case names that clearly state what the file contains**. This is also a binding rule for the AI itself — see the *Verbose File Naming* guardrail in `ai/policies/ai-policy-common.md`, which requires every AI-generated file to follow this convention by default.

Good examples:
- `azure-postgresql-flexible-server-migration-decisions.md`
- `ks5-order-module-sql-schema-constraints.md`
- `api-versioning-strategy-and-breaking-change-policy.md`

Poor examples:
- `decisions.md`
- `notes.md`
- `architecture.md`

**Why this matters — JIT loading:**

The AI assistant does not load large project knowledge files into context at boot time. Loading large files at startup wastes context window space and slows down every session. Instead, the protocol builds a lightweight index of project knowledge at startup — recording just the filenames and their apparent topics — and only reads a file's full content when an active task requires that specific knowledge.

This means the filename *is* the lookup key. A descriptive name like `azure-cli-subscription-context-fix.md` tells the AI exactly what to fetch when you ask about Azure CLI subscription issues. A vague name like `notes.md` is invisible — the AI cannot confidently map a task to it without reading it, which defeats the purpose of JIT loading.

Global knowledge files in `~/.ai/global-knowledge/` are a small, curated set, so they are loaded **in full** at boot rather than indexed — the AI always has them available. Verbose naming still matters most for project knowledge, which is indexed at boot and fetched on demand.

**Rule of thumb**: if a colleague couldn't guess what the file contains from its name alone, rename it.

**Application/source code is the exception.** This verbose convention is for *knowledge, documentation, and workflow artifacts* — where the filename is the AI's lookup key. It does **not** apply to application code. Source files must follow their language and framework idioms (`Button.tsx`, `user.rb`, `models.py`, `index.js`, `[id].tsx`), because the AI navigates code by structure, imports, and symbol search — not by guessing contents from the filename — and verbose names there would break imports, autoloading, and routing. This split is enforced by the *Verbose File Naming* guardrail in `ai/policies/ai-policy-common.md`.

---

## Key Features

### 1. Structured Protocol
- **Outcome-Oriented Procedures**: Uses clear, linear instructions for "Load Context", "Bootstrap", and "Checkpoint".
- **Relocatable Configuration**: Uses dynamic path inference from two base directories (Workflow and User Home), making the system portable across machines and OSs.
- **Reliable Guardrails**: Structured structural cues and immutable mandates ensure even lower-capability models can safely bootstrap without destroying state.

### 2. Automated Protocol Validation
- **System Integrity**: A built-in validation suite (`support-files/validate-protocol.sh`) verifies the bootstrap protocol, path availability, and structural integrity on demand.
- **Continuous Reliability**: Ensures the AI always operates from a known-good state.

### 3. Native Checkpoint Backups
- **On-Demand Archiving**: Native, cross-platform one-liners archive the `ai/` directory and `ai-customization.md` to a global backup folder. Triggered on demand by saying `"backup ai"` or `"backup ai state"` — not automatic at checkpoints.
- **Zero-Script Reliability**: Built directly into the protocol to ensure your project history is protected.

### 4. Surgical Git-Ignore Exceptions
- **Shell-Force Access**: Specifically authorizes the AI to use shell tools (`cat`, `ls`) to read `AGENTS.md` and the `ai/` folder even if they are git-ignored, bypassing common AI safety refusals while respecting ignore rules for the rest of the project.

### 5. Project Knowledge Protocol
- **Mandatory Sync at Checkpoint**: The AI is required to review and update `ai/shared/project-knowledge/` at every checkpoint, capturing decisions, findings, and discoveries — even if nothing changed (confirmation is mandatory).
- **Persistent Reasoning**: Key identifiers, configuration values, and architectural decisions are written to the project knowledge base so they survive across sessions and agents.

### 6. Multi-Domain Global Policies
- **Modular Expertise**: Specialized policies for Cloud, Frontend, Backend, Data, DBA, Observability, Linux SysAdmin, and Career Coaching.
- **Universal Engineering Standards**: Built-in SOLID, DRY, YAGNI, Twelve-Factor App, Trunk-Based Development, Semantic Versioning, and Conventional Commits — applied across all domains.

### 7. Multi-Agent Coordination
- **Handoff Lifecycle**: Standardized async task transfers between agents or sessions via `ai/shared/handoffs/`.
- **Coordination Board**: Real-time status board (`ai/shared/coordination.md`) for task locking and ownership in multi-agent environments.
- **Single-Writer State Ownership**: **Project AI State Files** are the canonical project narrative, written only by the project-root orchestrator. Sub-agents and role-based team members never write them — they report via the coordination board (the awareness channel), handoffs, and role-scoped knowledge; the orchestrator reconciles those into the state files at each checkpoint.

### 8. AI-Driven Secure Development
- **Implicit Security**: The AI inherently applies secure coding and infrastructure best practices derived from threat modeling (STRIDE, OWASP Top 10).
- **Proactive Scanning**: Mandatory file validation before any Git commit or infrastructure operation.

### 9. Peer Review Mode
- **On-Demand Code Review**: Trigger a strict peer review at any time by saying `"peer review"`, `"code review"`, or `"PR review"`. The AI switches to an objective reviewer role — no code writing, analysis and reporting only.
- **PR-Aware**: For a named PR, the AI fetches the latest remote refs, resolves the source and target branches, and diffs source against target before reviewing — not the local working tree.
- **Scope Discipline**: Reviews never stop at the diff. The AI examines the full file or module the change touches, checks live or runtime state when tooling allows, and states plainly what it did **not** check rather than omitting it silently.
- **Structured Reports**: Each review is saved to `ai/code-review-reports/` with a severity-classified report (Critical / Major / Minor / Suggestions / Not Checked) and a clear **APPROVED** or **CHANGES REQUESTED** verdict.
- **Iterative**: Run as many review rounds as needed. Each round produces a new numbered report; previous reports are never overwritten.

### 10. Session Resume (Compacted Context)
- **Post-Condensation Recovery**: When resuming from a condensed conversation summary, the AI automatically reloads standing rules, all Global Knowledge, and active policies, and re-indexes project knowledge before responding — no manual "load context" needed.
- **Context Integrity**: The condensed summary is treated as the sole authoritative source for current state, preventing stale data from corrupting the fresh context.
- **Gap Detection**: If the summary indicates a module was completed without TDD or peer review, the AI flags this before touching any code.

### 11. PWD-Only Scope
- **Project Isolation**: The AI is restricted to loading `AGENTS.md` and scanning the `ai/` directory from the current working directory only — prevents cross-project context leakage.
- **Safe Multi-Project Use**: Each project maintains its own isolated AI state, even when multiple projects exist under the same parent directory.

### 12. Token Rationing (Context Shielding)
- **Scoped JIT Indexing**: Token Rationing applies only to **Project Knowledge**, which can be large (e.g. repo-scan snapshots). Those files are indexed as a lightweight reference list at boot and loaded in full only when an active task requires it.
- **Full Load for Operational Context**: Settings, Global Knowledge, the common policy, and every policy referenced in `ai-customization.md` are loaded **in full** at boot — the AI never acts on rules or lessons it hasn't actually read.

### 13. Atomic Checkpoint Protocol
- **Atomic Write Protocol**: Checkpoint state is written in strict sequence — `progress.md` (Past) → `next-steps.md` (Future) → `context.md` (Present) — with a Transaction Log output confirming every write. If data is missing, the write aborts entirely.
- **Rich Context Dashboard**: `context.md` maintains a `## Current Status` section as a living dashboard — active branch, milestone, key identifiers, environment state, and open questions — without duplicating completed tasks or pending task lists.
- **Log Condensation (Sliding Horizon)**: When `ai/progress.md` exceeds 50 items or 200 lines, older entries are automatically archived to `ai/shared/project-knowledge/progress-archive.md`, keeping the 10 most recent. When `ai/context.md` exceeds 10 checkpoint entries, keep the 5 most recent and archive the rest to `ai/shared/project-knowledge/context-archive.md`.

### 14. Protocol Developer Mode
- **Self-Maintaining Protocol**: When the current working directory matches the **Global AI Workflow Directory**, the AI detects it is working on the protocol itself, not a user project.
- **Mandatory Pre-load**: Before modifying any protocol file (`AGENTS.md`, policy files, `validate-protocol.sh`, or anything under `ai/`), the AI must fully load `protocol-decisions.md` — bypassing JIT loading, because past decisions are authoritative constraints, not optional context.
- **Path Authoring Rule**: Any path or file reference written into policy files must be authored from the end-user's project root perspective, not from the protocol repository's internal directory structure.

### 15. Verbose AI File Naming
- **Filename as Lookup Key**: A binding guardrail requires the AI to give every knowledge, documentation, and workflow file it creates a verbose, descriptive, kebab-case name — so JIT indexing can map a task to the right file from the name alone.
- **Source Code Carve-Out**: Application and source-code files are explicitly exempt and must follow their language/framework idioms (`Button.tsx`, `user.rb`, `models.py`) — verbose names would break imports, autoloading, and routing.

### 16. Codebase Examination Mode
- **On-Demand Activation**: Say `"codebase examination"` or `"examine this codebase"` to activate the policy for examining (and optionally refactoring) a codebase that is too large to fit in the context window — application code, infrastructure-as-code, or database schemas.
- **Disk-as-Memory + Tiered JIT Loading**: Understanding is persisted to project-knowledge as a tiered skeleton map (repo map → module signatures → full files), loaded just-in-time so the active context stays bounded no matter how large the codebase — or its map.
- **Lightweight by Design**: Uses only the assistant's native file tools (`grep_search`, `read_file`); no vector databases, embeddings, or external indexing tools. Reuses branch-gating, TDD, and peer review as the safety net.

### 17. Custom Policy Auto-Discovery
- **Drop-In Policies**: Any `.md` file dropped into `ai/policies/` or `ai/policies/compliance/` is automatically discovered, loaded in full at boot, and acknowledged in the proof-of-load report — no need to list it in the customization file.
- **Recursive Scan**: The AI runs a recursive `find` on **Project AI Policies Directory** at boot, re-affirmation, and post-condensation recovery, ensuring user-created governance and framework policies are always active.
- **Compliance Directory**: `ai/policies/compliance/` is covered automatically by the recursive scan — dedicated subdirectory for framework-specific rules.

### 18. Git Workspace Detection
- **Multi-Repo Awareness**: Before offering git operations on the project root, the AI scans for `.git` subdirectories. If any are found, the root is recognized as part of a larger git workspace — not a repo itself.
- **Prevents Incorrect Operations**: The AI will not offer `git init`, run `git log` on the root, or propose git operations that assume the root is independently tracked.

### 19. Automatic Sync with Migration
- **One-Command Sync**: The `sync-agents-md.sh` (Linux) and `sync-agents-md.ps1` (Windows) scripts copy the canonical `AGENTS.md` to all project targets and configure each project's `ai-customization.md` in one pass — no manual path swapping.
- **Automatic Migration**: When run against a project with the old `ai/ai-customization.md` layout, the script automatically moves the file to the project root, injects the `## AI Workflow Configuration` section with the correct workflow directory, and preserves all existing expertise, traits, and compliance settings. If both old and new files exist, the old one is renamed to `.bak` with a warning.
- **Idempotent Updates**: If the target already has a root-level `ai-customization.md` with a working config, the script verifies the workflow directory path and updates it only if needed. No unnecessary changes.
- **Free From Song and Dance**: No more editing `AGENTS.md` for each project, no more copy-paste into nested `ai/` directories, no more exit-and-reload ceremony.

---

## Docs and Slides

- [Simple-AI-Workflow (GoogleSlides/Live/up-to-date)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link) - *The slides are available under Creative Commons license.*
- [Simple-AI-Workflow (Markdown slides)](docs/simple-ai-workflow-slides.md) - Project Markdown version of the presentation (Marp-compatible)
- Project docs directory: `docs/`
- AI usage guide (handoffs, knowledge base, coordination, git enrichment): [docs/workflow-guide.md](docs/workflow-guide.md)
- Protocol Validation System Guide: [docs/protocol-validation-system.md](docs/protocol-validation-system.md)
- Policy Influence on Quality & Safety: [docs/policy-influence-on-ai-work.md](docs/policy-influence-on-ai-work.md)
- Preferred AI tooling reference & installation: [docs/tools-preferences.md](docs/tools-preferences.md) *(legacy template — see `global-user-settings.md` for the recommended approach)*
- Codebase Examination Guide (examining/refactoring large codebases): [docs/codebase-examination-guide.md](docs/codebase-examination-guide.md)
- Persona templates (Mentor, Architect, Security Specialist): `docs/personas/`
- About the human user template: `docs/about-human.md` *(legacy template — see `global-user-settings.md` for the recommended approach)*
- Beginner setup guide: `docs/vscode-cline-provider-setup-for-beginners.md`
- Mobile app development policy guide: `docs/ai-policy-mobile-apps-guide.md`

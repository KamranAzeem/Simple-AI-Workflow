<!--
Created-by: Gemini
Updated-by: GitHub Copilot
Last modified: 2026-05-21T00:00:00+02:00
Intent: Fix stale 'final step' checkpoint reference; add Project Knowledge Sync to checkpoint and project-knowledge sections.
-->
---
# AI Usage Guide

This guide explains how to interact with AI assistants in this repository and how to manage the AI state tracking files.

## 1. Project Knowledge (`ai/shared/project-knowledge/`)
All persistent AI reasoning, style guides, and project-specific patterns are stored here.
- **Location**: `/ai/shared/project-knowledge/` (Git-ignored)
- **Status**: Non-version-controlled. Each contributor builds their own project knowledge base.
- **Usage**: Add Markdown files for permanent guidance (e.g., `css-architecture.md`, `style-guide.md`).
- **Policy**: AI assistants treat this directory as the source of truth for repository standards.
- **Checkpoint Sync**: The AI is required to review and update this directory at every checkpoint, capturing any new findings, decisions, or discoveries from the session — even if nothing changed (confirmation is mandatory).

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

## 5. Idiot-Proof Protocol (Low-IQ Compatibility)
### Structural Guardrails
Models with lower instruction-following capability (e.g., smaller or "lite" models) sometimes treat protocols as suggestions, leading to accidental re-initialization or overwriting of context files. This workflow implements high-visibility structural cues to prevent this:
- **Immortality Headers**: A high-visibility `⚠️ STOP` header at the top of `AGENTS.md` prevents AI from modifying the protocol.
- **Immutable Loading**: The context-loading sequence is explicitly flagged as **READ-ONLY**, preventing "instruction drift" during bootstrap.
- **No-Overwrite Mandates**: The context-loading sequence forbids overwriting existing files, ensuring project history is never accidentally wiped.
- **PWD-Only Scope**: The AI is restricted to loading `AGENTS.md` and scanning the `ai/` directory from the current working directory only — prevents cross-project context leakage and ensures each project maintains its own isolated AI state.
- **Recursive Discovery**: AI is commanded to run `ls -R` on the **Global User AI Directory** to proactively find all settings and knowledge subdirectories.
- **Proof-of-Load Summary**: The AI must explicitly list every global file read and every active trait found, providing empirical evidence of a successful bootstrap.

### Benefits
- **Reliability**: Use lower-cost models without risking project state.
- **Consistency**: The same protocol works safely across any IQ tier.
- **Visibility**: You know exactly what intelligence the AI has loaded before you start work.

## 6. Session Resume (Compacted Context)

When a session begins from a condensed/compacted conversation summary (rather than a fresh "load context"), the AI automatically runs a **Post-Condensation Recovery** procedure before responding to your first request.

### How it works
1. The AI detects it is resuming from a compacted summary (identified by structured headings like "Conversation Overview", "Technical Foundation", etc.).
2. It reloads all standing rules from the **Project Customization File** and **Global AI Policies Directory**.
3. It reloads all project knowledge files and applicable policies.
4. It outputs a brief confirmation of what was loaded and flags any gaps (e.g., a module completed without TDD or peer review).

### Key rules
- **Read-only**: No files are created, modified, or deleted during this procedure.
- **No state files**: The AI does not read `context.md`, `progress.md`, `next-steps.md`, or checkpoints — the condensed summary is the sole authoritative source for current state.
- **Gap detection**: If the summary shows work was completed without required processes (TDD, peer review), the AI raises this before proceeding.

### Benefits
- **Zero-touch resume**: No need to say "load context" after every condensation.
- **Context integrity**: Prevents stale pre-compaction data from corrupting the fresh session.
- **Safety net**: Missed processes are caught before any code changes.

## 7. Native Checkpoint Backups
### Automatic State Archiving
To prevent the loss of project context due to accidental overwrites or "hallucinations" from less capable models, the workflow mandates a backup of the `ai/` directory during every checkpoint.
- **Native Commands**: The backup uses native CLI tools (`tar` on Linux/Bash, `Compress-Archive` on PowerShell) embedded directly in `AGENTS.md`.
- **Global Storage**: Archives are stored in `~/.ai/backups/` and are uniquely identified by their project name and timestamp.
- **Policy Enforcement**: The `ai/policies/ai-policy-common.md` mandates two steps at every checkpoint: first, review and update `project-knowledge/` with any findings or decisions from the session; then run the backup. Neither step is optional.

### Benefits
- **Disaster Recovery**: Easily roll back to a previous state if the `ai/` directory is corrupted.
- **History Preservation**: Maintains a granular history of the AI's "brain" and project context over time.

## 8. AI-Driven Secure Development Practices
The AI assistant is designed to inherently apply secure coding and infrastructure best practices derived from threat modeling principles (e.g., STRIDE, OWASP Top 10). This ensures that generated code and configurations adhere to security standards by default, assisting developers, engineers, and security professionals in building safer applications and infrastructure. The AI uses the context of your requests to infer potential security concerns and generate appropriately secure outputs.

## 9. Universal Engineering Standards
The common policy (`ai/policies/ai-policy-common.md`) includes a dedicated **Universal Engineering Standards** section that applies across all domains:

- **SOLID Principles**: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion — non-negotiable for maintainable OO code.
- **DRY (Don't Repeat Yourself)**: Every piece of knowledge has a single, authoritative representation. Extract duplication into shared abstractions, but avoid over-abstracting before patterns emerge.
- **YAGNI (You Ain't Gonna Need It)**: Do not add functionality until it is actually needed.
- **Twelve-Factor App**: Codebase, dependencies, config, backing services, build/release/run, processes, port binding, concurrency, disposability, dev/prod parity, logs, admin processes.
- **Trunk-Based Development**: Short-lived feature branches merged to `main`/`master` frequently (at least daily).
- **Semantic Versioning**: MAJOR.MINOR.PATCH for all published packages and APIs.
- **Conventional Commits**: Structured commit messages (`feature:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`) for automated changelog generation.

These standards are loaded automatically as part of the common policy baseline and do not require any additional configuration.

## 9. AI Customization & Curated Traits
The `ai/ai-customization.md` file is the **"Single Dial"** for tailoring the AI to your project. It supports three configuration sections:

- **Active Expertise**: Load domain-specific policies (e.g., `cloud`, `api-backend`, `web-frontend`, `dba`, `observability`).
- **Active Traits**: Select one behavioral persona from the curated catalog in [`docs/ai-customization-guide.md`](docs/ai-customization-guide.md). Available traits include System Architect, System Integrator, Senior DBA, Observability Architect, Code Reviewer, Security Specialist, and Teacher/Trainer.
- **Required Compliance**: Activate regulatory standards (e.g., `gdpr`, `soc2`, `hipaa`, `iso-27001`) using AI built-in knowledge — no on-disk compliance files needed.

See the [AI Customization Guide](docs/ai-customization-guide.md) for the full catalog and multi-role examples.

## 10. Peer Review Mode

Trigger an on-demand code review at any point by saying:

> *"peer review"*

The AI immediately switches to a **Strict Peer Reviewer** role. It does not write or fix code during this mode — it only identifies, classifies, and explains issues.

### How it works
1. The AI reads `ai/policies/ai-policy-code-review.md` for its reviewer role definition.
2. It scans the files you specify, or the entire repository by default (excluding `ai/`, `tmp/`, and dependency directories).
3. It saves a structured report to `ai/code-review-reports/YYYY-MM-DD_HH-MM_review-NN.md`.
4. The report ends with a clear verdict: **APPROVED** or **CHANGES REQUESTED**.

### Iterating
- Apply the fixes from the report, then ask for another review.
- Each round creates a new numbered report. Previous reports are never overwritten.
- The AI notes which previous issues were resolved at the start of each new report.

### Why multiple review rounds are normal
The AI reviews the **full file set** on every pass — not just the latest diff. This means it can surface issues that were present before your fix, newly introduced issues, and patterns that only become visible after earlier findings are resolved. This is fundamentally different from diff-based automated review tools (like GitHub Copilot PR review), which only see the new diff on each push and therefore require many more rounds to converge. Expect 2–4 rounds for a thorough review; this is the intended workflow, not a sign of poor code quality.

### Compared to GitHub Copilot PR reviewer
Using GitHub Copilot's pull request reviewer involves a frustrating cycle: push your branch, wait for Copilot to review the diff, copy the review comments out of GitHub, paste them into your local AI chat to understand and fix them, apply the fixes, push again, and repeat. Each push triggers a new diff-only review that cannot see issues outside the changed lines. After many rounds, you still may not have a full-codebase verdict. With this workflow's peer review, the entire loop stays in your local AI chat window — no push required, no copy-pasting between tools, and the AI scans the full file set every time.

### Exiting reviewer mode
Say `"done reviewing"`, get an **APPROVED** verdict, or make a commit. The AI returns to its normal role.

### Report structure
- **Critical** — blocks commit (security, data loss, broken functionality)
- **Major** — fix before commit (policy violations, logic errors)
- **Minor** — fix when convenient (style, naming)
- **Suggestions** — optional improvements
- **Verdict** — APPROVED or CHANGES REQUESTED

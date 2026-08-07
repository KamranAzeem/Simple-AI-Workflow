---
# Simple AI Workflow
## From Chatting with AI, to Working with AI

Your trusted pair-programmer / co-driver / co-pilot

A no-fluff, simple & secure workflow for reliable AI-assisted work

by Muhammad Kamran Azeem (kamran@wbitt.com)

[github.com/KamranAzeem/Simple-AI-Workflow](https://github.com/KamranAzeem/Simple-AI-Workflow) — Creative Commons Attribution 4.0 International
... (rest of slides until feature list) ...
---

# More Features

- **Safe Git Operations** — Secrets scanning before every commit
- **No Tooling Lock-in** — Purely protocol-based; no brittle scripts or "song and dance"
- **Git Enrichment** — Automatic distillation of Git history
- **Handoff Protocol** — Seamlessly switch between IDE, CLI, and Web Chat
- **Notes (`ai/notes/`)** — Unpolished thoughts, meeting notes, random ideas
- **Artifacts (`ai/artifacts/`)** — Draft outputs, review before promoting to docs/code
- **Global Settings** (`~/.ai/settings/global-user-settings.md`) — AI learns your skills, tool preferences, and cross-project context
- **Modular Persona** — Quickly shift AI focus (Architect, Mentor) without losing guardrails
- **Project Customization** — `ai-customization.md` at project root for project-specific tailoring with curated traits catalog
- **Compliance Intelligence** — AI-native compliance using built-in knowledge; no on-disk compliance files needed
- **Idiot-Proof Protocol** — Structural guardrails for safe use with lower-capability "lite" models
- **Native Backups** — On-demand cross-platform state archiving; say `"backup ai"` to trigger (not automatic at checkpoints)
- **Project Knowledge Sync** — Key findings, decisions, and discoveries are written to `project-knowledge/` at every checkpoint
- **Universal Engineering Standards** — SOLID, DRY, YAGNI, Twelve-Factor App, Trunk-Based Development, SemVer, Conventional Commits
- **Intellectual Rigor** — Architect persona pressure-tests ideas with honest critique; no "yes man" engagement
- **Daily Snapshots** — Automated history of work and decisions
- **Peer Review Mode** — On-demand full-file-set code review (including PR reviews) with structured, severity-classified reports
- **Session Resume (Compacted Context)** — Re-reads standing rules, all Global Knowledge, and active policies, and re-indexes the shared directory when the conversation is compacted; additive reload that never wipes the working thread
- **PWD-Only Scope** — AI loads `AGENTS.md` and scans `ai/` from the current working directory only
- **Token Rationing Shield** — Settings, Global Knowledge, and active policies are always fully loaded; large Project Knowledge files are indexed at boot and loaded on demand
- **Log Condensation Shield** — Sliding Horizon auto-archives progress history when thresholds are crossed; keeps active context token-efficient
- **Atomic Write Protocol** — Checkpoint state writes are sequential and transactional; partial writes abort automatically with a transaction log in chat
- **Protocol Developer Mode** — When working on the protocol itself, AI detects the context, mandates a full load of `protocol-decisions.md`, and enforces end-user-perspective path authoring in policy files
- **Verbose AI File Naming** — AI gives knowledge/docs/workflow files descriptive kebab-case names (filename = JIT lookup key); application/source code is exempt and follows language/framework idioms
- **Codebase Examination Mode** — Activated by saying `"codebase examination"` or `"examine this codebase"`; uses tiered, disk-backed skeleton maps; no vector DBs or external tools
- **Career Coaching Policy** — Dedicated policy for job search strategy, resume/cover letter optimization, interview prep (STAR method), and career transition narrative
- **Windows System Admin Policy** — Covers Windows Server, Active Directory, Group Policy, PowerShell automation, Microsoft security baselines (SCT, CIS, DISA STIGs), Intune, MECM, and Zero Trust
- **Design Documentation Flow** — Structured document stack: Vision → PRD → HLD → LLD → ADRs → Delivery Ledger; ID-based tracking (`REQ-NNN`, `HLD-NNN`, `LLD-NNN`); AI checks for missing docs and updates the ledger at every checkpoint

---

# How Does This Compare to Copilot, Claude, ChatGPT, and Cursor?

## The Black Box Problem

Every AI assistant stores its context in its own hidden way:

- **Copilot** — memory in VS Code's internal storage and `/memories/` files; VS Code-only
- **Claude** — `CLAUDE.md` at project root + Claude Projects on Anthropic's servers
- **ChatGPT** — automatic Memory in your OpenAI account; AI decides what to save
- **Cursor** — `.cursor/rules` inside the project; invisible to every other tool

They are black boxes of different shades. Some darker than others.

**The core problem**: the state belongs to the tool, not to you.

Switch tools and you start from scratch. The new assistant has no idea what the previous one knew.

> **One tool = one box. Two tools = two boxes. No shared memory. Ever.**

---

# How Major AI Tools Store Context

| What you need | Copilot | Claude | ChatGPT | Cursor |
|---|---|---|---|---|
| Project instructions | `.github/copilot-instructions.md` | `CLAUDE.md` | Custom instructions | `.cursor/rules` |
| User preferences | `/memories/` (user scope) | `~/.claude/CLAUDE.md` | Custom instructions | User rules (in settings) |
| Per-project customization | No | No | Projects | No |
| Domain expertise / rules | `SKILLS.md`, `.instructions.md` | `CLAUDE.md` sections | Custom GPTs | `.cursor/rules` sections |
| Progress tracking | None | Claude Projects history | Projects | None |
| Pending tasks | None | None | None | None |
| Project knowledge / decisions | None | Uploaded files | Uploaded files | None |
| Cross-project lessons | None | Manual | Automatic, opaque | None |
| Post-summary recovery | `PreCompact` hook | None | None | None |

---

# Simple AI Workflow — The Same Table

| What you need | Simple AI Workflow |
|---|---|
| Project instructions | `AGENTS.md` — works with any tool, any editor |
| User preferences | `~/.ai/settings/global-user-settings.md` |
| Per-project customization | `ai-customization.md` |
| Domain expertise / rules | 16 modular policies in `ai/policies/` |
| Progress tracking | `ai/progress.md` |
| Pending tasks | `ai/next-steps.md` |
| Project knowledge / decisions | `ai/shared/project-knowledge/` |
| Cross-project lessons | `~/.ai/global-knowledge/` — explicit, structured |
| Post-summary recovery | Post-Compaction Recovery — automatic |
| Multi-tool handoffs | `ai/shared/handoffs/` |
| Compliance enforcement | `ai/policies/compliance/` + AI built-in knowledge |
| Peer code review | `"peer review"` — saved reports in `ai/code-review-reports/` |
| Protocol self-validation | `validate-protocol.sh` |
| Sync across all your projects | `sync-agents-md.sh` / `.ps1` |

> **One set of files. Any assistant reads them. Everything in plain sight.**

---

# Why Simple AI Workflow Wins on Portability

## Switch AI tools without losing anything
- Open any assistant, type `"load context using AGENTS.md protocol"`
- It reads the same files the previous assistant was using
- Copilot → Claude → ChatGPT → back to Copilot: zero re-work

## Change editors, OS, or machines — zero setup
- Files live in your project directory. That's it.
- VS Code → terminal → JetBrains — same files, same workflow
- Linux → macOS → Windows — nothing changes
- Copilot memory: VS Code only. Claude Projects: Anthropic's servers. ChatGPT Memory: your OpenAI account.
- **Simple AI Workflow: just files. They go wherever you go.**

## Moving to a new machine
- Run `"backup ai"` — archives the entire `ai/` directory to `~/.ai/backups/`
- Or set up `ai/` as its own private git repo (common for architects and platform engineers managing multiple projects)
- `git clone` and you are straight back to work

> **Your context is yours. Not the tool's. Not the cloud's. Yours.**

---

# The Trade-Off — And Why It Is Worth It

## What native tools do better
- ChatGPT Memory saves things automatically — zero effort
- Copilot's instructions are injected automatically — no prompt needed
- Claude reads `CLAUDE.md` without being asked

## What Simple AI Workflow asks of you
- `"load context using AGENTS.md protocol"` — start of every session
- `"checkpoint"` — after each task
- `"update project knowledge"` — when a decision is made
- `"backup ai"` — when you want a backup

## Why that friction is actually good
- Typing `"checkpoint"` forces a pause. You review what was done.
- `"update project knowledge"` makes you ask: *what did we decide, and is it written down?*
- The commands are friction — but they are **productive friction**.
- And unlike native automation, **you always know exactly what was saved and why**.

> **Less magic. More control. More discipline. Better results.**

---

# Idiot-Proof Protocol (Low-IQ Compatibility)

## The Problem: Instruction Drift
- Lower-capability "lite" models often treat protocols as suggestions
- Can lead to accidental re-initialization or overwriting context files
- "Instruction drift" occurs during complex bootstrap processes

## The Solution: Structural Guardrails
- **Immortality Headers**: High-visibility `⚠️ STOP` header prevents AI from modifying the protocol
- **Immutable Loading**: The context-loading sequence is explicitly flagged as **READ-ONLY**
- **No-Overwrite Mandates**: The context-loading sequence forbids overwriting existing files
- **Recursive Discovery**: AI must `ls -R` the **Global User AI Directory** to find all intelligence
- **Proof-of-Load**: AI must explicitly list Settings and Global Knowledge files fully loaded and Project Knowledge files indexed before proceeding

> **Safe execution across any IQ tier.** Use lower-cost models without risking project state.

---

# Native Checkpoint Backups

## The Problem: Fragile State
- AI "hallucinations" can sometimes lead to accidental context destruction
- Relying on manual backups is unreliable and slow
- "Dumb" models need a forced safety net

## The Solution: On-Demand Archiving
- **Native CLI One-Liners**: Bash (`tar`) and PowerShell (`Compress-Archive`)
- **On-Demand Trigger**: Run by saying "backup ai" or "backup ai state" (Procedure F) — not automatic at checkpoints
- **Global Storage**: Saved to `~/.ai/backups/` for easy recovery
- **Unique Naming**: `{parent}_{project}_{timestamp}`

> **Zero-Script Reliability.** Your project history is always protected.

---

# On-Demand Peer Review

## How it works
- Say `"peer review"`, `"code review"`, or `"PR review"` — the AI switches to an objective reviewer role
- For a named PR: fetches latest, resolves source/target branches, diffs source against target
- Scans the full file or module the change touches (not just a diff); checks live state when available; saves a structured report to `ai/code-review-reports/`
- Each report is severity-classified: **Critical / Major / Minor / Suggestions / Not Checked**
- Ends with a clear verdict: **APPROVED** or **CHANGES REQUESTED**
- Previous reports are never overwritten; each round gets a new numbered file

## Why multiple rounds are normal
- The AI reviews the **full file set** on every pass — not just the latest diff
- Fixing one issue can make a different pattern visible in the next pass
- Diff-based tools (e.g. GitHub Copilot PR review) see only the new diff on each push, requiring many more rounds to converge
- Expect 2–4 rounds for a thorough review; this is by design

## vs. GitHub Copilot PR Reviewer
- Push branch → wait for review → copy comments out of GitHub → paste into local AI → fix → push again → repeat
- Each push triggers a diff-only review — issues outside the changed lines are invisible
- After 15+ rounds you may still not have a full-codebase verdict
- With this workflow: everything stays in your local chat — no push, no copy-paste, full file set every time

> **Full-file-set review. Every round. No blind spots.**

---

# Token Rationing Shield

## The Problem: Context Window Bloat
- Loading every large knowledge file at boot consumes context window space in every session
- Large knowledge bases make every "load context" slower and more token-intensive
- Not all files are needed for every task

## The Solution: Scoped Token Rationing
- **Global Knowledge fully loaded at boot**: `~/.ai/global-knowledge/` files — small set, loaded in full so the AI never guesses at a lesson it never read
- **Active policies fully loaded at boot**: every policy referenced in `ai-customization.md` — the AI cannot follow a rule it hasn't read
- **Project Knowledge indexed at boot**: `ai/shared/project-knowledge/` files — index-only; large files load on demand
- **On-Demand Depth**: Project Knowledge loads precisely when a task needs it, not speculatively

> **Lean context. Fast boot. Full depth when it matters.**

---

# Design Documentation Flow

## The Stack

```
notes → vision → PRD → HLD → LLD → ADRs → delivery ledger
```

| Document | What it is |
|---|---|
| **Vision** | What you want to build and why. Plain language. 1–2 pages. |
| **PRD** | Requirements with `REQ-NNN` IDs. Defines scope and success criteria. |
| **HLD** | Architecture and components with `HLD-NNN` IDs. |
| **LLD** | Detailed per-component design with `LLD-NNN` IDs. |
| **ADRs** | Significant decisions with `ADR-NNN` IDs and full rationale. |
| **Delivery Ledger** | Tracks which IDs are done, in progress, or not started. |

## How the AI helps
- Checks for missing documents at the start of every session and prompts to create them
- Assigns IDs when generating requirements, components, or design items
- Updates the delivery ledger at every checkpoint
- Treats documentation drift as a code smell — flags design docs that lag behind the code

> **Start with notes. End with a clear record of what was built and why.**

---

# Use Verbose File Names

## Why It Matters
- The AI does not load large project knowledge files at boot — it builds a lightweight index instead
- The **filename is the lookup key**: when a task requires specific knowledge, the AI maps the task to the most relevant file by name
- A vague name like `notes.md` is invisible to this process — the AI cannot confidently map any task to it
- A descriptive name like `azure-postgresql-migration-decisions.md` is unambiguous

## The Rule
- Name every file in `ai/shared/project-knowledge/` and `~/.ai/global-knowledge/` to clearly describe its content
- Use kebab-case: `project-name-topic-subtopic.md`
- Ask: could a colleague guess what this file contains from the name alone? If not, rename it

## Good vs Poor Examples

| Poor | Good |
|---|---|
| `decisions.md` | `api-versioning-strategy-and-breaking-change-policy.md` |
| `notes.md` | `orders-service-sql-schema-constraints.md` |
| `architecture.md` | `azure-cli-subscription-context-fix.md` |

> **The filename is the lookup key. Make it count.**

---

# Atomic Checkpoint Protocol

## The Problem: Partial Writes & Context Drift
- A checkpoint interrupted mid-write leaves state files inconsistent
- Unbounded progress logs bloat the context window over time
- Writing one file without immediately updating the others causes context drift

## The Solution: Atomic Writes & Sliding Horizon
- **Sequential Writes**: `progress.md` → `next-steps.md` → `context.md` — strict order, always
- **Transaction Log**: Every checkpoint outputs a confirmation block in chat — what was written and what changed
- **Abort on Missing Data**: If data is incomplete, the write aborts; the gap is reported to the user
- **Sliding Horizon**: When `progress.md` exceeds 50 items or 200 lines, older entries archive automatically to `progress-archive.md`

> **Consistent state. Every checkpoint. No silent failures.**

---

# Keeping Context Healthy

## What is Context Rot?
- Over a long session, AI working knowledge degrades — stale state, token pressure, forgotten rules
- The AI starts contradicting earlier decisions or re-asking questions it already answered
- Left unchecked, it erodes the reliability of every output

## Built-in Defences in This Workflow
- **Atomic Write Protocol** — state files sync together or not at all; no partial writes
- **Sliding Horizon Shield** — `progress.md` auto-archives when it exceeds 50 items or 200 lines
- **Post-Compaction Recovery** — reloads rules from disk after any context compaction; for VS Code/Copilot a `PreCompact` hook provides a mechanical re-arm; for other tools a one-time memory note works (see the reload-trigger setup guide)
- **Proof-of-Load** — AI must confirm every file it read before starting work
- **Mandatory knowledge sync** — project decisions are written to `project-knowledge/` at every checkpoint

## The "Load Context" Command
- **Full form**: `"load context using AGENTS.md protocol"` — use this at the start of every session
- **Shorthand**: `"load context"` — fine mid-session; unreliable for fresh or weaker models
- **Rule**: always use the full form at the start of a new session or after a restart

## Habits That Prevent the Rest
- Checkpoint after each logical unit of work — not just at end of day
- When the AI loses track of context, checkpoint and start a fresh session
- Set up the per-tool reload trigger once; after any summary, ask "did you run the post-compaction reload?" before trusting the next answer
- Keep `context.md` lean — current state only, not a history log
- Review `next-steps.md` at session start — trim stale items before working

> **Checkpoint often. Session short. Context stays clean.**

---

# Post-Compaction Recovery

## What happens

Context windows fill up. The assistant compacts the conversation — replacing full history
with a compressed summary. Without recovery, the standing rules loaded at session start
(AGENTS.md, policies, Global Knowledge) are gone.

## How the recovery works

The AI re-reads all standing rules from disk. The compaction summary and task state are
never touched — only the rules reload.

```
   Session Start          Mid-Session          After Compaction      After Recovery

┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│ ■ AGENTS.md      │  │ ■ AGENTS.md      │  │ compacted        │  │ compacted        │
│ ■ Policies       │  │ ■ Policies       │  │ conversation     │  │ conversation     │
│ ■ Global Knowl.  │  │ ■ Global Knowl.  │  ├──────────────────┤  ├──────────────────┤
├──────────────────┤  ├──────────────────┤  │                  │  │ ■ AGENTS.md      │
│                  │  │ code, diffs,     │  │                  │  │ ■ Policies       │
│                  │  │ searches,        │  │ active work +    │  │ ■ Global Knowl.  │
│ active work +    │  │ conversation...  │  │ free space       │  ├──────────────────┤
│ free space       │  │ tool outputs...  │  │                  │  │ active work      │
│                  │  ├──────────────────┤  │                  │  │ (current) +      │
│                  │  │ ↑ compacted here │  │                  │  │ free space       │
│                  │  │  (limited free)  │  │                  │  │                  │
└──────────────────┘  └──────────────────┘  └──────────────────┘  └──────────────────┘
```

> Rules reload. Task state preserved. Session continues.

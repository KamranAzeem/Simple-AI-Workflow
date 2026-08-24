---
# Simple AI Workflow
## From Chatting with AI, to Working with AI

Your trusted pair-programmer, co-driver, and co-pilot

A no-fluff, simple, and secure workflow for reliable AI-assisted work

by Muhammad Kamran Azeem (kamran@wbitt.com)

[github.com/KamranAzeem/Simple-AI-Workflow](https://github.com/KamranAzeem/Simple-AI-Workflow), Creative Commons Attribution 4.0 International

*(The intro slides live in the Google Slides deck linked above.)*

---

# More Features

- **Safe Git operations**: secrets scan before every commit
- **No tool lock-in**: it is protocol-based, with no brittle scripts or "song and dance"
- **Git enrichment**: it distils your git history automatically
- **Handoff protocol**: switch between IDE, CLI, and web chat
- **Notes (`ai/notes/`)**: rough thoughts, meeting notes, random ideas
- **Artifacts (`ai/artifacts/`)**: draft outputs you review before promoting to docs or code
- **Global settings** (`~/.ai/settings/global-user-settings.md`): the AI learns your skills, tool preferences, and cross-project context
- **Modular persona**: shift the AI's focus (Architect, Mentor) without losing the guardrails
- **Project customization**: `ai-customization.md` at the project root, with a curated traits catalog
- **Compliance intelligence**: built-in AI knowledge, no on-disk compliance files
- **Idiot-proof protocol**: structural guardrails so even "lite" models stay safe
- **Native backups**: on-demand and cross-platform. Say `"backup ai"` to run one (it is not automatic at checkpoints)
- **Project knowledge sync**: findings, decisions, and discoveries land in `project-knowledge/` at every checkpoint
- **Universal engineering standards**: SOLID, DRY, YAGNI, Twelve-Factor, trunk-based development, SemVer, Conventional Commits
- **Intellectual rigor**: the Architect persona pressure-tests your ideas with honest critique, no "yes man"
- **Daily snapshots**: an automatic history of work and decisions
- **Peer review mode**: on-demand, full-file-set review (including PRs) with structured, severity-classified reports
- **Session resume (compacted context)**: re-reads the standing rules, all Global Knowledge, and active policies, and re-indexes the shared directory after a compaction. It adds files, it never wipes your working thread
- **PWD-only scope**: the AI loads `AGENTS.md` and scans `ai/` from the current directory only
- **Token rationing shield**: settings, Global Knowledge, and active policies load in full; large Project Knowledge files are indexed at boot and loaded on demand
- **Log condensation shield**: the Sliding Horizon auto-archives progress history once it crosses a threshold, keeping context lean
- **Atomic write protocol**: checkpoint writes are sequential and transactional. Partial writes abort, with a transaction log in the chat
- **Protocol developer mode**: when you work on the protocol itself, the AI detects it, loads `protocol-decisions.md` in full, and authors policy paths from the end-user's perspective
- **Verbose AI file naming**: the AI gives knowledge, docs, and workflow files descriptive kebab-case names (the filename is the lookup key). Source code is exempt and follows its own idioms
- **Codebase examination mode**: say `"codebase examination"` or `"examine this codebase"`. It uses tiered, disk-backed skeleton maps, no vector DBs or external tools
- **Career coaching policy**: job-search strategy, resume and cover-letter work, interview prep (STAR method), and career-transition narrative
- **Windows system admin policy**: Windows Server, Active Directory, Group Policy, PowerShell, Microsoft security baselines (SCT, CIS, DISA STIGs), Intune, MECM, and Zero Trust
- **Design documentation flow**: a document stack of Vision, PRD, HLD, LLD, ADRs, and a Delivery Ledger, with ID-based tracking (`REQ-NNN`, `HLD-NNN`, `LLD-NNN`). The AI checks for missing docs and updates the ledger at every checkpoint

---

# How does this compare to Copilot, Claude, ChatGPT, and Cursor?

## The black box problem

Every AI assistant stores its context in its own hidden way:

- **Copilot**: memory in VS Code's internal storage and `/memories/` files, VS Code only
- **Claude**: `CLAUDE.md` at the project root, plus Claude Projects on Anthropic's servers
- **ChatGPT**: automatic Memory in your OpenAI account, and the AI decides what to save
- **Cursor**: `.cursor/rules` inside the project, invisible to every other tool

They are black boxes of different shades, some darker than others.

**The core problem**: the state belongs to the tool, not to you.

Switch tools and you start from scratch. The new assistant has no idea what the last one knew.

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

# Simple AI Workflow: the same table

| What you need | Simple AI Workflow |
|---|---|
| Project instructions | `AGENTS.md`, works with any tool, any editor |
| User preferences | `~/.ai/settings/global-user-settings.md` |
| Per-project customization | `ai-customization.md` |
| Domain expertise and rules | 16 modular policies in `ai/policies/` |
| Progress tracking | `ai/state/progress.md` |
| Pending tasks | `ai/state/next-steps.md` |
| Project knowledge and decisions | `ai/shared/project-knowledge/` |
| Cross-project lessons | `~/.ai/global-knowledge/`, explicit and structured |
| Post-summary recovery | Post-Compaction Recovery, automatic |
| Multi-tool handoffs | `ai/shared/handoffs/` |
| Compliance enforcement | `ai/policies/compliance/` plus built-in AI knowledge |
| Peer code review | `"peer review"`, saved reports in `ai/code-review-reports/` |
| Protocol self-validation | `validate-protocol.sh` |
| Sync across all your projects | `sync-agents-md.sh` or `.ps1` |

> **One set of files. Any assistant reads them. Everything in plain sight.**

---

# Why Simple AI Workflow wins on portability

## Switch AI tools without losing anything
- Open any assistant, type `"load context using AGENTS.md protocol"`
- It reads the same files the previous assistant was using
- Copilot to Claude to ChatGPT and back to Copilot: zero re-work

## Change editors, OS, or machines, with zero setup
- Files live in your project directory. That is it.
- VS Code, terminal, JetBrains: same files, same workflow
- Linux, macOS, Windows: nothing changes
- Copilot memory: VS Code only. Claude Projects: Anthropic's servers. ChatGPT Memory: your OpenAI account.
- **Simple AI Workflow: just files. They go wherever you go.**

## Moving to a new machine
- Run `"backup ai"` and it archives the whole `ai/` directory to `~/.ai/backups/`
- Or set `ai/` up as its own private git repo (handy if you manage many projects)
- `git clone` and you are straight back to work

> **Your context is yours. Not the tool's. Not the cloud's. Yours.**

---

# The trade-off, and why it is worth it

## What native tools do better
- ChatGPT Memory saves things automatically, with zero effort
- Copilot's instructions are injected automatically, no prompt needed
- Claude reads `CLAUDE.md` without being asked

## What Simple AI Workflow asks of you
- `"load context using AGENTS.md protocol"` at the start of every session
- `"checkpoint"` after each task
- `"update project knowledge"` when you make a decision
- `"backup ai"` when you want a backup

## Why that friction is actually good
- Typing `"checkpoint"` forces a pause. You review what was done.
- `"update project knowledge"` makes you ask: *what did we decide, and is it written down?*
- The commands are friction, but it is **productive friction**.
- And unlike native automation, **you always know exactly what was saved, and why**.

> **Less magic. More control. More discipline. Better results.**

---

# Idiot-proof protocol (works with lite models)

## The problem: instruction drift
- Lower-capability "lite" models often treat protocols as suggestions
- That can lead to accidental re-initialization or overwritten context files
- The drift creeps in during a complex bootstrap

## The solution: structural guardrails
- **Immortality headers**: a high-visibility `⚠️ STOP` header keeps the AI from modifying the protocol
- **Immutable loading**: the context-loading sequence is flagged **READ-ONLY**
- **No-overwrite mandates**: the context-loading sequence forbids overwriting existing files
- **Recursive discovery**: the AI runs `ls -R` on the **Global User AI Directory** to find everything
- **Proof-of-Load**: the AI lists the Settings and Global Knowledge files it fully loaded, and the Project Knowledge files it indexed, before it starts

> **Safe with any model.** Use lower-cost models without risking your project state.

---

# Native checkpoint backups

## The problem: fragile state
- An AI "hallucination" can wreck your context by accident
- Manual backups are slow and easy to forget
- Weaker models need a forced safety net

## The solution: on-demand archiving
- **Native one-liners**: Bash (`tar`) and PowerShell (`Compress-Archive`)
- **On-demand trigger**: say "backup ai" or "backup ai state" to run one. It is not automatic at checkpoints
- **Global storage**: saved to `~/.ai/backups/` for easy recovery
- **Unique naming**: `{parent}_{project}_{timestamp}`

> **Reliable, with zero scripts.** Your project history is always protected.

---

# On-demand peer review

## How it works
- Say `"peer review"`, `"code review"`, or `"PR review"`, and the AI switches to an objective reviewer role
- For a named PR it fetches the latest, resolves the source and target branches, and diffs source against target
- It scans the full file or module the change touches, not just the diff, checks live state when it can, and saves a structured report to `ai/code-review-reports/`
- Each report is severity-classified: **Critical, Major, Minor, Suggestions, Not Checked**
- It ends with a clear verdict: **APPROVED** or **CHANGES REQUESTED**
- Previous reports are never overwritten. Each round gets a new numbered file

## Why multiple rounds are normal
- The AI reviews the **full file set** on every pass, not just the latest diff
- Fixing one issue can make a different pattern show up in the next pass
- Diff-based tools (like the GitHub Copilot PR review) see only the new diff on each push, so they need many more rounds to converge
- Expect 2 to 4 rounds for a thorough review. That is by design

## Compared to the GitHub Copilot PR reviewer
- There you push the branch, wait for the review, copy the comments out of GitHub, paste them into your local AI, fix, push again, and repeat
- Each push triggers a diff-only review, so issues outside the changed lines stay invisible
- After 15 or more rounds you may still not have a full-codebase verdict
- Here everything stays in your local chat: no push, no copy-paste, and the full file set every time

> **Full-file-set review. Every round. No blind spots.**

---

# Token rationing shield

## The problem: a bloated context window
- Loading every large knowledge file at boot eats context space in every session
- Big knowledge bases make every "load context" slower and more token-heavy
- Not every file is needed for every task

## The solution: scoped token rationing
- **Global Knowledge loaded in full at boot**: the `~/.ai/global-knowledge/` set is small, so it loads whole and the AI never guesses at a lesson it never read
- **Active policies loaded in full at boot**: every policy named in `ai-customization.md`, because the AI cannot follow a rule it hasn't read
- **Project Knowledge indexed at boot**: the `ai/shared/project-knowledge/` files are index-only, and large ones load on demand
- **Depth on demand**: Project Knowledge loads when a task needs it, not just in case

> **Lean context. Fast boot. Full depth when it matters.**

---

# Design Documentation Flow

## The Stack

```
notes → vision → PRD → HLD → LLD → ADRs → delivery ledger
```

| Document | What it is |
|---|---|
| **Vision** | What you want to build and why. Plain language. One to two pages. |
| **PRD** | Requirements with `REQ-NNN` IDs. Defines scope and success criteria. |
| **HLD** | Architecture and components with `HLD-NNN` IDs. |
| **LLD** | Detailed per-component design with `LLD-NNN` IDs. |
| **ADRs** | Significant decisions with `ADR-NNN` IDs and full rationale. |
| **Delivery Ledger** | Tracks which IDs are done, in progress, or not started. |

## How the AI helps
- It checks for missing documents at the start of every session and offers to create them
- It assigns IDs as it writes requirements, components, or design items
- It updates the delivery ledger at every checkpoint
- It treats documentation drift as a code smell, and flags design docs that lag behind the code

> **Start with notes. End with a clear record of what was built, and why.**

---

# Use verbose file names

## Why it matters
- The AI does not load large project knowledge files at boot. It builds a lightweight index instead
- The **filename is the lookup key**. When a task needs specific knowledge, the AI maps the task to a file by its name
- A vague name like `notes.md` is invisible to that process. The AI cannot map any task to it with confidence
- A descriptive name like `azure-postgresql-migration-decisions.md` leaves no doubt

## The rule
- Name every file in `ai/shared/project-knowledge/` and `~/.ai/global-knowledge/` so it describes its content
- Use kebab-case: `project-name-topic-subtopic.md`
- Ask yourself: could a colleague guess what this file holds from the name alone? If not, rename it

## Good vs poor examples

| Poor | Good |
|---|---|
| `decisions.md` | `api-versioning-strategy-and-breaking-change-policy.md` |
| `notes.md` | `orders-service-sql-schema-constraints.md` |
| `architecture.md` | `azure-cli-subscription-context-fix.md` |

> **The filename is the lookup key. Make it count.**

---

# Atomic checkpoint protocol

## The problem: partial writes and context drift
- A checkpoint interrupted mid-write leaves the state files out of sync
- Progress logs that grow forever bloat the context window
- Writing one file without updating the others causes context drift

## The solution: atomic writes and a sliding horizon
- **Sequential writes**, always in this order: `ai/state/progress.md`, then `ai/state/next-steps.md`, then `ai/state/context.md`
- **Transaction log**: every checkpoint prints a confirmation block in the chat, showing what was written and what changed
- **Abort on missing data**: if the data is incomplete, the write aborts and the gap is reported to you
- **Sliding horizon**: once `ai/state/progress.md` passes 50 items or 200 lines, older entries archive automatically to `progress-archive.md`

> **Consistent state. Every checkpoint. No silent failures.**

---

# Keeping context healthy

## What is context rot?
- Over a long session, the AI's working memory drifts: stale state, token pressure, forgotten rules
- It starts contradicting earlier decisions, or re-asking questions it already answered
- Left alone, it erodes the reliability of every answer

## Built-in defences in this workflow
- **Atomic write protocol**: state files sync together or not at all, so no partial writes
- **Sliding horizon shield**: `ai/state/progress.md` auto-archives once it passes 50 items or 200 lines
- **Post-Compaction Recovery**: reloads rules from disk after any compaction. On VS Code and Copilot a `PreCompact` hook re-arms it mechanically; on other tools a one-time memory note does the job (see the reload-trigger setup guide)
- **Proof-of-Load**: the AI confirms every file it read before it starts work
- **Mandatory knowledge sync**: project decisions land in `project-knowledge/` at every checkpoint

## The "load context" command
- **Full form**: `"load context using AGENTS.md protocol"`. Use this at the start of every session
- **Shorthand**: `"load context"`. Fine mid-session, but unreliable for fresh or weaker models
- **Rule**: always use the full form at the start of a new session, or after a restart

## Habits that handle the rest
- Checkpoint after each logical unit of work, not just at the end of the day
- When the AI loses the thread, checkpoint and start a fresh session
- Set up the per-tool reload trigger once. After any summary, ask "did you run the post-compaction reload?" before you trust the next answer
- Keep `ai/state/context.md` lean: current state only, not a history log
- Review `ai/state/next-steps.md` at session start, and trim stale items before you work

> **Checkpoint often. Keep sessions short. Context stays clean.**

---

# Post-Compaction Recovery

## What happens

Context windows fill up. The assistant compacts the conversation, replacing the full history
with a compressed summary. Without recovery, the standing rules loaded at session start
(AGENTS.md, policies, Global Knowledge) are gone.

## How the recovery works

The AI re-reads all standing rules from disk. The compaction summary and task state are
never touched. Only the rules reload.

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

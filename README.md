# Simple AI Workflow

> **Existing users**: The customization file moved from `ai/ai-customization.md` to `ai-customization.md` at the project root. Run the sync script (`support-files/sync-agents-md.sh` or `sync-agents-md.ps1`) to migrate automatically, or follow the [manual steps](docs/ai-customization-guide.md).

**Goal: Stop *chatting* with AI. Start *working* with AI.**

## Setup

- **Time**: Less than 5 minutes.
- **Difficulty**: Very low.
- **What you need**: Any AI assistant. Works best with one integrated into VS Code — Copilot, Claude, Gemini, DeepSeek, ChatGPT.
- **Installation**: One `git clone` and one file copy. No install scripts, no admin rights, no package managers.

## Quick Start

1. Clone this repo somewhere on your machine (e.g., `~/Projects/Simple-AI-Workflow`).
2. Create the global AI directory:
   - `$HOME/.ai/settings/`
   - `$HOME/.ai/global-knowledge/`
   - (Optional) Copy `docs/about-human.md` to `$HOME/.ai/settings/global-user-settings.md` and fill in your name, skills, and tool preferences.
3. Copy `AGENTS.md` to your project root.
4. In that `AGENTS.md`, set `Global AI Workflow Directory` to where you cloned this repo.
5. Open your project in VS Code and type this in the AI chat:
   - `"bootstrap using AGENTS.md protocol"`

> Don't use `/init` — it behaves differently across AI tools. Use the text prompt above.

## Setting up a new project

1. Copy `AGENTS.md` to the project root.
2. Copy `docs/ai-customization.md` to `ai-customization.md` at the project root. Update the workflow directory path inside it.
3. Optionally add expertise, traits, or compliance settings — see the [customization guide](docs/ai-customization-guide.md).
4. Type `"bootstrap using AGENTS.md protocol"` in the AI chat.
5. After each session, do a checkpoint. To resume later, type `"load context using AGENTS.md protocol"`.

## Keeping AGENTS.md up to date

When this repo has updates you want to use:

1. Do a checkpoint in your current project first.
2. `git pull` the latest changes here.
3. Run the sync script to update all your projects:

   **Linux/Git Bash:**
   ```bash
   ./support-files/sync-agents-md.sh --source ./AGENTS.md --target-path ~/Projects --dry-run
   ./support-files/sync-agents-md.sh --source ./AGENTS.md --target-path ~/Projects
   ```

   **Windows PowerShell:**
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\support-files\sync-agents-md.ps1 -Source '.\AGENTS.md' -TargetPath 'C:\Users\<you>\Projects' -WhatIf }"
   powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\support-files\sync-agents-md.ps1 -Source '.\AGENTS.md' -TargetPath 'C:\Users\<you>\Projects' }"
   ```

4. In each project, type `"load context using AGENTS.md protocol"` to pick up the new rules.


## What this is — and what it isn't

### What it is

A personal starter kit for one developer — you.

It helps you:
- Get better answers from your AI assistant — because it now knows your project's rules and your own preferences.
- Use the same setup across all your projects and across different AI tools.
- Stay organized — progress, notes, and decisions are saved so you can pick up where you left off.
- Keep AI notes out of your git history.

Think of it as turning your AI from a chat buddy into a teammate that actually remembers things.

### What it isn't

- Not an agent router — you still decide which AI to use.
- Not autonomous — the AI doesn't run in loops or make decisions without you.
- Not a team tool — designed for one developer.
- Not a replacement for your CI/CD, tests, or security scanners.
- Not a training system — it doesn't fine-tune models.

### Why this exists

If you only ever use one AI assistant, you probably don't need this. Your assistant keeps its own context and that mostly works fine.

The problem starts when you use two or more assistants on the same project. Without a shared system, each assistant stores its own state in its own hidden directory. Switch assistants and you start from scratch — the new one has no idea what the previous one did.

**Think of it like a road trip with multiple drivers:**

1. Gemini is driving. It works on the task and builds up context.
2. Gemini's free-tier quota runs out. Before stopping, it saves a checkpoint — writing the current state to `next-steps.md`, `progress.md`, and `context.md`.
3. DeepSeek takes the wheel. It reads those same files and continues exactly where Gemini stopped.
4. When you switch back, DeepSeek saves a checkpoint. Gemini takes over again.

No matter which assistant you use — ChatGPT, Claude, Gemini, DeepSeek, Copilot — they all share the same files. The state is always consistent.

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

## Common instructions

These are the phrases you type in your AI chat to drive the workflow.

| When | What to type |
|---|---|
| Very first time in a project | `"bootstrap using AGENTS.md protocol"` |
| Start of every session | `"load context using AGENTS.md protocol"` |
| End of a task — save progress | `"checkpoint"` |
| Back up the `ai/` directory | `"backup ai"` |
| Update project knowledge with recent findings | `"update project knowledge"` |
| Something applies beyond this project | `"update global knowledge"` |
| After the conversation was compacted | `"run post-compaction procedure"` |

> Don't use `/init` — it behaves differently across AI tools. Use the text prompts above.

Once context is loaded, you can also ask:
- *"Show me the progress so far"*
- *"What are the pending tasks?"*
- *"Where are we in this project?"*

**Notes:**
- Running bootstrap again in an already-initialized project is safe — it just checks what exists and skips anything already there.
- The post-compaction reload runs automatically when the AI detects a compaction summary. If you used `/compact` manually, or you're not sure it ran, just say it.

## Keeping context healthy

Over a long session, the AI's working knowledge degrades. State files accumulate stale info. The context window fills up. Rules that were clearly visible at the start get pushed out. This is called **context rot**.

The workflow has built-in defences:

| Problem | What protects you |
|---|---|
| Stale state files | All 3 state files are written together at checkpoint — or none at all |
| Progress log growing forever | Old entries auto-archive when the list gets too long |
| Rules lost after auto-summary | Post-Compaction Recovery reloads rules from disk automatically |
| AI forgetting what it loaded | Proof-of-Load runs at every "load context" |
| Knowledge base going stale | Every checkpoint includes a mandatory knowledge review |

Good habits that help:
- **Checkpoint often.** After each feature, fix, or review cycle — not just at end of day.
- **Keep sessions shorter.** If the AI starts repeating itself or forgetting earlier constraints, that's the signal: checkpoint and start a fresh session.
- **Always use the full `"load context using AGENTS.md protocol"` form** at the start of a session. The short `"load context"` is fine mid-session but unreliable with a fresh or weaker model.
- **Set up the post-compaction reload trigger once.** A long session can be auto-summarized, which can drop the rules your AI had loaded. See the [per-assistant setup guide](docs/post-compaction-reload-trigger-setup.md) for how to handle this for your tool.

## Customizing the AI (`ai-customization.md`)

This is the one file you edit to tailor the AI to your project. You can set:

1. **Expertise** — load a domain-specific policy (e.g., `cloud`, `api-backend`, `windows-system-admin`).
2. **Traits** — pick a persona (e.g., Senior DBA, Security Specialist, Mentor).
3. **Compliance** — activate regulatory standards (e.g., `gdpr`, `soc2`, `hipaa`).

See the [AI Customization Guide](docs/ai-customization-guide.md) for the full list and examples.

## File naming for knowledge and notes

When you or the AI create files under `ai/shared/project-knowledge/`, `ai/notes/`, or `docs/`, use descriptive names.

Good: `azure-postgresql-migration-decisions.md`  
Bad: `decisions.md`, `notes.md`, `architecture.md`

The AI doesn't load large project knowledge files at startup. It builds a name-based index and only reads a file when a task needs it. A vague name is invisible in that index — the AI can't confidently match it to a task without opening it first, which defeats the point.

This rule applies to AI-generated files too — it's enforced by the common policy. Source code is exempt — use whatever your language and framework expect.

---

## How does this compare to Copilot, Claude, or ChatGPT?

Each AI assistant has its own way of storing context — its own hidden directories, its own memory format, its own rules. They are all black boxes of different shades. Switch from one to another and you start from scratch, because the new assistant has no idea what the previous one knew.

Simple AI Workflow solves this. Everything lives in plain files inside your project. Any assistant reads the same files. Switch tools, change editors, move to a new machine — your context comes with you, zero setup required.

For a full breakdown of how concepts translate between Copilot, Claude, ChatGPT, Cursor, and this workflow — including a side-by-side comparison table — see:

**[Simple AI Workflow vs Copilot, Claude, ChatGPT — a full comparison](docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md)**

---

## What's included

- **16 domain policies** — Cloud, API Backend, Web Frontend, Data, DBA, Observability, Linux SysAdmin, Windows SysAdmin, Mobile, Accounting, Academic Research, Career Coaching, and more. Load whichever ones apply to your project.
- **Peer review mode** — say `"peer review"` or `"code review"` to trigger a structured review. The AI switches to reviewer mode and saves a report to `ai/code-review-reports/`.
- **Codebase examination mode** — say `"codebase examination"` to examine a large codebase without blowing up the context window.
- **Multi-agent coordination** — handoffs, a coordination board, and single-writer state ownership so multiple AI sessions don't step on each other.
- **Auto-sync script** — push `AGENTS.md` to all your projects in one command, with automatic migration from the old layout.
- **Protocol validator** — `support-files/validate-protocol.sh` checks that everything is wired up correctly.
- **Post-compaction recovery** — when a session is auto-summarized, the AI reloads its rules from disk automatically, without losing your working context.
- **Design documentation flow** — structured stack: Vision → PRD → HLD → LLD → ADRs → Delivery Ledger. ID-based tracking (`REQ-NNN`, `HLD-NNN`, `LLD-NNN`). AI checks for missing docs at session start and updates the ledger at every checkpoint.
- **Atomic checkpoint protocol** — all three state files are always written together. Partial writes don't happen.
- **Context shielding** — large project knowledge files are indexed at startup and loaded on demand. Small global files are always fully loaded.

---

## Docs and Slides

[Full slide deck (Google Slides, live)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link) — Creative Commons license.

[Markdown version of the slides](docs/simple-ai-workflow-slides.md)

Other docs:
- [Workflow guide](docs/workflow-guide.md) — handoffs, knowledge base, coordination
- [AI Customization Guide](docs/ai-customization-guide.md)
- [Post-compaction reload trigger setup](docs/post-compaction-reload-trigger-setup.md)
- [Protocol Validation System](docs/protocol-validation-system.md)
- [Policy influence on AI quality](docs/policy-influence-on-ai-work.md)
- [Codebase examination guide](docs/codebase-examination-guide.md)
- [Mobile app policy guide](docs/ai-policy-mobile-apps-guide.md)
- [Beginner setup guide](docs/vscode-cline-provider-setup-for-beginners.md)

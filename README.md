# Simple AI Workflow

> **Already using this?** The customization file moved from `ai/ai-customization.md` to `ai-customization.md` at your project root. Run the sync script (`support-files/sync-agents-md.sh` or `sync-agents-md.ps1`) and it migrates for you, or follow the [manual steps](docs/ai-customization-guide.md).

**The idea: stop *chatting* with AI, and start *working* with it.**

I built this for myself, to get my AI assistant to remember my projects and follow my rules. It is a handful of plain files. Nothing to install.

## Setup

- **Time**: under 5 minutes.
- **Difficulty**: very low.
- **What you need**: any AI assistant. It works best with one built into VS Code, like Copilot, Claude, Gemini, DeepSeek, or ChatGPT.
- **Install**: one `git clone` and one file copy. No install scripts, no admin rights, no package managers.

## Quick start

1. Clone this repo somewhere on your machine (for example `~/Projects/Simple-AI-Workflow`).
2. Create your global AI directory:
   - `$HOME/.ai/settings/`
   - `$HOME/.ai/global-knowledge/`
   - (Optional) Copy `docs/about-human.md` to `$HOME/.ai/settings/global-user-settings.md` and fill in your name, skills, and tool preferences.
3. Copy `AGENTS.md` to your project root.
4. In that `AGENTS.md`, set `Global AI Workflow Directory` to wherever you cloned this repo.
5. Open your project in VS Code and type this in the AI chat:
   - `"bootstrap using AGENTS.md protocol"`

> **Note:** don't use `/init`. It behaves differently across AI tools. Use the text prompt above instead.

## Setting up a new project

1. Copy `AGENTS.md` to the project root.
2. Copy `docs/ai-customization.md` to `ai-customization.md` at the project root, then update the workflow directory path inside it.
3. Add expertise, traits, or compliance settings if you want them (see the [customization guide](docs/ai-customization-guide.md)).
4. Type `"bootstrap using AGENTS.md protocol"` in the AI chat.
5. After each session, run a checkpoint. To pick up later, type `"load context using AGENTS.md protocol"`.

## Keeping AGENTS.md up to date

When I push updates here that you want:

1. Run a checkpoint in your current project first.
2. `git pull` the latest changes in this repo.
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

## What it is, and what it isn't

### What it is

A personal starter kit for one developer. You.

It helps you:
- Get better answers from your AI assistant, because it now knows your project's rules and your own preferences.
- Use the same setup across all your projects and across different AI tools.
- Stay organized. Progress, notes, and decisions are saved, so you can pick up where you left off.
- Keep AI notes out of your git history.

Think of it as turning your AI from a chat buddy into a teammate that actually remembers things.

### What it isn't

- Not an agent router. You still pick which AI to use.
- Not autonomous. The AI doesn't run in loops or decide things without you.
- Not a team tool. It is built for one developer.
- Not a replacement for your CI/CD, tests, or security scanners.
- Not a training system. It doesn't fine-tune models.

### Why I built it

If you only ever use one AI assistant, you probably don't need this. Your assistant keeps its own context and that mostly works fine.

The trouble starts when you use two or more assistants on the same project. Without a shared system, each one stores its state in its own hidden directory. Switch assistants and you start from scratch, because the new one has no idea what the last one did.

Think of it like a road trip with several drivers:

1. Gemini is driving. It works on the task and builds up context.
2. Gemini's free-tier quota runs out. Before it stops, it saves a checkpoint, writing the current state to `ai/state/next-steps.md`, `ai/state/progress.md`, and `ai/state/context.md`.
3. DeepSeek takes the wheel. It reads those same files and carries on exactly where Gemini stopped.
4. When you switch back, DeepSeek saves a checkpoint. Gemini takes over again.

It doesn't matter which assistant you use (ChatGPT, Claude, Gemini, DeepSeek, Copilot). They all share the same files, so the state stays consistent.

> **One protocol. One shared context. Any assistant picks up where the last one left off.**

## How it works

```text
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
| End of a task, to save progress | `"checkpoint"` |
| Back up the `ai/` directory | `"backup ai"` |
| Update project knowledge with recent findings | `"update project knowledge"` |
| Something applies beyond this project | `"update global knowledge"` |
| After the conversation was compacted | `"run post-compaction recovery procedure"` |

> **Note:** don't use `/init`. It behaves differently across AI tools. Use the text prompts above.
> **Note:** running bootstrap again in a project that is already set up is safe. It checks what exists and skips anything already there.

Once context is loaded, you can also ask:
- *"Show me the progress so far"*
- *"What are the pending tasks?"*
- *"Where are we in this project?"*

### Review and maintenance phrases

Ask the AI to review something or tidy up the workspace:

- *"perform a code review on <file | directory | git repo | PR or MR>"*
- *"perform a codebase examination of <directory | git repo>"*
- *"process my notes directory — remove the notes that are already implemented; for the notes that remain, add a short clarifying comment or a suggestion to me about the note."*
- *"process my plans directory and find all plans that are fully executed or implemented. If there are any, extract the useful knowledge from them and save it with a descriptive filename under `ai/shared/project-knowledge/`."*
- *"find any stale files under plans, artifacts, or notes — files that are no longer relevant because they are superseded, incomplete, or obsolete — and inform me about them without deleting anything."*
- *"process the artifacts directory and remove any stale files."*
- *"process my notes file and summarize it into a suggested line of action for how to approach them."*
- *"process my project knowledge — find any stale files and update or remove them as needed; where it helps, rename the files with better, verbose kebab-cased names for easier indexing."*

### Post-compaction recovery

When a session gets auto-summarized, the AI should reload its rules from disk. This is not 100% guaranteed, so it helps to know how it works and what to do:

1. **Ideally, it fires on its own.** When the AI spots a compaction summary in the conversation, it should run the `post-compaction recovery procedure` automatically and reload its loaded rules.
2. **If it doesn't fire, run it at your next prompt.** You'll notice the compaction appearing in the middle of some work or chat session. If the recovery didn't run, ask for it as soon as it's available: `"run post-compaction recovery procedure"`.
3. **Why it matters.** Without the reload, the AI loses its loaded rules and guidelines and starts deviating, making mistakes, or working off assumptions.
4. **Best approach: do it yourself.** To avoid the uncertainty entirely, compact the conversation yourself using a built-in tool (e.g. `/compact`), and then run the `post-compaction recovery procedure` yourself.

## Keeping context healthy

Over a long session, the AI's working memory drifts. State files fill up with stale notes. The context window gets crowded. Rules that were clear at the start get pushed out of view. This is called **context rot**.

The workflow pushes back with a few built-in defences:

| Problem | What protects you |
|---|---|
| Stale state files | All 3 state files are written together at checkpoint, or none at all |
| Progress log growing forever | Old entries auto-archive when the list gets too long |
| Rules lost after auto-summary | Post-Compaction Recovery reloads rules from disk on its own |
| AI forgetting what it loaded | Proof-of-Load runs at every "load context" |
| Knowledge base going stale | Every checkpoint includes a mandatory knowledge review |

A few habits help a lot:
- **Checkpoint often.** After each feature, fix, or review cycle, not just at the end of the day.
- **Keep sessions shorter.** If the AI starts repeating itself or forgetting earlier constraints, that is your signal. Checkpoint and start fresh.
- **Always type the full `"load context using AGENTS.md protocol"`** at the start of a session. The short `"load context"` is fine mid-session, but it is unreliable with a fresh or weaker model.

## Customizing the AI (`ai-customization.md`)

This is the one file you edit to tailor the AI to your project. You can set:

1. **Expertise**: load a domain policy (for example `cloud`, `api-backend`, `windows-system-admin`).
2. **Traits**: pick a persona (for example Senior DBA, Security Specialist, Mentor).
3. **Compliance**: turn on regulatory standards (for example `gdpr`, `soc2`, `hipaa`).

See the [AI Customization Guide](docs/ai-customization-guide.md) for the full list and examples.

## File naming for knowledge and notes

When you or the AI create files under `ai/shared/project-knowledge/`, `ai/notes/`, or `docs/`, give them descriptive names.

Good: `azure-postgresql-migration-decisions.md`  
Bad: `decisions.md`, `notes.md`, `architecture.md`

The AI doesn't load large project knowledge files at startup. It builds a name-based index and only opens a file when a task needs it. A vague name is invisible in that index, so the AI can't match it to a task without opening it first, which defeats the point.

This rule covers AI-generated files too, and the common policy enforces it. Source code is exempt, so use whatever your language and framework expect.

---

## How does this compare to Copilot, Claude, or ChatGPT?

Each AI assistant stores context its own way, in its own hidden directories, its own memory format, its own rules. They are all black boxes of different shades. Switch from one to another and you start from scratch, because the new assistant has no idea what the old one knew.

Simple AI Workflow fixes that. Everything lives in plain files inside your project. Any assistant reads the same files. Switch tools, change editors, move to a new machine, and your context comes with you. No setup needed.

For a full breakdown of how the concepts map between Copilot, Claude, ChatGPT, Cursor, and this workflow, with a side-by-side table, see:

**[Simple AI Workflow vs Copilot, Claude, ChatGPT: a full comparison](docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md)**

---

## What's included

- **12 domain policies**: Cloud, API Backend, Web Frontend, Data, DBA, Observability, Linux SysAdmin, Windows SysAdmin, Mobile, Accounting, Academic Research, and Career Coaching. Load the ones that apply to your project.
- **Peer review mode**: say `"peer review"` or `"code review"` and the AI switches to reviewer mode, then saves a report to `ai/code-review-reports/`.
- **Intent-based quality findings**: the AI describes code smells by intent, not bare linter scores, so fixes are genuine rather than gamed by the model.
- **Codebase examination mode**: say `"codebase examination"` to work through a large codebase without blowing up the context window.
- **Multi-agent coordination**: handoffs, a coordination board, and single-writer state ownership, so several AI sessions don't step on each other.
- **Auto-sync script**: push `AGENTS.md` to all your projects in one command, and it migrates the old layout for you.
- **Protocol validator**: `support-files/validate-protocol.sh` checks that everything is wired up correctly.
- **Post-compaction recovery**: when a session gets auto-summarized, the AI reloads its rules from disk on its own, without losing your working context.
- **Design documentation flow**: a structured stack of Notes, Vision, PRD, HLD, LLD, ADRs, and a Delivery Ledger, with ID-based tracking (`REQ-NNN`, `HLD-NNN`, `LLD-NNN`). The AI checks for missing docs at session start, updates the ledger at every checkpoint, and reviews each doc before writing the next.
- **Shared understanding before building**: for feature work, the AI interviews you to reach a shared design concept before it creates files or writes code.
- **Atomic checkpoint protocol**: all three state files are always written together. Partial writes don't happen.
- **Context shielding**: large project knowledge files are indexed at startup and loaded on demand. Small global files are always loaded in full.

---

## Docs and Slides

[Full slide deck (Google Slides, live)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link), under a Creative Commons license.

[Markdown version of the slides](docs/simple-ai-workflow-slides.md)

Other docs:
- [Workflow guide](docs/workflow-guide.md): handoffs, knowledge base, coordination
- [AI Customization Guide](docs/ai-customization-guide.md)
- [Post-compaction reload trigger setup](docs/post-compaction-reload-trigger-setup.md)
- [Protocol Validation System](docs/protocol-validation-system.md)
- [Policy influence on AI quality](docs/policy-influence-on-ai-work.md)
- [Codebase examination guide](docs/codebase-examination-guide.md)
- [Mobile app policy guide](docs/ai-policy-mobile-apps-guide.md)
- [Beginner setup guide](docs/vscode-cline-provider-setup-for-beginners.md)

# AI Assistants and Their Memory Systems — How Simple AI Workflow Fits In

If you have ever used more than one AI assistant on a project, you know the pain. You spent weeks building context with Copilot. Then you tried Claude for something. Then you switched back. Now you have no idea where each assistant saved what, whether any of it survived, and whether your new session knows anything about your previous work.

This is not a rare problem. It is the default experience.

This document explains how four widely-used AI tools handle memory and context, how their concepts map to Simple AI Workflow, and why Simple AI Workflow's approach is fundamentally different — and what that difference costs you.

---

## The Problem: Every Tool Is a Black Box

Each AI assistant stores context in its own way, in its own location, in its own format.

- **GitHub Copilot** keeps its memory in VS Code's internal workspace storage and the `/memories/` files in the agent framework. You cannot easily find, read, or move these files.
- **Claude** keeps project-level instructions in `CLAUDE.md` at the project root, and session memory in Claude Projects — tied to your Anthropic account and that specific project on their platform.
- **ChatGPT** has a Memory feature that automatically extracts facts from your conversations and stores them in your OpenAI account. You can view and delete memories, but you cannot control what gets stored or how it is structured.
- **Cursor** keeps AI rules in `.cursor/rules` inside your project. That file only works inside Cursor. Open the same project in VS Code or a terminal and those rules do nothing.

These are black boxes of different shades. Some are darker than others. But they all share the same core problem: **the state belongs to the tool, not to you.**

Switch tools and you start from scratch. The new assistant has no idea what the previous one knew. Your hard-won context — the architectural decisions, the known issues, the progress you made — is trapped inside the tool you just left.

---

## How the Tools Compare

### GitHub Copilot

Copilot is tightly integrated with VS Code. Its context system revolves around a few key files:

- **`.github/copilot-instructions.md`** — project-level instructions that are automatically injected into every conversation. You write this once and Copilot follows it for that project.
- **`.instructions.md` files** — more granular rules that apply to specific file types or directories (using `applyTo` patterns).
- **`SKILLS.md`** — defines custom reusable skills and agents. These are callable sub-workflows, not just passive rules.
- **`.prompt.md` files** — reusable prompt templates you can invoke by name.
- **`/memories/`** — user-level and session-level persistent notes in the agent framework.
- **`PreCompact` hook** — a script that runs before the session is summarized (compacted), giving you a chance to save state before context is lost.

Copilot's context system is the most feature-rich of the four. But it is still VS Code-specific. None of it works in a terminal, in a JetBrains IDE, or with a different AI tool.

### Claude (Claude Code)

Claude's context system is simpler and more explicit:

- **`CLAUDE.md`** at the project root — instructions Claude reads at the start of every session.
- **`~/.claude/CLAUDE.md`** — global instructions that apply across all projects.
- **Claude Projects** — a platform feature that lets you upload reference files and keep conversation history scoped to a project.

Claude's approach is clean and readable. But it only works with Claude. And Claude Projects lives on Anthropic's servers — you cannot take it with you or inspect it locally.

### ChatGPT

ChatGPT has the most automatic memory:

- **Custom instructions** — a global text block you write once that applies to every ChatGPT conversation.
- **Memory** — ChatGPT automatically extracts facts from your conversations and stores them. You can view and delete entries, but the AI decides what to save and how to phrase it.
- **Projects** — project-scoped memory and a set of uploaded reference files.
- **Custom GPTs** — custom system prompts with optional tools and API actions.

ChatGPT's memory is the most hands-off. It just works. But it is also the most opaque. You cannot control the structure, cannot move it to another tool, and cannot inspect what the AI actually remembered versus what it summarized away.

### Cursor

Cursor is an AI-first code editor built on VS Code. It lets you pick your own AI model (OpenAI, Anthropic, Gemini) and has strong multi-file editing capabilities. Its context system is minimal:

- **`.cursor/rules`** (or the older `.cursorrules`) — project-level instructions for the AI. Cursor reads this file automatically for every conversation in that project.
- **User rules** — a global instructions block in Cursor's settings that applies across all projects.
- No persistent cross-session memory. No project knowledge base. No state tracking between sessions.

Cursor's rules file is easy to set up and effective within Cursor. But the moment you open the same project in VS Code, a terminal, or any other tool, those rules do nothing. They are invisible to every AI assistant except Cursor.

---

## The Translation Table

Here is how the concepts from each tool map to Simple AI Workflow.

| What you need | Copilot | Claude | ChatGPT | Cursor | Simple AI Workflow |
|---|---|---|---|---|---|
| Project-level instructions | `.github/copilot-instructions.md` | `CLAUDE.md` | Custom instructions (global) | `.cursor/rules` | `AGENTS.md` |
| User preferences (cross-project) | `/memories/` (user scope) | `~/.claude/CLAUDE.md` | Custom instructions (global) | User rules (in Cursor settings) | `~/.ai/settings/global-user-settings.md` |
| Per-project customization | No standard equivalent | No standard equivalent | Projects | None | `ai-customization.md` |
| Domain expertise / rules | `SKILLS.md`, `.instructions.md` | `CLAUDE.md` sections | Custom GPTs | `.cursor/rules` sections | `ai/policies/ai-policy-*.md` (16 domain policies) |
| Progress tracking across sessions | None | Claude Projects history | Projects | None | `ai/state/progress.md` |
| Pending tasks | None | None | None | None | `ai/state/next-steps.md` |
| Current state / context dashboard | None | None | None | None | `ai/state/context.md` |
| Project knowledge / decisions | None | Uploaded project files | Uploaded project files | None | `ai/shared/project-knowledge/` |
| Lessons learned across projects | None | `~/.claude/CLAUDE.md` (manual) | Memory (automatic, opaque) | None | `~/.ai/global-knowledge/` (explicit, structured) |
| Multi-assistant handoffs | None | None | None | None | `ai/shared/handoffs/` |
| Post-summary recovery | `PreCompact` hook | None | None | None | Post-Compaction Recovery procedure |
| Compliance enforcement | None | None | None | None | `ai/policies/compliance/` + built-in AI knowledge |
| Peer code review mode | None | None | None | None | `"peer review"` procedure + saved reports |
| Protocol self-validation | None | None | None | None | `validate-protocol.sh` |
| Sync instructions across projects | None | None | None | None | `sync-agents-md.sh` / `.ps1` |

---

## What Simple AI Workflow Gives You That the Others Do Not

### Everything is in front of you

Open your project and you will find:

```
ai/
├── state/
│   ├── progress.md       ← what was done
│   ├── next-steps.md     ← what comes next
│   └── context.md        ← where things stand right now
├── policies/            ← domain rules and expertise
├── shared/
│   ├── project-knowledge/   ← decisions, findings, architecture notes
│   └── handoffs/            ← task transfers between sessions
└── daily-checkpoints/   ← timestamped save points

~/.ai/
├── settings/            ← your personal preferences and tools
└── global-knowledge/    ← lessons that apply across all projects
```

No hidden directories. No cloud accounts to log into. No mystery format. Every file is plain Markdown. You can read it, edit it, and understand it without documentation.

### Switch tools without losing anything

Say you have been working with Copilot for two weeks. You want to try Claude for a specific task, or maybe Copilot's context limit has been hit. With native tools, that means starting over.

With Simple AI Workflow, you open Claude, type `"load context using AGENTS.md protocol"`, and Claude reads the same files Copilot was using. It knows your progress. It knows what is next. It picks up exactly where Copilot left off.

Same if you switch back. Or switch to ChatGPT. Or to a CLI agent. **The protocol is the same. The files are the same. The assistant does not matter.**

### Change editors, machines, or operating systems — with zero setup

The files live in your project directory. That directory is yours. Put it on a new machine, open it in a different editor, switch from VS Code to a terminal — the AI workflow comes with it automatically. Switch from Linux to macOS to Windows and back — nothing changes. The same directory structure, the same files, the same commands.

With Copilot, your memory is tied to VS Code. With Claude Projects, your context is on Anthropic's platform. With ChatGPT Memory, your memories are in your OpenAI account. None of them travel with your project.

Simple AI Workflow does — because it is just files.

One note on the `ai/` directory: by default it is git-ignored, so it does not get committed with your project code. That is by design — it is your personal AI workspace, not part of the codebase. You have a few options for keeping it safe across machines:

- **Backup procedure**: say `"backup ai"` and the protocol archives the entire `ai/` directory to `~/.ai/backups/` automatically.
- **Include it in the repo**: you can remove `ai/` from `.gitignore` if you want to commit it. Some individuals do this for their own solo projects — it does not work in a team setting where multiple people would be writing to the same AI state files.
- **Own private repo**: if you are working at a project root that contains multiple git repos underneath it (a common pattern for architects and platform engineers), the `ai/` directory sits alongside them as a sibling. You can initialise it as its own private git repo on GitHub or GitLab. Then moving to a new machine is literally one `git clone` — and you are straight back to work.

### Domain expertise that actually enforces things

Copilot's `.instructions.md` and Claude's `CLAUDE.md` let you write plain text instructions. They help, but they are passive suggestions — the AI does its best to follow them.

Simple AI Workflow's policy files go further. They define the AI's role, mandate specific testing approaches, require security checks before commits, enforce naming conventions, and specify exactly what to do and not do for each domain. And they are modular — you load only the policies that apply to your project. A DevOps project loads `cloud` and `linux-system-admin`. A Windows environment loads `windows-system-admin`. A data engineering team loads `dba` and `data`.

These policies apply regardless of which AI assistant you use. The rules travel with the project.

### A structured knowledge base, not a vague "memory"

ChatGPT Memory is automatic. That sounds convenient — and it is — until you realize you have no control over what it stores or how. It might remember that you prefer tabs over spaces, but forget the critical architectural decision you made last Tuesday.

Simple AI Workflow stores knowledge in named files with descriptive titles. `azure-postgresql-migration-decisions.md` tells you and the AI exactly what is inside before either of you opens it. The AI indexes these files at startup and loads them on demand when a task needs them. You always know what is stored and can inspect, edit, or delete any of it.

### Compliance, security, and peer review — built in

No native AI tool has anything like Simple AI Workflow's compliance layer. You declare which standards apply (`soc2`, `iso-27001`, `gdpr`) in `ai-customization.md`, and the AI applies the relevant controls to everything it produces — code, infrastructure, documentation.

Peer review is similarly absent from native tools. Say `"peer review"` and the AI switches to a strict reviewer role. No code writing. Just analysis. The report is saved to `ai/code-review-reports/` with a clear verdict. Every round produces a new numbered report; nothing is overwritten.

---

## The Honest Trade-Off

Simple AI Workflow is not zero-friction. The native tools win on convenience.

ChatGPT Memory stores things without you having to ask. Copilot's `copilot-instructions.md` is injected automatically. Claude reads `CLAUDE.md` without a prompt.

With Simple AI Workflow, you need to type:

- `"load context using AGENTS.md protocol"` at the start of every session
- `"checkpoint"` after each task
- `"update project knowledge"` when you want something remembered
- `"backup ai"` when you want a backup

That is more deliberate. But deliberate is not the same as bad.

Most developers who use this workflow find that it enforces a discipline that actually improves their work. Typing `"checkpoint"` forces you to pause and review what was done. `"update project knowledge"` makes you ask: *what did we actually decide, and is it written down?* The commands are friction — but they are productive friction.

And unlike native tool automation, you always know what was saved and why.

---

## In Short

| | Native AI tools | Simple AI Workflow |
|---|---|---|
| Files | Hidden in tool-specific directories | In your project, plain Markdown |
| Portability | Tied to one tool or account | Works with any tool, any editor, any OS |
| Cross-tool continuity | Start over every time | Pick up where you left off, any assistant |
| Memory control | Automatic, often opaque | Explicit, structured, fully inspectable |
| Domain expertise | Flat instructions text | 16 modular domain policies with enforced rules |
| Compliance | None | SOC2, ISO-27001, GDPR, and more |
| Peer review | None | On-demand, with saved reports |
| Setup on a new machine | Re-configure each tool | Zero — files travel with the project |
| Cost | Zero friction | A few deliberate commands per session |

Simple AI Workflow is not trying to replace the convenience of native tools. It is solving a different problem: **what happens when the tool is not enough, or when you want the same discipline across all of them.**

If you use one AI assistant and trust its memory — that is fine. But if you want to stay in control of your context, switch tools freely, enforce real coding standards, and take your work anywhere — Simple AI Workflow is the layer that makes that possible.

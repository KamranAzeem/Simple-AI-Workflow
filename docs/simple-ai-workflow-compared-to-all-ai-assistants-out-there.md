# How AI Assistants Store Context, and How Simple AI Workflow Fits

The problem is not which assistant you use. The problem is that a plain chat has no fixed shape. The assistant decides what to load, what to save, and what to skip, and the result changes with the session. Simple AI Workflow gives the assistant a protocol, so the work is predictable, reproducible, and auditable.

This document compares how four widely used tools store context, maps their concepts to the workflow, and explains the fixed shape. The comparison is a secondary lens. The single-assistant developer is the main audience: the protocol gives one assistant the same shape every time. Multi-assistant portability is a design feature, not the pitch.

---

## The Problem: the State Belongs to the Tool

Each AI assistant stores context in its own way, in its own location, in its own format.

- **GitHub Copilot** keeps its memory in VS Code's internal workspace storage and the `/memories/` files in the agent framework. You cannot easily find, read, or move these files.
- **Claude** keeps project-level instructions in `CLAUDE.md` at the project root, and session memory in Claude Projects, tied to your Anthropic account and that specific project on their platform.
- **ChatGPT** has a Memory feature that automatically extracts facts from your conversations and stores them in your OpenAI account. You can view and delete memories, but you cannot control what gets stored or how it is structured.
- **Cursor** keeps AI rules in `.cursor/rules` inside your project. That file only works inside Cursor. Open the same project in VS Code or a terminal and those rules do nothing.

These are black boxes of different shades. Some are darker than others. But they all share the same core problem: **the state belongs to the tool, not to you.**

The cost shows up in two ways:

- **With one assistant**, the same chat can skip the project tickets, skip a checkpoint write, skip the acceptance tests, or change the output format from one answer to the next. The shape is not fixed.
- **With two or more assistants**, each one stores its state in its own hidden directory. Switch assistants and you start from scratch, because the new one has no idea what the last one did.

Simple AI Workflow fixes both: the state lives in the project, and the procedures give every session the same shape.

---

## How the Tools Compare

### GitHub Copilot

Copilot is tightly integrated with VS Code. Its context system revolves around a few key files:

- **`.github/copilot-instructions.md`**, project-level instructions that are automatically injected into every conversation.
- **`.instructions.md` files**, more granular rules that apply to specific file types or directories (using `applyTo` patterns).
- **`.github/skills/<name>/SKILL.md`**: a per-skill file defining one reusable, task-specific skill, loaded on demand.
- **`.prompt.md` files**, reusable prompt templates you can invoke by name.
- **`/memories/`**: persistent notes in the agent framework at user, repository (`/memories/repo/`), and session scope.
- **`PreCompact` hook**, a script that runs before the session is summarized.

Copilot's context system is feature-rich. But it is still VS Code-specific. None of it works in a terminal, in a JetBrains IDE, or with a different AI tool.

### Claude (Claude Code)

Claude's context system is simpler and more explicit:

- **`CLAUDE.md`** at the project root, instructions Claude reads at the start of every session.
- **`~/.claude/CLAUDE.md`**, global instructions that apply across all projects.
- **Claude Projects**, a platform feature that lets you upload reference files and keep conversation history scoped to a project.

Claude's approach is clean and readable. But it only works with Claude. Claude Projects lives on Anthropic's servers, so you cannot take it with you or inspect it locally.

### ChatGPT

ChatGPT has the most automatic memory:

- **Custom instructions**, a global text block you write once that applies to every ChatGPT conversation.
- **Memory**, ChatGPT automatically extracts facts from your conversations and stores them. You can view and delete entries, but the AI decides what to save and how to phrase it.
- **Projects**, project-scoped memory and a set of uploaded reference files.
- **Custom GPTs**, custom system prompts with optional tools and API actions.

ChatGPT's memory is the most hands-off. It just works. But it is also the most opaque. You cannot control the structure, move it to another tool, or inspect what the AI actually remembered versus what it summarized away.

### Cursor

Cursor is an AI-first code editor built on VS Code. It lets you pick your own AI model and has strong multi-file editing capabilities. Its context system is minimal:

- **`.cursor/rules`** (or the older `.cursorrules`), project-level instructions for the AI.
- **User rules**, a global instructions block in Cursor's settings.
- No persistent cross-session memory. No project knowledge base. No state tracking between sessions.

Cursor's rules file is easy to set up and effective within Cursor. Open the same project in VS Code, a terminal, or any other tool, and those rules do nothing.

---

## The Translation Table

Here is how the concepts from each tool map to Simple AI Workflow.

| What you need | Copilot | Claude | ChatGPT | Cursor | Simple AI Workflow |
|---|---|---|---|---|---|
| Project-level instructions | `.github/copilot-instructions.md` | `CLAUDE.md` | Custom instructions (global) | `.cursor/rules` | `AGENTS.md` |
| User preferences (cross-project) | `/memories/` (user scope) | `~/.claude/CLAUDE.md` | Custom instructions (global) | User rules | `<Global User AI Directory>/settings/global-user-settings.md` |
| Per-project customization | No standard equivalent | No standard equivalent | Projects | None | `ai-customization.md` |
| Domain expertise / rules | `.github/skills/`, `.instructions.md` | `CLAUDE.md` sections | Custom GPTs | `.cursor/rules` sections | `ai/policies/ai-policy-*.md` (25 policies) |
| Progress tracking | None | Claude Projects history | Projects | None | `ai/state/progress.md` |
| Pending tasks | None | None | None | None | `ai/state/next-steps.md` |
| Current state | None | None | None | None | `ai/state/context.md` |
| Project knowledge | None | Uploaded files | Uploaded files | None | `ai/shared/project-knowledge/` |
| Team lessons and skills | None | None | None | None | the optional team knowledge store |
| Skills on demand | `.github/skills/` | None | Custom GPTs | None | `ai/skills/<name>/SKILL.md` and the team store's `skills/` |
| Lessons across projects | `~/.claude/CLAUDE.md` (manual) | `~/.claude/CLAUDE.md` | Memory (opaque) | None | `<Global User AI Directory>/global-knowledge/` |
| Handoffs | None | None | None | None | `ai/shared/handoffs/` |
| Post-summary recovery | `PreCompact` hook | None | None | None | Post-Compaction Recovery procedure |
| Compliance enforcement | None | None | None | None | the compliance policies, applied by the AI |
| Peer review | None | None | None | None | `"peer review"` and saved reports |
| Protocol self-validation | None | None | None | None | `validate-protocol.sh` |
| Sync across projects | None | None | None | None | `sync-agents-md.sh` / `.ps1` |

---

## What the Fixed Shape Gives You

### The same shape every session

Every session runs the same five steps: load the context, plan the work as a ticket, implement the approved plan, review the result, and checkpoint. The AI cannot skip the tickets, the plan, the review gate, or the checkpoint because the procedures say what to do.

The result is predictable, reproducible in the same format, and auditable. You can inspect the state files, the tickets, the design documents, the review reports, and the diary.

### The state is plain files

Open your project and you will find:

```text
ai/
├── state/
│   ├── progress.md       ← what was done
│   ├── next-steps.md     ← what comes next
│   └── context.md        ← where things stand right now
├── policies/            ← the project policies (optional)
├── shared/
│   ├── project-knowledge/   ← decisions, findings, architecture notes
│   └── handoffs/            ← task transfers between sessions
└── daily-checkpoints/   ← timestamped save points

<Global User AI Directory>/   (default ~/.ai/)
├── settings/            ← your personal preferences and tools
└── global-knowledge/    ← lessons that apply across all projects
```

No hidden directories. No cloud accounts to log into. No mystery format. Every file is plain Markdown. You can read it, edit it, and understand it without documentation.

### The rules are enforced, not suggested

Native instructions are passive text. Simple AI Workflow's policy files define a role, mandate testing approaches, require security checks, and enforce naming conventions. They are modular: a DevOps project loads `cloud` and `linux-system-admin`; a Windows environment loads `windows-system-admin`; a data team loads `dba` and `data`.

The rules travel with the project and apply regardless of the assistant.

### The knowledge is structured

ChatGPT Memory is automatic. That sounds convenient until you realize you have no control over what it stores or how. It might remember that you prefer tabs over spaces but forget the architectural decision you made last Tuesday.

Simple AI Workflow stores knowledge in named files with descriptive titles. `azure-postgresql-migration-decisions.md` tells you and the AI exactly what is inside before either of you opens it. The AI indexes these files at startup and loads them on demand. You always know what is stored and can inspect, edit, or delete it.

A team can also pool lessons in the optional team knowledge store. It is a shared, reviewed Git repository, and the project still wins when the two disagree.

### Compliance, security, and peer review, built in

You declare which standards apply (`soc2`, `iso-27001`, `gdpr`) in `ai-customization.md`, and the AI applies the relevant controls to everything it produces.

Say `"peer review"` and the AI switches to a strict reviewer role. No code writing, just analysis. The report is saved under `ai/code-review-reports/` with a clear verdict, and every round produces a new numbered report.

### The context travels with the project (the secondary capability)

The same files work with Copilot, Claude, Gemini, DeepSeek, ChatGPT, or a local model. When a quota runs out or you change tools, the next assistant reads the same files and continues. Nothing is lost, because the state is in the project, not in the assistant.

The `ai/` directory is git-ignored by default, so it does not travel with the code. Keep it safe with `"backup ai"`, or put the project root's `ai/` in its own private repository.

This is a real capability, but it is secondary. The main value is the fixed shape for the assistant you already use.

---

## The Honest Trade-Off

Simple AI Workflow is not zero-friction. The native tools win on convenience.

With Simple AI Workflow, you type:

- `"load context using AGENTS.md protocol"` at the start of every session
- `"checkpoint"` after each task
- `"update project knowledge"` when you want something remembered
- `"backup ai"` when you want a backup

That is more deliberate. But deliberate is not the same as bad. Typing `"checkpoint"` forces you to pause and review what was done. `"update project knowledge"` makes you ask what you actually decided and whether it is written down. The commands are productive friction, and you always know what was saved and why.

---

## In Short

| | Native AI tools | Simple AI Workflow |
|---|---|---|
| Files | Hidden in tool-specific directories | In your project, plain Markdown |
| Consistency | The assistant decides the shape | The procedures fix the shape |
| Output format | Can change from answer to answer | Stable |
| Cross-tool continuity | Start over every time | Pick up where you left off |
| Memory control | Automatic, often opaque | Explicit, structured, inspectable |
| Domain expertise | Flat instructions text | 25 modular policies with enforced rules |
| Compliance | None | SOC2, ISO-27001, GDPR, and more |
| Peer review | None | On-demand, with saved reports |
| Setup on a new machine | Re-configure each tool | The files travel with the project |
| Cost | Zero friction | A few deliberate commands per session |

---

## The Main Idea

The single-assistant developer is the main audience. The protocol gives that assistant the same load, plan, implement, review, and checkpoint every session, so the output is predictable, reproducible, and auditable. No more guessing what the assistant decided to remember or which format it will use today.

VS Code is the recommended home. The protocol is editor-agnostic, and multi-assistant continuity is a capability you get for free. It is not the pitch.

For the workflow itself, see the [README](../README.md) and the [workflow guide](workflow-guide.md).

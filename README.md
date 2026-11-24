| Announcement |
| --- |
| **v7.3.1 (2026-11-24).** The deck is now a reproducible HTML deck with a 59-slide visual review, and the diagrams and speaker notes are corrected. Read the announcement: [docs/announcements/v7.3.1.md](docs/announcements/v7.3.1.md). |

# Simple AI Workflow

**Stop improvising with AI. Work the same predictable way every time.**

Simple AI Workflow is a small set of plain files that gives your AI assistant a protocol: the policies to load, the procedures to follow, the state to keep, and the review gates to pass. It is not a platform or a service. It is a repeatable way to work.

## Contents

- [The gap](#the-gap)
- [The fix](#the-fix)
- [The 60-second flow](#the-60-second-flow)
- [Quick start](#quick-start)
- [What you get](#what-you-get)
- [What it is not](#what-it-is-not)
- [Works with any assistant](#works-with-any-assistant)
- [Origin](#origin)
- [Docs and slides](#docs-and-slides)

## The gap

A plain chat has no fixed shape. The AI decides what to load, what to save, and what to skip. The result depends on its mood and the session.

- **Load context** may decide the project tickets are not important and skip them.
- **Checkpoint** may write the diary and update project knowledge one time, and skip them the next.
- **Design and delivery** may skip the HLD, the LLD, the acceptance tests, or verification during app work.
- **Output** may flip between bullets and tables from one answer to the next.

A long initialization prompt can describe your project, but it is a request, not a procedure. The AI can change its approach, and you have no fixed shape to audit.

## The fix

Simple AI Workflow gives the AI procedures it must follow and policies it must load. Bootstrap loads the background policies and procedures, so the assistant is ready without a long setup prompt.

Every session runs the same shape:

1. Load the context and the rules.
2. Plan the work as a ticket.
3. Implement the approved plan.
4. Review the result.
5. Checkpoint the state, the diary, and the knowledge.

The result is **predictable**, **reproducible in the same format**, and **auditable**. The state files, the ticket, the design gate, the review gate, and the checkpoint are fixed points you can inspect. There are no surprises.

> The point is not which assistant you use. The point is that the assistant works the same way every time.

## The 60-second flow

```text
You: "load context using AGENTS.md protocol"
AI:  proof-of-load, active policies, and the pending tickets.

You: "plan the issue ai/issues/open/example.md"
AI:  evidence, sharp questions, a plan, and a close sequence.

You: "implement the plan"
AI:  a branch, a failing test first, the code, a review, a checkpoint,
     and a commit.

You: "checkpoint"
AI:  the three state files, the diary, the knowledge review, and a
     grouped summary.
```

The full command list is in the [workflow guide](docs/workflow-guide.md#25-common-instructions).

## Quick start

1. Clone this repo, for example to `~/Projects/Simple-AI-Workflow`.
2. Create the global directories: `mkdir -p "$HOME/.ai/settings" "$HOME/.ai/global-knowledge" "$HOME/.ai/backups"`.
3. Copy `AGENTS.md` and `docs/ai-customization.md` to your project root. Set `Global AI Workflow Directory` in `ai-customization.md` to the clone.
4. Open the project in VS Code and type `"bootstrap using AGENTS.md protocol"`.
5. Start each session with `"load context using AGENTS.md protocol"`.

That is the whole install: no install scripts, no admin rights, no package manager. VS Code is the recommended home; any assistant works. See [setup](docs/setup.md) for the Windows paths, the manual steps, and the update flow.

The full phrase matters. A plain `"load context"` reads the assistant's own memory, not this protocol. Naming `AGENTS.md` tells the assistant to read the protocol first, so it knows where the state and knowledge live.

A cycle: file the issue, plan it, implement the approved plan, then checkpoint. Filing a ticket does not start planning. The implementation request is the approval for the branch, the commits, the push, and the close sequence named in the plan's `## Close Sequence`, including the trunk merge, tag, release, and external writes. The branch approval alone covers only commits and pushes on the branch. Ask for a separate approval only when the plan does not name the action or the request is not an implementation request.

This page describes the protocol. The protocol modules (`AGENTS.md`, the policies, and the procedures) are authoritative.

## What you get

### Setup

- Bootstrap, the sync script, the customization file, and the git identity. Why: the assistant knows the project and the rules from the first turn.
- Command: `"bootstrap using AGENTS.md protocol"`.
- See the [customization guide](docs/ai-customization-guide.md) and [setup](docs/setup.md).

### Daily loop

- Load context, plan the issue, implement the plan, and checkpoint. Why: the same shape every session, with the state and the review gate in place.
- Commands: `"load context using AGENTS.md protocol"`, `"plan the issue <file or #N>"`, `"implement the plan"`, `"checkpoint"`.
- Checkpoint often. It is the save button for the state, the diary, and the knowledge.

### Memory

- Three state files, project and global knowledge, handoffs, and the daily diary. Why: the next session starts where this one stopped.
- The state files are written together at checkpoint, or not at all. Old progress moves to the daily checkpoint archive.
- Knowledge files follow one shape and a task-based name. See the [workflow guide](docs/workflow-guide.md#23-knowledge-file-standards-and-repair).

### Quality

- Peer review, codebase examination, design documents, shared understanding, thinking modes, and the coding baseline. Why: the work is reviewed and the design is agreed before the code.
- Skills on demand: drop-in `SKILL.md` packages, indexed at boot and loaded by `"use skill <name>"` or one clear description match. See the [workflow guide](docs/workflow-guide.md#24-skills).
- Commands: `"peer review"`, `"codebase examination"`, `"update design documents"`, `"grill me"`.

### Delivery

- Issue management, the PR/MR path, the merge policy, and the outbound content scrub. Why: the work is tracked, and it leaves the project only after a scrub.
- Commands: `"file an issue: <summary>"`, `"list issues"`, `"close issue <file or #N>"`.
- Merge mode lives in `## Merge Policy`. A local ticket closes in the branch commit; an external ticket closes when the merge lands.
- See the [workflow guide](docs/workflow-guide.md).

### Maintenance

- Repair state files, repair knowledge files, back up `ai/`, recover manually after compaction, run the validator, and lint. Why: the workspace stays healthy over months.
- Commands: `"repair state files"`, `"repair knowledge files"`, `"backup ai"`, `"run post-compaction recovery procedure"`.
- The opt-in anomaly report logs a denied tool call, a missing file, or a self-correction in the day's checkpoint. See the [customization guide](docs/ai-customization-guide.md#10-report-anomalies).

### Team

- Optional team knowledge store: a shared Git repository of lessons, with the two configuration keys.
- Optional team skills: a third skills root at `<Team AI Knowledge Directory>/skills/`, with project, team, global precedence.
- The key names are **Team AI Knowledge Directory** and **Team AI Knowledge Repository**. Set them in `ai-customization.md` when the team has a store.
- The team repository's one-reviewer PR gate and access control are the trust boundary. The protocol does not verify review at boot. Team lessons are Class A: names stay, secrets never.
- Contribute a lesson with `"update team knowledge"`; contribute a skill by copying the package into `skills/` and opening a PR.
- See the [workflow guide](docs/workflow-guide.md#24-skills), the [customization guide](docs/ai-customization-guide.md), and the [v7.1.0](docs/announcements/v7.1.0.md) and [v7.2.0](docs/announcements/v7.2.0.md) announcements.

The full command list, the design flow, the knowledge standards, and the policy loading rules are in the [workflow guide](docs/workflow-guide.md).

## What it is not

- **Not a platform or a driver lock-in.** It is plain files. Any assistant can read them. VS Code is the recommended home; multi-assistant is a capability, not the pitch.
- **Not a replacement for your judgment or autonomy.** The AI follows the procedures; you decide, approve, and merge. It does not run in loops or choose goals.
- **Not a heavy install.** No service, no package manager, no admin rights. A clone, two files, and a command.

## Works with any assistant

The protocol is editor- and model-agnostic. The same files work with Copilot, Claude, Gemini, DeepSeek, ChatGPT, or a local model. That matters when a quota runs out, a project moves to another machine, or you change tools.

Think of a road trip with several drivers. One assistant drives, hits a limit, and checkpoints. The next reads the same state files and continues. Nothing is lost, because the state lives in the project, not in the assistant.

This is a design feature, not the main idea. The main idea is the fixed shape. For the full comparison, see [how the assistants store context and how this workflow fits](docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md).

## Origin

I built this for myself, to stop improvising with AI. The idea started with my friend [Muddassar Muneer](https://github.com/mudassarmuneer), who showed me a workflow he had built for AI assistants. I kept two ideas from it, state management and handoffs, and built the rest as one self-standing protocol.

## Docs and slides

- [Workflow guide](docs/workflow-guide.md): the reference manual.
- [AI Customization Guide](docs/ai-customization-guide.md): expertise, traits, compliance, merge policy.
- [Setup](docs/setup.md): Windows paths, the manual steps, and updates.
- [Compliance guide](docs/compliance-guide.md).
- [How policies work](docs/how-policies-work-in-this-workflow.md).
- [Policy influence on AI work](docs/policy-influence-on-ai-work.md).
- [Protocol validation](docs/protocol-validation-system.md).
- [Codebase examination](docs/codebase-examination-guide.md).
- [AI provider selection](docs/ai-provider-selection-guide.md): choosing a provider and the Kilo Code path.
- [Multi-agent runbook](docs/multi-agent-runbook.md): a three-assistant walkthrough.
- [Learning session runbook](docs/example-learning-session-runbook.md): a prompt-first walkthrough.
- [Personas](docs/personas/): example traits for an architect reviewer, a mentor, and a security specialist.
- [Skills example](docs/examples/skills/example-skill/SKILL.md).
- [Examples](docs/examples/): customizations, handoffs, knowledge, and skills.
- [Full slide deck (Google Slides, live)](https://docs.google.com/presentation/d/1BC-nLimx3fASWiHohiTiNQSeTKolHDM_AJiCt-IrhKU/edit?usp=drive_link), under a Creative Commons license.
- [Markdown slides](docs/simple-ai-workflow-slides.md).
- [HTML slides](docs/slides/simple-ai-workflow-slides.html).
- [Release announcements](docs/announcements/).

The 25 policies and 16 procedures are the fixed background. The 54 triggers are the phrases that load a policy or procedure on demand.

<!--
Created-by: Cline
Updated-by: Cline
Last modified: 2026-05-02T19:25:00+02:00
Intent: Promoted from ai/artifacts/simple-ai-workflow-slides.md to docs/ for public reference.
-->
---
# Simple AI Workflow
## From Chatting with AI, to Working with AI

Your trusted pair-programmer / co-driver / co-pilot

A no-fluff, simple & secure workflow for reliable AI-assisted work

by Muhammad Kamran Azeem (kamran@wbitt.com)

[github.com/KamranAzeem/Simple-AI-Workflow](https://github.com/KamranAzeem/Simple-AI-Workflow) — Creative Commons Attribution 4.0 International

---

# What it is — Setting right expectations

A **personal starter kit** — built for **one engineer** (you), not for a team.

It helps you:

- **Get more useful answers** — AI knows your project's rules and preferences
- **Keep things consistent** — same setup across projects and AI tools
- **Stay organized** — conversations, notes, and progress saved locally
- **Keep private stuff private** — all AI notes stay in `ai/`, out of the repo

> Turns AI from a chat buddy into a **reliable teammate** that follows your rules. Just for you.

---

# What it is "not" — Correct expectations

- ❌ **Not a local AI server** — Not about running DeepSeek, Ollama, Qwen, etc. on your machine
- ❌ **Not Agent Router** — You choose the driver; the workflow provides the map and logbook
- ❌ **Not Agent for Agents** — No meta-agent layer; just a shared protocol for any assistant
- ❌ **Not a team collaboration tool** — Built for solo focus, one developer
- ❌ **Not an autonomous robot** — Human-in-the-loop required; no unsupervised execution
- ❌ **Not a replacement** for CI/CD, testing, security scanners, or code reviews
- ❌ **Not a reporting dashboard** — No token tracking or manager reports
- ❌ **Not an AI training system** — No fine-tuning or model training

---

# Part 1: The Concept

---

# The Core Idea

> This isn't about better prompts or another AI tool.
>
> **It's about changing the way we work with AI.**

Tools and workflows should be simple to use. You shouldn't need to spend a lifetime learning a workflow.

---

# AI in a Nutshell

| Component | What it is |
|-----------|------------|
| **AI Assistants** | ChatGPT, Claude, DeepSeek, Gemini, GitHub Copilot... |
| **Memory (ai/)** | Context, checkpoints, progress, next-steps |
| **Brain (Policies)** | Rules for how AI should behave per project type |
| **Tools** | git, jq, grep, sed, docker, kubectl, gcloud... |
| **LLMs (Engine)** | GPT-5.4, GPT-5.4-mini, GPT-5.4-nano, GPT-5.3-codex... |

---

# Why Local AI is Better Than Web AI

## The Context Problem with Web Interfaces
- Web AI (ChatGPT, Gemini web) knows **only what you tell it** in a long prompt
- No memory of previous sessions — you start from scratch every time
- Limited file uploads — can't give it your full project

## The Local AI Advantage
- Runs **inside your project directory** — has access to **all your files**
- Builds a **much richer context** from your actual codebase
- You write **smaller prompts** — the AI already knows the project

> Web AI = you explain everything. Local AI = it already knows.

---

# Talk to AI Like a Person, Not a Computer

Think of AI as your **doctor** or your **therapist**.

- The more you tell it, the better response you get
- Don't write your requirements like computer instructions
- Speak naturally — describe what you want in plain language
- Share context, background, and reasoning — not just commands

> **Bad**: "function validateEmail(email) return bool regex test"
>
> **Good**: "I need a function that checks if an email address looks valid. It should handle common formats like name@domain.com. What's the best approach?"

---

# Personal AI Proficiency Model

| Level | Description |
|-------|-------------|
| 0 | Not using AI |
| 1 | Browser-based interaction (ChatGPT, Gemini web) |
| 2 | AI chat assistant in local editor (VS Code, etc.) |
| 3 | CLI-based interaction (copilot, claude, gemini, etc.) |
| 4 | Creating or using MCPs, Skills, etc. |
| 5 | Creating AI Agents that do tasks on your behalf |
| 6 | **Multiple AI assistants working together on a project** |

---

# Why This Workflow Was Created

## The Problem: The "Memory Gap"
- **The Prompt Tax**: You waste time re-explaining rules, tech stacks, and context
- **Context Loss**: AI forgets your next steps the moment a session ends
- **Scattered State**: One AI assistant = mostly fine, but tracking is buried in tool-specific logs
- **Two+ assistants** on the same project = chaos. Whose context is current?

## The Solution: Local Grounding
- **Instant Onboarding**: One protocol (AGENTS.md) replaces lengthy setup prompts
- **Predictable Behavior**: Every assistant follows the same local rules and guardrails
- **One shared context** — all assistants read/write the same files
- **Permanent Memory**: Project state lives in `ai/`. AI knows where it left off
- **Future-Proof**: Switch between IDE, CLI, or web chat without losing a beat
- **Zero-Script Setup**: No brittle scripts or "song and dance"; it's a logic-based protocol

> **One protocol. One shared state. Total Continuity.**

---

# How It Works — Different Situations

## Single Project, Single AI Assistant
1. You and AI work together → create a **checkpoint** before stopping
2. You come back next day, or a week later
3. AI loads the same context → continues from the same point

## Single Project, Multiple AI Assistants (Like a Road Trip)
1. Gemini is driving → creates a **checkpoint** before stopping
2. DeepSeek takes the wheel → loads the same context → continues from the same point
3. DeepSeek creates a checkpoint → Gemini takes over again

## Single Solution, Multiple Projects (The Architect)
- One AI brain oversees multiple project directories
- Design entire solution with ChatGPT/Codex
- When it gets tired, bring in DeepSeek

## Multiple Solutions, Multiple Architects
- Each architect oversees all projects under a solution
- Knowledge shared through a common file-system location

> **One protocol. One shared context. Any assistant picks up where the last one left off.**

---

# Single Project — Architecture

```
                    ┌──────────────────────┐
                    │   AI Assistant        │
                    │ (Claude/DeepSeek/     │
                    │  Gemini/Copilot/...)  │
                    └──────────┬───────────┘
                               │ reads AGENTS.md
                    ┌──────────▼───────────┐
                    │   AGENTS.md + ai/     │ ← Out-of-band management
                    └──────────────────────┘
                    ┌──────────────────────┐
                    │   Your Project        │
                    │   .git, src/, docs/   │
                    └──────────────────────┘
```

---

# Single Project — Directory View

```
my-project/
├── AGENTS.md          ← Points to central policy
├── ai/                ← AI context + state (git-ignored)
│   ├── context.md
│   ├── next-steps.md
│   ├── progress.md
│   ├── daily-checkpoints/
│   ├── notes/
│   ├── artifacts/
│   ├── shared/
│   │   ├── coordination.md
│   │   ├── handoffs/
│   │   └── knowledge-base/
├── .git/
├── README.md
├── docs/
└── src/
    └── index.html
```

---

# Single Project — Multiple Git Branches

```
                    ┌──────────────────────┐
                    │   AI Assistant        │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │   AGENTS.md + ai/     │
                    └──────────────────────┘
                    ┌──────────┬───────────┐
                    │          │           │
                    ▼          ▼           ▼
              master/main    feature/add-aboutus-page
              ───────────    ───────────────────────
              index.html     index.html
              css/style.css  aboutus.html
                             css/style.css
```

Two git branches for the same code base — notice different state of files.

---

# Single Project + Multiple AI Assistants

```
Load context using          Create a handoff for
AGENTS.md protocol.         Gemini, to create a proper
                            "contact-us.html" page for
                            this website.

Analyse the file in         Load context using
"notes/", and create a      AGENTS.md protocol.
plan out of it; Save
your plan in                Process the handoff files
"artifacts/".               one by one, ensuring that
                            you follow information
                            from the shared
                            knowledge-base.

                            Update relevant
                            documentation as you
                            process each handoff.
```

> This is a little advanced, but we will get there.

---

# Out-of-Band Management → Security + Privacy

**The Analogy**: Just like `.git` tracks your history without being part of your application code, Simple-AI-Workflow acts as an **external intelligence layer** — a dedicated brain and memory system for this project only.

**Key Benefit**: No "AI clutter" or "AI noise" (prompts, logs, agent files, state) spread all over your production repository.

**Independence**: The AI manages the project, but its own state exists outside Git history, contained in a single git-ignored directory (`ai/`).

**Privacy**: Your thoughts, reasoning, decisions, way of working, project/client/infrastructure details — all private. Nothing in Git — ever!

**Bonus**: Does not need your directory to be a Git repository either! Bring your idea in an empty directory, bring in AI, start brainstorming/building!

---

# Anatomy of AGENTS.md

```
# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants...

## AI Behavior Rules
- Strictly treat this file as read-only
- Strictly keep AI artifacts under ai/
- Strictly keep ai/ git-ignored
...

Read in this order:

**Central Policy Directory**: `/path/to/Simple-AI-Workflow/ai/`

### Centralized Authority (Mandatory)
1. [central main policy file](ai-policy-cloud.md)
2. [central common policy file](ai-policy-common.md)

After reading all accessible files above, acknowledge readiness...
```

**Key facts:**
- ~105 lines total — intentionally minimal
- Single absolute path points to the policy you want
- Same file works across all AI assistants

---

# Wait a minute!

> This is the same as what my existing AI assistant does!
> Why do I need this workflow then?

---

# The Central Policy Files

```
~/Simple-AI-Workflow/
├── AGENTS.md
├── ai/
│   ├── ai-policy-common.md           ← Universal guardrails
│   ├── ai-policy-cloud.md            ← Cloud/Infra
│   ├── ai-policy-web-frontend.md     ← Frontend
│   ├── ai-policy-api-backend.md      ← Backend/APIs
│   ├── ai-policy-data.md             ← Data/ETL
│   ├── ai-policy-linux-system-admin.md ← Linux/SRE
│   └── ai-policy-mobile-apps.md      ← Mobile Apps
└── README.md
```

Pick the policy that matches your project type.

---

# Key Features of This Workflow

- **Very Easy Setup** — Standardized Bootstrap Protocol, zero-install, easy updates
- **Instant Onboarding** — One standard prompt replaces pages of manual explanation
- **Autonomous State & Context Management** — Checkpoint system with just 3 files
- **Plug-n-Play** — Place AGENTS.md in any directory and start using AI
- **Acts as your Personal Project Manager** for each repository
- **Standardized Traceability** — Metadata headers on every AI-modified file
- **Centralized Policy Authority** — Cloud, Data, Web, Mobile, Linux — token & API efficiency
- **Analyze-Plan-Stop** — Mandatory pause for human directive before implementation
- **Multi-Agent Coordination** — A2A collaboration, knowledge base, handoffs
- **AI-Driven Secure Development** — Security best practices from threat modeling (STRIDE)

---

# More Features

- **Safe Git Operations** — Secrets scanning before every commit
- **No Tooling Lock-in** — Purely protocol-based; no brittle scripts or "song and dance"
- **Git Enrichment** — Automatic distillation of Git history
- **Handoff Protocol** — Seamlessly switch between IDE, CLI, and Web Chat
- **Notes (`ai/notes/`)** — Unpolished thoughts, meeting notes, random ideas
- **Artifacts (`ai/artifacts/`)** — Draft outputs, review before promoting to docs/code
- **About Human (`ai/about-human.md`)** — AI learns your skills and preferences
- **Modular Persona** — Quickly shift AI focus (Architect, Mentor) without losing guardrails
- **Policy Override** — `ai/ai-policy-override.md` for local exceptions
- **Daily Snapshots** — Automated history of work and decisions

---

# Quick Setup

1. **Clone** this repo to a central location (e.g. `~/Projects/Personal/Simple-AI-Workflow/`)
2. **Copy** `AGENTS.md` into your project root
3. **Update** the central policy path in `AGENTS.md`
4. **Start VS Code** and type in the AI chat:

   ```
   "bootstrap using AGENTS.md protocol"
   ```

> No install scripts. No sudo. No admin. No pip/npm. No this, no that!

---

# Daily Workflow

- **After completing important activities, taking a pause, or before closing VS Code:**
  - Use: `"checkpoint"` — updates all AI tracking files

- **When coming back from a pause or restart:**
  - Use: `"load context using AGENTS.md protocol"`
  - Followed by: `"Where are we in this project?"`

- **Everything AI-related** lives in `ai/` (git-ignored)
  - If you lose it, rebuild with: `"bootstrap using AGENTS.md protocol"`

---

# Checkpoint System

Checkpoints save AI state so you can resume later.

**Format:** `CP-YYYY-MM-DD-XX`

**Files updated:**
- `ai/next-steps.md` — current resume point
- `ai/progress.md` — chronological history
- `ai/daily-checkpoints/YYYY-MM-DD.md` — daily snapshot
- `ai/context.md` — project briefing

**When to checkpoint:**
- After completing a significant task
- Before closing VS Code
- Before your AI quota runs out
- Before switching AI assistants

---

# Bring Updates from Upstream

1. **Pull** recent changes from GitHub/Simple-AI-Workflow in your central policy location
2. **Run** `sync-agents-md.sh` to propagate the new AGENTS.md to all your projects
3. **Open** the project in VS Code
4. **Ask AI**: `"load context, and update the structure of the ai/ directory to comply with AGENTS.md"`

> The AI will implement new features without disturbing anything in `ai/` or your main project files.

---

# The Architect

```
                    ┌──────────────────────┐
                    │   AI Assistant        │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │   AGENTS.md + ai/     │
                    └──────────────────────┘
                    ┌──────┬──────┬───────┐
                    │      │      │       │
                    ▼      ▼      ▼       ▼
              static-  web-   infra-  my-business-
              website  api    structure  idea/docs
```

One AI "brain" sees everything across all your projects.

---

# The Architect — Directory View

```
.
├── AGENTS.md
├── ai/
│   ├── notes/
│   ├── artifacts/
│   ├── shared/
│   │   ├── coordination.md
│   │   ├── handoffs/
│   │   └── knowledge-base/
│   ├── secrets/
│   ├── context.md
│   ├── next-steps.md
│   ├── progress.md
│   └── daily-checkpoints/
├── README.md
├── docs/
└── src/
    └── main.go
```

| Area | Purpose |
|------|---------|
| `ai/` | The brain of the project |
| `src/`, `docs/` | Your public-facing project files |
| `ai/notes/` | Raw notes by you, for AI (and vice versa) |
| `ai/artifacts/` | Draft outputs, not yet ready for docs/code |
| `ai/shared/` | Multi-agent coordination |
| `ai/secrets/` | Temporary passwords, keys (NOT a vault) |
| `ai/daily-checkpoints/` | Audit logs — what was done on a certain day |

---

# Benefits of Architect-Level AI Setup

- **Visibility** — Complete overview of all related components
- **Cleanliness** — Production repos stay lean and professional
- **Portability** — One AI brain for entire solution, not one per project
- **Contextual Power** — Breaks the silo of single-repository AI tools
- **Cross-Project Refactoring** — Change shared code, see impact across all projects
- **Consistent Patterns** — Same policies and conventions everywhere
- **Instant Onboarding** — New project inherits all existing context
- **Unified Memory** — AI remembers decisions across project boundaries

---

# Number of Lines in Each Policy

```
$ wc -l ai-policy-*.md

  71 ai-policy-api-backend.md
  45 ai-policy-cloud.md
  67 ai-policy-common.md
  51 ai-policy-data.md
  40 ai-policy-linux-system-admin.md
  96 ai-policy-meta.md
 181 ai-policy-mobile-apps.md
  22 ai-policy-override.example.md
  71 ai-policy-web-frontend.md
```

---

# Policy Files Used by AGENTS.md

```
$ grep \# ai-policy-cloud.md
# DO NOT MODIFY THIS FILE
# AI Assistant Policy for Cloud and Platform Engineering
## Scope
## Role: Cloud and Platform Engineer
## Cloud Engineering Standards
## Infrastructure Security

$ grep \# ai-policy-common.md
# DO NOT MODIFY THIS FILE
# AI Assistant Policy — Common Guardrails & Contracts
## Instruction Precedence
## Feature Development and Branch-Gating
## Agent-to-Agent (A2A) Coordination
## Operational Restart and Checkpoint Contract
## Standardized Traceability & Metadata
## Universal Operational Guardrails
## Communication Standards
```

These are just some of the headings — the Do's and Don'ts.

---

# Anatomy of a Central Policy File

```
# DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Assistant Policy for Cloud and Platform Engineering

## Scope
- Applies to any AI assistant used in this repository...

## Role: Cloud and Platform Engineer
The AI Assistant acts as a **Senior Cloud Architect and Senior Cloud Engineer**...
```

**Important — must have a role!**
- Faster response
- 30-50% cheaper in token use
- Less clarification needed in follow-up prompts

---

# Token Saving in a MoE (Mixture of Experts) LLM

```
Your Role is "Senior Cloud Engineer"

    ┌─────────────────────────────────────────┐
    │         MoE LLM                         │
    │  ┌──────────┐ ┌──────────┐ ┌──────────┐ │
    │  │  Cloud   │ │  Programming │ │ Medicine │ │
    │  │  Tech    │ │             │ │          │ │
    │  │ GCP,AWS, │ │             │ │          │ │
    │  │ Azure... │ │             │ │          │ │
    │  └──────────┘ └──────────┘ └──────────┘ │
    └─────────────────────────────────────────┘
```

A clear role activates the right "expert" in the MoE model — saving tokens and getting better answers faster.

---

# Can I Create & Use My Own Policy? — Absolutely!

Write in the AI chat window (example):

> "I usually work as 'Windows Administrator', and manage some infrastructure on Azure. So, using ai-policy-cloud.md as guideline, create a new AI policy file for me, tailored for the type of work I do. Name the policy-file as ai-policy-windows.md"

Then inspect the file thoroughly. When you're happy, place it at a central location and use it through your AGENTS.md file.

---

# Example of ai-policy-override.md

```markdown
# AI Policy Override

## Windows Shell Priority (Local Setup)

For terminal execution on this Windows machine:

1. Use Git Bash first for all commands by default.
2. Prefer Git Bash-compatible command forms and tools.
3. Use PowerShell only when the operation is truly Windows-native.
4. When PowerShell is used, include a brief reason why Git Bash was not suitable.
5. Avoid unnecessary shell switching during a single task.
```

---

# Central Location for All Policies

```
~/Projects/Personal/Simple-AI-Workflow/ai/
├── ai-policy-backend-api.md
├── ai-policy-cloud.md
├── ai-policy-data.md
├── ai-policy-frontend-web.md
├── ai-policy-linux-admin.md
└── ai-policy-mobile-apps.md
```

Central location enables easy access and maintenance across all your projects.

---

# How to Keep All AGENTS.md Files Updated?

```
$ ./sync-agents-md.sh --source ../AGENTS.md --target-path ~/Projects/Personal/

Source: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/AGENTS.md
Searching under: /c/Users/kamran.azeem/Projects/Personal
Found 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal

Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md
Policy file in use: /c/.../Simple-AI-Workflow/ai/ai-policy-cloud.md

Updating ... (while retaining target policy path)
Done. Processed 3 AGENTS.md file(s).
```

---

# Managing AI Costs

## Token Saving Tips
1. **Watch your limits:** RPD (requests/day), RPM (requests/min), TPM (tokens/min)
2. **Use `/compact` or `/reset`** to summarize long conversations
3. **The piping strategy (CLI):**
   - ❌ Bad: Open a session and slowly paste 5 logs
   - ✅ Good: `grep "ERROR" logs.txt | gemini "Summarize these errors"`
4. **Check `/stats`** to see how much context you've used

## The Economics of AI Assistance

| Approach | Token Usage | Cost |
|----------|------------|------|
| AI does **everything** | High | 💰💰💰 |
| AI as **architect / guide / reviewer** | Low | 💰 |

> AI is your co-pilot, not your autopilot. Use it strategically.

---

# Bonus: TDD + AI = A Perfect Match

## The Old Excuse
> "TDD is too hard. Writing tests first takes too long; and, waste of time and (company's) money."

## The AI Reality
With AI, there is **nothing stopping you** from using the most feared — and yet most powerful — software engineering principle: **Test-Driven Development**.

## How to Do It
1. **Describe** what you want to build — a function, a component, an API endpoint
2. **Ask AI to write the test first** — before any implementation code
3. **Review the test** — does it capture the right behavior?
4. **Ask AI to write the implementation** — make the test pass
5. **Run the test** — green means you're done

> AI generates the test. You validate the logic. AI writes the code. The test proves it works.

---

# Git is Your Friend

## The Golden Rule

> **No matter how small you perceive your change — make a branch, commit frequently, and squash-merge when done.**

### Why this matters

When working with AI, things can go wrong:
- Editor crashes mid-edit
- AI glitches while modifying files
- Unexpected tool output corrupts your work

**Result?** Unusable code. Repairing it is far more painful than using Git.

---

# Git is Your Friend (contd.)

## The Strategy

```
1. CREATE A BRANCH
   └── "AI, create a branch for this fix"

2. COMMIT FREQUENTLY
   └── Let AI auto-commit as you go — it is safe
       Each commit = a safe fallback point

3. SQUASH-MERGE WHEN DONE
   └── "AI, document all work, commit, merge into main, push, delete local branch"
       All tiny commits → one clean commit on main

4. AI DOES IT ALL
   └── You never type a Git command
```

| Step | Benefit |
|------|---------|
| **Branch** | Isolates work. Main stays clean. |
| **Frequent commits** | Crash loses one step, not hours |
| **Squash-merge** | Clean history — one feature = one commit |
| **AI does it all** | Zero Git stress for you! |

---

# Git is Your Friend (contd.)

## The One-Liner Prompt

> **"Commit the work done until now in the current git branch, and then merge the branch into main, push main to remote, and delete the local branch."**

The AI will:
1. ✅ Scan files for secrets before committing
2. ✅ Commit with a descriptive message
3. ✅ Squash-merge into main/master
4. ✅ Push to remote
5. ✅ Delete the local branch

> **Git is your safety net. Let the AI be your Git driver. You just enjoy the ride.**

---

# Part 2: How to Use the Simple AI Workflow

---

# Prerequisites

- **AI assistant**: Any pricing tier; prefer one integrated with VS Code Chat extension (ChatGPT, Claude, DeepSeek, Gemini, GitHub Copilot)
- **VS Code chat extension**: Required. Examples: codeGPT, Cline (formerly Claude Dev)

---

# Quick Setup

1. Follow [github.com/KamranAzeem/Simple-AI-Workflow](https://github.com/KamranAzeem/Simple-AI-Workflow)
2. **Clone** this repo to a central location (e.g. `~/Projects/Personal/Simple-AI-Workflow/`)
3. **Copy** `AGENTS.md` into your target project root
4. **Update** the absolute path for the appropriate policy file in `AGENTS.md`
5. **Write** in the AI chat window:

   ```
   "bootstrap using AGENTS.md protocol"
   ```

> You have full control over your local copy.

---

# But I Use Copilot / Claude / ChatGPT! How Do I Use This Workflow?

- All AI assistants honor AGENTS.md — that's what the industry is converging on as a standard
- AGENTS.md has a section at the top to instruct all AI assistants to follow the directory structure and refrain from littering the project with their own files
- The only thing you need to do:

  ```
  "bootstrap using AGENTS.md protocol"
  ```

---

# Day-to-Day Tasks

| Prompt | What it does |
|--------|-------------|
| `"bootstrap using AGENTS.md protocol"` | First-time setup |
| `"checkpoint"` | Save current state |
| `"load context using AGENTS.md protocol, then show pending tasks"` | Resume and review |
| `"load context and update ai/ directory structure to comply with AGENTS.md"` | Upgrade ai/ structure |
| `"Add a note to TODO list to fix the background color"` | Quick task addition |
| `"Initialize git repo in this directory, add all files to first commit"` | Git init |
| `"Create a new git branch to create the menu system for website"` | Branch creation |

---

# Background Process When Loading Context

```
"load context"
       │
       ▼
┌──────────────────┐
│  Context files    │
│  in the "ai/"     │
│  directory        │
│                   │
│  ├─ context.md    │
│  ├─ next-steps.md │
│  ├─ progress.md   │
│  └─ checkpoints/  │
└──────────────────┘
```

---

# Part 3: Demo

## Simple Static Website
### (Using AI Chat within VS Code IDE)

---

# Part 4: Use AI Chat Window in the IDE or Use the CLI?

---

# IDE vs CLI (1/3)

## IDE (VS Code) + AI Chat Extension
- Resource hungry
- Costly
- Designed to be "helpful" by default — token-heavy
- Auto-indexes workspace, pulls files into prompt background
- Long system prompt sent with every message
- Entire chat history active = massive token debt
- **Best for:** Large-scale refactoring, coding

## AI CLI (Copilot, Gemini, etc.)
- Lightweight on system resources
- Less expensive
- More manual = better token control
- Efficient for precise IT tasks
- No "token tax" — knows only what you ask
- Fresh command starts at zero tokens
- **Best for:** IT infra, scripts, log analysis

---

# IDE vs CLI (2/3)

## How to Save Tokens in Both

1. **Watch your limits:**
   - Requests per minute (RPM)
   - Tokens per minute (TPM)
   - Requests per day (RPD)

2. **Use `/compact` or `/reset`** to summarize long conversations

3. **Check your stats:** `/stats` or `/about` to see token usage

**The Verdict:** For IT/Cloud work (logs, YAML files), CLI is more token-efficient because it doesn't guess what else is relevant in your project.

---

# Getting Started with CLI

Install your preferred AI assistant CLI:

- **GitHub Copilot:** `npm install -g @githubnext/github-copilot-cli`
- **Gemini:** `npm install @google/gemini-cli` — generous free plan
- **Claude:** `npm install -g @anthropic-ai/claude-code`
- **Codex (OpenAI):** `npm install -g openai-codex`
- **DeepSeek:** No official CLI tool yet

---

# Part 5: Demo

## Simple Static Website
### (Using Gemini CLI + IDE / Basic Text Editor)

---

# Summary

| Before | After |
|--------|-------|
| Each assistant has its own context | One shared context in `ai/` |
| Switching assistants = starting over | Any assistant picks up where the last left off |
| Different layouts per assistant/tool | Same AGENTS.md protocol everywhere |
| Context is lost on restart | Checkpoints preserve state |

> **One protocol. One shared context. Any assistant picks up where the last one left off.**

---

# Architectural Philosophy: Protocol vs. Plumbing

## The "Context Engineering" Core
Moving from "chatting" with AI to **Governance-as-Code**.

- **Protocol (Your Approach)**: Declarative, transparent, markdown-based policies.
  - Stateless intelligence layer.
  - No heavy orchestration, no background processes.
- **Plumbing (Anti-pattern)**: Avoiding deep-nested, brittle agent frameworks.

## Scalability Guardrails
1. **Analyze-Plan-Stop**: The ultimate token-saver; prevents AI from wandering off-script.
2. **Modular Loading**: Only bootstrap with policies relevant to the current project.
3. **Context Separation**:
   - **Policy Files** = The "Rules" (mandatory, universal)
   - **Shared Knowledge** = The "Memory" (lessons learned, indexed on-demand)

> **Verdict**: You are building a sustainable intelligence infrastructure, not just a set of scripts.

---

# Questions?

**Simple AI Workflow**

[github.com/KamranAzeem/Simple-AI-Workflow](https://github.com/KamranAzeem/Simple-AI-Workflow)

© 2026 by Muhammad Kamran Azeem — Licensed under Creative Commons Attribution 4.0 International

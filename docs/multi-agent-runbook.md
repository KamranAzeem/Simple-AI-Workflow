---
# Multi-Agent Runbook: Three AI Assistants, One Website

A step-by-step walkthrough demonstrating how multiple AI assistants collaborate on the same project using the Simple-AI-Workflow protocol.

## Scenario

Build a simple 3-page static website (Home, About, Contact) using three different AI assistants:

- **Agent A (Gemini)**: Creates project structure, `index.html`, and CSS
- **Agent B (Claude)**: Creates `about.html` and `contact.html`
- **Agent C (DeepSeek)**: Reviews all pages, fixes issues, and finalizes

## Prerequisites

- Simple-AI-Workflow cloned to a central location
- `AGENTS.md` copied to the project root with the correct policy path
- All three AI assistants have access to the same project directory
- The `ai/` directory is git-ignored (shared state, not committed)

---

## Phase 1: Agent A (Gemini) — Foundation

### Step 1.1: Bootstrap

Open your IDE with Agent A (Gemini) and send:

```
bootstrap using AGENTS.md protocol
```

**Expected outcome**: Agent A loads AGENTS.md, creates the `ai/` directory structure, initializes state files, and acknowledges readiness.

### Step 1.2: Initialize Git

```
Initialize git repo with main branch, add .gitignore, show changes, stop before commit.
```

**Expected outcome**: Git repo initialized on `main` with `.gitignore` excluding `ai/**` and `AGENTS.md`.

### Step 1.3: Create Home Page

```
Create index.html with minimalistic inline CSS: header, main content, footer. No frameworks, no animations. Show files and test command.
```

**Expected outcome**: `index.html` created with clean, minimalistic design.

### Step 1.4: Update Coordination Board

```
Update ai/shared/coordination.md to record that Agent A (Gemini) has completed the project foundation (index.html, CSS, git init). List remaining tasks for Agent B.
```

**Expected outcome**: `coordination.md` reflects current state and next steps.

### Step 1.5: Create Handoff for Agent B

```
Create a handoff file at ai/shared/handoffs/agent-b-create-pages.md with:
- Objective: Create about.html and contact.html matching index.html style
- Requirements: Consistent CSS, navigation links between all pages
- Verification: All three pages link to each other, consistent styling
```

**Expected outcome**: Handoff file created with clear requirements and verification steps.

### Step 1.6: Checkpoint

```
checkpoint
```

**Expected outcome**: AI tracking files updated. Agent A's work is saved.

---

## Phase 2: Agent B (Claude) — Page Creation

### Step 2.1: Load Context

Open your IDE with Agent B (Claude) and send:

```
load context using AGENTS.md protocol
```

**Expected outcome**: Agent B loads the shared context and sees the pending handoff.

### Step 2.2: Claim and Execute Handoff

```
Claim and execute the handoff at ai/shared/handoffs/agent-b-create-pages.md
```

**Expected outcome**: Agent B:
1. Records ownership in `coordination.md`
2. Creates `about.html` and `contact.html` matching the existing style
3. Adds navigation links between all three pages
4. Runs verification steps

### Step 2.3: Create Handoff for Agent C

```
Create a handoff file at ai/shared/handoffs/agent-c-review.md with:
- Objective: Review all three pages for consistency, fix any issues
- Requirements: Check styling consistency, navigation, HTML validity
- Verification: All pages pass review with zero issues noted
```

**Expected outcome**: Handoff for Agent C created.

### Step 2.4: Checkpoint

```
checkpoint
```

**Expected outcome**: Agent B's work is saved. Handoff ready for Agent C.

---

## Phase 3: Agent C (DeepSeek) — Review & Finalize

### Step 3.1: Load Context

Open your IDE with Agent C (DeepSeek) and send:

```
load context using AGENTS.md protocol
```

**Expected outcome**: Agent C loads the shared context and sees the pending review handoff.

### Step 3.2: Claim and Execute Review

```
Claim and execute the handoff at ai/shared/handoffs/agent-c-review.md
```

**Expected outcome**: Agent C:
1. Records ownership in `coordination.md`
2. Reviews all three pages
3. Fixes any issues found
4. Runs verification steps

### Step 3.3: Finalize

```
Update ai/shared/coordination.md to mark all tasks complete. Create a final checkpoint.
```

**Expected outcome**: Project state finalized. All tasks marked complete.

---

## Key Takeaways

- **Shared context** (`ai/`) enables seamless handoffs between different AI assistants
- **Handoffs** provide clear task boundaries with verification criteria
- **Coordination.md** acts as a task board, preventing duplicate work
- **Checkpoints** preserve state so any assistant can resume where another left off
- **No special tooling needed** — just AGENTS.md, `ai/`, and standard AI chat interfaces

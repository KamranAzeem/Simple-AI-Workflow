<!--
Created-by: GitHub Copilot
Updated-by: GitHub Copilot
Last modified: 2026-04-23T12:35:00+02:00
Intent: Provide a prompt-first runbook for sequential AI-driven execution of the onboarding exercise.
-->
---
# Example Learning Session Runbook (Prompt-First)

This runbook is a sequence of simple prompts the user sends to AI.

Use one step at a time, in order. After each step, wait for AI to finish before sending the next prompt.

## Prerequisites

### 1. IDE and AI Chat Extension
- Install a modern IDE:
  - **VS Code** (recommended) or equivalent (JetBrains IDEs, etc.)
- Install an AI chat extension matching your chosen AI provider:
  - **GitHub Copilot**: Install official GitHub Copilot Chat extension in VS Code
  - **DeepSeek**: Install Cline extension and configure for DeepSeek API
  - **ChatGPT/OpenAI**: Install relevant extension (e.g., ChatGPT extension or Cline)
  - **Claude/Anthropic**: Install Cline extension and configure for Claude API
  - **Google Gemini**: Install Cline extension and configure for Gemini
- Authenticate with your chosen AI provider:
  - Generate API key/token from your AI provider's dashboard (if needed).
  - Configure the extension with valid credentials (API key, auth token, etc.).
  - Test the connection by opening a chat in the IDE and sending a simple message.

### 2. Simple-AI-Workflow Repository
- Clone the [Simple-AI-Workflow](https://github.com/kamran-azeem/Simple-AI-Workflow) repository to a central location on your machine.
- Example: `~/Projects/Simple-AI-Workflow` or `C:\Users\YourName\Projects\Simple-AI-Workflow`
- This central location is your reference copy for policies and protocol.

### 3. AGENTS.md Configuration
- Copy `AGENTS.md` from the central Simple-AI-Workflow repository to your example project directory.
- Open the copied `AGENTS.md` in your example directory.
- Update the central policy path reference to point to the correct location on your machine:
  - Windows example: `C:/Users/YourName/Projects/Personal/Simple-AI-Workflow/ai/`
  - macOS/Linux example: `~/Projects/Personal/Simple-AI-Workflow/ai/`
  - Ensure the path reflects your actual central repository location.
- Verify the policy files exist at the path you configured (check that `ai-policy-meta.md` and `ai-policy-common.md` are accessible).

### 4. Verification Checklist
Before starting Step 1, confirm:
- [ ] IDE is installed and AI chat extension is visible in the UI.
- [ ] AI extension is authenticated and ready (test with a simple message).
- [ ] You can open a chat window in the IDE and send prompts.
- [ ] Simple-AI-Workflow repository is cloned to a central location.
- [ ] AGENTS.md is copied to your example project directory.
- [ ] AGENTS.md central policy path is updated to your machine's path.

Once all prerequisites are met, proceed to Step 1.

## Quick Rules for the User
- Send one prompt at a time.
- Ask AI to stop after each major step so you can review.
- Do not send a new instruction while AI is actively working on the current one.
- If AI is clearly going in the wrong direction, interrupt early to avoid wasting context window and tokens.

## Operational Notes
- Use `/stats` regularly (if your chat extension supports it) to monitor model usage, token usage, and current context size.
- Watch the context window usage indicator in your chat extension during long sessions.
- If usage gets high, compress or summarize context when the extension supports it, then continue with the next step.

## Step 1: Bootstrap ai/ Directory Structure
Send this prompt:

```text
bootstrap using AGENTS.md protocol
```

**Note:** Do not use the built-in `/init` command. It has extension-specific behavior across AI chat tools.

Expected outcome:
- The agent will load instructions from AGENTS.md and load necessary policy files.
- New ai/ directory with all required subdirectories exists.
- User can verify directory tree under ai/.

## Step 2: Initialize Git Repository
Send this prompt:

```text
Initialize git repo with main branch, add .gitignore, show changes, stop before commit.
```

Expected outcome:
- Git repo ready on main branch.

## Step 3: Build Home Page
Send this prompt:

```text
Create index.html with minimalistic inline CSS: header, main content, footer. No frameworks, no animations. Show files and test command.
```

Expected outcome:
- index.html created with minimalistic CSS.

## Step 4: Create Todo List
Send this prompt:

```text
Create ai/tasks/todo.md with: create aboutus page, create contactus page, local test, branch cleanup.
```

Expected outcome:
- Todo file exists under ai/tasks/.

## Step 5: Create Feature Branch for About Us
Send this prompt:

```text
Create and checkout feature/aboutus branch, then stop.
```

Expected outcome:
- On feature/aboutus branch.

## Step 6: Implement About Us Page
Send this prompt:

```text
Create aboutus.html with minimalistic CSS consistent with index.html, add nav link from index.html, show files and test command.
```

Expected outcome:
- aboutus.html exists and is linked from home page.

## Step 7: Merge and Clean Up
Send this prompt:

```text
Switch to main, squash-merge feature/aboutus with good commit message, delete feature/aboutus, show git log and status. Do not push.
```

Expected outcome:
- Branch merged to main as one commit and deleted.

## Step 8: Checkpoint
Send this prompt:

```text
checkpoint
```

Expected outcome:
- AI Tracking files updated. No code files will be touched.

## Step 9: Session Restart
User action:
- Close IDE/chat.
- Reopen workspace.

Then send this prompt:

```text
Load context using AGENTS.md protocol, tell me where we left off and next action.
```

Expected outcome:
- AI resumes from tracking files.

## Step 10: Repeat for Contact Us Page
Send this prompt:

```text
create page in a new git branch, implement page with minimalistic CSS, link nav, squash-merge to main, delete branch, show git status.
```

Expected outcome:
- contactus task completed and merged.

## Step 11: Create Handoff and Knowledge Base
Send this prompt:

```text
Create ai/shared/handoffs/sample.md (objective, state, next step, criteria) and two files in ai/shared/knowledge-base: minimal-page-pattern.md and branch-squash-merge-pattern.md. Show paths.
```

Expected outcome:
- 1 handoff + 2 knowledge-base files created.

The user then inspects the newly created files, and uses the handoff file to create a new task for AI.

## Step 12: Optional Containerization
Send this prompt:

```text
containerize this project (simple website) with minimal Dockerfile. Provide build/run commands and verification steps.
```

Expected outcome:
- Optional container setup available.

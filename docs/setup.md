# Setup

## Windows path formats

File-manipulation tools on Windows require absolute paths (`C:\path\to\file`).

- Git Bash POSIX: `/c/Users/` → `C:\Users\`
- WSL POSIX: `/mnt/c/Users/` → `C:\Users\`

## Manual setup

- Manually create your **User AI Directory** structure. The default is `[HOME]/.ai/`, resolved from `User AI Directory` in `ai-customization.md`.
- Create a personal settings file (e.g., `user-settings.md`) in the **User AI Settings Directory**. This file holds your personal preferences, tool configurations, and cross-project context that the AI fully loads at every session start.
- **Reading the protocol**: Open `AGENTS.md` with the assistant's built-in file-read tool. If a client hides a git-ignored path, use the reported fallback in `AGENTS.md`; never treat the file as unreadable.

## Kilo Code Setup

Kilo Code is the recommended VS Code extension for this workflow.

1. Install VS Code, then install the Kilo Code extension from the Marketplace.
2. Open Kilo Code and choose a provider. See the [provider guide](ai-provider-selection-guide.md) if you are unsure.
3. Paste the provider API key and choose a model.
4. Open the project root with `AGENTS.md` and `ai-customization.md`, then run `"bootstrap using AGENTS.md protocol"`.
5. Start each session with `"load context using AGENTS.md protocol"`.

## How It Works

```text
Simple-AI-Workflow/              Your Project/
|-- AGENTS.md            -->     |-- AGENTS.md
|-- ai-customization.md  -->     |-- ai-customization.md
|-- ai/policies/                 |-- ai/ (state, notes, issues, skills)
|-- ai/procedures/               |-- src/
|-- ai/skills/                   |
|-- docs/                        |-- ...
|-- support-files/
```

The clone holds the workflow, the policy and procedure store, and the workflow skills. The project copies `AGENTS.md` and `ai-customization.md`. The procedure modules stay in the clone and load from `(Workflow AI Directory)/ai/procedures/`.

## Updating an Existing Project

1. Run a checkpoint in the project and close the assistant.
2. In the clone, run `git pull`.
3. Run the sync script from the clone:
   - Linux or Git Bash: `./support-files/sync-agents-md.sh --source ./AGENTS.md --target-path ~/Projects`
   - Windows PowerShell: `.\support-files\sync-agents-md.ps1 -Source '.\AGENTS.md' -TargetPath 'C:\Users\<you>\Projects'`
4. Reopen the project and run `"load context using AGENTS.md protocol"`.
5. Run `"repair knowledge files"` once in each project; add `global` for the global store.

The sync script updates `AGENTS.md`, checks or creates `ai-customization.md`, adds `## Merge Policy` when it is missing, and migrates the state layout. It does not create `AGENTS.md` for a new project, and it does not copy skills.

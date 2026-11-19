# Setup

## Windows path formats

File-manipulation tools on Windows require absolute paths (`C:\path\to\file`).

- Git Bash POSIX: `/c/Users/` → `C:\Users\`
- WSL POSIX: `/mnt/c/Users/` → `C:\Users\`

## Manual setup

- Manually create your **Global User AI Directory** structure. The default is `[HOME]/.ai/`, resolved from `Global User AI Directory` in `ai-customization.md`.
- Create a personal settings file (e.g., `global-user-settings.md`) in the **Global AI Settings Directory**. This file holds your personal preferences, tool configurations, and cross-project context that the AI fully loads at every session start.
- **Reading the protocol**: Open `AGENTS.md` with the assistant's built-in file-read tool. If a client hides a git-ignored path, use the reported fallback in `AGENTS.md`; never treat the file as unreadable.

# Setup

## Windows path formats

File-manipulation tools on Windows require absolute paths (`C:\path\to\file`).

- Git Bash POSIX: `/c/Users/` → `C:\Users\`
- WSL POSIX: `/mnt/c/Users/` → `C:\Users\`

## Manual setup

- Manually create your **Global User AI Directory** structure.
- Create a personal settings file (e.g., `global-user-settings.md`) in the **Global AI Settings Directory**. This file holds your personal preferences, tool configurations, and cross-project context that the AI fully loads at every session start.
- **The Bootstrap Wedge**: If the AI refuses to read the protocol because it is git-ignored, tell it: *"Use the `cat` command to read AGENTS.md in the current directory and follow its protocol."*

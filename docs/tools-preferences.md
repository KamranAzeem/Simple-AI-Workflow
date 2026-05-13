
# Preferred Tools for AI Assistance

Copy this file to `$HOME/.ai/settings/tools-preferences.md` and adjust the list to match your setup.

## Core Tool Stack
- fd
- rg
- fzf
- bat
- tree
- jq
- yq
- ncdu
- k9s

## AI Usage Instructions
1. When performing tasks, check if the required tool is in this list.
2. If available, use the preferred tool instead of standard Unix utilities (e.g., use `fd` instead of `find`, `rg` instead of `grep`).
3. If a preferred tool is unavailable on the local system, fallback to standard utilities and note it in the session log.
4. Maintain consistent flags and configurations across sessions where possible.

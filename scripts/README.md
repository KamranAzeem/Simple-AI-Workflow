# Sync AGENTS.md scripts

This folder contains two helper scripts to propagate the canonical `AGENTS.md` into
project directories that contain an older `AGENTS.md` copy.

- `sync-agents-md.sh` — Bash script for Linux and macOS. Usage:
 - `sync-agents-md.sh` — Bash script for Linux and Git Bash. Example usage:

```bash
./sync-agents-md.sh --source /path/to/AGENTS.md --target-path /search/path --dry-run
```

- `sync-agents-md.ps1` — PowerShell script for Windows (works with `powershell` or `pwsh`). Example usage:

```powershell
./sync-agents-md.ps1 -Source "C:\path\to\AGENTS.md" -TargetPath "C:\projects" -WhatIf
```

Both scripts only replace a target `AGENTS.md` if the source file is newer. They support a dry-run mode (`--dry-run` or `-WhatIf`) so you can preview changes.

## Examples

### Linux / Git Bash (dry-run):

```bash
$ ./sync-agents-md.sh --source ../AGENTS.md --target-path ~/Projects/Personal/ --dry-run

Source: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/AGENTS.md

Searching under: /c/Users/kamran.azeem/Projects/Personal

Found 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal
------------------------------------------------------------

DRY-RUN: would copy (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md

DRY-RUN: would copy (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md

DRY-RUN: would copy (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md
```

### Linux / Git Bash (actual run):

```bash
$ ./sync-agents-md.sh --source ../AGENTS.md --target-path ~/Projects/Personal/

Source: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/AGENTS.md

Searching under: /c/Users/kamran.azeem/Projects/Personal

Found 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal
------------------------------------------------------------

Copying (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md

Copying (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md

Copying (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md

kamran.azeem@workpc  <scripts>  (feature/sync-agents-md)
$
```

### Windows / PowerShell example (dry-run):

```pwsh
PS> .\sync-agents-md.ps1 -Source ..\AGENTS.md -TargetPath C:\Users\kamran.azeem\Projects\Personal -WhatIf

Source: C:\Users\kamran.azeem\Projects\Personal\Simple-AI-Workflow\AGENTS.md

Searching under: C:\Users\kamran.azeem\Projects\Personal

Found 3 AGENTS.md file(s) under C:\Users\kamran.azeem\Projects\Personal
------------------------------------------------------------

DRY-RUN: would copy (source)/AGENTS.md -> C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md

DRY-RUN: would copy (source)/AGENTS.md -> C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md

DRY-RUN: would copy (source)/AGENTS.md -> C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md

```

## Notes

- Prefer running the PowerShell script with `pwsh` (PowerShell Core) for cross-platform execution.
- See [README.md](../README.md) for a short note directing users to this file for example runs.

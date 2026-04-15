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

Behavior

Both scripts compare file contents first and will update a target `AGENTS.md` whenever the contents differ. This avoids relying on timestamps alone. They support a dry-run mode (`--dry-run` or `-WhatIf`) so you can preview changes.
Implementation details:

- Bash: uses `cmp -s` (fast, short-circuiting) with `diff` as a fallback.
- PowerShell: uses `Get-FileHash -Algorithm SHA256` to compare file hashes.

Argument notes:

- `sync-agents-md.sh` requires the `--source` argument to appear before `--target-path` on the command line (this prevents accidental ordering mistakes).

Safety:

- Always run with the dry-run flag first to verify what will change.
- On Windows, PowerShell's Execution Policy may block script execution; run with a one-time bypass or set `-Scope CurrentUser RemoteSigned` if you trust the source.


## Examples

### Linux / Git Bash (dry-run):

```bash
$ ./sync-agents-md.sh --source ../AGENTS.md --target-path ~/Projects/Personal/ --dry-run

Source: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/AGENTS.md

Searching under: /c/Users/kamran.azeem/Projects/Personal

Found 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal

DRY-RUN: would copy (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md

DRY-RUN: would copy (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md

DRY-RUN: would copy (source)/AGENTS.md -> /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md
Found 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal
------------------------------------------------------------

Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md

Policy file in use: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md

DRY-RUN: would update /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md (while retaining target policy path)

----------------------------------------------------------------------------

Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md

Policy file in use: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md

DRY-RUN: would update /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md (while retaining target policy path)

----------------------------------------------------------------------------

Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md

Policy file in use: (none)

DRY-RUN: would replace /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md (no central policy line found)
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

### Windows / PowerShell example (dry-run + actual run):

```pwsh
PS> powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\sync-agents-md.ps1 -Source '..\AGENTS.md' -TargetPath 'C:\Users\kamran.azeem\Projects\Personal\' -WhatIf }"

Source: C:\Users\kamran.azeem\Projects\Personal\Simple-AI-Workflow\AGENTS.md

Searching under: C:\Users\kamran.azeem\Projects\Personal\

Found 3 AGENTS.md file(s) under C:\Users\kamran.azeem\Projects\Personal\
------------------------------------------------------------

Target: C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md
Policy file in use: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md

DRY-RUN: would update C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md (while retaining target policy path)

Target: C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md
Policy file in use: /c/Users/kamran.azeem\Projects\Personal\Simple-AI-Workflow/ai/ai-policy-cloud.md

DRY-RUN: would update C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md (while retaining target policy path)

Target: C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md
Policy file in use: (none)

DRY-RUN: would replace C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md (no central policy line found)

PS> powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\sync-agents-md.ps1 -Source '..\AGENTS.md' -TargetPath 'C:\Users\kamran.azeem\Projects\Personal\' }"

Source: C:\Users\kamran.azeem\Projects\Personal\Simple-AI-Workflow\AGENTS.md

Searching under: C:\Users\kamran.azeem\Projects\Personal\

Found 3 AGENTS.md file(s) under C:\Users\kamran.azeem\Projects\Personal\
------------------------------------------------------------

Target: C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md
Policy file in use: /c/Users/kamran.azeem\Projects\Personal\Simple-AI-Workflow/ai/ai-policy-cloud.md

Updating C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md (while retaining target policy path)

Target: C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md
Policy file in use: /c/Users\kamran.azeem\Projects\Personal\Simple-AI-Workflow/ai/ai-policy-cloud.md

Updating C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md (while retaining target policy path)

Target: C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md
Policy file in use: (none)

Replacing C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md (no central policy line found)
```

## Notes

- Prefer running the PowerShell script with `pwsh` (PowerShell Core) for cross-platform execution.
- See [README.md](../README.md) for a short note directing users to this file for example runs.

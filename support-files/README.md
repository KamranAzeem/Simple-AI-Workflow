# Sync AGENTS.md scripts

This folder contains two helper scripts to propagate the canonical `AGENTS.md` into project directories that may contain an older `AGENTS.md` copy, while preserving the "central workflow directory and central policy file references" locations in those `AGENTS.md` files. This makes is very easy to find and update all the `AGENTS.md` files, no matter where they are in the target-path that you provide to the script. This is shown below in the test runs.

Remember, these tools/scripts are completely optional. If you want, you can instead use your OS (CLI-based) copy commands - or a file manager in the GUI to copy the `AGENTS.md` file to the project/directory of your choice. 

- `sync-agents-md.sh` — Bash script for Linux, macOS, and Git Bash (POSIX environments).

```bash
./sync-agents-md.sh --source /path/to/AGENTS.md --target-path /search/path --dry-run
```

- `sync-agents-md.ps1` — PowerShell script for Windows (works with `powershell` or `pwsh`).

```powershell
./sync-agents-md.ps1 -Source "C:\path\to\AGENTS.md" -TargetPath "C:\projects" -WhatIf
```

## Behavior

Both scripts compare file contents first and will update a target `AGENTS.md` whenever the contents differ. This avoids relying on timestamps alone. They support a dry-run mode (`--dry-run` or `-WhatIf`) so you can preview changes.

## Implementation details

- Bash: compares file contents and injects the target's central workflow directory value using `grep`/`sed` plus `cp`/`mv` for updates; it enforces the `--source` before `--target-path` ordering for safety.
- PowerShell: reads the source content and performs a regex-based replacement/injection of the central workflow directory line; it uses content-based comparison and write operations rather than an explicit file-hash command.

Note: The Bash script enforces positional ordering of `--source` before `--target-path` (see argument notes). The PowerShell script accepts named parameters, so explicit ordering is not required there.

### Argument notes

- `sync-agents-md.sh` requires the `--source` argument to appear before `--target-path` on the command line (this prevents accidental ordering mistakes).

### Safety

- Always run with the dry-run flag first to verify what will change.
- On Windows, PowerShell's Execution Policy may block script execution; run with a one-time bypass or set `-Scope CurrentUser RemoteSigned` if you trust the source.


## Examples

### Linux / Git Bash (dry-run):
```bash
$ ./sync-agents-md.sh --source ../AGENTS.md --target-path ~/Projects/Personal/ --dry-run

Source: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/AGENTS.md

Searching under: /c/Users/kamran.azeem/Projects/Personal

Found 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal

----------------------------------------------------------------------------


Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/
	Central Main Policy:      /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md
	Central Common Policy:    /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-common.md

DRY-RUN: would update /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/
	Central Main Policy:      /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md
	Central Common Policy:    /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-common.md

DRY-RUN: would update /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: (not found, will use source value)
	Central Main Policy:      (not found, will use source value)
	Central Common Policy:    (not found, will use source value)

DRY-RUN: would update /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Done. Processed 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal
```

### Linux / Git Bash (actual run):

```bash
$ ./sync-agents-md.sh --source ../AGENTS.md --target-path ~/Projects/Personal/

Source: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/AGENTS.md

Searching under: /c/Users/kamran.azeem/Projects/Personal

Found 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal

----------------------------------------------------------------------------


Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/
	Central Main Policy:      /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md
	Central Common Policy:    /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-common.md
Updating /c/Users/kamran.azeem/Projects/Personal/azure-katas/AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/
	Central Main Policy:      /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md
	Central Common Policy:    /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-common.md
Updating /c/Users/kamran.azeem/Projects/Personal/local-ai-server-feasibility/AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Target AGENTS.md file: /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: (not found, will use source value)
	Central Main Policy:      (not found, will use source value)
	Central Common Policy:    (not found, will use source value)
Updating /c/Users/kamran.azeem/Projects/Personal/static-website/AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Done. Processed 3 AGENTS.md file(s) under /c/Users/kamran.azeem/Projects/Personal
```


### Windows / PowerShell example (dry-run):

```powershell
PS> powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\sync-agents-md.ps1 -Source '..\AGENTS.md' -TargetPath 'C:\Users\kamran.azeem\Projects\Personal\' -WhatIf }"
Source: C:\Users\kamran.azeem\Projects\Personal\Simple-AI-Workflow\AGENTS.md

Searching under: C:\Users\kamran.azeem\Projects\Personal\

Found 3 AGENTS.md file(s) under C:\Users\kamran.azeem\Projects\Personal\
------------------------------------------------------------

Target AGENTS.md file: C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/
	Central Main Policy:      /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-azure.md
	Central Common Policy:    /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-common.md

DRY-RUN: would update C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Target AGENTS.md file: C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/
	Central Main Policy:      /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md
	Central Common Policy:    /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-common.md

DRY-RUN: would update C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Target AGENTS.md file: C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: (not found, will use source value)
	Central Main Policy:      (not found, will use source value)
	Central Common Policy:    (not found, will use source value)

DRY-RUN: would update C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Done. Processed 3 AGENTS.md file(s) under C:\Users\kamran.azeem\Projects\Personal\
```

### Windows / PowerShell example (actual run):


```powershell
PS> powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\sync-agents-md.ps1 -Source '..\AGENTS.md' -TargetPath 'C:\Users\kamran.azeem\Projects\Personal\' }"
Source: C:\Users\kamran.azeem\Projects\Personal\Simple-AI-Workflow\AGENTS.md

Searching under: C:\Users\kamran.azeem\Projects\Personal\

Found 3 AGENTS.md file(s) under C:\Users\kamran.azeem\Projects\Personal\
------------------------------------------------------------

Target AGENTS.md file: C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/
	Central Main Policy:      /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-azure.md
	Central Common Policy:    /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-common.md

Updating C:\Users\kamran.azeem\Projects\Personal\azure-katas\AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Target AGENTS.md file: C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/
	Central Main Policy:      /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md
	Central Common Policy:    /c/Users/kamran.azeem/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-common.md

Updating C:\Users\kamran.azeem\Projects\Personal\local-ai-server-feasibility\AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Target AGENTS.md file: C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md

Values preserved from target (if found):
	Central Workflow Directory: (not found, will use source value)
	Central Main Policy:      (not found, will use source value)
	Central Common Policy:    (not found, will use source value)

Updating C:\Users\kamran.azeem\Projects\Personal\static-website\AGENTS.md (while retaining target-specific policy settings)

----------------------------------------------------------------------------

Done. Processed 3 AGENTS.md file(s) under C:\Users\kamran.azeem\Projects\Personal\
```

## Notes

- Prefer running the PowerShell script with `pwsh` (PowerShell Core) for cross-platform execution.

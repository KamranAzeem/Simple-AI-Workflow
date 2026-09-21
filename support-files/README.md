# Sync AGENTS.md scripts

Optional helper scripts that propagate the canonical `AGENTS.md` into your project directories, and make sure each project has a correctly configured `ai-customization.md` at its project root. They also migrate the old `ai/ai-customization.md` location when they find one.

- `sync-agents-md.sh` — Bash script for Linux, macOS, and Git Bash (POSIX environments).
- `sync-agents-md.ps1` — PowerShell script for Windows (works with `powershell` or `pwsh`).

These scripts are optional. You can instead copy `AGENTS.md` and `ai-customization.md` yourself with CLI commands or a GUI file manager.

## Usage

Bash:

```bash
./sync-agents-md.sh --source /path/to/AGENTS.md --target-path /search/path --dry-run
```

PowerShell:

```powershell
./sync-agents-md.ps1 -Source "C:\path\to\AGENTS.md" -TargetPath "C:\projects" -WhatIf
```

## Behavior

- Copies the canonical `AGENTS.md` into every project under the target path that has an `AGENTS.md`. It compares contents first, so unchanged files are skipped.
- For each project, ensures `ai-customization.md` exists at the project root with a `## AI Workflow Configuration` section, and points `**Global AI Workflow Directory**` at the current clone.
- Migrates the old layout: an `ai/ai-customization.md` is moved to the project root. If the root `ai-customization.md` is a symlink to it, the link is kept and the real file is edited in place.
- Supports a dry run (`--dry-run` or `-WhatIf`) that reports what it would change without writing.

## Argument notes

- `sync-agents-md.sh` requires `--source` to appear before `--target-path`, to prevent ordering mistakes.
- `sync-agents-md.ps1` uses named parameters, so ordering does not matter.

## Safety

- Run the dry run first to verify what will change.
- On Windows, the PowerShell execution policy may block the script. Run it with a one-time bypass, or set `-Scope CurrentUser RemoteSigned` if you trust the source.

## Example (Bash dry run)

```text
$ ./sync-agents-md.sh --source ./AGENTS.md --target-path ~/Projects --dry-run
Source: ~/Projects/Simple-AI-Workflow/AGENTS.md
Workflow directory: ~/Projects/Simple-AI-Workflow
Searching under: /path/to/projects
Found 2 AGENTS.md file(s)
----------------------------------------------------------------------------
Target: /path/to/projects/proj-b/AGENTS.md
  DRY-RUN: would update /path/to/projects/proj-b/AGENTS.md from source
  (AGENTS.md sync)
  ai-customization.md: creating with default configuration
----------------------------------------------------------------------------
Target: /path/to/projects/proj-a/AGENTS.md
  DRY-RUN: would update /path/to/projects/proj-a/AGENTS.md from source
  (AGENTS.md sync)
  ai-customization.md: updating workflow directory path (was: /home/user/Projects/Personal/Simple-AI-Workflow/)
----------------------------------------------------------------------------
Done.
```

The real run performs the same actions without the `DRY-RUN` prefix.

## Notes

- Prefer `pwsh` (PowerShell Core) for cross-platform execution.

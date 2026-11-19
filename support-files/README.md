# Support files

Optional helper scripts that sync `AGENTS.md`, back up project AI state, and check the protocol. None of them is required; the AI boot works without them.

## Sync AGENTS.md scripts

Optional helper scripts that propagate the canonical `AGENTS.md` into your project directories, and make sure each project has a correctly configured `ai-customization.md` at its project root. They also migrate the old `ai/ai-customization.md` location when they find one.

- `sync-agents-md.sh`: Bash script for Linux, macOS, and Git Bash (POSIX environments).
- `sync-agents-md.ps1`: PowerShell script for Windows (works with `powershell` or `pwsh`).

These scripts are optional. You can copy `AGENTS.md` and `ai-customization.md` yourself with CLI commands or a GUI file manager. However, a manual copy updates only the `AGENTS.md` half: the scripts also check or create `ai-customization.md` and migrate state files, so use the scripts for updates.

### Usage

Bash:

```bash
./sync-agents-md.sh --source /path/to/AGENTS.md --target-path /search/path --dry-run
```

PowerShell:

```powershell
./sync-agents-md.ps1 -Source "C:\path\to\AGENTS.md" -TargetPath "C:\projects" -WhatIf
```

### Behavior

- Copies the canonical `AGENTS.md` into every project under the target path that has an `AGENTS.md`. It compares contents first, so unchanged files are skipped.
- Excludes the workflow clone itself, including its own `AGENTS.md` and any nested files.
- Processes each target independently. A failed target is reported, the remaining targets still run, and the script exits non-zero at the end.
- For each project, ensures `ai-customization.md` exists at the project root with a `## AI Workflow Configuration` section, and points `**Global AI Workflow Directory**` at the current clone.
- Migrates the old layout: an `ai/ai-customization.md` is moved to the project root. If the root `ai-customization.md` is a symlink to it, the link is kept and the real file is edited in place.
- Supports a dry run (`--dry-run` or `-WhatIf`) that reports what it would change without writing.

### Argument notes

- `sync-agents-md.sh` accepts `--source` and `--target-path` in either order.
- `sync-agents-md.ps1` uses named parameters, so ordering does not matter.

### Safety

- Run the dry run first to verify what will change.
- On Windows, the PowerShell execution policy may block the script. Run it with a one-time bypass, or set `-Scope CurrentUser RemoteSigned` if you trust the source.

### Example (Bash dry run)

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
Processed 2 target(s); 0 failed.
Done.
```

The real run performs the same actions without the `DRY-RUN` prefix.

### Notes

- Prefer `pwsh` (PowerShell Core) for cross-platform execution.

## Out-of-band backup scripts

- `backup-ai.sh`: Bash script for Linux, macOS, and Git Bash.
- `backup-ai.ps1`: PowerShell 7 script for Windows.

They back up project AI state without an AI assistant. Use them when the assistant is broken, or when you want one sweep across many projects. The interactive `"backup ai"` command remains the in-session backup for the current project.

A project is a directory with `ai-customization.md`, or with `ai/state/` and `ai/shared/`. The workflow clone itself is skipped.

### Usage

Bash:

```bash
./backup-ai.sh --target-path ~/Projects --backup-dir ~/backups --dry-run
./backup-ai.sh --target-path ~/Projects
```

PowerShell:

```powershell
./backup-ai.ps1 -TargetPath C:\Users\me\Projects -BackupDir D:\backups -WhatIf
./backup-ai.ps1 -TargetPath C:\Users\me\Projects
```

### Options

Bash:

- `--target-path PATH`: the directory to search. Required.
- `--backup-dir PATH`: where the archives go. Defaults to `$HOME/.ai/backups`.
- `--exclude-secrets`: leave `ai/secrets/` out of the archive.
- `--dry-run`: list the projects and archive names, write nothing.
- `-h`, `--help`: show the help.

PowerShell:

- `-TargetPath`: the directory to search. Required.
- `-BackupDir`: where the archives go. Defaults to `$HOME/.ai/backups`.
- `-ExcludeSecrets`: leave `ai/secrets/` out of the archive.
- `-WhatIf`: list the projects and archive names, write nothing.

### Behavior

- Finds every project under the search path and writes one archive per project.
- Skips the workflow clone, does not descend into `.git`, and does not rescan inside a project it already found.
- Names the archive `<parent>_<project>_<date>_<HH-MM>.tar.gz`. Characters outside letters, digits, dots, hyphens, and underscores become `_`.
- Never overwrites. An existing name fails that project and the run continues.
- Creates the default backup directory with a message when it is missing. A dry run does not create it.
- Processes each project on its own. A failed project is reported, the others still run, and the script exits non-zero.
- Exit codes: `0` all projects backed up, `1` one or more projects failed, `2` bad arguments, an unreadable search path, or a partial discovery failure.

### Archive and restore

The archive holds `ai/...` and `ai-customization.md` relative to the project root. The Bash script dereferences a symlinked `ai-customization.md`, so the archive holds the file content. The PowerShell script copies the link target on a best-effort basis.

```bash
cd /path/to/project
tar -xzf /path/to/Projects_app_2026-01-31_09-30.tar.gz
```

### Safety

- Secrets are included by default, because the project needs them to work. Use `--exclude-secrets` or `-ExcludeSecrets` when you do not want them.
- Archives are created readable by the owner only on POSIX. On Windows the script applies an owner-only ACL when it can.
- The archive directory keeps its own permissions; only the archives are forced to owner-only. Keep the default directory in a private location.
- A `.tar.gz` is not encrypted. When it holds secrets, copy it only to a location you trust.
- Run the dry run first.

### Example (Bash dry run)

```text
$ ./backup-ai.sh --target-path ~/Projects --dry-run
DRY-RUN: would archive /home/me/Projects/app -> /home/me/.ai/backups/Projects_app_2026-01-31_09-30.tar.gz
DRY-RUN: would archive /home/me/Projects/site -> /home/me/.ai/backups/Projects_site_2026-01-31_09-30.tar.gz
```

### Notes

- `backup-ai.ps1` needs `pwsh` 7 or later and the `tar.exe` that Windows ships.
- The interactive Windows backup writes `.zip`; these scripts write `.tar.gz` on every platform, so one restore command works everywhere.

## Optional protocol index tool

- The boot builds the index with the assistant's built-in reader, glob, and search. It does not run a script and reports `index-source=builtin`.
- `index-protocol.sh` is an optional maintainer tool for exact duplicate and overlap checks and release verification. It calls `validate-policy-authoring.sh --index`, sets `effective` and `conflict`, and writes no file. The sync scripts do not copy it; it ships with the workflow clone.
- Process creation is slow on Windows Git Bash, which is why the boot does not call the helper. A manual run uses `timeout 20 bash support-files/index-protocol.sh`.
- `index-protocol-contract.md` records the line format and the optional-helper behavior.

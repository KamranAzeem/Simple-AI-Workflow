# Plan: Configurable Global User AI Directory, Early Settings, and Default Shell

## Evidence

- The config ticket: `ai/issues/open/configurable-global-user-ai-directory-early-settings-and-shell.md`.
- The user settled the design on 2026-11-19: the rename to `Default Shell`; the customization carries `Global User AI Directory` and `Default Shell`; the global settings carry `Default Shell Path`; the whole settings directory is read early, after the customization; the sync keeps `## Merge Policy` and adds no new keys; the config ticket owns the bootstrap change; the user-global skills root is a separate ticket.
- The inventory: 39 hardcoded global-path references in 13 files. The historical `docs/announcements/v5.4.0.md` is excluded. The live set is the README, the setup and customization docs, the guide, the workflow guide, the collaboration doc, the runbook, the compared doc, the slides, the knowledge policy and repair procedure, the validator, and the two tests. The sync scripts and the global settings template are included.
- The validator hardcodes `GLOBAL_DIR="$HOME/.ai"` (`support-files/validate-protocol.sh:149`) and `BACKUP_DIR="$GLOBAL_DIR/backups"` (`:416`).
- GitHub #9: the shell preference is read too late; the config ticket absorbs it.
- `ai/issues/open/bootstrap-global-settings-file.md`: the bootstrap creates the global directory and the starter settings; the config ticket owns that change.
- The ADR and the user's 2026-11-19 correction: `design-docs/protocol-decisions.md` (1,142 lines) read in full; the developer-mode ADR entry is part of the change, confirmed by the plan and implement approval; no trigger.
- Files read: `ai-customization.md`, `~/.ai/settings/global-user-settings.md`, `ai/procedures/load-context.md`, `ai/procedures/create-backup.md`, `ai/procedures/bootstrap-project.md`, `support-files/validate-protocol.sh`, `support-files/sync-agents-md.sh`, `tests/test-load-context-boot.sh`, the config ticket, GitHub #9, and the bootstrap ticket.

## HLD

### Layers

- `ai-customization.md`, `## AI Workflow Configuration`: `Global AI Workflow Directory` (existing), `Global User AI Directory` (new, default `[HOME]/.ai/`), `Default Shell` (new, optional, one of `bash`, `zsh`, `pwsh`, `git-bash`).
- Global settings directory `(Global User AI Directory)/settings/`: the user's settings files; one carries `Default Shell Path`, the OS/FS native path for the shell named in the customization.
- The boot: read the customization first (workflow directory, user directory, shell name), then the whole settings directory (the shell path and the other settings), before the first shell command; the state, checkpoint, and coordination stay late.
- The sync: add or fix only `Global AI Workflow Directory`; keep `## Merge Policy`; verify `Global User AI Directory` when present; add no new keys.
- The bootstrap: create the configured user directory with `settings/`, `global-knowledge/`, and `backups/`, and the starter settings.
- The validator and backup: default and configured directory; quoted paths.

### Resolvers

- User directory: the customization key, default `[HOME]/.ai/`; resolve `[HOME]`/`%USERPROFILE%`.
- Shell: the name from the customization; the path from the settings; the path wins, then the name in `PATH`, then the current behavior; `git-bash` resolves to a Git for Windows `bash.exe` or `bash` in `PATH`; a name and path mismatch stops and reports; a missing shell stops and reports.
- Global paths: settings, knowledge, and backups derive from the user directory.

### No breaking changes

- The default directory stays `[HOME]/.ai/`.
- Absent keys keep the current behavior.
- The settings are read earlier with the same content, so the result is the same, only before the first command.
- The sync keeps its current behavior and adds nothing new.

## LLD

### Keys and values

- `**Global User AI Directory**: [HOME]/.ai/` (a path, with `[HOME]` or `%USERPROFILE%`; resolve to an absolute path).
- `**Default Shell**: bash` (optional; the allowed values are `bash`, `zsh`, `pwsh`, `git-bash`; an unknown value stops and reports).
- The settings `**Default Shell Path**: <native path>` (optional; the path for the named shell).

### Boot order

- Read `ai-customization.md` first: the workflow directory, the user directory, and the shell name.
- Then read the whole settings directory: the shell path and the other settings.
- Then run the first shell command.
- The current STEP-LOADING reads the customization and the settings late; both move early in this order.
- The boot scan, the shell commands, and the shell resolution follow the early read.
- The state, checkpoint, and coordination stay in the later loading step.
- The proof-of-load reports the settings file count, the policy count, and the shell resolution.
- The settings directory is read once; the later step does not read it again.

### Shell resolution

- Resolve the name from the customization.
- If `Default Shell Path` is set, use it; validate that it exists and matches the named shell; stop on a mismatch or a missing path.
- Otherwise find the name in `PATH`; for `git-bash`, find a Git for Windows `bash.exe` or `bash`.
- If no shell is found, stop and report.
- If no `Default Shell` is set, keep the current behavior.

### Sync

- Bash and PowerShell parity.
- Add or fix only `Global AI Workflow Directory`.
- Keep `## Merge Policy`.
- Verify `Global User AI Directory` when present; report a missing path; create nothing.
- Add no new keys.
- Tests for the verification and the unchanged behavior.

### Bootstrap

- Read the configured `Global User AI Directory`.
- Create the directory with `settings/`, `global-knowledge/`, and `backups/`.
- Write the starter settings.
- Keep the default when the key is absent.

### Validator and backup

- `GLOBAL_DIR` defaults to `[HOME]/.ai/` and reads the customization key when present.
- The backup directory derives from the configured directory.
- The create-backup procedure carries the native commands with quoted paths for both OS families.
- The spaced-path test backs up and restores a path with spaces.

### Docs and tests

- Update the live set; exclude the historical announcements.
- Document the three keys, the four values, the `git-bash` path, the no-key behavior, and the early settings read.
- Test the config resolution, the shell name and path, the mismatch, the `git-bash` PATH lookup, the no-key defaults, the sync verification, the bootstrap, the spaced path, the validator default, and the suite.

## Risks

- The early read changes the boot order; the proof-of-load and the suite must show the same settings content.
- The shell path and `PATH` resolution has OS differences; the tests must cover Linux and Windows path shapes.
- The sync behavior must stay unchanged except for the user-directory verification.
- The existing users must keep the default and current shell behavior.
- The docs inventory must exclude the historical announcements and include the slides and the compared page.

## Acceptance criteria

- The default directory is `[HOME]/.ai/`; absent keys keep the current behavior.
- The customization accepts the three keys and the four shell values.
- The boot reads the whole settings directory before the first shell command and uses the named shell.
- The `Default Shell Path` is the native path; the mismatch and missing cases stop and report.
- The sync adds or fixes only the workflow directory, keeps `## Merge Policy`, and verifies the user directory when present.
- The bootstrap creates the configured directory and the starter settings.
- The validator defaults to `[HOME]/.ai/` and reads the key when present.
- The backup commands quote every path; the spaced-path test passes.
- The live docs are updated; the historical announcements are untouched.
- The protocol validator, the authoring validator, the suite, markdownlint, and shellcheck pass.
- GitHub #9 is closed as absorbed.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`
- Base: `master`
- Branch: `feature/configurable-global-user-ai-directory`, opened at implementation
- Ticket: `ai/issues/open/configurable-global-user-ai-directory-early-settings-and-shell.md`; move to `in-progress/` at implementation; close on the branch with the plan attached
- Merge: direct (no `## Merge Policy`; default direct); one squash commit
- ADR: the design decisions are added as part of the change, confirmed by the plan and implement approval; no trigger
- Validation: `support-files/validate-protocol.sh`; `support-files/validate-policy-authoring.sh` on the changed policies and procedures; `tests/run-all.sh`; markdownlint-cli2; shellcheck
- Review: implementation peer review; fix Critical and Major; re-review
- Checkpoint: on the branch; remove the next-steps item
- Release: v6.8.0 minor; release note draft-first for approval; tag and GitHub release
- Done: ticket closed with the plan attached; #9 closed as absorbed; branch merged and deleted; master pushed; release published

## Peer Review Log

- Round 1: `ai/code-review-reports/2026-11-19_01-05_review-28.md`; APPROVED; no Critical or Major; one Minor (state that the customization read moves early) adopted.
- 2026-11-19: the user fixed the read order; the customization is read first, then the whole settings directory, then the first shell command.

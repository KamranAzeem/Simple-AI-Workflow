Reported: 2026-11-19
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Make the Global User AI Directory, early settings load, and default shell configurable, and remove hardcoded `$HOME/.ai` and unquoted paths

Description:

**Goal**: one configurable global user directory and an early settings load, so the shell preference and every global path apply before the first boot command.

**Scope**:

- Add `Global User AI Directory` under `## AI Workflow Configuration` in `ai-customization.md`, default `[HOME]/.ai/`. Derive the global settings, knowledge, backups, and other global paths from it.
- Load the global settings before the first shell command, so `Default Shell Interpreter` applies to boot and procedure commands.
- Add `Default Shell Interpreter` to the configuration, with customization precedence, the bash fallback, and the stop-and-report rule when the preferred shell is missing. GitHub #9 owns the shell-timing fix; this ticket links it.
- Quote every path that can contain spaces, starting with the backup command.
- Replace the hardcoded `GLOBAL_DIR="$HOME/.ai"` in `support-files/validate-protocol.sh`; update the sync scripts, tests, and docs.

**Related tickets**:

- GitHub #9: shell preference is read too late.
- `ai/issues/open/bootstrap-global-settings-file.md`: bootstrap creates `~/.ai/` and the starter settings file.

**Constraints**:

- Keep the default `[HOME]/.ai/` behavior for existing users.
- Do not duplicate the shell-timing fix in #9.
- Plan and peer review before implementation.

**Acceptance criteria**:

- A clone with the global directory on a path with spaces boots and runs every command.
- The first boot command runs after the global settings load and uses the configured shell.
- No hardcoded `$HOME/.ai` remains in the validator, scripts, tests, or docs.
- Changing `Global User AI Directory` moves every global path with no other edits.
- The protocol validator, the authoring validator, the test suite, markdownlint, and shellcheck pass.

**Open questions for the plan**: resolved in `ai/plans/configurable-global-user-ai-directory-early-settings-and-shell.md`.

---
2026-11-19
Plan: `ai/plans/configurable-global-user-ai-directory-early-settings-and-shell.md`. Review-28 APPROVED.

Close note: the user renamed `Default Shell Interpreter` to `Default Shell` and moved the native path to `Default Shell Path` in the global settings. The plan records the settled design.

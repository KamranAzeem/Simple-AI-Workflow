# Protocol verification toolchain

How to verify this repo (the Simple-AI-Workflow protocol) after a change. Run every command from the project root. Recorded 2026-10-13; refreshed 2026-10-18.

## Commands

- Protocol validator: `bash support-files/validate-protocol.sh`. Runs eight checks: the AGENTS.md hardening anchors, the configuration mapping, the global and project AI directory structure, the coordination board, the 17-policy baseline, the `.gitignore` safety, and the checkpoint/backup cycle. Expect `Protocol Validation v6.1 Completed Successfully` and 8/8.
- Authoring validator: `./support-files/validate-policy-authoring.sh <file> [<file>...]`. Checks the authoring shape of changed `AGENTS.md` and policy files: the guard, marker order, title, purpose line, `## Scope`, `## References`, domain sections, procedure metadata, trigger uniqueness, and the `## Triggers` reservation. Expect `PASSED`.
- Reference test: `bash support-files/test-protocol-references.sh`. Confirms every procedure, step, tier, and Proof-of-Load item reference resolves, and that no letter or number references remain. The script is not executable, so invoke it with `bash`. Expect `PASS` plus a definition count (11 procedures, 79 steps, 4 tiers, 9 items at v6.1).
- Markdown lint: `markdownlint-cli2 "**/*.md" "#node_modules"`. The reference config is `.markdownlint-cli2.jsonc`. Expect `0 issues`. On this machine the binary lives at `~/.nvm/versions/node/v24.19.0/bin/markdownlint-cli2` (machine-specific; use `markdownlint-cli2` from `PATH` where available).

## Lint scope

`.markdownlint-cli2.jsonc` ignores four local or archival directories, so the lint covers the living set only:

- `ai/secrets/**` (local credentials)
- `ai/code-review-reports/**` (session-local review reports)
- `ai/artifacts/**` (local report artifacts)
- `ai/daily-checkpoints/**` (the diary)

Everything else is linted, including `ai/issues/**` and `ai/state/**`.

## Lesson (2026-10-13)

Lint every new markdown file before committing it, not only the files you edited. Three tickets created in one session were committed with an MD032 error (a list directly after `Acceptance criteria:` with no blank line) because only the edited policy and docs files were linted. Write the blank line between a lead-in line and a list.

## Lesson (2026-10-18)

- The authoring validator's `# AI Assistant Policy:` title exception applies only to `ai-policy-common.md`; every other policy uses `# AI Policy: <Domain>`.
- A `## Triggers` section is reserved for the plugin model and is rejected until that model lands.
- `shellcheck` is not installed on this machine; use `bash -n` for syntax checks and note the missing linter.
- The repo has `core.fileMode=false`. After `chmod +x`, record the executable bit with `git update-index --chmod=+x <file>`; otherwise the commit records `100644`.

## Related

- `.markdownlint-cli2.jsonc` and the `Markdown Output` section of `ai/policies/ai-policy-common.md` are the source of truth for the rules.
- `ai/policies/ai-policy-meta.md` (`## Procedure and Policy Authoring`) owns the authoring standard.
- `support-files/validate-policy-authoring.sh` checks changed policy files and `AGENTS.md`.
- `ai/shared/coordination.md` and `ai/state/context.md` carry the current status.

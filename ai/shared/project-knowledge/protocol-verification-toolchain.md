# Protocol verification toolchain

How to verify this repo (the Simple-AI-Workflow protocol) after a change. Run every command from the project root. Recorded 2026-10-13; counts refreshed 2026-10-16.

## Commands

- Protocol validator: `bash support-files/validate-protocol.sh`. Runs eight checks: the AGENTS.md hardening anchors, the configuration mapping, the global and project AI directory structure, the coordination board, the 17-policy baseline, the `.gitignore` safety, and the checkpoint/backup cycle. Expect `Protocol Validation v6.1 Completed Successfully` and 8/8.
- Reference test: `bash support-files/test-protocol-references.sh`. Confirms every procedure, step, tier, and Proof-of-Load item reference resolves, and that no letter or number references remain. Expect `PASS` plus a definition count (11 procedures, 79 steps, 4 tiers, 9 items at v6.1).
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

## Related

- `.markdownlint-cli2.jsonc` and the `Markdown Output` section of `ai/policies/ai-policy-common.md` are the source of truth for the rules.
- `ai/shared/coordination.md` and `ai/state/context.md` carry the current status.

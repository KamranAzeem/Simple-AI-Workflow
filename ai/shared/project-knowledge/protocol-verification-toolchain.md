> **Knowledge file.** Follow `ai-policy-common.md`, section `## Knowledge File Standards`. This header is canonical: copy it verbatim and do not edit it. If it is missing, run `repair knowledge files`.

# Protocol Verification Toolchain

## Context

Run these checks from the project root after a change to the protocol, a policy, or a script. They cover the protocol surface, the authoring shape, reference integrity, and markdown style.

## Rule or Fix

- Run the protocol validator with `bash support-files/validate-protocol.sh`.
- Run the authoring validator on every changed `AGENTS.md` or policy file with `./support-files/validate-policy-authoring.sh <file> [<file>...]`.
- Run the reference test with `bash support-files/test-protocol-references.sh`.
- Run markdownlint with `markdownlint-cli2 "**/*.md" "#node_modules"`.
- Lint every new markdown file, not only the edited files.

## Why

- The protocol validator checks the hardening anchors, configuration, directory structure, board, 18-policy baseline, git safety, and checkpoint cycle.
- The authoring validator checks the guard, marker order, title, purpose, scope, references, procedure metadata, trigger uniqueness, and `## Triggers` reservation.
- The reference test confirms that every procedure, step, tier, and load item resolves.
- Markdownlint catches structural defects before review.

## Verify

- Confirm `Protocol Validation v6.1 Completed Successfully` and 8/8.
- Confirm the authoring validator prints `PASSED`.
- Confirm the reference test prints `PASS` with 12 procedures, 93 steps, 4 tiers, and 9 items.
- Confirm markdownlint reports `0 issues`.

## Caveats

- Lint ignores `ai/secrets/**`, `ai/code-review-reports/**`, `ai/artifacts/**`, and `ai/daily-checkpoints/**`; it covers `ai/issues/**` and `ai/state/**`.
- A list directly after a lead-in line needs a blank line; three tickets were committed with MD032 because only some files were linted. The global `markdown-lint-new-files-before-commit.md` captures the general rule.
- `.markdownlint-cli2.jsonc` and the common policy `Markdown Output` are the source of truth for markdown rules.
- `ai/policies/ai-policy-meta.md` (`## Procedure and Policy Authoring`) owns the authoring standard.
- `support-files/validate-policy-authoring.sh` checks changed policy files and `AGENTS.md`.
- On this machine the markdownlint binary is at `~/.nvm/versions/node/v24.19.0/bin/markdownlint-cli2`; use `markdownlint-cli2` from `PATH` where available.
- The `# AI Assistant Policy:` title exception applies only to `ai-policy-common.md`.
- A `## Triggers` section is reserved until the plugin model lands.
- `shellcheck` is not installed on this machine; use `bash -n` for syntax checks.
- The repo has `core.fileMode=false`; record an executable bit with `git update-index --chmod=+x <file>`.

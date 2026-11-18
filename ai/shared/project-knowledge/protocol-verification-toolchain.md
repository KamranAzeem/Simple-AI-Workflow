> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Protocol Verification Toolchain

## Context

Run these checks from the project root after a change to the protocol, a policy, or a script. They cover the protocol surface, the authoring shape, reference integrity, and markdown style.

## Rule or Fix

- Run the protocol validator with `bash support-files/validate-protocol.sh`.
- Run the authoring validator on every changed `AGENTS.md` or policy file with `./support-files/validate-policy-authoring.sh <file> [<file>...]`.
- Run the reference test with `bash tests/test-protocol-references.sh`.
- Run the knowledge-repair fixture with `bash tests/test-knowledge-repair-fixture.sh --all`.
- Run the skills fixture with `bash tests/test-skills-index.sh`.
- Run the trigger fixture with `bash tests/test-trigger-rules.sh`.
- Run the boot fixture with `bash tests/test-load-context-boot.sh`.
- Run the sync fixture with `bash tests/test-sync-agents-md.sh`.
- Run the outbound content scrub fixture with `bash tests/test-outbound-content-scrub.sh`.
- Run the handoff fixture with `bash tests/test-create-handoff.sh`.
- Run the policy loading fixture with `bash tests/test-policy-load-paths.sh`.
- Run the policy shape wrapper with `bash tests/test-policy-shape.sh`.
- Run the common-boundary fixture with `bash tests/test-common-boundary.sh`.
- Run the full dev suite with `bash tests/run-all.sh`.
- Run markdownlint with `markdownlint-cli2 "**/*.md" "#node_modules"`.
- Lint every new markdown file, not only the edited files.

## Why

- The protocol validator checks the hardening anchors, configuration, directory structure, board, a policy directory scan with a floor of 23, the knowledge anchors and legacy-phrase guard, the skills keys and anchors, git safety, and checkpoint cycle.
- The authoring validator checks the guard, marker order, title, purpose, scope, references, procedure metadata, trigger uniqueness, `## Triggers` shape, and the optional `## Loading` contract; it permits only the two shared steps in the thin `AGENTS.md`. It ignores heading-like lines inside fenced code blocks when it builds the index and checks the policy and procedure shape.
- The loading contract has four modes: `boot`, `trigger`, `procedure`, and `expertise`. One path per policy; a non-trigger mode forbids triggers; `Load in:` takes the lowercase procedure file stem. An absent `## Loading` keeps the legacy load. The declaration governs global policies; a project policy keeps the legacy boot load. The validator checks syntax and placement; the fixture resolves every declared path.
- The index oracle prints the declared loading mode and the scope (`global` or `project`).
- The common policy is the invariant layer: outside the canonical state-file header blocks it names no policy file, its References lists only `AGENTS.md` and the procedure layer, and its title is `# AI Policy: Common Guardrails`. A plug-in may reference the common policy; the reverse is forbidden.
- The outbound content scrub is the first extracted plug-in: `ai-policy-outbound-content-scrub.md`, trigger `outbound content scrub`, `Mode: trigger`, loaded explicitly by MANAGE-ISSUES, IMPLEMENT-PLAN, and CREATE-HANDOFF. The common policy keeps the heading and the generic invariant.
- The knowledge protocols and file standards are `ai-policy-knowledge.md`, trigger `knowledge file standards`, `Mode: trigger`, loaded explicitly by LOAD-CONTEXT, WRITE-CHECKPOINT, and REPAIR-KNOWLEDGE-FILES. The common policy keeps the settings full load, the boot index invariant, and the contract pointer.
- The issue rules are `ai-policy-issue-management.md`, triggers `issue standards` and `ticket standards`, `Mode: trigger`, loaded explicitly by MANAGE-ISSUES and IMPLEMENT-PLAN. The common policy keeps the issue invariant; the load-context template creation loads the plug-in only when the template is missing.
- The design rules are merged into `ai-policy-design-docs.md`, `Mode: procedure`, `Load in: update-design-docs`; the update and migrate procedures, MANAGE-ISSUES planning, and IMPLEMENT-PLAN preflight load it. The common policy keeps the design invariant and the Pre-Work Gate points at the contract.
- The thinking modes are `ai-policy-thinking-modes.md`, triggers `grill me` and `brainstorm`, `Mode: trigger`, loaded explicitly by MANAGE-ISSUES planning and IMPLEMENT-PLAN preflight. The common policy keeps the thinking-modes invariant and the Pre-Work Gate points at the contract.
- The legacy rewrites declare `Mode: expertise` and add an anchor fixture; Linux, accounting, career, Windows, and academic are done, and `tests/test-linux-policy.sh`, `tests/test-accounting-policy.sh`, `tests/test-career-policy.sh`, `tests/test-windows-policy.sh`, and `tests/test-academic-policy.sh` pin their loading and key rules. The five legacy children are complete; the coding-baseline standards stay in the common policy, and that unit is resolved.
- The reference test confirms that every procedure, step, tier, and load item resolves, and that the work-item order appears only in `AGENTS.md`.
- The skills fixture checks the two roots, the package and frontmatter, the one-level rule, hidden and symlink skip, the project override, the collision report, the 200-character description, the no-body rule, and the 16 KB bound.
- Markdownlint catches structural defects before review.
- The user docs drift when a unit adds a policy, procedure, fixture, or trigger; the README, the slides, the validation doc, and the compared doc are the drift points.

## Verify

- Confirm `Protocol Validation v6.3 Completed Successfully` and 8/8.
- Confirm the authoring validator prints `PASSED`.
- Confirm the reference test prints `PASS` with 14 procedures, 108 steps, 4 tiers, and 12 items.
- Confirm the knowledge-repair fixture prints `PASS`.
- Confirm the outbound content scrub fixture prints `PASSED`.
- Confirm the handoff fixture prints `PASSED`.
- Confirm the skills fixture prints `PASSED`.
- Confirm the boot fixture prints `PASSED`.
- Confirm the loader fixture prints `PASSED`, the shape wrapper prints `PASSED`, and the boundary fixture prints `PASSED`.
- Confirm the trigger fixture prints `PASS`.
- Confirm markdownlint reports `0 issues`.
- Confirm the user docs counts: 23 policies (12 domain and 11 protocol), 14 procedures, 20 test scripts, 47 triggers, and the floor of 23.

## Caveats

- Lint ignores secrets, review reports, artifacts, and the daily checkpoint diary; it covers the issue and state trees.
- A list directly after a lead-in line needs a blank line; three tickets were committed with MD032 because only some files were linted.
- On this machine the markdownlint binary is at `~/.nvm/versions/node/v24.19.0/bin/markdownlint-cli2`; use `markdownlint-cli2` from `PATH` where available.
- The `## Triggers` section is live for policies and procedure modules; the plugin model landed.
- The `## Loading` section is live for policies; specs are separate acceptance contracts, not design documents.
- `shellcheck` is installed at `/usr/bin/shellcheck`; run it on changed shell scripts.
- The repo has `core.fileMode=false`; record an executable bit with `git update-index --chmod=+x <file>`.

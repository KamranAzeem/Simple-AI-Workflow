Reported: 2026-11-23
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Add a sync-script --init mode that scaffolds a project from a policy and trait selection

Description:
Extend the sync scripts with an `--init` mode that treats a target directory as a new project root.

Proposed behavior:

- Accept a target directory, a list of policies or expertise domains, and an active trait or traits.
- Copy `AGENTS.md` into the target and copy a matching `ai-customization.md` preset from the docs or examples tree.
- Set the selected Active Expertise and Traits, and leave the rest ready for the user to adjust.
- Do not run bootstrap or load context; the user starts an AI session in the target and bootstraps there.
- Work in both `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1`, with parity, dry-run behavior, idempotence, and clear failure messages.

Preset dependency:

- The preconfigured customization variants are already tracked in `ai/issues/open/customization-presets-per-role.md`; this ticket consumes them and does not duplicate the role content.
- Add the preset mapping only after that ticket settles the role list and contents.

Open questions:

- CLI shape: `--init <target> --policy cloud --trait ...`, or a named preset?
- Must the target be empty? What happens on an existing non-empty directory?
- Copy or symlink the two root files?
- Is `AGENTS.md` copied from the workflow clone root?
- Does `--init` select a preset, or build a customization from policy and trait flags?
- Which docs page explains the new path?

Acceptance criteria:

- `--init` on a temporary target creates `AGENTS.md` and `ai-customization.md` with the selected Active Expertise and Traits.
- A dry run writes nothing and lists the planned actions.
- Bash and PowerShell parity; tests cover success, an existing target, a dry run, a missing preset, and an invalid policy.
- The docs explain how to pick a preset and adjust it.
- No new policy or procedure is required unless the implementation proves one is needed.

---

2026-11-25

## Sync and init behavior

The sync and init split is confirmed. Sync reconciles an initialized project and runs any needed migration. Init creates a new project from a preset.

Decisions:

- Sync has no `--migrate` flag. It performs the migration automatically when it detects an old layout. Report every move, keep the operation idempotent, support `--dry-run`, and back up a store before moving it.
- Sync is for initialized projects. A project is initialized when it has `AGENTS.md` and `ai-customization.md`; `ai/` is not required.
- A project with only one of the two root files is uninitialized. Sync reports it and does not modify it. Init does not fill the missing file.
- Target semantics: process the initialized projects, report the uninitialized ones, and refuse only when the tree contains none. A single uninitialized target gets the `--init` hint.
- `--init` takes a role switch and selects a preset from `customization-presets-per-role.md`. Proposed CLI: `--init --target-path <dir> --role <preset>`.
- Init target: a directory with neither `AGENTS.md` nor `ai-customization.md`. It may contain other files and subdirectories. Init writes only the two root files and ignores every subdirectory.
- `--init` copies `AGENTS.md` from the workflow clone root and writes `ai-customization.md` from the preset. It creates no symlinks and does not create `ai/`.
- If either root file exists, init refuses and does not fill the missing one.
- An unknown role lists the available presets and exits non-zero.
- Remove the legacy root `ai-customization.md` symlink handling from both sync scripts. Do not preserve or write through a symlink.
- Presets are not ready. Init waits for `customization-presets-per-role.md` to settle the role list and contents. Sequence: scope naming, presets, init.
- Job manifest: use a sibling TSV under `support-files/` with a fixed verb set (`copy`, `move`, `ensure-section`, `replace-key`) and rows `verb|when|from|to`. Both scripts parse the same file. It carries the migration path map, key renames, and preset names. No arbitrary shell commands. Validate it as a protocol artifact.

Open points:

- Exit codes and the exact refusal message.
- The role switch name (`--role` or `--expertise`) and the preset names.
- The docs page that explains the init path.

Answers to the original open questions:

- CLI shape: a named preset selected by the role switch, not separate policy and trait flags.
- Copy or symlink: copy.
- `AGENTS.md` source: the workflow clone root.
- Preset selection: yes, one preset per role.
- Target emptiness: not required. Init requires that neither root file exists, allows other files and subdirectories, and writes only the two root files.
- Docs page: still open.

Updated acceptance criteria:

- Sync performs migrations automatically and has no `--migrate`.
- Sync processes the initialized projects, reports the uninitialized ones, and refuses only when the tree contains none. A project is initialized when it has `AGENTS.md` and `ai-customization.md`; `ai/` is not required.
- `--init --role <preset>` creates `AGENTS.md` and `ai-customization.md` only when neither root file exists, with no symlinks. It ignores subdirectories, does not create `ai/`, and refuses when either root file exists.
- Both scripts read the same `support-files/` TSV job manifest with the fixed verb set; the schema is validated and no arbitrary shell command is allowed.
- An unknown role lists the presets and fails.
- Bash and PowerShell parity, dry-run, idempotence, and tests for success, partial targets, uninitialized refusal, missing preset, and invalid role.
- The sync scripts no longer preserve or write through a root `ai-customization.md` symlink.
- The docs explain sync, init, and preset selection.

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

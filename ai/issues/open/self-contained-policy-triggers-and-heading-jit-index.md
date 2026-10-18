Reported: 2026-10-18
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Make policies self-contained trigger plugins and index their headings for JIT discovery

Description:

## Problem

Triggers are registered in `AGENTS.md`, so every new policy or procedure needs a matching edit there. The policy is not self-sustained, and the trigger list lives in two places. The AI also indexes policy filenames only, not the headings inside them, so it can miss the right policy or trigger.

## Required behavior

- A policy declares its own trigger phrases, scope, and loading rules.
- Adding a policy requires no edit to `AGENTS.md`.
- A generic dispatcher discovers the declarations and loads the right policy.
- Boot, recovery, and load context index policy headings (for example `grep '^#' <policy-file>`) next to the filename, so the AI can match a user phrase to a trigger and a policy.
- Always-on rules and the read-first-rules tier stay unchanged.
- Stable all-caps procedure names, validator anchors, and the reference-integrity test keep working.

## Open decisions

- What is the declaration shape: a fixed `## Triggers` block, a metadata block, or a heading convention?
- Is the heading index built for every policy at boot, or only for the active expertise and the project policy directory?
- How does discovery interact with the Protocol Developer Mode exception that skips the recursive policy scan?
- Does this replace the triggered-procedure tier in `AGENTS.md`, or coexist with it during a migration?
- How do validator anchors work when a procedure definition moves out of `AGENTS.md`?
- How is the heading index bounded for a large policy set?
- Is this sequenced before or after `policies-to-skills-rename.md`?

## Acceptance criteria

- Adding a new policy needs no `AGENTS.md` edit.
- The AI resolves a trigger phrase to the correct policy from the policy's own declaration.
- Load context, recovery, and checkpoint re-affirmation report a policy heading index.
- Existing procedures still work; validator and reference-integrity test stay green.
- Docs describe the plugin model and the migration path.

## Notes

- This is a later-stage architectural change. The authoring standard ticket is a prerequisite for a consistent declaration shape.
- Related: `policies-to-skills-rename.md` (naming and directory change), `procedure-e-precedence-rework.md`, `protocol-design-docs.md`.
- Existing decisions to reconcile: the 2026-08-31 router model, the 2026-10-06 stable procedure names, and the 2026-08-22 Protocol Developer Mode scan exception.

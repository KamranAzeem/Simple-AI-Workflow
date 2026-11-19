Reported: 2026-10-06
Reporter: Kamran Azeem (via Kilo)
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P4)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Decommission the Cline provider setup and replace it with Kilo Code documentation.

Description:

## Request

Replace the Cline provider guidance with Kilo Code guidance. This includes `docs/vscode-cline-provider-setup-for-beginners.md` and any references to it from `README.md` and other docs.

## To investigate before scoping

- Which docs reference Cline (the setup-for-beginners guide, README docs list, provider selection guide).
- Whether it is a rename plus rewrite, or a new guide with the old one removed.
- Any provider-specific screenshots, steps, or config that do not carry over to Kilo Code.

Filed for later; not started.

## Merged scope (2026-11-19)

Absorbed `kilo-code-documentation.md`. Add the Kilo Code facts to `docs/post-compaction-reload-trigger-setup.md` and `ai/shared/project-knowledge/compaction-trigger-problem.md`: AGENTS.md is always-on in Kilo, the compaction summary is visible in chat, the human backstop is sufficient, and no slash command or new files are needed. The KiloCode row exists at `docs/post-compaction-reload-trigger-setup.md:72` but lacks those facts.

Additional live Cline references: `README.md:473`, `docs/example-learning-session-runbook.md:15-18`, and `docs/ai-provider-selection-guide.md:3,118`.

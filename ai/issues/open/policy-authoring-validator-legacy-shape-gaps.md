Reported: 2026-11-09
Reporter: Kamran Azeem
IssueType: Bug
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Fix five shipped policy shape failures and two authoring-validator gaps

Description:

The authoring validator fails five shipped policies for a missing `# AI Policy:` title or a missing `## References` section: `ai-policy-academic-researcher.md`, `ai-policy-accounting.md`, `ai-policy-career-coaching.md`, `ai-policy-linux-system-admin.md`, and `ai-policy-windows-system-admin.md`. It also accepts more than one `**Aliases**` line per procedure.

Stage 1 added a `--triggers` mode so the trigger namespace check could run over the full policy set without being blocked by these pre-existing shape gaps.

Scope:

- Fix the title and `## References` shape for the five named policies.
- Reject more than one `**Aliases**` line per procedure.
- Add fixture coverage for both.
- Keep the trigger namespace rules unchanged.

Related: `ai/issues/in-progress/policy-plugin-v0-trigger-dispatch.md`, `design-docs/protocol-decisions.md`.

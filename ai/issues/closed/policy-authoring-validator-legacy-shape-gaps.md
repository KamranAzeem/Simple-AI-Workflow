Reported: 2026-11-09
Reporter: Kamran Azeem
IssueType: Bug
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Fix five shipped policy shape failures

Description:

The authoring validator fails five shipped policies for a missing `# AI Policy:` title or a missing `## References` section: `ai-policy-academic-researcher.md`, `ai-policy-accounting.md`, `ai-policy-career-coaching.md`, `ai-policy-linux-system-admin.md`, and `ai-policy-windows-system-admin.md`.

The `--triggers` mode lets the trigger namespace check run over the full policy set without being blocked by these pre-existing shape gaps.

Scope:

- Fix the title and `## References` shape for the five named policies.
- Add fixture coverage for the five shape failures.
- Keep the trigger namespace rules unchanged.

Related: `ai/issues/closed/policy-plugin-v0-trigger-dispatch.md`, `design-docs/protocol-decisions.md`.

Status: Fixed 2026-11-09. The five titles use `# AI Policy: <Domain>` with a one-line purpose; the three missing `## References` sections are added; the fixture covers the old title, the missing references, and the missing purpose. The default authoring run reports zero failures and `--index` reports zero errors. Merged to `master` in the `fix/policy-shape-legacy` squash commit. No release was made in this work item.

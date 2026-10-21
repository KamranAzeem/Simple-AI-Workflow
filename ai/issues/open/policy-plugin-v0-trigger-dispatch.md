Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Implement the minimal policy plugin v0 (trigger declaration, indexing, dispatch)

Description:

The coding baseline policy is complete, but the plugin mechanism that lets a policy declare its own trigger phrases is still missing. This ticket carries that remaining work, split out of `code-authoring-policy-and-policy-plugin.md` so the policy deliverable can close.

Scope:

- A policy declares its own trigger phrases in a `## Triggers` section.
- Boot, post-compaction recovery, and checkpoint re-affirmation index only policy filenames and trigger lines, never the body.
- A declared phrase loads that policy in full for the session.
- A policy without `## Triggers` keeps today's behavior.
- The authoring validator currently rejects `## Triggers`; the plugin lands with the validator update and the `AGENTS.md` dispatch.
- The broad ticket `self-contained-policy-triggers-and-heading-jit-index.md` remains the later architectural change.

Related: `ai/issues/open/self-contained-policy-triggers-and-heading-jit-index.md`, `ai/issues/closed/code-authoring-policy-and-policy-plugin.md`, `design-docs/protocol-decisions.md`.

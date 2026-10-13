Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Add a careful, confirmation-gated "update design docs" procedure

Description:

Design documents are sensitive and must stay pure. They hold the design of the application or a component, never operational bookkeeping such as commit hashes or session trivia, and they must not be touched without the user's explicit permission. This is why they are out of scope for the consolidated "checkpoint" (`consolidate-checkpoint-updates-into-one-command.md`).

This ticket adds a standalone `"update design docs"` procedure that:

- Handles design documents only. It never updates project knowledge or global knowledge.
- Finds the design documents wherever they live: `ai/shared/project-knowledge/` (not yet migrated), or `design-docs/` at the project root or in a component or repo subdirectory.
- Proposes every change and waits for the user's explicit confirmation before writing anything.
- Never writes operational bookkeeping (commit hashes, branch names, session trivia) into a design document.

Acceptance criteria:

- A new trigger runs the procedure, and it covers design docs only.
- Every proposed change is confirmed with the user before it is written.
- No operational bookkeeping is ever written into a design document.
- The checkpoint never invokes this procedure.
- Validator green; reference test PASS; ADR entry added; peer review APPROVED.

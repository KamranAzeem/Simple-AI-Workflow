Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Add a read-only Kanban skill that renders the issue directories as a markdown table

Description:

Source: `ai/notes/notes.md` point 3 (2026-11-24).

Goal: show that the protocol supports skills, and give a useful local board. No new policy or procedure.

Decisions:

- Read-only: the skill renders the board and never moves a ticket.
- Package location: a usable package under the protocol skills directory, `ai/skills/kanban-board/`.
- Columns: Open, In progress, Closed, matching the three issue directories.

Scope:

- Add `ai/skills/kanban-board/SKILL.md` with the name, the description, and the rendering instructions.
- The skill instructs the AI to read the current project's `ai/issues/open`, `ai/issues/in-progress`, and `ai/issues/closed`, then print a three-column markdown table in chat. It writes nothing.
- Document the skill in the skills docs and add a slide or appendix line.
- Add a fixture or a test check for the package text and the columns.

Acceptance criteria:

- The package has a valid `SKILL.md` with a name and a description of at most 200 characters.
- The instructions read the three directories and print the table.
- The skill never writes under `ai/issues/`.
- The docs and slides mention the example.
- The skills index and the suite pass.

---
2026-11-24
Plan attached below.

## Implementation Plan

# Plan: Add a read-only Kanban skill

## Evidence

- `ai/notes/notes.md` point 3.
- `ai/issues/in-progress/kanban-example-skill.md`: read-only, `ai/skills/kanban-board/`, columns Open, In progress, Closed.
- The skills root is `ai/skills/`; the package rules are in the common policy and the guide Section 24.

## Context

The skill is a small, self-contained example. It reads the current project's issue directories and prints a table. It never moves or edits a ticket. The goal is both a useful board and a working example of the skills subsystem.

## Acceptance criteria

- AC-1: `ai/skills/kanban-board/SKILL.md` has `name: kanban-board` and a description of at most 200 characters.
- AC-2: The instructions read the current project's `ai/issues/open/`, `in-progress/`, and `closed/` filenames and print a three-column table.
- AC-3: The skill is read-only and never creates, moves, or edits a ticket.
- AC-4: The guide Section 24 documents the example.
- AC-5: The deck appendix mentions the example.
- AC-6: Tests pin the package, the read-only prohibition, the three columns, and the docs and deck mention.
- AC-7: The validator, authoring checks, suite, markdownlint, and shellcheck pass.

## Checks

- `bash tests/test-skills-index.sh`: PASSED.
- `bash tests/test-docs-audit.sh`: PASSED.
- `bash tests/test-slides.sh`: PASSED.
- `bash support-files/validate-protocol.sh`: 8/8.
- `bash tests/run-all.sh`: 31/31.
- `markdownlint-cli2`: 0 issues.
- `shellcheck`: 0 findings.

## Close Sequence

- Repo: this repository.
- Base ref: `master`.
- Branch: `feature/kanban-example-skill`.
- Merge mode: `direct`.
- Ticket: `ai/issues/in-progress/kanban-example-skill.md`; close it with this plan attached.
- Release: none; a documentation and skill example only.
- Evidence: suite, validator, markdownlint, shellcheck.

## Peer Review Log

- Plan review waived by the user's `proceed` instruction; the approved scope is the ticket and this plan.
- Implementation review-98 CHANGES REQUESTED; fixes applied.
- Implementation review-99 APPROVED.

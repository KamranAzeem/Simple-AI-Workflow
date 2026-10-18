Reported: 2026-10-18
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P4)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Add validator checks for banned modals and tables in protocol files

Description:

## Problem

The authoring standard bans soft modals (`should`, `prefer`, `consider`, `try`) and tables in protocol files. These are currently enforced by peer review only. A mechanical check would catch drift earlier.

## Scope

- Check `AGENTS.md` and `ai/policies/*` for banned modals.
- Check `AGENTS.md` and `ai/policies/*` for markdown tables.
- Handle the `may` exception for genuine optional branches without false positives.
- Decide whether issues and plans are in scope, since tables are already banned there by the common policy.
- Run the check as a separate authoring linter, not as part of the 8/8 protocol validator, to avoid failing the existing corpus before migration.

## Acceptance criteria

- A script reports banned modals and tables by file and line.
- The `may` exception is defined and tested.
- The check runs on changed files during peer review.
- The main protocol validator stays green.
- The rule is documented in the authoring standard.

## Notes

- Follow-up to the authoring-standard grilling on 2026-10-18.
- The authoring standard keeps the main validator to structure checks only in this change.

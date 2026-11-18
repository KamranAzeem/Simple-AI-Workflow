<!-- STATE-FILE-HEADER: next-steps.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** open items only, oldest first, one item per line; no commands, implementation steps, investigation notes, or rationale.
- **Delete on done:** remove each item when it is finished; never keep completed items or history.
- **Never drop:** an unfinished item stays until it is done.
- **Brevity:** at most three short bullets per item.
- **Size:** 5 KB soft target. Delete completed items; if open items still exceed the target, keep them and report the overage. Never drop an unfinished item.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: next-steps.md END -->

## Pending

- Complete the v6.6.1 release: merge, tag, publish, and delete the temporary work branch.
- Rewrite the common policy to the authoring prose shape (L).
- Update the tool-selection ticket's scope: drop the shell preference and the shell fixture.
- Implement the tool-selection unit on a separate branch.
- Add the #10 documentation section and the short prompt.
- Run the full codebase examination over `docs/`, `tests/`, and `support-files/`.
- Revisit GitHub #9 after the live test.
- Declare the missing policy loading modes.
- Rewrite the release docs in the user's voice, starting with v6.6.0.

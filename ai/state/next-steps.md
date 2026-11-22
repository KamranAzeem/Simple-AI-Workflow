<!-- STATE-FILE-HEADER: next-steps.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** open items only, oldest first, one item per line; no commands, implementation steps, investigation notes, or rationale.
- **Delete on done:** remove each item when it is finished; never keep completed items or history.
- **Never drop:** an unfinished item stays until it is done.
- **Brevity:** at most three short bullets per item.
- **Size:** counted in the shared state-file budget in `ai-policy-common.md`. Delete completed items; if open items still exceed the budget, keep them and report the overage. Never drop an unfinished item.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: next-steps.md END -->

## Pending

- Refresh the state-file headers in each existing project after v7.0.0.
- Verify the team knowledge publish path against a live store when one is configured.
- Grill the team skills questions now that the team knowledge store ships.
- Decide the slide-deck source of truth: Markdown-first or Google Slides-first.
- Plan the README restructure and the guide audit after the slide narrative is agreed.

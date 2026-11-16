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

- File the TDD policy-configuration child ticket under the TDD parent: the `## Loading` shape, the load-path test, the shape wrapper, and the scenario spec template.
- Open `feature/plugin-extraction` from trunk before any file edit and push it.
- Plan the prerequisite and the boundary child on that branch; no trunk merge, tag, or release until the live test passes.

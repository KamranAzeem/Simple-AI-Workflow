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
- Verify the team publish path against a live store when one is configured.
- File the Google Slides update and physical Gate 2 as a separate issue.
- Confirm a reliable post-compaction hook; update the manual-recovery docs if one appears.
- Sync AGENTS.md and the v7.7.0 layout into downstream projects.
- Migrate the live User AI Directory with a dry run, then the real sync.
- Decide whether to delete the stray scope-migration backup from the test run.
- Install or locate PowerShell to run the PowerShell fixtures.
- Resume the presentation policy only on request; design layout and type control first.
- Resume the trimmed slide review speed scope only on request.
- Decide whether `support-files/build-slides-html.sh` earns its place when the slide work resumes.
- Implement the customization presets on request; init follows.
- Audit the Project Knowledge the protocol relies on.
- Retire the user-space review-verdict-binding lesson with `repair knowledge files user`.
- Plan `ai/issues/open/slide-authoring-pipeline-and-deck-refresh.md`.

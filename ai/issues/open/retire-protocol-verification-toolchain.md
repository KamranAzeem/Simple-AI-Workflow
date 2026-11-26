Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Retire the verification runbook and the unenforced verdict-hash rules, and move the gate commands into the protocol

Description:

## Problem

The user wants `ai/knowledge/protocol-verification-toolchain.md` removed. It is a 95-line, 9,439-byte runbook, not a policy, and the protocol must not depend on `docs/`. Consume the useful content into protocol surfaces; drop the rest.

The same change removes `### Verdict and Delta Verification` from `ai-policy-code-review.md`. The rule is one day old, unenforced, and unused: no script checks a review hash, the report template has no hash field, and 0 of 442 review reports record one. It adds ceremony without a check. The blocking gate and the iteration protocol remain the review contract.

## Decisions

- Consume into protocol surfaces only. No new `docs/` content and no docs dependency.
- Drop the per-fixture command list. `tests/run-all.sh` runs every `test-*.sh`; add one full-suite rule to `ai-policy-meta.md`.
- Keep the existing validator, authoring, and trigger commands in `ai-policy-meta.md`; drop the duplicates.
- Drop the migration facts (the ADR and `load-context.md` own them), the init facts (no `--init` exists), the plan-quality facts (the issue policy and ADR own them), the Why block, the Verify counts, and the duplicated caveats.
- Keep `core.fileMode=false` as one ADR entry. Keep the live-tree count rule and the stash re-validation rule as one `ai-policy-meta.md` Enforcement line each.
- Delete the map lines at `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md:61-62`.
- Remove the verdict-hash section and its four assertions. Keep the old ADR as history; append a superseding ADR.
- Retire the user-space lesson `~/.ai/knowledge/review-verdict-binding.md` through `repair knowledge files user`, outside this repo change.
- Release: PATCH.

## Current dependencies

- `tests/test-docs-audit.sh:26` and `:167-168`, `:200-205`, `:213` pin the knowledge file; remove them. The live-gate and plan-quality facts stay asserted against the ADR, the guide, and the map.
- `tests/test-user-settings-repair-fixture.sh:72-76` reads counts from the file; remove them. The derived counts stay covered by `tests/test-slides.sh` and `tests/test-readme-shape.sh`.
- `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md:61-62` names the file and the verdict-hash rules; update both.
- `tests/test-issue-policy.sh:103-106` pins the four hash clauses; remove them.
- `design-docs/protocol-decisions.md:1432` is the old ADR; append a superseding entry.
- No `AGENTS.md`, policy, or procedure names the knowledge file.

## Content disposition

- Commands: drop, except one full-suite rule in `ai-policy-meta.md`.
- Current facts: drop; all owned elsewhere.
- Why: drop; every fact is pinned by a policy, fixture, or ADR.
- Verify counts: drop; the validator and suite are the oracle.
- Caveats: drop the duplicates; keep `core.fileMode=false` in the ADR and the two meta rules.
- Knowledge file: delete.
- Map lines: delete.
- Verdict-hash section: delete.

## Desired outcome

- No knowledge file and no docs dependency. The protocol owns every surviving rule and command.
- The code-review policy keeps the blocking gate and the iteration protocol, without the hash section.
- The map no longer names the file, and the next checkpoint records the knowledge-store count. The suite and the validator stay green.

## Acceptance criteria

- The file is absent and the boot index no longer lists it. Assertion: `test ! -e` and `tests/test-load-context-boot.sh` passes.
- The map no longer names the file or the verdict-hash rules. Assertion: `rg` on the map.
- The code-review policy has no `### Verdict and Delta Verification`; the blocking gate and the iteration protocol remain. Assertion: `rg` and `tests/test-issue-policy.sh`.
- The four hash assertions are gone; the suite passes 33/33; no new test script. Assertion: `rg`, `tests/run-all.sh`, and the test count.
- The knowledge-file count assertions are gone; the derived counts stay covered by `tests/test-slides.sh` and `tests/test-readme-shape.sh`. Assertion: `rg` on the fixture and both fixtures pass.
- Every content block has a recorded disposition; the diff carries no unmoved required content. Assertion: the plan's disposition list and the diff.
- The no-reference guard covers `AGENTS.md`, policies, procedures, docs, tests, and the map, excluding closed history and checkpoints. Assertion: the guard fails on a reference and passes on the tree.
- The full gate passes: protocol 8/8, authoring, suite 33/33, markdownlint 0, index 25/16/58.
- The release is tagged and published if the plan carries one. Assertion: the release URL.

## Out of scope

- Changing the blocking gate, severity, report format, iteration protocol, or review dimensions.
- Rewriting closed tickets, the daily diary, or historical review reports.
- The broad audit of other knowledge files; it stays a separate future ticket.
- Moving command lists into a policy. Policies hold rules, not runbooks; the full-suite rule is a rule.
- General knowledge-store cleanup beyond this file and the user-space lesson.

## Follow-on audit

The user wants a later audit of other project-knowledge files that the protocol, tests, docs, or map implicitly rely on. This ticket does not perform that audit. It records the request so it is not lost. Candidate references to inspect later: `tests/test-docs-audit.sh` and other fixtures that name knowledge files, the boot index, the checkpoint knowledge step, the map, and the issue template. The output should list each file, its referencing surface, and whether the dependency is necessary or accidental.

## Notes

- The knowledge file is 95 lines and 9,439 bytes, under the 15 KB knowledge trigger.
- The old path appears in closed history and the daily checkpoint; that is history, not an operational reference.
- No branch exists yet. This ticket stays in `open/`.

---

2026-11-26

Plan: `ai/plans/retire-verification-runbook-and-verdict-hash.md`.

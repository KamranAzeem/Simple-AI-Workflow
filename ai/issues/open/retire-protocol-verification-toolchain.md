Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Consume the protocol-verification-toolchain knowledge file into the protocol only where necessary, then remove it

Description:

## Problem

The user wants to remove `ai/shared/project-knowledge/protocol-verification-toolchain.md` from the knowledge store. The file is a 90-line, 8,897-byte runbook, not a policy, but the dev suite and the map still depend on it. The protocol modules do not name or load it. The necessary content should be consumed into the protocol and the rest dropped, not copied wholesale.

## Current dependencies

- `tests/test-docs-audit.sh:26` names the file; lines 160-161 and 199 require the live-gate fact and the plan-quality fact; the new review-sequencing absence checks also target it.
- `tests/test-global-settings-repair-fixture.sh:71-75` reads the policy, procedure, test, and trigger counts from it.
- `ai/shared/project-knowledge/codebase-skeleton-map-simple-ai-workflow.md:61` lists it.
- The boot's project-knowledge index includes it; the checkpoint project-knowledge step can update it. No `AGENTS.md`, policy, or procedure names it.
- Closed tickets, the closed plan, the daily checkpoints, and the review reports mention the old path as history. Do not rewrite them.

## Content inventory

- Header and Context.
- The command list: protocol validator, authoring, reference, knowledge, skills, README, docs, slides, trigger, boot, sync, scrub, handoff, policy load, policy shape, common boundary, full suite, markdownlint, new-file lint, and the stash validator.
- Current Facts: the plan template, S/M light path, clean-tree baseline; migration and init rules.
- Why: the validator, index, fixture, plugin, skills, and docs details.
- Verify: 8/8; PASSED; 16 procedures, 129 steps, 4 tiers, 13 items; 25 policies (12 domain and 13 protocol), 16 procedures, 31 test scripts, 54 triggers, floor 25; the review verdict; migration; init.
- Caveats: lint ignores; markdownlint path; triggers and loading live; specs separate; shellcheck path; `core.fileMode`; fixture counts; the uniform gate.

## Desired outcome

- Classify every block as move, derive, or drop. Move only what the protocol needs. Do not move the whole file and do not create a replacement knowledge file.
- The likely home for the commands and environment caveats is `docs/protocol-validation-system.md`; the test counts should be derived by the tests or read from the live index, not copied.
- The plan-quality facts already live in the issue policy and ADR. The migration and init facts belong in their owning policy, procedure, or doc. The review rules already live in the code-review policy and ADR. Drop the duplicates and the stale review remnants.
- Delete the file, remove the map line, update the project-knowledge count, and update the two fixtures so they no longer reference it.
- Add a guard that the protocol modules, docs, tests, and map do not name the removed file. Exclude closed history and the daily diary.
- Decide the release in the plan. A PATCH is likely.

## Acceptance criteria

- Every content block has a recorded disposition, and the final diff contains no unmoved required content. Assertion: the plan's disposition list and the diff.
- The file is absent; the map line is gone; the project-knowledge count drops by one; the boot index no longer lists it. Assertion: `test ! -e`, `rg` on the map, and the count.
- `tests/test-docs-audit.sh` and `tests/test-global-settings-repair-fixture.sh` no longer reference the file; the count checks derive from the live tree or the index; the suite passes 31/31. Assertion: `rg` and the suite.
- The necessary commands and caveats live in the named doc or owning protocol surface without duplication or stale counts. Assertion: the docs/content check and the suite.
- No `AGENTS.md`, policy, procedure, doc, test, or map names the old path; closed history is excluded. Assertion: a repo `rg` guard.
- The full gate passes. Assertion: protocol 8/8, authoring, suite 31/31, markdownlint 0, index 25/16/54.
- The release is tagged and published if the plan carries one. Assertion: the release URL.

## Out of scope

- The broad audit of other knowledge files. The follow-on is recorded below and is a separate future ticket.
- Moving command lists into a policy. Policies hold rules, not runbooks.
- Rewriting closed tickets, the daily diary, or historical review reports.
- The review-sequencing rules; they are already policy and ADR owned.
- General knowledge-store cleanup beyond this file.

## Follow-on audit

The user wants a later audit of other project-knowledge files that the protocol, tests, docs, or map implicitly rely on. This ticket does not perform that audit. It records the request so it is not lost. Candidate references to inspect later: `tests/test-docs-audit.sh` and other fixtures that name knowledge files, the boot index, the checkpoint knowledge step, the map, and the issue template. The output should list each file, its referencing surface, and whether the dependency is necessary or accidental.

## Notes

- The protocol modules do not reference the file today. The explicit dependencies are the two fixtures and the map.
- The file is 90 lines and 8,897 bytes, under the 15 KB knowledge trigger.
- The old path appears in closed history and the daily checkpoint; that is history, not an operational reference.
- No plan or branch exists yet. This ticket stays in `open/`.

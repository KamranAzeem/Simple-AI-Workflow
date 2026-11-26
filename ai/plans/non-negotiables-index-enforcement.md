# Plan: Non-Negotiables index enforcement

## Goal

Bring the common-policy Non-Negotiables index back in line with the decided two-layer always-on design: make items 2 and 3 reference-only, retire the fixed numeric cap with a superseding ADR, correct the stale routing caveat, and guard the index shape with an executable fixture.

Ticket: `ai/issues/open/non-negotiables-index-enforcement.md`.

## Evidence

- The 2026-08-25 ADR caps the index at six and lists six rules (`design-docs/protocol-decisions.md:557`).
- The 2026-08-31 ADR says full reads and no-truncation stay as their own mandate and are "referenced, not restated" (`design-docs/protocol-decisions.md:587`).
- The 2026-08-31 router ADR limits the two-layer pattern to universal always-on mechanics (`design-docs/protocol-decisions.md:591`).
- The Level 0 precedence names both layers (`AGENTS.md:139`).
- The index has nine items; items 2 and 3 restate the mandates, and item 3 wrongly points at Full File Reads (`ai/policies/ai-policy-common.md:25-33`).
- The section is about 1.5 KB as it stands.
- The routing caveat still says the layers "claim an always-on role" and "the consolidation is unresolved" (`ai/knowledge/protocol-routing-principle.md:32`).
- `tests/test-policy-shape.sh` is 50 lines and has no Non-Negotiables assertion.
- The predecessor ticket is in `closed/` in the working tree but untracked; the baseline commit is what makes it tracked (`ai/issues/closed/tier2-vs-non-negotiables-consolidation.md:39`).
- Release artifacts are version-pinned: the docs audit lists each announcement (`tests/test-docs-audit.sh:21-39`), the README carries the banner and a trigger-count line (`README.md:3`, `README.md:224`), and `tests/test-readme-shape.sh:85` hardcodes the banner version.
- Workflow clone up to date at `d0189d6`; index 26 policies, 16 procedures, 55 triggers, 0 conflicts.

## Depth

M. Context plus acceptance criteria, per `ai-policy-issue-management.md` (`### Plan`). No HLD or LLD.

## Context

The index is an always-loaded, one-screen list. Its job is to name each high-cost rule and point at the section that owns it. Items 4 to 9 follow that shape: a one-line gloss plus a pointer. Items 2 and 3 break it by carrying the operational mechanics, and item 3 names the wrong owner. The fixed cap of six no longer matches the rules the protocol keeps always-on; three were added later without amending it.

Item 1 stays as the lead because it matches the gloss-plus-pointer shape and points at the Investigation Contract below. The item label "No truncated evidence" stays as the ticket dictates; the owner name in `AGENTS.md` is "No Sliced Evidence", and the pointer carries that name.

The index shape rule is defined once, so the fixture has something precise to assert.

## Decisions (ADR)

- **D1: Retire the numeric cap.** The index has no fixed count. User decision, 2026-11-26. A new dated ADR entry supersedes the cap; the 2026-08-25 entry stays as history.
- **D2: Define the index shape.** Each item is one line: the rule name, at most one short gloss, and a pointer to the owning section. An item never repeats another layer's mandate text or its operational mechanics, for example the `AGENTS.md` full-read and no-truncation wording. A same-layer gloss is allowed, so item 1 and items 4 to 9 stay. The section stays short, under 3,000 bytes, asserted by the fixture.
- **D3: Keep item 1 as the index lead.** It matches the items 4 to 9 shape and points at the Investigation Contract below. User approved, 2026-11-26.
- **D4: Extend `tests/test-policy-shape.sh`.** No new test file, so the suite stays at 36 and the deck count does not move.
- **D5: Ship a PATCH, v7.12.2.** The change is a behavior-neutral policy refactor with a test guard, matching the v7.12.1 precedent. It carries the announcement, README banner, and version-pinned test updates.
- **D6: Verify, do not redo, the predecessor close.** The old ticket is already closed as obsolete with a dated note; the baseline commit carries the move.

Plan-local ADRs only; the protocol ADR entry is a separate delta required by `ai-policy-meta.md` (`## Procedure and Policy Authoring`).

## Deltas

- `ai/policies/ai-policy-common.md:26`: item 2 becomes `**Full file reads.** See Full File Reads in \`AGENTS.md\` TIER READ-FIRST-RULES.`
- `ai/policies/ai-policy-common.md:27`: item 3 becomes `**No truncated evidence.** See No Sliced Evidence in \`AGENTS.md\` TIER READ-FIRST-RULES.`
- `ai/policies/ai-policy-common.md:25-33`: items 1 and 4 to 9 unchanged. The heading is unchanged.
- `design-docs/protocol-decisions.md`: insert one ADR-INDEX line after line 270, `- 2026-11-26: The Non-Negotiables index has no fixed count`.
- `design-docs/protocol-decisions.md` EOF: append one dated section with the heading `## 2026-11-26: The Non-Negotiables index has no fixed count`, recording D1 and D2, with Context and Consequences, and naming the superseded 2026-08-25 entry.
- `ai/knowledge/protocol-routing-principle.md:32`: replace the caveat with the resolved division: `AGENTS.md` holds the universal read-first rules, the common policy owns their contracts and indexes them, and the pattern is deliberate and only for universal always-on mechanics.
- `tests/test-policy-shape.sh`: add `check_non_negotiables <file>` with a positive run on the real policy, a negative copy whose item 2 restates `line 1 to EOF`, and a negative copy whose item 3 restates the truncation mechanics. Assert the 3,000-byte bound, the pointer targets, one line per item, and the 240-character item bound.
- `docs/announcements/v7.12.2.md`: new announcement in the user's voice.
- `README.md:3` and `README.md:224`: point the banner at the v7.12.2 announcement and update the trigger-count line version.
- `tests/test-readme-shape.sh:85`: expect the v7.12.2 banner.
- `tests/test-docs-audit.sh`: add the `v7.12.2` announcement variable, existence check, and content check, and update the README pointer assertion at line 194 from `v7.12.1.md` to `v7.12.2.md`, including its assertion label text.
- `ai/issues/open/non-negotiables-index-enforcement.md`: append the dated plan entry at planning; move to `closed/` with the plan attached at close.

## Acceptance Criteria

- **AC-1**: Items 2 and 3 are reference-only, and item 3 points to No Sliced Evidence. Assertion: the fixture passes on the repaired file, rejects `line 1 to EOF` in item 2, and rejects `head`, `tail`, or `-N` in item 3.
- **AC-2**: One superseding ADR entry records D1 and D2, its ADR-INDEX line mirrors the heading, and the entry names the superseded 2026-08-25 entry. Assertion: `grep` for `no fixed count`, `at most one short gloss`, and `2026-08-25` in the new section, plus `bash tests/test-docs-audit.sh`.
- **AC-3**: The caveat states the division and does not contain `unresolved`. Assertion: `grep` finds `universal read-first rules` and `only for universal always-on mechanics`, and finds no `unresolved`.
- **AC-4**: `tests/test-policy-shape.sh` fails on each negative copy and passes on the repaired tree; suite 36/36; validator 8/8; markdownlint 0.
- **AC-5**: The predecessor ticket stays closed with its dated note citing the 2026-08-31 ADRs. The note's term is "Closed as obsolete", not "superseded", and the historical file stays byte-identical. Assertion: `grep` finds `Closed as obsolete` and `2026-08-31` in the note, and the note is present in the baseline commit.
- **AC-6**: No behavior change. Assertion: `AGENTS.md` and the precedence are untouched, and no trigger, loading, or procedure file changes.
- **AC-7**: The release artifacts agree. Assertion: `bash tests/test-readme-shape.sh` and the docs audit pass with the v7.12.2 announcement and README pointer, `git tag --list v7.12.2` returns the tag, and `gh release view v7.12.2` reports a public release.

## Verification

- `bash tests/test-policy-shape.sh`
- `bash tests/run-all.sh` (36/36)
- `bash support-files/validate-protocol.sh` (8/8)
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md ai/procedures/*.md`
- `bash tests/test-docs-audit.sh`
- `bash tests/test-readme-shape.sh`
- `markdownlint-cli2` on the common policy, the ADR store, the knowledge file, the announcement, the README, and both tickets
- `grep -n 'unresolved' ai/knowledge/protocol-routing-principle.md` returns nothing
- `git diff --stat` confirms no `AGENTS.md`, procedure, trigger, or unrelated policy change

## Peer Review Log

- 2026-11-26, round 1: CHANGES REQUESTED. 6 Major, 8 Minor. Majors: release artifacts missing, close sequence missing branch lifecycle, item 3 negative fixture missing, D2 overbroad, rollback conflicted with the no-post-merge rule, baseline contained unnamed unrelated edits. Minors: weak AC-2, AC-3, and AC-5 assertions, repo binding, terminal gate, ADR-INDEX wording, wrong lint target, no section-length guard, untracked predecessor wording, missing authoring validator. All fixed in this revision.
- 2026-11-26, round 2: CHANGES REQUESTED. One Major: the docs audit still asserts the README pointer at v7.12.1 (`tests/test-docs-audit.sh:194`). The five other Majors verified FIXED. Minors: AC-2, AC-5, and AC-7 assertions, base-ref wording, byte count, release drafting gate, and the D2 same-layer boundary. All fixed in this revision.
- 2026-11-26, round 3: CHANGES REQUESTED. Eight prior items verified FIXED. One Major: AC-5 grepped `superseded`, but the predecessor note says `Closed as obsolete` and must stay byte-identical. Fixed by asserting the actual note text and recording the term in D6. The docs-audit label-text Minor is also fixed.
- 2026-11-26, round 4: APPROVED. AC-5 and D6 verified against the live note, and the docs-audit label-text Minor is fixed. One non-blocking Minor remains in the ticket's paraphrase of the close term; it is clarified in the ticket's plan entry.

## Risks and Rollback

- Risk: the fixture hardcodes wording, so a later legitimate reword of items 2 or 3 fails the test. Mitigation: assert the pointer target and the absence of the mandate strings, not the full sentence.
- Risk: the 3,000-byte section bound flags a legitimate growth. Mitigation: it is generous for nine one-line items and reports the size.
- Risk: the version-pinned release tests drift. Mitigation: the docs audit and the README shape test are gates, and they run in verification.
- Risk: the baseline mixes the prior session's review-212 knowledge repair with this planning record. Mitigation: the Close Sequence names every path and states the repair is already approved and not touched by the implementation branch.
- Rollback: before the merge, revert the branch or the squash commit; after the merge, fix forward on a new branch and ship a follow-up PATCH, per the no-post-merge rule.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, origin `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- Base ref: `master`, the repository default branch, at the baseline commit created from `d0189d6`.
- Merge mode: direct, per `ai-customization.md` `Merge Mode: direct`. Deliver one squash commit to `master`.
- Baseline: one chore commit on `master` before the branch, containing `ai/issues/open/non-negotiables-index-enforcement.md`, the moved `ai/issues/closed/tier2-vs-non-negotiables-consolidation.md`, `ai/plans/non-negotiables-index-enforcement.md`, the prior session's `ai/state/` and `ai/daily-checkpoints/2026-11-26.md` updates, and the prior session's review-212 approved knowledge repair (`ai/knowledge/architectural-reflection-protocol-vs-plumbing.md`, `ai/knowledge/out-of-scope-rejection-records.md`, and the rename to `ai/knowledge/local-first-knowledge-retrieval.md`). The implementation branch does not touch the knowledge repair.
- Branch: `feature/non-negotiables-index-enforcement`, created after the baseline and a clean-tree check.
- Ticket: `ai/issues/open/non-negotiables-index-enforcement.md`, moved to `closed/` in the branch commit with this plan appended before the plan file is deleted.
- Release: PATCH `v7.12.2`. Draft the announcement, the README banner, and the GitHub release body in a temp file, show the exact draft to the user, and wait for approval before writing the final files or publishing (`ai/knowledge/release-practices.md:17-18`). Then write `docs/announcements/v7.12.2.md`, point `README.md:3` at it, update `README.md:224`, `tests/test-readme-shape.sh:85`, and `tests/test-docs-audit.sh` including line 194; tag `v7.12.2` after the merge; push `master` and the tag; publish the public GitHub Release.
- Evidence: plan review APPROVED, implementation review APPROVED, validator 8/8, authoring validator pass, suite 36/36, docs audit pass, README shape test pass, markdownlint 0, clean tree at the terminal gate.
- Terminal gate: the branch is at least one commit ahead of `master`, the tree is clean, and no post-merge repository change is made.
- Branch checkpoint: write the checkpoint on the branch before the implementation commit, then push `master`, delete the branch, and confirm the tag and GitHub Release.

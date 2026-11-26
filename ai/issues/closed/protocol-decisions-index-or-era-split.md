Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: The 184 KB protocol decision store has no index or era split and is full-loaded before every protocol change.

Description:

- `design-docs/protocol-decisions.md` is 1,600 lines and 184,582 bytes with 260 dated entries.
- There is no table of contents, index, or era split.
- `ai-policy-meta.md:42` requires a full load before any protocol change, so every protocol edit pays roughly 46K tokens to read the store.
- The store is append-only and internally consistent, with no duplicate dated headings.
- This is an observation and a design decision, not a defect.

Resolution options:

- Add a table of contents of dated entries at the top.
- Split by year or era into linked files, preserving the append-only history.
- Keep one file and accept the load cost.

Acceptance criteria:

- The chosen structure keeps every decision reachable and the append-only rule intact.
- A maintainer can find a decision without reading the whole store.

---
2026-11-26
Filed from the 2026-11-26 codebase examination. Evidence group O1. No secret or identifying name present.

---
2026-11-26
Plan attached below. Plan reviews 198 (CHANGES REQUESTED, fixed) and 199 (APPROVED); implementation review 200 APPROVED. Closed in the ADR-index branch; release v7.11.1.

## Implementation Plan

# Plan: Add a checked index to the protocol decision store

## Goal

Add a marked index at the top of `design-docs/protocol-decisions.md`, mirror the dated headings into it, enforce the mirror with a check in `tests/test-docs-audit.sh`, and record the rule in `ai-policy-meta.md`. Keep one file, leave the full-load policy unchanged, and ship PATCH v7.11.1.

## Evidence

- `design-docs/protocol-decisions.md` is 1,600 lines and 184,582 bytes, with 262 dated `## YYYY-MM-DD: Title` entries at planning and 263 after the new entry. It has no index.
- `ai-policies/ai-policy-meta.md:42` requires a full load before a protocol change, so every protocol edit reads the whole store.
- `tests/test-docs-audit.sh` already sets `DECISIONS="$ROOT/design-docs/protocol-decisions.md"` and has the `pass` and `fail_case` helpers.
- No test currently checks for duplicate dated headings or a stale index.
- The F2 to F5 docs batch landed without a release. This plan differs because it edits `ai-policy-meta.md`, a policy file, so the release rule applies.

## Depth

M. Context plus acceptance criteria; no HLD or LLD is required.

## Context

The store is hard to navigate at 262 entries. The user chose the in-file index over an era split because a split would require changing `ai-policy-meta.md` to load only the current era, and an older superseded decision could be missed. The index is the navigation aid; the full-load rule stays. The check is the gate; no generator script is kept.

Out of scope: the era split, any change to the full-load rule, any change to the index format beyond `- YYYY-MM-DD: Title`, and any tooling that rewrites the store automatically.

## Decisions (ADR)

- ADR-1, an in-file marked block, not an era split. One artifact, no policy change to the full-load rule.
- ADR-2, no generator script. The docs-audit check is the gate, and a maintainer adds one `- YYYY-MM-DD: Title` line per decision by hand.
- ADR-3, the index mirrors the headings in document order, so the check is an exact string comparison. The block is a mirror, not a curated list.
- ADR-4, keep the one-line meta-policy rule. The check also fails with the missing or extra line, so the fix is obvious even without the rule.
- ADR-5, PATCH v7.11.1. The meta-policy line is a policy change, so `release-practices.md:14` requires a release; PATCH is the lowest conservative version. Ship the announcement, the README banner, the tag, and the GitHub Release.

## Deltas

- `design-docs/protocol-decisions.md`:
  - Add the marked block after the title and before the first dated entry:
    - `<!-- ADR-INDEX:START -->`
    - one `- YYYY-MM-DD: Title` line per dated heading, in document order
    - `<!-- ADR-INDEX:END -->`
  - Build the initial block once from the live headings. Do not add a generator script.
  - Append the new ADR entry for this decision at the end and add its index line.
- `tests/test-docs-audit.sh`: add the ADR index check:
  - extract `^## YYYY-MM-DD:` headings in file order;
  - extract the lines between the two `ADR-INDEX` markers;
  - compare them exactly and fail with the missing or extra line;
  - fail on a duplicate dated heading;
  - pass with a clear label when the index is current.
- `ai/policies/ai-policy-meta.md`: add one line near the ADR entry rule: "Append the decision and its `ADR-INDEX` line; the docs-audit fixture fails on a stale index."
- `ai/issues/open/protocol-decisions-index-or-era-split.md`: append the plan entry now; close it in the branch commit with the plan attached.
- `docs/announcements/v7.11.1.md`: new PATCH announcement. Point the README banner at it.
- No era split. No change to the full-load rule. No trigger, policy-count, or procedure-count change (26 policies, 16 procedures, 55 triggers).

## Acceptance Criteria

- AC-1: the index mirrors the headings exactly. Assertion: `tests/test-docs-audit.sh` passes, and the block contains one line per dated heading in the same order.
- AC-2: a duplicate dated heading fails. Assertion: run the check logic on a scratch copy with a duplicated heading; it exits 1. The docs audit is the positive gate.
- AC-3: a stale index fails. Assertion: run the check logic on a scratch copy with one block line removed; it exits 1 and names the missing line.
- AC-4: the meta policy has the rule. Assertion: `rg -n 'ADR-INDEX' ai/policies/ai-policy-meta.md` matches.
- AC-5: the store stays one file and the full-load rule is unchanged. Assertion: `ls design-docs` has no new decision file, and `rg -n 'full load' ai/policies/ai-policy-meta.md` still matches.
- AC-6: the full validation is green. Assertion: `tests/run-all.sh` exits 0, `validate-protocol.sh` prints 8 of 8, authoring validation prints PASSED, `markdownlint-cli2` reports 0, and `shellcheck -S warning` reports 0.
- AC-7 (release): the v7.11.1 announcement exists, the README banner links it, the annotated tag `v7.11.1` exists, and the GitHub Release is public.

## Verification

1. `bash tests/test-docs-audit.sh`.
2. Run the check logic on scratch copies with a duplicate heading and with one block line removed; expect exit 1, then remove the copies.
3. `bash support-files/validate-policy-authoring.sh AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`.
4. `bash support-files/validate-protocol.sh`.
5. `bash tests/run-all.sh`.
6. `markdownlint-cli2 'docs/**/*.md' '*.md' 'AGENTS.md' 'ai/issues/**/*.md'`.
7. `shellcheck -S warning support-files/*.sh tests/*.sh`.
8. `rg -n 'ADR-INDEX' ai/policies/ai-policy-meta.md design-docs/protocol-decisions.md`.

PowerShell fixtures remain PENDING when `pwsh` is absent, as today.

## Peer Review Log

- 2026-11-26, review-198: CHANGES REQUESTED. One Major (the plan changed a policy but claimed no release) and one Minor (the negative check cannot run the docs audit on a scratch copy). Both fixed.
- 2026-11-26, review-199: APPROVED after the fixes.

## Risks and Rollback

- Risk: the exact comparison is brittle if a heading is edited without the index. That is the point; the failure names the line, and the meta-policy rule explains the fix.
- Risk: the block adds roughly 12 KB to a 184 KB store, so the full load grows a little. Accepted against the navigation win.
- Risk: the meta-policy line is a policy change and requires a PATCH. Mitigation: ADR-5 and the Close Sequence ship v7.11.1.
- Rollback: remove the block, the check, and the policy line on the branch before the merge; after the merge, fix forward on a new branch. No release to unwind.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, origin `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- Base ref: `master`, the repository default branch.
- Merge mode: direct, per `ai-customization.md` `Merge Mode: direct`. Deliver one squash commit to `master`.
- Baseline: commit the plan, the ticket update, and the carried state-repair checkpoint as a chore baseline on `master` before opening the branch.
- Branch: `docs/protocol-decisions-index`.
- Ticket: close `ai/issues/open/protocol-decisions-index-or-era-split.md` in the branch commit with the plan attached under `## Implementation Plan`.
- Release: v7.11.1, PATCH. Write `docs/announcements/v7.11.1.md`, point the README banner at it, tag `v7.11.1` after the merge, push `master` and the tag, and publish the public GitHub Release.
- Evidence: the docs audit, the duplicate and stale scratch runs, the authoring validator, `validate-protocol.sh` 8 of 8, `tests/run-all.sh`, `markdownlint-cli2` 0, and `shellcheck` 0 are recorded in the checkpoint and the review.
- Terminal gate: the branch is at least one commit ahead of `master`, the tree is clean, and no post-merge repository change is made.

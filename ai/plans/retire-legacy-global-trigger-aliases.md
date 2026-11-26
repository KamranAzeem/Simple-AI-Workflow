# Plan: Retire the legacy global trigger aliases

## Goal

Remove the four v7.7.x trigger aliases that are still live at v7.10.0: `update global knowledge`, `repair global settings`, `tidy global settings`, and `heal global settings`. Settle the trigger count at 55, remove the stale v7.8.0 removal notices from current files, and ship the change as the MINOR release v7.11.0.

## Evidence

- `ai/procedures/write-checkpoint.md:8` declares `- update global knowledge`.
- `ai/procedures/repair-user-settings.md:8` to `:10` declare `repair global settings`, `tidy global settings`, and `heal global settings`.
- `ai/policies/ai-policy-user-settings.md:80` says "Accept `repair global settings` as a v7.7.x alias; remove the alias in v7.8.0."
- `ai/procedures/repair-user-settings.md:12` says the phrases are "removed in v7.8.0".
- `ai/knowledge/scope-vocabulary-and-storage-roots.md:35` says the aliases "are removed in v7.8.0".
- `ai/knowledge/trigger-phrase-naming.md:14` says to keep a "v7.7.x alias" and remove it "in the next minor".
- `README.md:35` and `README.md:36` say the aliases are removed in v7.8.0.
- `README.md:220` says "The 59 triggers in v7.10.0 include no temporary aliases."
- `docs/workflow-guide.md:350` and `:612` tell the user to say `update global knowledge`.
- `docs/simple-ai-workflow-slides.md:438` and `docs/slides/simple-ai-workflow-slides.html:527` state 59 triggers.
- `tests/test-readme-shape.sh:84` asserts "59 triggers".
- `tests/test-team-knowledge.sh:127` asserts `triggers=59` in the index summary.
- `tests/test-scope-migration.sh:89` and `:91` assert the two legacy trigger bullets are present.
- `tests/test-scope-migration.sh:92` and `:93` assert the v7.8.0 removal notes.
- `tests/test-user-settings-repair-fixture.sh:55` asserts `- repair global settings` is present.
- Live oracle at filing: `modules=42|policies=26|procedures=16|triggers=59|conflicts=0|errors=0`.
- `tests/test-slides.sh:61` and `:63` also mention 59, but that is the slide count, not the trigger count. Do not change it.
- `ai/knowledge/release-practices.md:14` says a behavior change ships as MINOR.
- Historical records keep their vocabulary. `docs/announcements/v7.7.0.md` is a historical announcement and stays unchanged.

## Depth

M. The issue contract uses context plus acceptance criteria for an S or M ticket. No HLD or LLD is required. The change is a bounded trigger and documentation sweep.

## Context

The v7.7.0 scope rename introduced `Workflow`, `User`, `Team`, and `Project` vocabulary and promised to remove the old `global` trigger phrases in v7.8.0. The aliases survived v7.8.0 through v7.10.0, so the README claim of "no temporary aliases" is false today. The user chose to retire them rather than keep them. Removing a trigger phrase is a behavior change, so the release is MINOR, v7.11.0.

Out of scope: the `repair knowledge files` scope word `global` (a scope or option word, not one of the four triggers), any broader rewrite of `ai/knowledge/trigger-phrase-naming.md` beyond the one-line edit in Deltas, and the historical v7.7.0 announcement.

## Decisions (ADR)

- ADR-1, retire rather than keep. The aliases were announced for removal in v7.8.0 and add namespace noise. Remove them now. This supersedes the v7.8.0 removal date with actual removal in v7.11.0.
- ADR-2, MINOR release. A trigger phrase stops working, which is a behavior change under `release-practices.md:14`. Ship v7.11.0.
- ADR-3, the `--index` oracle is the count source of truth. The expected summary is `triggers=55`, and every other count follows it.
- ADR-4, leave the historical announcement. `docs/announcements/v7.7.0.md` keeps its original text; the new v7.11.0 announcement records the overdue removal.
- ADR-5, the knowledge-repair scope word stays. The `repair knowledge files global` scope word is not one of the four triggers and is out of this ticket.

## Deltas

Trigger declarations:

- `ai/procedures/write-checkpoint.md`: delete the `- update global knowledge` bullet at line 8. Rewrite the "Single-step aliases" line at line 10 to drop the clause "the previous wording is a v7.7.x alias".
- `ai/procedures/repair-user-settings.md`: delete the three trigger bullets at lines 8 to 10. Delete the sentence "The previous trigger phrases are v7.7.x aliases and are removed in v7.8.0." from the Boundaries line.

Policy and knowledge:

- `ai/policies/ai-policy-user-settings.md:80`: delete the alias bullet "Accept `repair global settings` as a v7.7.x alias; remove the alias in v7.8.0."
- `ai/knowledge/scope-vocabulary-and-storage-roots.md:35`: delete the removal-notice bullet in `### Exceptions`.
- `ai/knowledge/trigger-phrase-naming.md:14`: rewrite to "Keep the previous phrase as an alias only when a rename needs one; remove the alias in the next minor." This removes the v7.7.x specificity but keeps the rule.

Docs and counts:

- `README.md:35` and `:36`: change the two alias rows so the note says "Removed in v7.11.0; use the new phrase."
- `README.md:220`: change "59 triggers in v7.10.0" to "55 triggers in v7.11.0".
- `README.md:3`: point the banner at `docs/announcements/v7.11.0.md`.
- `docs/workflow-guide.md:350`: replace `update global knowledge` with `update user knowledge` and change "the global promotion" to "the user promotion".
- `docs/workflow-guide.md:612`: replace the table row value `"update global knowledge"` with `"update user knowledge"`.
- `docs/simple-ai-workflow-slides.md:438`: 59 triggers to 55 triggers.
- `docs/slides/simple-ai-workflow-slides.html:527`: 59 triggers to 55 triggers.
- `docs/announcements/v7.11.0.md`: new announcement in the user's voice; reason first, no changelog; state that the overdue alias removal is done.

Tests:

- `tests/test-readme-shape.sh:84`: assert "55 triggers".
- `tests/test-team-knowledge.sh:127`: assert `triggers=55`.
- `tests/test-scope-migration.sh:89` and `:91`: change the two `present` assertions to `absent` for the legacy bullets.
- `tests/test-scope-migration.sh:92` and `:93`: keep the historical announcement assertion at `:92`; change `:93` so it no longer expects the removal note in `ai/procedures/repair-user-settings.md`.
- `tests/test-user-settings-repair-fixture.sh:55`: change the `present` assertion to `absent`.

Record:

- `design-docs/protocol-decisions.md`: append a dated decision that records the retirement and supersedes the v7.8.0 removal date.
- `ai/issues/open/retire-or-keep-legacy-global-trigger-aliases.md`: append the dated plan entry now, and move to `ai/issues/closed/` in the branch commit with the plan attached.

## Acceptance Criteria

- AC-1: The index reports 55 triggers, 0 conflicts, and 0 errors. Assertion: `bash support-files/validate-policy-authoring.sh --index | grep '^summary'` contains `triggers=55`, `conflicts=0`, and `errors=0`.
- AC-2: The four phrases are absent from the trigger namespace. Assertion: `bash support-files/validate-policy-authoring.sh --index | grep -E 'update global knowledge|repair global settings|tidy global settings|heal global settings'` returns no match.
- AC-3: The trigger namespace check passes. Assertion: `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)` exits 0.
- AC-4: No current file carries a v7.8.0 removal notice. Assertion: `rg -n 'removed in v7\.8\.0' ai/policies ai/procedures ai/knowledge README.md docs --glob '!docs/announcements/**'` returns no match.
- AC-5: Every trigger count is 55 and no stale trigger count remains. Assertion: `rg -n '59 triggers|triggers=59' README.md docs/simple-ai-workflow-slides.md docs/slides/simple-ai-workflow-slides.html tests/test-readme-shape.sh tests/test-team-knowledge.sh` returns no match, and `rg -n '55 triggers|triggers=55'` on the same files matches. The 59 in `tests/test-slides.sh` is the slide count and stays.
- AC-6: The full validation is green. Assertion: `tests/run-all.sh` exits 0, `validate-protocol.sh` prints 8 of 8, authoring validation prints PASSED, `markdownlint-cli2` reports 0 issues, and `shellcheck -S warning` reports 0.
- AC-7: The release is recorded. Assertion: `docs/announcements/v7.11.0.md` exists, the README banner links it, the annotated tag `v7.11.0` exists, and the GitHub Release is public.
- AC-8: The decision is recorded. Assertion: `design-docs/protocol-decisions.md` has a new dated entry that names the four phrases and v7.11.0.
- AC-9: The historical announcement is unchanged. Assertion: `git diff master -- docs/announcements/v7.7.0.md` is empty.

## Verification

Run these on the branch before the merge:

1. `bash support-files/validate-policy-authoring.sh --index | tail -1` and confirm `triggers=55`, `conflicts=0`, `errors=0`.
2. `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`.
3. `bash support-files/validate-protocol.sh`.
4. `bash tests/run-all.sh`.
5. `markdownlint-cli2 'docs/**/*.md' '*.md' 'AGENTS.md' 'ai/issues/**/*.md'`.
6. `shellcheck -S warning support-files/*.sh tests/*.sh`.
7. The `rg` count and removal-notice checks from AC-2, AC-4, and AC-5.
8. After the merge, confirm the annotated tag `v7.11.0` and the public GitHub Release exist, and the README banner links the announcement.

PowerShell fixtures remain PENDING when `pwsh` is absent, as today.

## Peer Review Log

- 2026-11-26, review-191: CHANGES REQUESTED. One Major (the rollback violated the no-post-merge rule) and three Minor (the `global promotion` wording, the out-of-scope wording for `trigger-phrase-naming.md`, and the missing post-merge release verification). All fixed. One Suggestion accepted (the slide-count note in AC-5).
- 2026-11-26, review-192: APPROVED after the fixes.

## Risks and Rollback

- Risk: a user script calls one of the four retired phrases. Mitigation: MINOR release, the announcement explains the removal, and the README migration table points to the new phrases.
- Risk: a stale 59 trigger count sits in a file the sweep misses. Mitigation: the targeted `rg` check and the full suite. The `59 slides` number in `tests/test-slides.sh` is a different count and stays.
- Risk: the knowledge-repair scope word `global` is confused with the retired triggers. Mitigation: ADR-5 keeps it out of scope and the plan names it.
- Rollback, before the merge: delete the branch and leave `master` untouched. After the merge: do not revert on `master`; open a new ticket and branch, fix forward, and ship a follow-up PATCH release. A bad tag or release may be edited or deleted on the remote, but `master` gets no post-merge commit.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, origin `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- Base ref: `master`, the repository default branch.
- Merge mode: direct, per `ai-customization.md` `Merge Mode: direct`. Deliver one squash commit to `master`.
- Baseline: commit the plan, the review report, and the ticket update as a chore baseline on `master` before opening the branch. The approved plan plus the implement request is the approval for this baseline and for the merge named here.
- Branch: `feature/retire-legacy-global-trigger-aliases`.
- Ticket: move `ai/issues/open/retire-or-keep-legacy-global-trigger-aliases.md` to `ai/issues/closed/` in the branch commit, with the plan attached under `## Implementation Plan`.
- Release: v7.11.0, MINOR. Write `docs/announcements/v7.11.0.md`, point the README banner at it, tag `v7.11.0` after the merge, push `master` and the tag, and publish the public GitHub Release.
- Evidence: the index summary, the authoring and trigger validators, `validate-protocol.sh` 8 of 8, `tests/run-all.sh`, `markdownlint-cli2` 0, and `shellcheck` 0 are recorded in the checkpoint and the review.
- Terminal gate: the branch is at least one commit ahead of `master`, the tree is clean, and no post-merge repository change is made.

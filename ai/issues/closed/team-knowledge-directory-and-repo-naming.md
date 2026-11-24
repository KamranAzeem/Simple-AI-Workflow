Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: S
Label:
URL:
Summary: Rename the team store lessons directory to team-knowledge

Description:

Rename `lessons/` to `team-knowledge/` in the optional team knowledge store so all three knowledge scopes share one directory pattern: `global-knowledge/`, `project-knowledge/`, and `team-knowledge/`.

Scope narrowed on 2026-11-24. The repository naming convention and the report-only check moved to `team-repository-naming-convention.md`. The rename ships alone.

Current shape:

- `Team AI Knowledge Directory` points at the team repository root.
- Lessons are flat under `lessons/`; skills are under `skills/`.
- `Team AI Knowledge Directory` still points at the repository root, so `skills/` stays a sibling.

Proposed shape:

- Lessons are flat under `team-knowledge/`; `skills/` stays a sibling.
- The two configuration keys and the precedence stay unchanged.
- No fallback to `lessons/`.

Live files that name `lessons/`:

- `ai/policies/ai-policy-team-knowledge.md` (`## Store Shape`, active and retired lesson rules).
- `ai/procedures/knowledge-publish.md` (`STEP-WRITE-LESSON`).
- `ai/procedures/load-context.md` (`STEP-TEAM-KNOWLEDGE-INDEX`).
- `docs/ai-customization-guide.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`.
- `docs/slides/diagrams/knowledge-skills.svg`.
- `tests/test-team-knowledge.sh`, including the fixture at `tests/team-knowledge/lessons/`.
- Rebuild the HTML deck after the deck and diagram change.

Also update:

- The validator anchors for the team store path.
- `README.md` and `docs/ai-customization.md` where they state the store layout or show the example root.
- A new ADR; keep the 2026-11-22 flat-lessons ADR as history, and supersede only its `lessons/` location clause.
- A minor release with the announcement, banner, and release-practices entry. Leave the v7.1.0 and v7.2.0 announcements and historical release entries unchanged, except the v7.3.1 publication-status correction.

Migration:

- No team store is configured in the current customization, so the protocol can rename cleanly.
- An existing team repository renames `lessons/` to `team-knowledge/` and updates its README and CONTRIBUTING links.
- Clean rename, no fallback. The store is optional and the only known store is a test fixture.

Acceptance criteria:

- No live operational file in the guard set names `lessons/` as the team store path; the policy, publish procedure, boot index, docs, deck, and rebuilt HTML use `team-knowledge/`.
- The fixture root is `tests/team-alpha/`, with `team-knowledge/` and `skills/` siblings; the tests fail on the old path.
- The ADR records the rename; the historical announcement is untouched.
- The validator, suite, markdownlint with a nonzero file count, and shellcheck pass.
- The release documents are approved and published.

Out of scope:

- The repository naming convention, the report-only check, and the optional helper.
- Empty-key edge cases and the proof-note contract change.

Scope history:

- 2026-11-24: The original ticket also covered the team repository naming convention and a report-only check. The plan review showed the combined scope was too large. The naming work moved to `team-repository-naming-convention.md`; this ticket is now the directory rename only.
- 2026-11-24: Plan review ran 13 rounds (review-117 to review-129). The design was stable; the later rounds churned on close-sequence mechanics. The plan was cut from 220 lines to a one-page S note.

Source: the user's request on 2026-11-24.

## Implementation Plan: Rename the team store directory to team-knowledge

## Evidence

- The ticket: `ai/issues/open/team-knowledge-directory-and-repo-naming.md`; the repository naming convention is split to `ai/issues/open/team-repository-naming-convention.md`.
- The live operational references are `ai/policies/ai-policy-team-knowledge.md:44,47`, `ai/procedures/knowledge-publish.md:13`, and `ai/procedures/load-context.md:88`.
- The docs and deck references are `docs/ai-customization-guide.md:66`, `docs/workflow-guide.md:526`, `docs/simple-ai-workflow-slides.md:461`, `docs/slides/diagrams/knowledge-skills.svg:59`, and the generated HTML note at `docs/slides/simple-ai-workflow-slides.html:550`.
- The fixture is `tests/team-knowledge/lessons/` with two lessons; `tests/test-team-knowledge.sh:17,138` names the root and the lesson path.
- The customization template shows the team root at `docs/ai-customization.md:17`.
- The counts are 25 policies, 16 procedures, and 54 triggers; v7.3.1 is live.
- Files read: the ticket; the split ticket; `ai-policy-team-knowledge.md`; `knowledge-publish.md`; `load-context.md`; `ai-policy-common.md`; `ai-policy-issue-management.md`; `ai-policy-code-review.md`; `ai-policy-design-docs.md`; `implement-plan.md`; `test-team-knowledge.sh`; `test-slides.sh`; `test-readme-shape.sh`; `validate-protocol.sh`; the five docs; the SVG; the HTML note; `release-practices.md`; `protocol-decisions.md`.

## Context

The optional team store is the third knowledge scope. It stores one flat lesson per file under `lessons/`. The other two scopes use `global-knowledge/` and `project-knowledge/`. Rename the team directory to `team-knowledge/` and change nothing else.

This is an S ticket. It uses context plus acceptance criteria, not an HLD or LLD. The repository naming convention and the report-only check are a separate ticket.

## Changes

- `ai/policies/ai-policy-team-knowledge.md`: change `## Store Shape` active and retired paths to `team-knowledge/`.
- `ai/procedures/knowledge-publish.md`: change `STEP-WRITE-LESSON` to write under `team-knowledge/`.
- `ai/procedures/load-context.md`: change `STEP-TEAM-KNOWLEDGE-INDEX` to index `team-knowledge/`.
- `tests/test-team-knowledge.sh`: move the fixture root to `tests/team-alpha/`, put the lessons under `team-knowledge/`, add a `skills/` placeholder, assert the new path, and add a live-file guard that fails on `lessons/`.
- `tests/test-slides.sh`: assert the new speaker note and the SVG label, and assert the old note is absent.
- `tests/test-readme-shape.sh`: add `team-knowledge/` to the team phrase list.
- `docs/ai-customization-guide.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, `README.md`, `docs/ai-customization.md`: change the path and the example root.
- `docs/slides/diagrams/knowledge-skills.svg`: change the label to `team-knowledge/` and move the label, title, and subtitle down so the longer label clears the `OPTIONAL` badge at the 24px rendered floor. Rebuild the HTML and render the changed slide; inspect the PNG for label and badge clearance.
- `support-files/validate-protocol.sh`: add `team-knowledge/` anchors for the team policy and the boot step.
- `design-docs/protocol-decisions.md`: add the rename ADR.
- Release: v7.4.0 announcement, README banner, and release-practices entry.

## Acceptance criteria

- No live operational file in the guard set contains `lessons/`; the guard prints `file:line` and passes.
- The policy, publish procedure, boot step, tests, docs, deck note, SVG, and rebuilt HTML use `team-knowledge/`.
- The fixture root is `tests/team-alpha/` and holds `team-knowledge/` and `skills/`.
- The changed team slide PNG shows the `team-knowledge/` label and the `OPTIONAL` badge clear of each other at the 24px rendered floor.
- The ADR records the rename and the historical announcement stays unchanged.
- `support-files/validate-protocol.sh` reports 8/8; `support-files/validate-policy-authoring.sh` passes on the changed policy and procedure; `tests/run-all.sh` passes; markdownlint reports 0 issues on the named files with a nonzero file count; shellcheck passes on the changed tests.
- The v7.4.0 announcement, README banner, and release-practices entry are approved and published.

## Pre-work

- Park the unrelated working-tree changes in a named stash: `ai/notes/notes.md`, `ai/daily-checkpoints/2026-11-23.md`, the closed `configurable-...` ticket, the deleted `configurable-...` plan, `ai/issues/open/slide-deck-review-speed.md`, `ai/shared/project-knowledge/slide-deck-visual-system.md`, and the untracked follow-up tickets. Keep `ai/state/`, today's checkpoint, and `release-practices.md` on the branch.
- Open the branch from clean `master`; add this plan and the ticket in the first branch commit.
- Restore the stash after delivery in the working tree; the deleted config plan stays deleted. Recreate `ai/pending/` if the stash round-trip removes it.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`; base: `master`; branch: `feature/team-knowledge-directory-rename`; merge: direct, one squash commit.
- Ticket: move to `in-progress/` at implementation; attach this plan under `## Implementation Plan`; delete this plan file; move the ticket to `closed/` in the branch commit.
- Validation: run the commands in the acceptance criteria; record each command result in the implementation review report.
- Review: one plan review and one implementation review; fix every Critical and Major finding; re-review.
- Release docs: after the implementation review and before the checkpoint, draft the v7.4.0 announcement, the README banner, the GitHub release body, and the release-practices entry; scrub them; get approval; commit them on the branch, with the v7.3.1 publication correction.
- Checkpoint: run on the branch after the release-docs commit; write today's checkpoint; the closing commit carries the three state files, the diary, the ticket close, and the plan attachment.
- Terminal gate: after the closing commit, resolve `master` to a SHA, confirm the branch is at least one commit ahead, confirm the tree is clean, and append the three results to the implementation review report.
- Ship: squash-merge to `master`, delete the branch, push `master`, run the post-merge validator 8/8, tag the merged `master` commit, push the tag, publish the GitHub Release, and confirm with `gh release view v7.4.0`.
- Done: ticket closed with the plan attached, branch merged and deleted, `master` pushed, tag and release published.

## Peer Review Log

- Round 1: `ai/code-review-reports/2026-11-24_23-10_review-130.md`; APPROVED; 5 Minor; the plan is ready for implementation.
- Round 2: `ai/code-review-reports/2026-11-25_00-15_review-131.md`; APPROVED on the implementation; the terminal gate and the release wait for their steps.

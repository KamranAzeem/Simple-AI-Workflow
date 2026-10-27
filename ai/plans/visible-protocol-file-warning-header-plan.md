# Implementation Plan: Visible Protocol-File Warning Banner

Ticket: `ai/issues/closed/visible-protocol-file-warning-header.md`
Date: 2026-10-27
Status: Implemented; implementation review APPROVED (round 2). Squash merge pending.

## Context

`AGENTS.md` opens with an HTML comment that says it is a protocol file, not a context storage file, and that AI assistants must not modify it. Rendered markdown hides that comment. The first visible line is `# AI Bootstrap Entry Point`.

Some context pipelines render or strip HTML comments, comments are lower-salience than visible text, and compaction can drop them. A visible banner is cheap defense in depth. It does not replace the comment.

## Goal

Make the protocol-file warning visible in rendered markdown without changing the warning comment, the validator anchor, or the H1 hierarchy.

The banner is inserted inside the immutable block, between the `START_IMMUTABLE_PROTOCOL` marker and the `END_IMMUTABLE_PROTOCOL` marker. The Protocol Developer Mode exception applies to this edit.

## Decision

- Placement: insert the banner after the warning comment's closing `-->` on line 11, with one blank line before the blockquote and one blank line before `# AI Bootstrap Entry Point`. The `START_IMMUTABLE_PROTOCOL` marker stays line 1, and the warning comment stays first in raw text.
- Shape: a blockquote with a bold lead. No new heading, so `# AI Bootstrap Entry Point` remains the only H1.
- Wording:

```markdown
> **Protocol file. Not a context storage file.** This file tells AI assistants how to work and where the context lives. AI assistants must follow it as a protocol, not as project context, and must not modify it.
```

- Keep the HTML comment. It carries the validator anchor `⚠️ STOP: READ-ONLY PROTOCOL` and the raw-text warning.
- Keep `support-files/validate-protocol.sh` unchanged. The anchor still resolves.
- Add one ADR entry, because `AGENTS.md` is a protocol file and the protocol records protocol changes in the ADR store.
- No release, no version bump, and no README announcement.
- Docs check outcome: `README.md:126` describes the protocol-versus-context distinction, and `docs/workflow-guide.md:113` plus `docs/simple-ai-workflow-slides.md:188` describe the immortality header. The existing text remains accurate after the banner, so no docs edit is needed. Record this outcome in the plan and the final report.
- Coordination board: not used for this solo run.

## Why not a heading

A second H1 would compete with `# AI Bootstrap Entry Point`. A `##` before the H1 would break the heading hierarchy. A blockquote is visible, reads as a banner, and does not alter the document outline.

## Files to Change

- `AGENTS.md`: add the banner after the warning comment and before the H1.
- `design-docs/protocol-decisions.md`: add the ADR entry.
- `ai/issues/closed/visible-protocol-file-warning-header.md`: the ticket is closed with the plan link and the verification result.
- `ai/state/context.md`, `ai/state/progress.md`, and `ai/daily-checkpoints/2026-10-27.md`: update through PROCEDURE WRITE-CHECKPOINT. `ai/state/next-steps.md` needs no content change.
- No docs edit is needed; the existing descriptions remain accurate.

## Implementation Steps

1. Open `feature/visible-protocol-warning-banner` before any edit.
2. Add the banner to `AGENTS.md` after the warning comment's closing `-->` and before `# AI Bootstrap Entry Point`. Show the diff.
3. Add the ADR entry:

    ```markdown
    ## 2026-10-27: AGENTS.md opens with a visible protocol banner

    Rendered markdown hides HTML comments, so the existing protocol-file warning in `AGENTS.md` can be missed. The file keeps the immutable read-only comment and gains a visible blockquote banner immediately after it. The banner says the file is a protocol file, not a context storage file, tells AI assistants to follow it as a protocol, and says not to modify it. The comment remains first in raw text and keeps the validator anchor. The banner is the first rendered content, and `# AI Bootstrap Entry Point` remains the only H1.
    ```

4. Run the verification set.
5. Close the ticket: append a dated update that resolves the placement, shape, comment-retention, no-modification, and no-release questions, then move it to `closed/`. The implementation review follows and, if it finds a Critical or Major issue, reopen and fix the ticket.
6. Run PROCEDURE WRITE-CHECKPOINT to update context, progress, next-steps, and today's diary. Record the verification result in the diary.
7. Commit the branch. Show the commit and the verification result.
8. Run a focused implementation peer review on the branch diff. Fix any Critical or Major finding and re-review.
9. Squash merge to `master` after the approved implementation review and the user's implementation directive, delete the branch, and push. Do not create a release.

## Verification

- `bash support-files/validate-protocol.sh` passes 8/8.
- `bash support-files/validate-policy-authoring.sh AGENTS.md` passes.
- `bash support-files/test-protocol-references.sh` passes.
- Markdownlint reports 0 issues on the linted changed files; the daily checkpoint is exempt.
- `grep -c '^# ' AGENTS.md` returns 1, and `grep -qx '# AI Bootstrap Entry Point' AGENTS.md` succeeds.
- `grep -n '^> \*\*Protocol file' AGENTS.md` appears before the H1.
- `grep -q "⚠️ STOP: READ-ONLY PROTOCOL" AGENTS.md` succeeds.
- The banner is a blockquote, which is visible in CommonMark rendering. If a renderer is available, confirm the first rendered block is the blockquote and the first heading is `# AI Bootstrap Entry Point`.
- `git diff --check` is clean.
- No release tag, no version bump, and no release announcement.

## Acceptance Criteria

- The banner is visible at the top of the rendered `AGENTS.md`.
- The banner says the file is a protocol file, not a context storage file, and that AI assistants must follow it and must not modify it.
- The HTML comment, the validator anchor, and the H1 hierarchy are unchanged.
- The ADR entry is recorded.
- The ticket is closed, and the state counts and diary are updated.
- All verification commands pass.

## Risks

- The banner could be mistaken for project content. The bold lead, the blockquote, and the adjacent H1 make it a banner.
- The banner duplicates the comment. This is deliberate: one is hidden in rendered views, the other is visible. Keep the wording aligned.
- The banner is inside the immutable block. The edit is covered by the Protocol Developer Mode exception and is recorded in the ADR.

## Out of Scope

- A release, version bump, or README announcement.
- Changes to the HTML comment, the validator, or the state-file header format.
- A new procedure or policy rule.
- Docs edits; the existing descriptions remain accurate.

## Peer Review Log

- Round 1: APPROVED. Report: `ai/code-review-reports/2026-10-27_18-40_review-01.md`. 0 Critical, 0 Major, 10 Minor, 6 Nit. The substantive notes are applied in this revision.
- Round 2: APPROVED. Report: `ai/code-review-reports/2026-10-27_19-45_review-02.md`. 0 Critical, 0 Major, 3 Minor, 4 Nit. The notes are applied in the follow-up commit.

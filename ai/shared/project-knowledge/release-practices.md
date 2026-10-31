> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Release Practices

## Context

The workflow uses semantic versioning. GitHub Releases is the authoritative changelog. Each release also gets a short friendly announcement under `docs/announcements/`, and the README banner links to it.

## Rule or Fix

### Versioning and announcement

- Use `MAJOR.MINOR.PATCH`.
- Create an annotated tag after the merge: `git tag -a vX.Y.Z -m "summary"`.
- Push the default branch and the tag: `git push origin <default-branch> && git push origin vX.Y.Z`.
- Write the release notes on GitHub Releases.
- Write a short announcement at `docs/announcements/vX.Y.Z.md`.
- Point the README banner at the announcement.
- Do not keep a version history in the README or a `RELEASE_NOTES.md` file.

### Release checklist

1. Add a `### vX.Y.Z (date)` section under `## Rule or Fix` with the release highlights.
2. Run markdownlint on the linted set and confirm 0 issues; lint every new markdown file.
3. Finish the docs sweep: slides, workflow guide, README docs list.
4. Write the announcement and point the README banner at it.
5. Keep all release documentation on the feature branch.
6. Squash merge the branch and confirm the validator passes 8/8.
7. Create the annotated tag on the default branch.
8. Push the default branch and the tag.
9. Publish the GitHub Release.

### v5.5.0 (2026-10-31)

- Add a bound `## Close Sequence` to every plan.
- Require plan review to check the close sequence and the terminal gate.
- Gate any close or merge claim on at least one commit ahead of the resolved base and a clean working tree.
- Cover local commits and pushes with feature-branch approval; keep trunk merge, tags, releases, and external writes gated.
- Require every unblocked step before an approval request.
- Record an uncommitted branch as unfinished work.
- Store AI state only under the project root `ai/`, tracked or not.
- Add the procedural-completeness review dimension and four ADRs.
- Upgrade action: none beyond the usual sync.

### v5.4.1 (2026-10-29)

- Replace the 100-line and one-lesson rule with a 10 KB soft target and a 15 KB automatic review.
- Never split; trim and merge; a checklist stays one file; the file count cannot increase.
- Make knowledge files self-standing; remove cross-file pointers; use the self-contained header.
- Make the repair autonomous; no questions; preserve ambiguous content; abort an incomplete file; require an `APPROVED` review before replacement.
- Project knowledge may keep identifying names; global knowledge removes them; raw secrets are banned in both.
- Repair the project and global corpora, the docs, the announcement, the release practices, and the ADRs.
- Upgrade action: run `repair knowledge files` once; add `global` if you keep global knowledge.

## Why

- GitHub Releases gives one authoritative changelog.
- A short announcement answers what changed and what to do.
- A checklist keeps the docs, tag, and release in sync.
- The branch carries the release documentation before the merge.

## Verify

- Confirm the release section is in this file before the merge.
- Confirm markdownlint reports 0 issues.
- Confirm the README banner links to the announcement.
- Confirm the validator passes 8/8.
- Confirm the tag and GitHub Release exist after the merge.

## Caveats

- The announcement is a summary, not a second changelog.
- The release email is optional and uses the announcement as its source.
- The historical release records are not part of the shipped corpus; Git tags and GitHub Releases are the authoritative history.

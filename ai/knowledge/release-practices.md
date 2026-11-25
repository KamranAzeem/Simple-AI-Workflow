> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Release Practices

## Context

The workflow uses semantic versioning. GitHub Releases is the authoritative changelog. Each release also gets a short friendly announcement under `docs/announcements/`, and the README banner links to it.

## Rule or Fix

### Versioning and announcement

- Use `MAJOR.MINOR.PATCH`.
- Create an annotated tag after the merge: `git tag -a vX.Y.Z -m "summary"`.
- Push the default branch and the tag: `git push origin <default-branch> && git push origin vX.Y.Z`.
- Draft the announcement, the banner, and the GitHub release body in a temp file first.
- Show the exact draft to the user and wait for the user's edits and approval before writing the final files or publishing.
- Write in the user's first-person voice from the user settings (`### Voice`, `### Structure`, and `### Words and Phrases to Avoid`).
- Put the reason before the detail in the announcement.
- Explain each internal term in plain words the first time it appears, and do not write a changelog.
- Never invent an event, feeling, or reason the user did not state.
- Write the release notes on GitHub Releases.
- Write a short announcement at `docs/announcements/vX.Y.Z.md`.
- Point the README banner at the announcement.
- Do not keep a version history in the README, a `RELEASE_NOTES.md` file, or a knowledge file.

### Release checklist

1. Confirm the release is recorded in the GitHub Release and the announcement; do not add a release history section to this file.
2. Run markdownlint on the linted set and confirm 0 issues; lint every new markdown file.
3. Finish the docs sweep: slides, workflow guide, README docs list.
4. Write the announcement and point the README banner at it.
5. Keep all release documentation on the feature branch.
6. Squash merge the branch and confirm the validator passes 8/8.
7. Create the annotated tag on the default branch.
8. Push the default branch and the tag.
9. Publish the GitHub Release.

## Why

- GitHub Releases gives one authoritative changelog.
- A short announcement answers what changed and what to do.
- A checklist keeps the docs, tag, and release in sync.
- The branch carries the release documentation before the merge.

## Verify

- Confirm the release is recorded in the GitHub Release and the announcement before the merge.
- Confirm markdownlint reports 0 issues.
- Confirm the README banner links to the announcement.
- Confirm the validator passes 8/8.
- Confirm the tag and GitHub Release exist after the merge.

## Caveats

- The announcement is a summary, not a second changelog.
- The release email is optional and uses the announcement as its source.
- The historical release records are not part of the shipped corpus; Git tags and GitHub Releases are the authoritative history.

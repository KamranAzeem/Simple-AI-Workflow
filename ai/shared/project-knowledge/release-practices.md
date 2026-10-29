> **Knowledge file.** Follow `ai-policy-common.md`, section `## Knowledge File Standards`. This header is canonical: copy it verbatim and do not edit it. If it is missing, run `repair knowledge files`.

# Release Practices

## Context

The workflow uses semantic versioning. GitHub Releases is the authoritative changelog. Each release also gets a short friendly announcement under `docs/announcements/`, and the README banner links to it.

## Rule or Fix

### Versioning and announcement

- Use `MAJOR.MINOR.PATCH`.
- Create an annotated tag after the merge: `git tag -a vX.Y.Z -m "summary"`.
- Push the branch and the tag: `git push origin master && git push origin vX.Y.Z`.
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
7. Create the annotated tag on `master`.
8. Push `master` and the tag.
9. Publish the GitHub Release.

### v5.4.0 (2026-10-29)

- Add one shared knowledge capture pass, one knowledge file standard, and the canonical knowledge header.
- Add the conservation-gated `repair knowledge files` procedure and the report-only checkpoint hygiene flag.
- Repair the project and global knowledge corpora.
- Include the visible protocol-file banner, the Matt Pocock backlog cleanup, and the sync-script self-exclusion fix.
- Include the work-item branch and plan lifecycle.
- Upgrade action: run `repair knowledge files` once; run `repair knowledge files global` when you keep global knowledge.

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

# Release Practices

## Versioning

- Use [Semantic Versioning](https://semver.org/): `v1.0.0`, `v1.1.0`, `v2.0.0`, etc.
- Tags are created locally: `git tag -a v1.0.0 -m "summary"` then pushed: `git push origin v1.0.0`
- Release notes are written directly on GitHub Releases, which is the authoritative changelog. No `RELEASE_NOTES.md` file is maintained.
- No version history section in README.md or any other file. Git tags plus the GitHub Release are the authoritative changelog; `docs/announcements/` holds a short friendly note per release (see Announcements below).

## First Release

- v1.0.0: Initial release. Created 2026-05-30.
- Release notes covered: features, changes in this release (metadata header removal, Project Knowledge Protocol, Universal Engineering Standards, curated traits catalog, sync script fixes, Markdown Styling Guide, state file consistency).

## v3.0.0 (2026-09-22)

- **MAJOR**: the full history was rewritten to purge sensitive identifiers, so existing clones must run `git fetch origin && git reset --hard origin/master`. All tags were recreated.
- **Features**: issue management (`ai/issues/` with `open/`, `in-progress/`, `closed/`), State-File Model v2 with `"repair state files"`, the bounded boot-time staleness heuristic, the self-consistency check, `"Untried is not impossible"`, and the agent-facing documentation dimension in peer review.
- **Privacy**: a sensitive-name guardrail in the global settings, and a full history purge with no credentials found.
- **Docs**: README overhaul, global user settings template (Git configuration guide, CLI tools by role), slides and workflow guide synced, documentation cleanup, markdownlint clean.

## v4.0.0 (2026-10-06)

- **MAJOR**: procedures, steps, and tiers were renamed from letters and numbers to stable ALL-CAPS kebab names, so old references like "Procedure A" no longer match live files. Migration map: `protocol-name-migration-map-2026-10-06.md`.
- **Behavior**: Global Knowledge is now JIT-indexed at boot, on reload, and on Post-Compaction Recovery instead of fully loaded; the 90-day staleness flag covers both knowledge sets; each procedure gained an Aliases line of user phrases.
- **Policy**: pre-work commits on `master` are banned, and every protocol or policy change requires an ADR entry; a canonical-reference-names rule forbids letter and number references.
- **Tooling**: validator v6.0 with updated anchors and a no-letter/no-number guard; new `support-files/test-protocol-references.sh`; sync scripts updated.
- **Docs**: migration map and README banner; workflow guide, slides, agent-collaboration, codebase-examination guide, and examples updated.

## v5.0.0 (2026-10-12)

- **MAJOR**: design documents moved beside the code into `design-docs/`, never under `ai/`. Existing documents under `ai/shared/project-knowledge/` are grandfathered and migration is optional: say `"migrate design docs"`.
- **Standards**: the design-documentation standards were rewritten. The chain is `Notes -> Vision -> PRD -> HLD -> LLD (with AC) -> Risk and Gap Analysis -> ADRs -> Delivery Ledger`, with `RSK-NNN` risks, decision-only ADRs, MVP-first requirements, proportional and role-aware depth, and layering.
- **Features**: the issue-management workflow, the consolidated `Markdown Output` policy with a stricter `.markdownlint-cli2.jsonc`, author-identity and identifying-names rules, and the Grilling and Brainstorming modes.
- **Store**: the protocol ADR store is now `design-docs/protocol-decisions.md` and holds design decisions only.
- **Docs**: README banner, `docs/announcements/v5.0.0.md`, workflow-guide section 22, and a slides bullet.

## Announcements

- Each release gets a short, friendly note at `docs/announcements/vX.Y.Z.md`. It answers "what changed for me, and what should I do", in plain language.
- Role split: the GitHub Release is the exhaustive, authoritative changelog; the announcement is a friendly summary that links to the release. Do not duplicate the full changelog in the announcement.
- The README banner links to the latest announcement.
- The announcement doubles as the source for the release email.
- Release email sent: the v5.0.0 announcement was emailed to the primary users on 2026-10-12.

## Release Checklist

1. Confirm the feature branch is squash-merged to `master` and the validator passes 8/8.
2. Add the release's `## vX.Y.Z (date)` section to this file with the release highlights, so the release history never falls behind.
3. Run markdownlint on the linted set (the repository minus the four ignored directories in `.markdownlint-cli2.jsonc`) and confirm 0 issues. Lint every new markdown file, not just the files you edited.
4. Finish the release-prep docs sweep (slides, workflow guide, README docs list).
5. Write the friendly announcement at `docs/announcements/vX.Y.Z.md` and point the README banner at it.
6. Create the annotated tag on `master`: `git tag -a vX.Y.Z -m "summary"`.
7. Push `master` and the tag: `git push origin master && git push origin vX.Y.Z`.
8. Write the release notes on GitHub Releases (the authoritative changelog; no version file).

# Release Practices

## Versioning
- Use [Semantic Versioning](https://semver.org/) — `v1.0.0`, `v1.1.0`, `v2.0.0`, etc.
- Tags are created locally: `git tag -a v1.0.0 -m "summary"` then pushed: `git push origin v1.0.0`
- Release notes are written directly on GitHub Releases — no `RELEASE_NOTES.md` file maintained.
- No version history section in README.md or any other file. Git tags + GitHub Releases are the sole source of truth.

## First Release
- v1.0.0 — Initial release. Created 2026-05-30.
- Release notes covered: features, changes in this release (metadata header removal, Project Knowledge Protocol, Universal Engineering Standards, curated traits catalog, sync script fixes, Markdown Styling Guide, state file consistency).

## Next Release (planned)
- **v2.4.0** — history purge and sensitive-name guardrail, issue management, State-File Model v2, self-consistency check, "Untried is not impossible", agent-facing documentation in peer review, README overhaul and global user settings template, and the documentation cleanup.

## Release Checklist
1. Confirm the feature branch is squash-merged to `master` and the validator passes 8/8.
2. Run markdownlint on all tracked markdown and confirm 0 issues.
3. Finish the release-prep docs sweep (slides, workflow guide, README docs list).
4. Create the annotated tag on `master`: `git tag -a vX.Y.Z -m "summary"`.
5. Push `master` and the tag: `git push origin master && git push origin vX.Y.Z`.
6. Write the release notes on GitHub Releases (the sole source of truth; no version file).

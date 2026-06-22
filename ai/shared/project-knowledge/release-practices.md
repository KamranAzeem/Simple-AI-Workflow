# Release Practices

## Versioning
- Use [Semantic Versioning](https://semver.org/) — `v1.0.0`, `v1.1.0`, `v2.0.0`, etc.
- Tags are created locally: `git tag -a v1.0.0 -m "summary"` then pushed: `git push origin v1.0.0`
- Release notes are written directly on GitHub Releases — no `RELEASE_NOTES.md` file maintained.
- No version history section in README.md or any other file. Git tags + GitHub Releases are the sole source of truth.

## First Release
- v1.0.0 — Initial release. Created 2026-05-30.
- Release notes covered: features, changes in this release (metadata header removal, Project Knowledge Protocol, Universal Engineering Standards, curated traits catalog, sync script fixes, Markdown Styling Guide, state file consistency).

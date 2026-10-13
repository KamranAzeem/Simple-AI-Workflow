Reported: 2026-10-12
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Update docs, slides, and release notes for the design-docs change, with a breaking-change banner
Label:

Description:

Documentation and release handling for the design-docs change. Depends on the standards rewrite and the location/indexing tickets.

Requirements:

- Update `docs/workflow-guide.md` and `docs/simple-ai-workflow-slides.md` for the design-docs location, the chain, and proportional depth.
- Add a README banner at the top and a `docs/announcements/` note for the breaking change.
- Add an upgrade section describing the optional migration.
- Bump the version (major).

Acceptance criteria:

- Docs and slides reflect the change; the README banner and announcement exist; the upgrade section is present; the version is bumped.
- markdownlint 0 on the edited files.

---
2026-10-12
Plan: `ai/plans/design-docs-release-and-docs-plan.md`.

Closed on branch `feature/design-docs-release`. Bumped to v5.0.0, updated the README banner, added `docs/announcements/v5.0.0.md`, added workflow-guide section 22, and a design-documents slide bullet. Verified: markdownlint 0, validator v6.0 8/8, reference test PASS. Peer review review-28 APPROVED. Tagging and publishing the release is a separate step.

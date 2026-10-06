Reported: 2026-10-06
Reporter: Kamran Azeem (via Kilo)
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Add a docs/announcements/ directory for short, friendly per-release announcements, separate from the authoritative GitHub Release notes.

Description:

## Request

Add `docs/announcements/` with one short, friendly announcement per release, for example `docs/announcements/v4.0.0.md`. The announcement answers "what changed for me, and what should I do" in plain language. The GitHub Release stays the exhaustive, authoritative changelog.

## Role split (to avoid drift)

- **GitHub Release**: the exhaustive changelog, every change, authoritative.
- **`docs/announcements/vX.Y.Z.md`**: a short, friendly summary that links to the release. Not a changelog.
- **README banner**: links to the latest announcement instead of carrying the full notice in the table.

## Scope

- Create `docs/announcements/v4.0.0.md` from the existing announcement email (`ai/artifacts/simple-ai-workflow-v4.0.0-release-announcement-email.md`).
- Update the README banner to link the latest announcement.
- Update `release-practices.md`: add an announcement step to the Release Checklist, and soften the "sole source of truth" wording so the two surfaces do not compete.
- Record an ADR entry in `protocol-decisions.md`.
- No `docs/announcements/README.md` index (decided: skip it).

## Acceptance criteria

- `docs/announcements/v4.0.0.md` exists, reads as a short friendly note, and links to the v4.0.0 GitHub Release.
- The README banner points to it.
- `release-practices.md` documents the announcement role and the checklist step.
- ADR entry recorded.
- markdownlint clean; validator 8/8.

---

2026-10-06
Implemented on branch `feature/docs-announcements`. Added `docs/announcements/` with the v4.0.0 announcement, pointed the README banner at it, and updated `release-practices.md` with the announcement role split and a Release Checklist step. Recorded the ADR entry. No index file, per request. Validator 8/8, reference test PASS, markdownlint 0. Peer review review-09 CHANGES REQUESTED (map location), review-10 APPROVED. Closed by the squash merge into `master`.

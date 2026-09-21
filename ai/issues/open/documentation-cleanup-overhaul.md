Reported: 2026-09-20
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P3
Size: L
URL:
Summary: General documentation cleanup and overhaul against inaccuracies and staleness

Description:

Sweep all user-facing documentation for inaccuracies and stale content, and fix it. Scope: README, `docs/` (workflow guide, guides, slides, examples), and the AGENTS.md-facing explanations.

Known issues to address:
- The README has confusing areas.
- The examples need improvement.

What to look for:
- Inaccuracies: statements that no longer match the protocol (renamed paths, changed behavior, removed features, wrong counts).
- Staleness: outdated examples, version numbers, feature lists, and references.
- Broken or drifting cross-references and links.

Do it in reviewable batches, not one mass edit. Split out work that needs its own ticket.

Acceptance criteria:
- Every user-facing doc file is reviewed against the current protocol.
- Inaccuracies and stale content are fixed, or split into their own tickets.
- Links and cross-references resolve.
- markdownlint clean and validator green.

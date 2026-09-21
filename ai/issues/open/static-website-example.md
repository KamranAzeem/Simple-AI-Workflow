Reported: 2026-09-20
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P3
Size: M
URL:
Summary: Add a simple static website example, with and without design docs

Description:

Add a clear, minimal worked example that a newcomer can follow end to end. Two variants:
- Variant A: no design documents. Show the plain workflow: bootstrap, load context, build, checkpoint.
- Variant B: with design documents. Show the Notes, Vision, PRD, HLD, LLD, ADR, and Delivery Ledger flow driving the build.

Place each variant under `docs/examples/` and link both from the README examples section.

Acceptance criteria:
- Two runnable walkthroughs exist for the same small static site.
- Variant B shows the design chain in order, and how the AI checks for missing docs.
- Both link from the README and use real commands.

Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: P4
Size: M
URL:
Summary: Rework Post-Compaction Recovery precedence so resume can read authoritative state

Description:

Today, Post-Compaction Recovery treats the compaction summary as the sole source of truth and deliberately does not read the three state files, because the on-disk files may be older than the fresh summary.

The proposed rework: allow recovery to read the latest checkpoint and the state files when they are authoritative (single-writer, fresher than a lossy summary), and reconcile the two. This is marked breaking because it reverses a deliberate safety rule.

Not urgent. Deferred from the 2026-06-30 state-ownership work (CP-2026-06-30-02).

Acceptance criteria:
- A design that defines precedence between the summary and the state files.
- State files are never read during recovery before that precedence rule is satisfied.
- Validator anchors updated and green.

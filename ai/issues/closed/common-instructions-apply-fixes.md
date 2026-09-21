Reported: 2026-09-20
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P4
Size: S
URL:
Summary: Add an "apply fixes" common instruction after a review

Description:

The "Common instructions" table should include a phrase to apply the fixes from a peer-review or code-review report. Proposed phrase: "apply fixes".

Behavior: read the latest report, apply the fixes, and note which findings were resolved.

Acceptance criteria:
- README "Common instructions" table has a row for applying fixes after a review.
- The phrase is also covered in the workflow guide if it lists review phrases.

---
2026-09-20
Implemented on branch `docs/readme-overhaul`. The Common instructions table now has two rows: `"perform a code review on <topic>"` and `"apply fixes for problems identified in code review report"`. The duplicate code-review phrase was removed from the "Review and maintenance phrases" list. The workflow guide documents peer review as a mode and does not carry the common-instruction phrase list, so no change was needed there. Pending merge.

---

2026-09-22

Closed as part of the `docs/readme-overhaul` squash merge into `master`. Both review phrases are in the README Common instructions table, and the build is lint-clean.

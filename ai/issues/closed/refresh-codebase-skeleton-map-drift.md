Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: The Level 0 skeleton map has stale issue counts and points at a closed ticket as in-progress.

Description:

`ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md` is the Level 0 navigation map. Four parts are stale.

- Line 32 says "8 open, 0 in-progress, and 148 closed as of 2026-11-26". The live tree is 6 open, 0 in-progress, and 152 closed.
- Line 34 says "14 durable project lessons". Live `ai/knowledge/` holds 16 lessons plus `issue-template.md` and the map.
- Line 73 names `ai/issues/in-progress/global-to-workflow-policy-terminology.md`. That ticket is in `ai/issues/closed/`, and `ai/issues/in-progress/` holds only `.gitkeep`.
- The caveat at line 90 says the snapshot is 2026-11-25.

Resolution:

- Refresh the counts, fix the pointer, and set the snapshot date.
- Recount the live tree before writing.

Acceptance criteria:

- The map's counts match the live tree at the time of the fix.
- No pointer names a file outside its current directory.

---
2026-11-26
Filed from the 2026-11-26 codebase examination. Evidence group F3. No secret or identifying name present.

---
2026-11-26
Closed in the docs batch; the plan is attached to the F2 ticket `ai/issues/closed/stale-global-scope-token-in-validation-doc-and-spec.md`. Implementation review 197 APPROVED. No release.

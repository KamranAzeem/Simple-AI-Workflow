Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: The README docs index omits three top-level guides.

Description:

- `docs/ai-policy-mobile-apps-guide.md` has no inbound link from the README or any guide. It appears only in `tests/test-docs-audit.sh:92` and closed tickets.
- `docs/custom-policy-howto.md` is linked from `docs/workflow-guide.md:227` and `docs/ai-customization-guide.md:58`, but not from the README index.
- `docs/post-compaction-reload-trigger-setup.md` is linked from `docs/workflow-guide.md:174` and `docs/ai-provider-selection-guide.md:131`, but not from the README index.
- The README docs index is `README.md:200` through `README.md:218`.

Impact: discoverability only. No broken link exists.

Resolution:

- Add the three entries to the README index.
- Or record why the mobile guide is intentionally out of the index and make the docs audit assert that decision.

Acceptance criteria:

- The README index covers every top-level doc, or the omission is documented and tested.

---
2026-11-26
Filed from the 2026-11-26 codebase examination. Evidence group F5. No secret or identifying name present.

---
2026-11-26
Closed in the docs batch; the plan is attached to the F2 ticket `ai/issues/closed/stale-global-scope-token-in-validation-doc-and-spec.md`. Implementation review 197 APPROVED. No release.

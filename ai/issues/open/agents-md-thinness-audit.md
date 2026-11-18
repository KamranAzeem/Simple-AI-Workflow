Reported: 2026-11-17
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: L
Label:
URL:
Summary: Audit AGENTS.md for bloat, thinness, and protocol wiring, and report the refactoring backlog

Description:

- `AGENTS.md` is 157 lines and 16,869 bytes, close to the 160-line thin cap, and several bullets carry very long sentences.
- Audit scope: `AGENTS.md`, its size and sentence shape, duplicate rules against the common policy, and the policy and procedure wiring it dispatches to.
- The audit produces a peer review report with findings and a prioritized refactoring list. It does not change any file.
- A full codebase examination of `docs/`, `tests/`, and `support-files/` is a separate phase. This ticket records it as a follow-up, not part of the first report.
- The review report is written to `ai/code-review-reports/` and linked from this ticket.

## Acceptance Criteria

- The report measures lines, words, bytes, and long sentences against the thin targets.
- The report lists every rule duplicated between `AGENTS.md` and the common policy, with the owner for each.
- The report maps each policy and procedure to its trigger or load path, and flags any orphan.
- The report classifies each candidate move as read-first, common-policy, procedure, or boot-policy, with the ordering constraint.
- The report gives a prioritized refactoring backlog and a verdict.
- No file other than the report and this ticket changes.

## Out of Scope

- Applying the refactor.
- The full codebase examination.
- The tool-selection and common-policy prose-shape work already tracked.

---
2026-11-17
Peer review complete. Report: `ai/code-review-reports/2026-11-17_22-19_review-01.md`. Verdict: CHANGES REQUESTED. Top findings: `AGENTS.md` is at 157/160 lines and 2,399/2,400 words; nine bullets exceed 350 characters; the Single-Writer bullet duplicates the common policy; the boot scan exclusions and the shared index steps are procedural detail in the router; 13 of 23 policies lack an explicit `## Loading` Mode. No protocol file changed.

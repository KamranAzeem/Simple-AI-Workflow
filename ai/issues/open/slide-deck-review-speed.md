Reported: 2026-11-24
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: The full slide-deck review took 47 minutes; add deterministic checks and a diff-scoped verification loop.

Description:

The 2026-11-24 full deck review took about 47 minutes: two full 59-slide visual passes, a voice pass over 59 speaker notes and five guide sections, five visual reviewers, one implementation peer review, and one fix round. The render is about 6 minutes; the repeated AI reading of 59 PNGs and the review and fix rounds are the rest.

Proposed for the next iteration:

- Run a deterministic geometry and style check first: a fixture that rejects inline font-size overrides below 24 units, scans the SVGs for labels below 24 units, and measures the rendered text bounds with headless Chrome or Playwright for overflow, clipping, and caption overlap.
- Review only the slides the checker flags; keep the 59-slide render as the record.
- After the fixes, verify only the changed slides with the checker and a visual diff; skip the second full pass.
- Fix the systemic causes in one sweep: the inline font-size overrides, the template's right and bottom padding, and the caption baselines.
- Scope the implementation peer review to the diff and the plan's acceptance criteria.
- Add the inline-size guard and the geometry check to `tests/test-slides.sh`.
- Target under 15 minutes for the next full pass.

Source: the user's feedback on 2026-11-24; the deck review plan `ai/plans/full-slide-deck-review.md`; the review reports 110-113.

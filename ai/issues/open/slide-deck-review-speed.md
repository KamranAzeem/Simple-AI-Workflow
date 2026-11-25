Reported: 2026-11-24
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: The full slide-deck review took 47 minutes; keep the audit-first loop and the cheap guards, and drop the new browser dependency.

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

---

2026-11-24

Scope trimmed after an evidence-based investigation. This update supersedes the proposed scope above.

Keep:

- Static 24-unit guard: scan every `docs/slides/diagrams/*.svg` and the deck for inline font sizes below 24, and fail the fixture on a hit. This is about 10 lines and needs no browser. It would have caught the four below-24 overrides in review-113.
- Exact counts: keep the 59-slide check and assert 59 PNGs after a full render. Review-110 found the old fixture accepted "at least 30".
- Subset render: add a slide list or range to `render-slides-preview.sh` so a fix round re-renders only changed slides. Keep one full render as the record.
- Audit-first loop: document it in `ai/shared/project-knowledge/slide-deck-visual-system.md`. Build, audit, render, inspect only flagged plus changed slides, one diff-scoped peer review, no second full pass. Review-115 used this loop and approved.
- Flake fix: wait for `document.fonts.ready` before the audit measures, or vendor the fonts. Review-115 recorded a false 940/930 while the webfont loaded.

Drop:

- Playwright. No `package.json`; Chrome and Python already work; the scripts promise no installation.
- The Chrome geometry audit inside `tests/test-slides.sh`. The suite is 31 shell tests that run no browser and use no network, while the template loads reveal.js and Google Fonts from CDNs.
- SVG caption-overlap and internal-layout detection. The audit sees each SVG as one `<img>` and would catch none of review-113's nine layout findings. That is a new tool, not a test tweak.

Acceptance criteria:

- The fixture fails on any SVG or inline font size below 24.
- The fixture asserts 59 slides and 59 PNGs after a full render.
- The renderer accepts a slide range and renders only those slides.
- A full audit reports 59 audited and 0 overflow, with no font-load false positive when run right after the renderer.
- The visual-system knowledge file states the audit-first loop.

Evidence: the audit ran 59 slides with 0 overflow in 2.97s on 2026-11-24; reviews 110, 113, and 115; commit `5f860b3` already added the audit and fixed the template sizes. Estimated effort: about 1-2 hours.

---

2026-11-24

Deferred by the user with the presentation policy. Do not plan or implement until the user reopens it.

- The trimmed scope above stays the agreed scope when work resumes.
- The user also questions whether `support-files/build-slides-html.sh` earns its place; leave it unchanged until this ticket resumes.

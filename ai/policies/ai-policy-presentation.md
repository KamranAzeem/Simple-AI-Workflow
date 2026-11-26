# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Presentation

Apply one presentation standard to every slide deck and its diagrams.

## Triggers

- presentation standards

## Loading

- Mode: trigger

## Scope

- Apply this policy to a slide deck, a talk, a handout, and the diagrams in them.
- This policy owns the narrative shape, the layout, the type and palette, the source of truth, the diagram pipeline, and the review.
- The project-specific visual system stays in the project knowledge.
- The common policy keeps the presentation invariant and points here.

## Narrative

- Make the slide title the assertion.
- Use a Problem, Solution, Proof arc when it fits.
- Keep one idea per slide.
- Make the appendix a complete reference catalog when the deck is a reference.

## Layout

- Use a full-slide diagram when the visual is the point.
- Bound the text and do not build a bullet wall.
- Remove the bullet list and the paragraph when the diagram carries the slide.

## Type and Palette

- Use one type scale: 2.4rem body, 1.9rem appendix, and a 3.3rem diagram-slide title.
- Keep every generated diagram label at 32 units or above.
- Keep a legacy hand-authored SVG at 24 units or above until it is converted.
- Use the teal and slate palette and do not add stock art.

## Source of Truth

- Treat the Markdown deck as canonical.
- Generate the HTML deck from the Markdown.
- Keep each diagram source beside the generated SVG.
- Rebuild the deck after a content or diagram change.

## Diagram Pipeline

- Use D2 by default.
- Use Mermaid only for a flow or sequence that D2 handles poorly.
- Keep one source per diagram in `docs/slides/diagrams/src/`.
- Record each diagram as source-backed or legacy with a reason in `docs/slides/diagrams/manifest.tsv`.
- Generate the SVG with `support-files/build-slide-diagrams.sh`.
- Never hand-edit a generated SVG.
- Keep a diagram that the guide already carries; do not redraw it.
- Keep the deck's six-level ladder as the ladder standard.

## Review

- Run the static guard, the build, and the render.
- Inspect only the changed or flagged slides.
- Run one diff-scoped peer review.
- Do not read every rendered PNG in a full pass.
- Target under 15 minutes for a full build, render, and review.

## References

- `ai-policy-common.md` (`## Markdown Output`).
- `ai-policy-meta.md` (`## Procedure and Policy Authoring`).
- `PROCEDURE IMPLEMENT-PLAN`.

<!-- AI-ASSISTANT: READ-ONLY END -->

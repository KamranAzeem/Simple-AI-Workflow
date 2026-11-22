> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Slide deck visual system

## Context

The slide deck is the canonical Markdown story at `docs/simple-ai-workflow-slides.md`, with its SVGs beside it. The local reveal.js preview and the headless renderer turn it into per-slide PNGs for review. The deck teaches the protocol and doubles as a reference.

## Rule or Fix

- Use 1.6rem body and appendix type on the deck; keep the story slides and the catalog on the same type scale.
- Render diagram slides at 78vh and pure diagrams at 88vh; give a dense diagram a smaller type scale than a concept diagram.
- Use three acts: Concepts, The Workflow, Proof; keep the optional team act behind a gate. Put a section divider before each act.
- Make the slide title the assertion. Put a caption inside the SVG only when it adds a different idea; do not repeat the slide title in the SVG.
- When a diagram carries the slide, remove the bullet list and the paragraph. The preview gives the image 88vh only when the slide has an SVG and no list or paragraph; a list drops it to the small generic image height.
- Make the appendix a full catalog: name every policy and procedure with one line of explanation, grouped by job.
- Use one column for the appendix at 1.6rem; a two-column layout overflows at that size.
- Format each catalog line as a bold policy or procedure name, an em dash, and one sentence.
- Keep one idea per story slide; use a full-slide diagram instead of a small image on a sparse slide.
- Use the teal and slate palette and the axe photo; do not add stock art.
- Enlarge SVG text with a style block of attribute selectors. Use a smaller scale for a dense diagram, and fix the layout or the scale rather than shrinking the whole diagram.
- Read the reveal.js hash as zero-based: `#/32` is the 33rd slide, and its rendered PNG is `slide-33.png`.
- Check every rendered PNG for overlap after a type or layout change.
- Treat the Markdown as canonical and Google Slides as a manual copy after Gate 1.

## Why

The deck teaches and then serves as a reference. A uniform type scale and a complete catalog keep it readable, and full-slide diagrams use the space instead of leaving a small image in a large slide. The slide is the teaching unit: if the diagram is the point, it must fill the slide. A list plus a small image is the failure mode to remove.

## Verify

- Run `bash tests/test-slides.sh`; the fixture checks the story, the catalog groups, all 25 policies, all 16 procedures, the SVG assets, the preview, and the renderer.
- Run `bash support-files/render-slides-preview.sh` and inspect the PNGs; `#/32` maps to `slide-33.png`.
- Confirm 1.6rem body and appendix type and 78vh/88vh diagram sizes.
- Confirm every catalog group is present: Setup, Daily loop, Memory, Quality, Delivery, Maintenance, Team, Compliance, Domain expertise, Traits and skills, Commands.

## Caveats

- Google Slides may not preserve the SVG's internal type rules; check each inserted diagram at its final size and adjust it there.
- Dense diagrams need a smaller scale; uniformity is the target, not one identical size for every label.

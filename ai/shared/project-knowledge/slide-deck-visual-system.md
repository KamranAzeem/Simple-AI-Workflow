> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Slide deck visual system

## Context

The slide deck is the canonical Markdown story at `docs/simple-ai-workflow-slides.md`, with its SVGs beside it. The reveal.js HTML at `docs/slides/simple-ai-workflow-slides.html` and the headless renderer turn it into per-slide PNGs for review. The deck teaches the protocol and doubles as a reference.

## Rule or Fix

- Use 2.4rem body and 1.9rem appendix type on the deck; the title slide is 1.5rem, the section prompts 1.8rem, the section list 1.65rem, and the diagram-slide title 3.3rem with a 1.9rem subtitle.
- Render diagram slides at 84vh and pure diagrams at 98vh. Keep every SVG label at 24 units or above; when a dense diagram cannot fit that floor, record the exception with the slide and the reason in the findings log.
- Use three acts: Concepts, The Workflow, Proof; keep the optional team act behind a gate. Put a section divider before each act.
- Make the slide title the assertion. Put a caption inside the SVG only when it adds a different idea; do not repeat the slide title in the SVG.
- When a diagram carries the slide, remove the bullet list and the paragraph. The HTML deck gives the image 98vh only when the slide has an SVG and no text; a title or a list keeps the diagram-slide height.
- Make the appendix a full catalog: name every policy and procedure with one line of explanation, grouped by job.
- Use one column for the appendix at 1.9rem; a two-column layout overflows at that size.
- Format each catalog line as a bold policy or procedure name, a colon, and one sentence.
- Keep one idea per story slide; use a full-slide diagram instead of a small image on a sparse slide.
- Use the teal and slate palette and the axe photo; do not add stock art.
- Enlarge SVG text with a style block of attribute selectors. Raise each label to 24 units or above, and fix the layout rather than shrinking the whole diagram; a dense diagram that cannot meet the floor keeps a recorded exception.
- Read the reveal.js hash as zero-based: `#/32` is the 33rd slide, and its rendered PNG is `slide-33.png`.
- Check every rendered PNG for overlap after a type or layout change.
- Treat the Markdown as canonical and Google Slides as a manual copy after Gate 1.
- Use the PPTX proficiency ladder with six levels: 0, 1, 2 (editor chat: project assistant, context, memory, tools, 100% of the work), 3 (multiple assistants), 4 (MCPs), and 5 (agentic/swarm mode). Levels 3-5 are normal and unlabelled; only level 2 carries the workflow mark. Never call them rungs.
- Name the multi-repo root for the customer, for example `customer-joe/`, not a generic solution root.
- Keep the ticket, issue, and support-request slide to those three records; an idea enters through the idea intake, not that slide.
- Draw the quality loop as acceptance criteria, test first, implement, peer review, ship, and design docs; connect every arrowhead to a box edge.
- Put the model card in the middle of the three-part assistant diagram: memory left, model middle, tools right.
- The compaction diagram uses 77vh with the 2.4rem body; it is a fitted special height.
- Draw loop arrows at 3px with a small 5-unit marker; start and end each arrow on the box edge, and use straight or smooth cubic segments.

## Why

The deck teaches and then serves as a reference. A uniform type scale and a complete catalog keep it readable, and full-slide diagrams use the space instead of leaving a small image in a large slide. The slide is the teaching unit: if the diagram is the point, it must fill the slide. A list plus a small image is the failure mode to remove.

## Verify

- Run `bash tests/test-slides.sh`; the fixture checks the story, the catalog groups, all 25 policies, all 16 procedures, the SVG assets, the HTML deck, and the renderer.
- Run `bash support-files/audit-slides.sh`; a clean deck reports 59 audited and 0 overflow.
- Run `bash support-files/render-slides-preview.sh` and inspect the PNGs; `#/32` maps to `slide-33.png`.
- Confirm 2.4rem body and 1.9rem appendix type, 84vh/98vh diagram sizes, and every SVG label at 24 units or above or recorded as an exception.
- Confirm every catalog group is present: Setup, Daily loop, Memory, Quality, Delivery, Maintenance, Team, Compliance, Domain expertise, Traits and skills, Commands.

## Caveats

- Google Slides may not preserve the SVG's internal type rules; check each inserted diagram at its final size and adjust it there.
- Dense diagrams may keep a smaller scale only as a recorded exception with the slide and the reason; uniformity is the target, not one identical size for every label.
- `support-files/audit-slides.sh` measures HTML element boxes only; it sees each SVG as one image. Inspect the rendered PNGs for SVG-internal overlap, clipping, and margins.

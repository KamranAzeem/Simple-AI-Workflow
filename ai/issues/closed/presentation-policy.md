Reported: 2026-11-23
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Add a presentation policy so slide decks share one visual and structural standard

Description:
Add a workflow policy for presentation decks. The recent Simple AI Workflow deck is the reference standard.

The policy should cover:

- Narrative shape: assertion headlines, a Problem, Solution, Proof arc where it fits, and one idea per slide.
- Layout: a full-slide diagram when the visual is the point, bounded text, and no bullet walls.
- Type and palette: one type scale, a readable minimum size, a consistent palette, and no decorative stock art.
- Appendix: a complete reference catalog when the deck is a reference, with one line per item.
- Source of truth: Markdown is canonical; a published slide copy is downstream.
- Review: render and inspect the actual slides before sign-off; check overflow, legibility, links, and crops.
- Loading and scope: decide whether this is a workflow policy loaded by trigger or Active Expertise, and what stays in the project-level slide deck visual-system lesson.
- Policy authoring: follow `ai-policy-meta.md`; update the validator, docs, tests, ADR, and release when the policy floor changes.

The reference material is `docs/simple-ai-workflow-slides.md` and the project lesson in `ai/shared/project-knowledge/slide-deck-visual-system.md`. Extract the reusable rules, not the project-specific story.

Open questions:

- Policy name and domain: `ai-policy-presentation.md`?
- Loading mode: trigger with `presentation standards`, or Active Expertise?
- Which rules generalize beyond this repository and which stay project knowledge?
- Does the policy cover only slide decks or all presentations, including talks, diagrams, and handouts?
- Is a release required for the new policy?

Acceptance criteria:

- The policy exists under the workflow policy tree and passes the authoring validator.
- The policy states the standard, the review gate, and the Markdown-versus-published-copy rule.
- The docs, validator anchors, tests, and policy count are updated.
- The recent deck is cited as the reference, not copied as project-specific content.

---

2026-11-24

Deferred by the user. Do not plan or implement until the user reopens it.

Reasons:

- The current deck is already delivered; the policy is not blocking any work.
- The policy needs careful design of layout and type control, not only narrative rules. The user's earlier HTML deck experience had images and text rendering too small.
- The toolchain needs a decision too; the user questions whether `support-files/build-slides-html.sh` earns its place.

The procedure and any skill proposed for presentations wait for this policy. No procedure ticket is filed yet.

---

2026-11-26

Superseded by `slide-authoring-pipeline-and-deck-refresh` and v7.8.0. The standard is `ai-policy-presentation.md` with the `presentation standards` trigger.

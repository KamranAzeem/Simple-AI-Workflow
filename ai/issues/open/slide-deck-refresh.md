Reported: 2026-11-22
Reporter: Kamran Azeem
IssueType: Documentation
Severity: P2
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Rebuild the slide deck around a fixed-shape workflow narrative, remove stale content, and define the source of truth

Description:

Origin.

- The Google Slides deck is old, stale, and inaccurate.
- The Markdown version in the repo is a separate copy, so neither is the clear source of truth.
- The deck opens with tool portability and the multi-driver story, which is no longer the main idea.
- The VS Code versus CLI framing is no longer useful. VS Code is the recommended home.

Evidence.

- `docs/simple-ai-workflow-slides.md` is 495 lines, about 50 slides, with a large "More Features" dump.
- The title slide shows `kamran@wbitt.com`, which is not the current contact.
- The "Idiot-proof" slide says the AI runs `ls -R` on the Global User AI Directory, which is stale; the boot uses built-in scoped indexing.
- The opening builds to "Why Simple AI Workflow wins on portability" and a tool-memory comparison. That is a secondary benefit, not the thesis.
- `README.md` says "If you only ever use one AI assistant, you probably don't need this." The new position is the opposite.
- The Google Slides link is in `README.md`; the Markdown deck is a separate version.

The narrative brief.

- Thesis: the problem is not which assistant you use. The problem is that ad-hoc chat has no fixed shape. Every session improvises what to load, how to plan, and what to save. The workflow gives every session the same predictable, repeatable shape.
- Opening: open VS Code and an AI chat, and say "work on X." It may help, but it has no project state, no rules, no checkpoint, and no review gate. Tomorrow it may behave differently. That is the gap.
- The wood-cutter rule: sharpening the axe is part of the job. Checkpoint, knowledge capture, repair, and backup are the sharpening, not overhead. A dull axe costs more time than the sharpening does. This is the old wood-cutter's rule, commonly attributed to Abraham Lincoln; the attribution is traditional, so the slide need not name him.
- VS Code is the recommended home. The protocol is editor-agnostic, but "VS Code versus CLI" is not a selling point.
- Multi-driver and portability stay as a secondary capability for the minority who switch assistants or machines. Do not open with them.
- One-sentence promise: "Stop chatting with AI. Start working with it, the same way every time."

Proposed outline, 12 to 15 slides.

1. Title and the one-sentence promise.
2. The gap: no fixed shape.
3. The fix: a protocol, not a platform.
4. The daily loop: load context, plan, implement, review, checkpoint.
5. A day in the life.
6. What you get, grouped by job: setup, memory, quality, delivery, maintenance.
7. The sharpening-the-axe rule.
8. Works with any assistant, as a secondary capability. VS Code is the recommended home.
9. The honest trade-off: a few commands, deliberate friction.
10. Getting started in 5 minutes.
11. Close.
12. Optional appendix: the tool comparison table.

Scope.

- Rewrite the Markdown deck in the new order and cut the feature dump.
- Group capabilities by job, with what it does, why it matters, and the command.
- Fix every stale fact: policy and procedure counts, commands, paths, contact email, indexing, and backup behavior.
- Add speaker notes and a short demo script.
- Produce a Google Slides change sheet: slide number, action (delete, replace, or add), new title, and new bullets.
- Decide the source of truth. Recommended: the Markdown in the repo is canonical, and Google Slides is a published copy.
- Keep the Creative Commons note.

Constraints.

- Do not install a slide tool. No pandoc, marp, slidev, or python-pptx is installed. LibreOffice is present and can convert between office formats.
- A generated PPTX or PDF needs a separate build-tool decision.

Open questions.

- Source of truth: Markdown or Google Slides?
- Target slide count: 12 to 15?
- Keep the tool comparison as an appendix, or drop it?
- Keep a contact email on the title slide, or remove it?
- Do you want a generated office-file path, or a manual Google Slides update?

Acceptance criteria.

- No stale claim remains in the deck.
- A new viewer can state the value in one sentence after the opening.
- The deck matches the README's top-level narrative.
- Every command and count matches the repository.
- The Google Slides change sheet is complete, or the deck is regenerated from the Markdown.

---

2026-11-22

Filed from the documentation discussion. No source-of-truth decision yet. The README restructure and the guide audit reference this ticket's narrative brief.

---

2026-11-22 (protocol update)

- The README restructure is the first issue and leads the narrative; this deck follows the README.
- Thesis: predictability, reproducibility, auditability, and a fixed shape. The multi-assistant/changing-drivers story is a secondary capability, not the opening.
- Add the v7.1.0 team knowledge store and v7.2.0 team skills: the two keys, team lessons, the team skills root, project/team/global precedence, the trust boundary, and the manual contribution. Counts are 25 policies, 16 procedures, 53 triggers, and 28 tests; the README is 476 lines and the deck is 495.
- The source-of-truth question stays open; the README first, the deck after. Keep the tool comparison as an appendix at most.

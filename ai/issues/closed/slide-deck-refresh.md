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

---

2026-11-22

Plan written: `ai/plans/slide-deck-refresh.md`. The grilling settled the 22-slide storyboard, the Problem, Solution, Proof arc, the assertion-evidence layout, the optional team act, the three-root `ai/` slide, the two scopes, the knowledge and skills map, the axe assets, the local preview, the Google Slides update, and the two manual gates. Peer review: review-86 APPROVED, no Critical or Major.

Open questions resolved: the Markdown deck is canonical and Google Slides is a published copy; the main deck is 22 slides plus an appendix; the tool comparison is a pointer only; the contact is the repo and azeemconsulting.com with no personal email; the Google Slides update is manual, with no generated office file. Gate 1 is the local preview; Gate 2 is the physical Google Slides review before the ticket closes.

---

2026-11-22 (amendment)

Plan amended: `ai/plans/slide-deck-refresh.md` adds the AI render-and-read preview and the joint review cadence. The AI renders the deck with headless Google Chrome to `ai/artifacts/slides-preview/`, reads the PNGs, and self-reviews before each joint review. The user and AI review the same rendered version, act by act, then the full deck, before the Google Slides update. Peer review: review-87 APPROVED.

---

2026-11-22 (amendment 2)

The first joint review found the axe crop, small typography, and an overclaim: the five-step loop is not every session. The plan and deck now use the trail thesis, a modes slide, the 22-slide map, and a contained axe. Peer review: review-88 APPROVED.

---

2026-11-22 (amendment 3: concepts act)

The user asked for a knowledge refresh first, using the old Google Slides deck for inspiration: what makes up an AI assistant, the out-of-band git-ignored `ai/` memory, and the strongest concepts from the old deck. The plan is amended to 31 main slides: Part 1 Concepts (assistant anatomy, context window, memory gap, out-of-band `ai/`, project brain, is/is-not boundary), Part 2 The Workflow (including the solution root), Part 3 Proof, the gated team act, and the close.

Added seven SVGs and adjusted four existing diagrams; the preview now styles section dividers and sizes diagram slides; the fixture checks the concepts, the out-of-band safety claims, the new assets, and the derived counts. The old PPTX at `ai/artifacts/Simple-AI-Workflow.pptx` is the reference, not a source of truth. Local deck only; the Google Slides update and the physical Gate 2 review remain.

Peer review: review-90 CHANGES REQUESTED (two Majors, three Minors), review-91 APPROVED. Suite 31/31; protocol 8/8; markdownlint 0; shellcheck 0.

---

2026-11-22 (amendment 4: slide review fixes)

- The out-of-band slide no longer assumes the project root is a Git repository. It shows the single-project case where the root is a repository, and the Architect case where the root has no `.git` and the repositories sit below it. `ai/` stays out of band in both.
- Repaired the tree continuation lines in the project-brain and solution-root diagrams, and made the project appendix tree fit on its slide.
- Renamed the protocol slide to "The workflow is a protocol, not a platform". The Architect slide now names the vision, the decisions, and the definition of done. The loop copy says "fixed few steps" instead of "five steps".
- Raised the appendix capability and command-sheet type to 1.1rem, and kept the appendix code trees readable and complete.
- Review-92 APPROVED. Suite 31/31; protocol 8/8; markdownlint 0; shellcheck 0. Local deck only; the Google Slides update and Gate 2 remain.

---

2026-11-22 (amendment 5: full catalog and uniform type)

- The user rejected the summary appendix and the small type. The appendix is now a 15-slide catalog: Setup, Daily loop, Memory 1/2, Quality 1/2, Delivery 1/2, Maintenance 1/2, Team, Compliance, Domain expertise, Traits and skills, and Commands. Every policy and procedure is named at least once, with one line of explanation.
- The main deck is 37 slides. Added the AI ladder, two small files, compliance, the quality loop, token discipline, and Git safety. Six jobs, not speed, team gate, publish, and getting started now use full-slide diagrams.
- Type: 1.6rem body and appendix, 78vh diagram slides, 88vh pure diagrams, and larger SVG text with per-diagram control where the layout is dense.
- Added 11 SVGs (25 total) and fixed the dense-diagram overlaps. Added the compliance content (standards, validation, evidence, not a certification) and the missing old-deck points (ladder, root files, TDD/quality, Git, token).
- Review-93 APPROVED. Suite 31/31; protocol 8/8; markdownlint 0; shellcheck 0; 52 slides rendered. Local deck only; the Google Slides update and Gate 2 remain.
- Follow-up: the preview `#/32` knowledge and skills slide is now a full-slide 88vh diagram with larger type; the two team keys and the trust boundary are in the visual. The Team gate slide was also enlarged to 88vh.

---

2026-11-22 (close)

Closed on the user's instruction after Gate 1. The Markdown deck is accepted.

- 52 slides: 37 main plus the 15-slide catalog.
- Review-93 APPROVED; suite 31/31; protocol 8/8; markdownlint 0; shellcheck 0; all 25 SVGs valid.
- The Google Slides update and the physical Gate 2 review are deferred to a separate issue; they are not closure conditions for this ticket.
- This close supersedes ADR-006 and the plan's Gate 2 close condition.
- The branch `feature/slide-deck-refresh` remains uncommitted. No merge, release, or checkpoint was performed by this close.
- The plan is attached under `## Implementation Plan`.

## Implementation Plan

# Implementation Plan: Slide Deck Refresh

Ticket: `ai/issues/open/slide-deck-refresh.md`
Date: 2026-11-22
Status: Planned; review-86 through review-89 APPROVED. Amendment 4 (concepts act): review-90 CHANGES REQUESTED, review-91 APPROVED. Amendment 5 (slide review fixes): review-92 APPROVED. Amendment 6 (full policy catalog and uniform type): review-93 APPROVED.

## Evidence

Sources read in full this session, with line counts:

- `ai/issues/open/slide-deck-refresh.md`: 96 lines.
- `docs/simple-ai-workflow-slides.md`: 495 lines.
- `README.md`: 172 lines.
- `AGENTS.md`: 149 lines.
- `docs/setup.md`: 51 lines.
- `docs/ai-customization-guide.md`: 270 lines.
- `docs/ai-customization.md`: 89 lines.
- `docs/global-user-settings.md`: 50 lines.
- `docs/announcements/v7.1.0.md`: 13 lines.
- `docs/announcements/v7.2.0.md`: 11 lines.
- `tests/run-all.sh`: 39 lines.
- `tests/test-docs-audit.sh`: 124 lines.
- `tests/test-readme-shape.sh`: 108 lines.
- `docs/protocol-validation-system.md`: 69 lines.
- `.markdownlint-cli2.jsonc`: 24 lines.
- `support-files/README.md`: 171 lines.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md`: 75 lines.
- `ai/policies/ai-policy-issue-management.md`: 119 lines.
- `ai/policies/ai-policy-design-docs.md`: 171 lines.
- `ai/policies/ai-policy-code-review.md`: 131 lines.
- `ai/policies/ai-policy-thinking-modes.md`: 51 lines.
- `ai/policies/ai-policy-common.md`: 693 lines.
- `ai/policies/ai-policy-meta.md`: 208 lines.
- `ai/issues/closed/docs-guide-audit.md`: 361 lines.
- `ai/shared/coordination.md`: 38 lines.
- `ai/notes/notes.md`: 58 lines.
- `ai-customization.md`: 40 lines.

Commands and results:

- `ls ai/policies/*.md | wc -l`: 25 policies.
- `ls ai/procedures/*.md | wc -l`: 16 procedures.
- `ls tests/test-*.sh | wc -l`: 30 test scripts before the new fixture; 31 after it.
- `ls docs/*.md | wc -l`: 18 user-facing docs.
- `ls ai/issues/open/*.md | wc -l`: 8 open; 0 in-progress; 120 closed.
- `ls ai/code-review-reports/*.md | wc -l`: 366 reports; the latest before this plan's review is `2026-11-22_21-12_review-85.md`; this plan's review is `2026-11-22_21-50_review-86.md`.
- `curl -sI https://azeemconsulting.com/img/axe.jpg`: HTTP 200, `image/jpeg`, 1800x1200, 279 KB.
- The site palette: teal `#0090C1`, slate `#505962`, white, dark overlay.
- `git status --short`: the post-merge checkpoint (`ai/state/*`, `ai/daily-checkpoints/2026-11-22.md`) and `ai/notes/notes.md` are modified.
- `command -v google-chrome`: `/usr/bin/google-chrome`; `google-chrome --version`: 158.0.8127.36. `firefox`, `libreoffice`, and `pdftoppm` are also installed.
- The built-in reader reads PNG and PDF files, so the AI can inspect a rendered deck.

Confirmed facts:

- The current deck is 495 lines, about 50 slides, with a 48-bullet "More Features" dump, a portability opening, a three-slide tool comparison, and a stale `kamran@wbitt.com` title, `ls -R` claim, and VS Code versus CLI framing.
- The README is 172 lines and already tells the fixed-shape story. It says 25 policies, 16 procedures, and 53 triggers. The README links the Google Slides deck at line 168 and the Markdown deck at line 169.
- The README was restructured before this unit; the docs guide audit followed. The deck is the remaining documentation refresh.
- The source-of-truth decision is settled: the Markdown deck is canonical; Google Slides is a published copy.
- The presentation standard is settled from the user-supplied text: Problem, Solution, Proof as the macro arc, a Technical Deep-Dive inside the Solution act, assertion-evidence layouts, and diagrams over bullet walls. The 10/20/30 pitch rule is not the deck's constraint; a live demo is not in the Markdown deck.
- The presentation-layout policy the user remembered does not exist in the current tree, the full git history (including the deleted `presentation-slides/` directory), or `~/.ai` settings and knowledge. The user supplied the standard in the 2026-11-22 message.
- The axe image is live at `https://azeemconsulting.com/img/axe.jpg` and belongs to the user's site. The site tagline is "We sharpen your axe. We also chop wood - when needed!".
- The old deck's "More Features" list is the source for the exhaustive capability appendix. The README's six "What you get" groups are the main-deck map.
- The setup tree separates the clone, the project root, and the global directory. The project root copies `AGENTS.md` and `ai-customization.md`; the `ai/` tree holds the project state and knowledge; the clone holds the policies, procedures, and global skills.
- The global settings template holds identity, profile, communication, shell path, tools, operating instructions, and sensitive names. `ai-customization.md` holds the workflow configuration, expertise, traits, compliance, design docs, merge policy, team keys, and optional sensitive names.
- Knowledge precedence is project, team, global. Skill precedence is project, team, global. The team parts are optional.
- The suite has 30 test scripts. The docs validation doc and the toolchain note say 30. The validation doc also says "15 procedure modules"; the live count is 16.
- The working tree has the post-merge checkpoint and the user's `ai/notes/notes.md` sync `--init` idea. The notes file is out of scope for this unit.

Grilling decisions, 2026-11-22:

- Audience: the solo developer or architect; team leads are secondary.
- Length: 20 to 25 minutes; 22 main slides plus an appendix.
- Arc: Problem, Solution, Proof; the Technical Deep-Dive sits inside the Solution act; assertion-evidence layout.
- Thesis: "You are the architect. The AI is your reliable peer. Every session follows the same shape."
- Coverage: six job groups in the main deck; the full capability index in the appendix.
- `ai/` structure: a first-class three-root slide; one main slide plus the full tree in the appendix.
- Team: the no-team story first, then a gated three-slide optional act.
- Axe: title hero, the dedicated sharpening slide, and a small close echo; only the sharpening slide uses the full image.
- Proof: before-and-after plus "built with itself" through the repo and tests; no recorded walkthrough now.
- Appendix: a grouped capability index with every capability named once, the full tree, and the command sheet.
- Visual: the azeemconsulting.com palette and the axe image. No git graphs. The road trip gets one slide.
- Contact: no personal email; the repo and azeemconsulting.com.
- Manual gates: the local preview first, then the physical Google Slides review before the ticket closes.

Open questions: none. The contact, source, length, standard, preview, and Google Slides update are settled.

## HLD

### Narrative and slide order

The deck has three layers. The original 31-slide main deck was the talk: Concepts, The Workflow, Proof, and a gated team act. The appendix was the reference. The main deck is complete for a solo developer; the team act is optional and clearly gated. Amendment 4 restored the best concepts from the old Google Slides deck. Amendment 6 adds the remaining core concepts, the full policy catalog, and uniform type.

1. **Title and promise**. "Simple AI Workflow: The Architect and the Peer." Promise: "You are the architect. The AI is your reliable peer. The work leaves a trail you can inspect." Visual: the axe photo as the hero, the site and GitHub links, the CC BY 4.0 note.
2. **Part 1: Concepts**. Section divider. "The model is not the workflow. These are the pieces around it." Four promises: what an assistant is made of, why context is the whole game, where the memory lives, and what the workflow is not.
3. **An AI assistant is a brain, a memory, and your tools**. Visual: three panels. The brain is the model; the memory is the context window plus the files on disk; the tools are files, search, shell, git, and the network. The model is rented; the memory and the tools are yours.
4. **The assistant only knows what is in its context**. Visual: a bounded context window with four slots: rules, state, work, and code. A web chat knows only what you paste; a local assistant can read the project. Context costs tokens, latency, and attention.
5. **A plain chat has no fixed shape**. Visual: the memory gap in three panels: the prompt tax, context loss, and scattered state. Same prompt tomorrow, a different process.
6. **The `ai/` directory is out-of-band memory, outside git**. Visual: two cases. A single project whose root is a Git repository, and a solution root whose repositories sit below it. `ai/` is out of band in both; bootstrap makes `ai/**` git-ignored when the root is a repository. It is local and personal; it is not application code, and it is not a secrets vault.
7. **The `ai/` directory is the project's brain**. Visual: an annotated `ai/` tree. State, diary, knowledge, work, and inbox; all plain text and inspectable. Load context reads the index and opens a file only when a task needs it.
8. **What this is, and what it is not**. Visual: a two-column boundary. It is a protocol, one peer, local, and portable. It is not a model, a local server, an agent swarm, a team tool, or a replacement for CI/CD and code review.
9. **Part 2: The Workflow**. Section divider. "The shape around the model."
10. **The protocol**. "The workflow is a protocol, not a platform." Visual: plain files, the two root files, and the fixed few-step shape.
11. **The Architect and the peer**. "You set the vision and the definition of done, and you make the decisions. The AI executes, remembers, and reviews." Visual: two panels, architect and peer; the architect sets the vision, makes the decisions, defines done, approves the plan, and merges; a crossed-out agent swarm. Pair programming, not parallel agents.
12. **One repo, one developer**. "The core case is one person, one project, one peer." Visual: the project root with `AGENTS.md`, `ai-customization.md`, `ai/`, and code, plus the AI peer. This is the only single-repo scenario slide.
13. **The solution root**. "The same protocol scales to a solution root." Visual: one `AGENTS.md` and one `ai/` above several repositories; one memory, many Git histories. The assistant still works from the directory you open. This restores the old deck's Architect layout without making it the opening.
14. **The daily loop**. "Load, plan, implement, review, checkpoint." Visual: a circular fixed few-step diagram.
15. **A session is not one script**. "The work can start anywhere; the protocol makes the mode explicit." Visual: brainstorm, grill, examine, plan, implement, and change direction; the issue loop is the implementation default.
16. **Three roots**. "Three roots: the project's memory, your settings, the rulebook." Visual: the global store and the clone on the left, the project tree on the right, in the real `tree` layout. The project tree is the memory; the clone is the rulebook; the global store is the person.
17. **The two dials**. "Global settings shape you; `ai-customization.md` shapes this project." Visual: two scopes meeting at load context. Global settings cover identity, tools, shell, and cross-project context. The project file selects expertise, traits, compliance, design docs, merge policy, and optional team keys.
18. **Knowledge and skills**. "Three scopes, two kinds of memory." Visual: a 3x2 map. Project, global, and team knowledge; project, global, and team skills. The team column is dashed and marked optional. Precedence is project, team, global.
19. **Sharpening the axe**. "Checkpoint, knowledge, repair, and backup are the sharpening." Visual: the axe photo, the site tagline, and the wood-cutter's rule. A dull axe costs more than the sharpening.
20. **The capability map**. "Six jobs, one protocol." Visual: Setup, Daily loop, Memory, Quality, Delivery, and Maintenance, each with one line and one icon. Team is separate and optional.
21. **Not speed**. "This is not about going faster. It is about fewer wrong turns." Visual: a straight path against a zigzag. Body: efficiency, confidence, precision, and a predictable flow.
22. **The honest trade-off**. "A few commands, deliberate friction." Visual: the command list and the fixed shape. You always know what was saved, and why.
23. **Part 3: Proof**. Section divider. "The repository is the case study."
24. **Proof: before and after**. "Same task, two shapes." Visual: an ad-hoc chat against the protocol loop; what is inspectable in each.
25. **Proof: the repository**. "The repository is the proof." Visual: the issue tracker, the plans, the review reports, the checkpoints, and the releases. The counts are current.
26. **Team gate**. "Team features are not for everyone. If you work alone, stop here." Visual: a clear stop marker; the solo story is already complete.
27. **Team knowledge and skills**. "A shared store, two optional roots." Visual: the team column of the 3x2 map. The two keys, the precedence, the one-reviewer trust boundary.
28. **Team contribution**. "Publish a lesson, copy a skill, one reviewer merges." Visual: the contribution flow and the review gate.
29. **Multiple assistants, turn by turn**. "The protocol supports multiple assistants, turn by turn, and handoffs for some parallelism." Visual: the road trip; the handoff policy makes the independence explicit.
30. **Getting started**. "Five minutes to the first loop." Visual: clone, create the global directories, copy two files, bootstrap, and load context.
31. **Close**. "You are the architect. The AI is your peer." Visual: the axe echo, the repo and site links, and the CC BY 4.0 note.

The 31-slide list above was the original Google Slides update map. Amendment 6 supersedes it with the 37-slide map and the 15-slide catalog.

### Appendix

Amendment 6 replaces this summary appendix with a 15-slide full catalog:

- Setup (9 items), Daily loop (7), Memory (2 slides), Quality (2), Delivery (2), Maintenance (2), Team (7), Compliance (8), Domain expertise (12), Traits and skills (7), Commands (14).
- Every policy and procedure is named at least once, with one line of explanation, at 1.6rem body type. Repetition is allowed only where a group needs the item.
- No tool comparison, no tree appendix, no capability summary.

### Amendment 6: Full policy catalog and uniform type

The user rejected the summary appendix and the small type. This amendment supersedes the 31-slide map above.

- **Main deck: 37 slides.** Add 9. The AI ladder, 11. Two small files start the whole thing, 20. Compliance is a dial, not a badge, 22. Quality is a loop, not a hope, 27. Load the index, not the world, and 28. Git is your safety net. The Six jobs, Not speed, Team gate, Publish, and Getting started slides gain full-slide diagrams.
- **Appendix: 15 catalog slides.** Setup (9 policies and procedures), Daily loop (7), Memory (2 slides), Quality (2), Delivery (2), Maintenance (2), Team (7), Compliance (8), Domain expertise (12), Traits and skills (7), Commands (14). Every policy and procedure is named once, with one line of explanation. No tool comparison and no tree appendix.
- **Type:** body 1.6rem, appendix 1.6rem, diagram slides 78vh, pure diagrams 88vh, and larger SVG text with per-diagram control where the layout is dense.
- **Compliance:** a main slide and an appendix group. Standards are listed in `ai-customization.md`, applied from AI knowledge, validated against recognized names, and never stored as on-disk files.
- **Assets:** 25 SVGs total. The 11 new ones are `ai-ladder`, `root-files`, `compliance`, `quality-loop`, `git-safety`, `token-budget`, `six-jobs`, `straight-vs-zigzag`, `team-gate`, `team-publish`, and `first-loop`.

### Feature coverage

The appendix maps every old "More Features" bullet and every README capability into one group:

- Setup: bootstrap, sync, customization, git identity.
- Daily loop: load, plan, implement, review, checkpoint.
- Memory: state files, diary, project knowledge, global knowledge, handoffs, skills, design docs.
- Quality: peer review, codebase examination, shared understanding, thinking modes, coding baseline, design docs, acceptance criteria.
- Delivery: issue management, plans, merge policy, outbound scrub, handoff creation.
- Maintenance: state-file repair, knowledge repair, backup, post-compaction recovery, validator, lint, context health, state-file budget.
- Team: team knowledge store, team lessons, team skills, precedence, trust boundary, contribution.

The implementation keeps the old "More Features" bullet-to-group checklist in the ticket until every bullet is mapped. Amendment 6 goes further: the appendix names every policy and procedure, so the old checklist is fully covered.

The concepts act is not a seventh job group. It explains the model, the context window, the memory gap, the out-of-band `ai/` memory, the project brain, the is/is-not boundary, and the solution root before the job groups. It restores the strongest concepts from the old Google Slides deck without bringing back the portability opening or the tool comparison.

### Visual system

- Palette: teal `#0090C1`, slate `#505962`, white, and a dark overlay for the axe photo.
- Type: one family, large. The final Google Slides uses 30pt or larger for body text.
- Every slide title is a full-sentence claim. Each story slide has one visual and at most four short points; the appendix catalog uses one line per policy or procedure. No bullet walls, no git graphs, and no decorative clip art.
- The diagrams are hand-authored SVGs in the palette, with accessible text. The axe is the only photograph.

### Assets

- `docs/slides/assets/axe.jpg`: copied from the user's site, with the attribution "Photo: Kamran Azeem, azeemconsulting.com".
- `docs/slides/diagrams/three-roots.svg`: the project, global, and clone roots.
- `docs/slides/diagrams/two-scopes.svg`: global settings and `ai-customization.md` meeting at load context.
- `docs/slides/diagrams/knowledge-skills.svg`: the 3x2 map with the team column dashed.
- `docs/slides/diagrams/daily-loop.svg`: the fixed few-step loop.
- `docs/slides/diagrams/architect-peer.svg`: the architect and peer against the agent swarm.
- `docs/slides/diagrams/before-after.svg`: the ad-hoc chat against the fixed loop.
- `docs/slides/diagrams/road-trip.svg`: the one-slide multi-driver capability.
- `docs/slides/diagrams/ai-nutshell.svg`: the brain, the memory, and the tools.
- `docs/slides/diagrams/context-window.svg`: the bounded context window and the two sources.
- `docs/slides/diagrams/memory-gap.svg`: the prompt tax, the context loss, and the scattered state.
- `docs/slides/diagrams/out-of-band.svg`: the tracked product and the git-ignored AI layer.
- `docs/slides/diagrams/project-brain.svg`: the annotated `ai/` tree by job.
- `docs/slides/diagrams/is-isnot.svg`: the boundary between the protocol and the platform.
- `docs/slides/diagrams/architect-solution.svg`: the solution root above several repositories.
- `docs/slides/diagrams/ai-ladder.svg`: the seven-rung proficiency model.
- `docs/slides/diagrams/root-files.svg`: the pointer and the project dial.
- `docs/slides/diagrams/compliance.svg`: the compliance dial and the controls.
- `docs/slides/diagrams/quality-loop.svg`: acceptance criteria, test first, peer review, and design docs.
- `docs/slides/diagrams/git-safety.svg`: branch, commit, review, and squash merge.
- `docs/slides/diagrams/token-budget.svg`: the session context budget.
- `docs/slides/diagrams/six-jobs.svg`: the six-job lifecycle.
- `docs/slides/diagrams/straight-vs-zigzag.svg`: the straight path against the zigzag.
- `docs/slides/diagrams/team-gate.svg`: the solo and team fork.
- `docs/slides/diagrams/team-publish.svg`: the contribution flow and the one-reviewer gate.
- `docs/slides/diagrams/first-loop.svg`: the five-minute onboarding path.

### Local preview and the AI renderer

- Add `support-files/preview-slides.html`, the interactive preview. It fetches `../docs/simple-ai-workflow-slides.md`, splits it on `---`, and renders the slides with reveal.js and marked from a CDN. The SVGs and the axe are local.
- Add `support-files/render-slides-preview.sh`, the AI renderer. It starts `python3 -m http.server` in the repo root, renders each slide with headless Google Chrome at 1600x900, writes `ai/artifacts/slides-preview/slide-NN.png`, and stops the server. It creates the output directory.
- The AI reads the PNGs with the built-in reader and self-reviews before each joint review: overflow, contrast, diagram legibility, body size, the palette, the axe, and the SVG labels. It fixes the deck and re-renders.
- The user opens the same `preview-slides.html`, or the PNGs. The joint review uses the same rendered version.
- The renderer uses only installed tools: Google Chrome 158.0.8127.36, Python, and the existing `ai/artifacts/` area. No install.
- The preview and the renderer are local dev helpers. The PNGs stay in `ai/artifacts/`, which is session-local. If the CDN is unavailable, the fallback is the Markdown and the SVGs in VS Code.

### Review cadence

- Draft 1 is the full 37 slides and the 15-slide catalog.
- The AI renders draft 1 and self-reviews it before the first joint review.
- Joint review 1: the story and the Concepts act (slides 1-10), including the AI ladder.
- Joint review 2: The Workflow act (slides 11-28), including compliance, quality, token discipline, and Git safety.
- Joint review 3: Proof, the gated team act, the close (slides 29-37), and the appendix catalog (slides 38-52).
- The joint reviews can change the storyboard. The final approved 37-slide map updates the HLD list and the Google Slides update map before Gate 2.
- The final joint review covers the full local deck; the user signs off. Only then does the Google Slides update start.
- Gate 2 is the physical Google Slides review on desktop and phone; the user signs off; then the ticket closes.

### Google Slides update

- The Google Slides deck is an external published copy. After Gate 1, replace its content with the 37 slides and the 15-slide catalog.
- Delete the old "More Features" dump, the tool comparison tables, the portability opening, the stale slides, and the git diagrams. Archive the old version through Google Slides history and keep the existing link.
- Run the outbound content scrub as Class B (public): remove secrets and unintended identifying names; keep the author's intended links and the user's photo. Show the scrubbed text and the category report, then wait for approval.
- The user reviews the physical deck on desktop and phone. The ticket records the sign-off.

## LLD with Acceptance Criteria

### Story and slides

- **AC-001**: The deck has the 37 main slides in the approved order, plus the 15-slide appendix catalog.
- **AC-002**: The title and promise, the Concepts divider, the assistant anatomy, the context window, the gap, the out-of-band `ai/` with the single-project and solution-root cases, the project brain, the is/is-not boundary, the Workflow divider, the protocol, the Architect and peer with the vision and the definition of done, the single-repo case, the solution root, the daily loop, the explicit modes, the three roots, the two dials, the knowledge and skills map, the sharpening the axe, the capability map, the not-speed slide, the trade-off, the Proof divider, the two proof slides, the team gate and two team slides, the road trip, the getting started, and the close are present.
- **AC-003**: The deck has no git graph and no multi-driver opening. The road trip is one slide.
- **AC-004**: The team act is behind the gate, and the main story is complete without it.
- **AC-005**: The appendix is a full catalog. Every policy and procedure is named at least once, with one line of explanation, under Setup, Daily loop, Memory, Quality, Delivery, Maintenance, Team, Compliance, Domain expertise, Traits and skills, or Commands. Repetition is allowed only where a group needs the item. There is no tool comparison and no tree appendix.
- **AC-006**: The `ai/` slides show the end-user project tree, the git-ignored out-of-band layer, the solution root whose repositories sit below it, the global `~/.ai/` root, and the clone. The annotations explain why each directory exists.
- **AC-007**: The two dials slide shows global settings and `ai-customization.md` meeting at load context.
- **AC-008**: The knowledge and skills map has project, global, and team knowledge and skills, with the team dashed and optional, and the precedence.
- **AC-009**: The axe photo appears on the title, the sharpening slide, and the close echo. The site tagline and the wood-cutter's rule are present, and the provenance is recorded.
- **AC-010**: The visual system uses the teal and slate palette, assertion headlines, and the SVGs. The body type is 1.6rem, the appendix type is 1.6rem, diagram slides render at 78vh, pure diagrams at 88vh, and the SVG type is enlarged per diagram, with tighter type only where the layout is dense. No dense bullet walls.
- **AC-011**: The stale facts are gone: `kamran@wbitt.com`, `ls -R`, "28 tests", "476 lines", "Cline", and "VS Code versus CLI". The counts 25 policies, 16 procedures, 53 triggers, 31 tests, and 18 docs are current.
- **AC-012**: The contact is the repo and azeemconsulting.com; there is no personal email. The CC BY 4.0 note stays.
- **AC-013**: The local preview renders the deck from the Markdown, the SVGs, and the axe; the renderer produces per-slide PNGs; the AI reads them and self-reviews; the fallback is documented.
- **AC-014**: The Google Slides update map is complete, the outbound scrub is run, and the physical review on desktop and phone is signed off before the ticket closes.
- **AC-015**: The test suite is 31/31; the protocol validator is 8/8; markdownlint is 0; shellcheck is 0. The new slides fixture derives the counts from the live tree.
- **AC-016**: No policy, procedure, or trigger changes. No release. The README content and links stay as they are.
- **AC-017**: The AI render-and-read self-review precedes each joint review, and the user and AI review the same rendered version.
- **AC-018**: The Concepts act opens the deck and names the brain, the memory, the tools, the context window, the memory gap, the out-of-band `ai/`, the project brain, and the is/is-not boundary before the workflow.
- **AC-019**: The out-of-band slide states that the project root is not always a Git repository; that bootstrap adds `ai/**`, `ai-customization.md`, and `AGENTS.md` to `.gitignore` when it is; that a solution root keeps its repositories below it; that the `ai/` layer is local and personal; that it is not application code; and that it is not a secrets vault.
- **AC-020**: The solution-root slide shows one `AGENTS.md` and one `ai/` above several repositories, with one memory across the projects and one Git history per project.
- **AC-021**: The AI ladder is a main slide with seven rungs, level 3 highlighted as the daily loop and level 6 as multiple assistants.
- **AC-022**: Two small files are a main slide: `AGENTS.md` as the pointer and `ai-customization.md` as the project dial, with the two directory keys named.
- **AC-023**: Compliance is a main slide and an appendix group: standards are listed in `ai-customization.md`, applied from AI knowledge, validated, evidenced in the work, and never stored as on-disk files. The slide says it is not a certification.
- **AC-024**: Quality is a main slide with acceptance criteria, TDD, peer review, and the design chain; Git safety is a main slide with branch, commit, review, and squash merge; token discipline is a main slide with the index-at-boot and load-on-demand budget.
- **AC-025**: The appendix lists all 25 policies and all 16 procedures by name, with one line of explanation each, and no policy or procedure is missing. Duplicates across groups are allowed.

### Assets, preview, and tests

- The 25 SVGs and the axe image exist at the named paths and are referenced by the deck.
- The preview file exists, references the Markdown deck, and uses no installed tool.
- `tests/test-slides.sh` is the 31st test. It checks the story phrases, the concepts act, the six groups, the three roots, the two scopes, the knowledge and skills terms, the team gate, the road trip, the axe and SVGs, the stale-string absence, and the derived counts.
- The preview adds the section-slide styling and the diagram-only class, and it assigns the classes after the slide HTML is parsed.
- `docs/protocol-validation-system.md` gains the slides fixture line, the 31-test count, and the corrected 16-procedure count.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md` gains the slides fixture command and the 31-test count.

## ADRs

### ADR-001: Problem, Solution, Proof with assertion-evidence

- **Decision**: Use the Problem, Solution, Proof macro arc, a Technical Deep-Dive inside the Solution act, and assertion-evidence layouts.
- **Context**: The user supplied the format choices; the deck is a new-product talk for developers and architects, not a pitch or a live demo.
- **Consequences**: The deck opens with the gap, builds through the architecture, and closes with inspectable proof. The 10/20/30 rule and the live demo are out of scope.

### ADR-002: 37 main slides, a Concepts act, six job groups, and an optional team act

- **Decision**: Use 37 main slides: the Concepts act with the AI ladder, the Workflow act with compliance, quality, token discipline, and Git safety, the Proof act, and the gated team act. The appendix is a 15-slide full catalog.
- **Context**: The old deck's 50 slides and 48-bullet dump were dry and stale. The user wants a knowledge refresh first, then every policy and procedure listed in the appendix with a line of explanation.
- **Consequences**: The deck opens with concepts, not with the product. The main story is longer but staged, the appendix is a reference, and a solo viewer can stop before the team act.

### ADR-003: The `ai/` structure is a first-class slide

- **Decision**: Show the project `ai/` tree, the global root, and the clone in one annotated three-root diagram. The appendix catalog names the policies and procedures; it does not repeat the tree.
- **Context**: The clear `ai/` layout is one of the protocol's strongest points and the user asked for it explicitly.
- **Consequences**: The deck explains where state, knowledge, and rules live. The diagram must show an end-user project, not the protocol repository.

### ADR-004: Markdown is canonical; Google Slides is a published copy

- **Decision**: Author `docs/simple-ai-workflow-slides.md` as the source of truth. Use a local reveal.js preview for Gate 1 and update Google Slides manually for Gate 2.
- **Context**: The two copies had no clear owner; no slide tool is installed, and the physical Google Slides review is required.
- **Consequences**: The Markdown and the assets are versioned. The Google Slides update is a deliberate external action with a scrub and a sign-off.

### ADR-005: The site assets and the contact

- **Decision**: Use the axe photo and the teal and slate palette from azeemconsulting.com. Remove the personal email and link the repo and the site.
- **Context**: The user likes the axe image and owns it; the old title's email is stale.
- **Consequences**: The deck has a consistent visual identity and no stale contact. The photo is attributed; the deck stays CC BY 4.0.

### ADR-006: No release; close after the physical review

- **Decision**: Treat this as a docs-only unit with no version bump. Close the ticket only after the Google Slides physical review.
- **Context**: The deck is a documentation refresh; the user cannot close the ticket without seeing the physical deck.
- **Consequences**: The release history stays at v7.2.0. The branch stays open through the external update and Gate 2.

### ADR-007: Open with a Concepts act, not with the product

- **Decision**: Put the knowledge refresh first: the assistant anatomy, the context window, the memory gap, the out-of-band `ai/`, the project brain, and the is/is-not boundary. Then start the workflow.
- **Context**: The user asked for the first section to be concepts, and the old deck's best teaching slides were its concept slides. A cold open on the protocol assumes the audience already knows why context and memory matter.
- **Consequences**: The deck earns the protocol before it presents it. The Concepts act must stay short and visual; it is not a second product pitch.

### ADR-008: Recover the old deck's concepts, not its structure

- **Decision**: Reuse the old deck's brain-memory-tools model, the memory gap, the out-of-band `ai/` security and privacy reasoning, the annotated project brain, the is/is-not expectations, and the Architect solution root. Do not bring back the portability opening, the tool comparison tables, the stale counts, the email, or the 48-bullet feature dump.
- **Context**: The old Google Slides deck is the user's own material and contains durable concepts. Its structure and facts are stale.
- **Consequences**: The new deck keeps the author's best explanations and drops the stale framing. The out-of-band claim must match the current bootstrap behavior: `ai/**`, `ai-customization.md`, and `AGENTS.md` are added to `.gitignore`.

### ADR-009: The appendix is a full catalog, not a summary

- **Decision**: Replace the capability summary, the tree appendix, and the comparison pointer with 15 catalog slides. Each slide names the policies and procedures in one group, with one line of explanation, at 1.6rem body type.
- **Context**: The user rejected the summary appendix and asked to show everything. The group heading plus one line per item is the readable form.
- **Consequences**: The appendix is long but complete. It is a reference, not the talk. No policy or procedure can be missing.

### ADR-010: One type scale, with per-diagram control

- **Decision**: Use 1.6rem body type on the main slides and the appendix, 78vh for diagram slides, 88vh for pure diagrams, and enlarged SVG type with a smaller scale for the dense diagrams.
- **Context**: The user found the slide type and the diagram type too small and inconsistent, and the larger type caused overlaps in dense diagrams.
- **Consequences**: The deck reads uniformly. The dense diagrams keep their layout, the concept diagrams carry larger text, and every rendered slide is checked for overlap.

## Risks and Gaps

- **RSK-001**: The 37 slides still feel dry. Mitigation: assertion headlines, the SVGs, the axe, one idea per slide, and the Gate 1 review.
- **RSK-002**: The Google Slides update drifts from the Markdown. Mitigation: the 37-slide map, the Markdown as canonical, and Gate 2.
- **RSK-011**: The full catalog becomes a wall of text. Mitigation: 15 slides, one line per item, 1.6rem type, group intros, and the appendix is reference, not the talk.
- **RSK-012**: Larger diagram type overlaps the layout. Mitigation: per-diagram type control, the dense diagrams use a smaller scale, and the render-and-read review checks every slide.
- **RSK-003**: The counts go stale. Mitigation: the slides fixture derives the module, doc, and test counts; the proof slide avoids a fixed review count.
- **RSK-004**: The axe image provenance or license is unclear. Mitigation: use the user's own site image, add the attribution, and keep the deck CC BY 4.0.
- **RSK-005**: The preview CDN is unavailable. Mitigation: the VS Code Markdown and SVG fallback; the preview is local-only.
- **RSK-006**: The `ai/` tree shows the protocol repository instead of an end-user project. Mitigation: use the setup tree and the AGENTS.md directory anchors; label the three roots.
- **RSK-007**: The working tree's notes and the post-merge checkpoint interfere with the branch. Mitigation: carry the checkpoint into the branch checkpoint and set the notes aside before the terminal gate.
- **RSK-008**: The 31st test ripples into the counts. Mitigation: update the validation doc and the toolchain note, and derive the test count in the fixture.
- **RSK-009**: The Concepts act makes the deck too long. Mitigation: one idea per slide, short speaker notes, the section dividers as exits, and the joint review to cut.
- **RSK-010**: The out-of-band slide overclaims privacy. Mitigation: say "local and out of the repository", not "encrypted"; say "git-ignored by bootstrap"; and keep the "not a secrets vault" warning.

## Test Plan

Write the failing test first: add `tests/test-slides.sh` as the 31st test script.

- Check the deck exists and has at least 30 slide separators.
- Check the story phrases: the title and promise, the Architect and peer with the vision and the definition of done, the gap, the protocol, the daily loop with the fixed few steps, the explicit modes, the three roots, the two dials, the knowledge and skills map, the sharpening the axe, the six groups, the not-speed line, the trade-off, the before-and-after, the repository proof, the team gate, the team slides, the multiple assistants, the getting started, and the close.
- Check the Concepts act: the section title, the assistant anatomy, the context window, the out-of-band `ai/` memory, the project brain, the is/is-not boundary, and the solution root.
- Check the out-of-band safety phrase: `git-ignored`, `not always a Git repository`, local, not application code, and not a secrets vault.
- Check the six group names: Setup, Daily loop, Memory, Quality, Delivery, Maintenance.
- Check the three roots and the two dials terms: `Global AI Workflow Directory`, `Global User AI Directory`, `ai-customization.md`.
- Check the knowledge and skills terms with case-insensitive matches: project, global, team, knowledge, skill.
- Check the stale strings are absent: `kamran@wbitt.com`, `ls -R`, `Cline`, `VS Code versus CLI`, `28 tests`, `476 lines`, `128 KB`, `GPT-5.4`.
- Derive the counts from the live tree: 25 policies, 16 procedures, 53 triggers, 31 tests, 18 docs. Check the deck contains them.
- Check the axe image and the 25 SVG files exist and are referenced.
- Check the appendix groups and the 25 policies plus 16 procedures by name.
- Check the six new main slides: the AI ladder, the two root files, compliance, quality, token discipline, and Git safety.
- Check the preview file exists and references `docs/simple-ai-workflow-slides.md`, the section-slide class, and the diagram-only class.
- Check `support-files/render-slides-preview.sh` exists and references `google-chrome` and `preview-slides.html`.
- Check the README's `docs/simple-ai-workflow-slides.md` link resolves.
- Update `docs/protocol-validation-system.md` and `protocol-verification-toolchain.md` to 31 tests, and fix the validation doc's 15-procedure line to 16.
- Run `bash tests/run-all.sh` (31/31), `bash support-files/validate-protocol.sh` (8/8), markdownlint on the deck and changed docs, and shellcheck on the new test.
- Render the deck with the render script, self-review the PNGs, and run the joint reviews; complete Gate 1 before the Google Slides update.

## Close Sequence

- **Repo**: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- **Base ref**: `master`.
- **Branch**: `feature/slide-deck-refresh`, created at implementation.
- **Merge mode**: direct, because `ai-customization.md` has no `## Merge Policy`; squash merge, delete the branch, and push.
- **Protected branch**: explicit approval before the merge to `master`.
- **Tickets**: move `slide-deck-refresh.md` from `open/` to `in-progress/` at implementation; move it to `closed/` in the branch commit after Gate 2.
- **Plan attachment**: attach this plan under `## Implementation Plan` before deleting the plan file.
- **Review report**: keep review-86 and review-87 local; the review reports are session-local and not committed, and the ticket references the verdicts.
- **Gate 1 (content)**: build the deck, the assets, the preview, the renderer, and the test; run the suite; the AI renders and self-reviews; run the joint act-by-act reviews and the final full-deck review; the user signs off in the ticket. No Google Slides update before Gate 1.
- **Google Slides update**: load `ai-policy-outbound-content-scrub.md` and apply `## Outbound Content Scrub` as Class B public; show the scrubbed text and the category report; get explicit approval; replace the deck content with the 37-slide map and the 15-slide catalog; archive the old version and keep the link.
- **Gate 2 (physical)**: the user reviews the Google Slides deck on desktop and phone; the ticket records the checklist and the sign-off. The ticket does not close before Gate 2.
- **Close**: after Gate 2, move the ticket to `closed/`, attach the plan, and write the branch checkpoint. Carry the existing post-merge checkpoint; leave `ai/notes/notes.md` out of the commit.
- **Checkpoint**: on the branch before the commit.
- **Release**: none planned. The README banner stays at v7.2.0.
- **Terminal gate**: the branch is at least one commit ahead of `master`; the tree is clean after `ai/notes/notes.md` is kept local and out of the commit, or the user commits it separately before this gate; the base ref is resolved.
- **Verification**: the suite is 31/31; the protocol validator is 8/8; markdownlint is 0; shellcheck is 0; the slides fixture passes; the local preview is signed off; the Google Slides physical review is signed off.
- **Post-merge**: no commits and no repository changes.

## Peer Review Log

- Round 1: APPROVED, `ai/code-review-reports/2026-11-22_21-50_review-86.md`; no Critical or Major; three Minor: the latest-review reference is now current, the term check is case-insensitive, and the notes set-aside is concrete; three Suggestions: the outbound scrub policy is named, the HLD list is the Google Slides update map, and the capability checklist stays in the ticket. All applied.
- Amendment 1: APPROVED, `ai/code-review-reports/2026-11-22_21-58_review-87.md`; no Critical or Major; one Minor: the final approved storyboard updates the Google Slides map before Gate 2. Applied.
- Amendment 2: APPROVED, `ai/code-review-reports/2026-11-22_22-20_review-88.md`; no Critical or Major; one Minor: the title, the modes slide, and the close must keep the "trail, not every session" claim consistent. Applied.
- Amendment 3: APPROVED, `ai/code-review-reports/2026-11-22_22-40_review-89.md`; no Critical or Major; one Minor: the project tree card must fit the real tree. Applied.
- Amendment 4, round 1: CHANGES REQUESTED, `ai/code-review-reports/2026-11-22_22-54_review-90.md`; two Major: the "team tool" claim contradicted the optional team act, and the close said every session leaves a trail; three Minor: section-slide control contrast, the appendix A1-A4 numbering, and the test-plan gap. All applied.
- Amendment 4, round 2: APPROVED, `ai/code-review-reports/2026-11-22_22-56_review-91.md`; no Critical, Major, or Minor; two Suggestions: larger SVG type in Google Slides, and a class-order fixture assertion. The second is a test-hardening idea for a later pass.
- Amendment 5 (slide review fixes): APPROVED, `ai/code-review-reports/2026-11-22_23-12_review-92.md`; no Critical, Major, or Minor; two Suggestions: use the larger appendix type in Google Slides if the boxes allow it, and optionally split the out-of-band cases at Gate 1. The out-of-band slide now shows the single-project and solution-root cases; the root is not always a repository. The project-brain and solution-root trees carry their continuation lines, and the appendix trees fit. The protocol heading, the Architect's vision and definition of done, and "fixed few steps" are applied. The capability appendix is 1.1rem.
- Amendment 6 (full policy catalog and uniform type): APPROVED, `ai/code-review-reports/2026-11-22_23-46_review-93.md`; no Critical, Major, or Minor; three Suggestions: check the diagrams in Google Slides at final size, keep the catalog after the close, and keep the TDD wording qualified. The deck is 37 main slides and 15 catalog slides, with 25 SVGs, 1.6rem body and appendix type, 78vh diagrams, 88vh pure diagrams, and every policy and procedure named at least once.
- Amendment 6 follow-up: the preview `#/32` knowledge and skills slide and the Team gate slide are now pure 88vh diagrams with larger type. The two team keys and the trust boundary are in the knowledge visual. Suite 31/31; markdownlint 0; shellcheck 0; SVG XML valid.

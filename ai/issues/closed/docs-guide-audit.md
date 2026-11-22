Reported: 2026-11-22
Reporter: Kamran Azeem
IssueType: Documentation
Severity: P3
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Audit the separate guides, retire or merge stale ones, and remove the VS Code versus CLI framing

Description:

Origin.

- Some separate guides are stale or unnecessary.
- The VS Code versus CLI framing is no longer meaningful. VS Code is more useful than the CLI alone.
- The workflow guide and the README overlap, and the provider guides age quickly.

Evidence.

- `docs/` holds more than 20 guides, runbooks, and reference pages, with overlapping topics.
- `docs/workflow-guide.md` is 506 lines and repeats parts of the README.
- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md` opens with the multi-tool problem, which is now a secondary benefit.
- `docs/vscode-cline-provider-setup-for-beginners.md` and `docs/ai-provider-selection-guide.md` describe a fast-moving tool landscape.
- `docs/multi-agent-runbook.md` covers a secondary use case.
- `docs/protocol-name-migration-map-2026-10-06.md` is historical.
- `ai/issues/open/replace-cline-provider-with-kilo-code.md` already records a provider-name change.

Scope.

- Inventory every file under `docs/`.
- Classify each as keep, merge, retire, or rewrite.
- Name one canonical home per topic.
- Keep `docs/workflow-guide.md` as the reference manual, and remove the README duplication.
- Rewrite or demote the compared-to-all-assistants document around the fixed-shape narrative.
- Audit the provider and beginner guides for current tool names, commands, and screenshots. Coordinate with `replace-cline-provider-with-kilo-code.md`.
- Treat the protocol-name migration map as historical, or retire it when it no longer helps.
- Decide whether the multi-agent runbook stays as a niche guide.
- Update the README docs index to match.

Acceptance criteria.

- Every doc has a recorded status: keep, merge, retire, or rewrite.
- No topic has two canonical homes.
- The README docs index matches the files.
- Every link and command is current.
- VS Code is presented as the recommended home, and editor-agnostic support is a capability, not a contest.

---

2026-11-22

Filed from the documentation discussion. Independent of the deck and README work, but its findings feed both.

---

2026-11-22 (protocol update)

- The docs now include the v7.1.0 and v7.2.0 team features: the workflow guide team knowledge and team skills sections, the customization guide team keys and skills root, the README team bullets, the two announcements, and the team store test fixture. Inventory them and name one canonical home; the announcements are historical.
- The README restructure is the first issue; its narrative is the fixed-shape predictability, reproducibility, and auditability story. Keep the workflow guide as the reference manual. The provider guides coordinate with `replace-cline-provider-with-kilo-code.md`; the compared-to-all-assistants doc is secondary.
- Counts: README 476 lines, workflow guide 517, slides 495, docs more than 20; 25 policies, 16 procedures, 53 triggers, 28 tests.

---

2026-11-22 (sequence)

- This is the next unit after the README restructure. It owns the stale and deletable docs: the protocol-name migration map, the Cline provider guide (coordinated with `replace-cline-provider-with-kilo-code.md`), the provider selection guide, the compared-to-all-assistants document, the multi-agent runbook, and any overlapping guide.
- The README unit updates only the README, its docs index, and its links. This audit performs the keep, merge, retire, or rewrite decisions and the deletions, then updates the README index.
- The slide deck follows the README in its own ticket.

---

2026-11-22

Plan written: `ai/plans/docs-guide-audit.md`. Grilling settled the prune, the single reference manual, the Kilo Code provider consolidation, the compared-doc rewrite, the niche runbooks, the collaboration merge, no release, and the slide exclusion. APPROVED after review-84; implemented on `feature/docs-guide-audit`; review-85 APPROVED.

---

2026-11-22

Closed. Implemented on `feature/docs-guide-audit`; review-85 APPROVED. Plan attached below.

## Implementation Plan: Docs Guide Audit

Ticket: `ai/issues/closed/docs-guide-audit.md`
Date: 2026-11-22
Status: Implemented; review-85 APPROVED; merge pending

## Evidence

Sources read in full this session, with line counts:

- `docs/protocol-name-migration-map-2026-10-06.md`: 107 lines.
- `docs/ai-provider-selection-guide.md`: 118 lines.
- `docs/vscode-cline-provider-setup-for-beginners.md`: 158 lines.
- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`: 204 lines.
- `docs/ai-agent-collaboration.md`: 71 lines.
- `docs/multi-agent-runbook.md`: 169 lines.
- `docs/example-learning-session-runbook.md`: 223 lines.
- `docs/post-compaction-reload-trigger-setup.md`: 116 lines.
- `README.md`: 163 lines.
- `docs/workflow-guide.md`: 572 lines.
- `docs/setup.md`: 41 lines.
- `docs/protocol-validation-system.md`: 68 lines.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md`: 73 lines.
- `ai/issues/open/docs-guide-audit.md`: 68 lines.
- `ai/issues/open/replace-cline-provider-with-kilo-code.md`: 27 lines.
- `tests/test-readme-shape.sh`: 108 lines.
- `tests/run-all.sh`: 39 lines.
- `AGENTS.md`: 149 lines.
- `ai/policies/ai-policy-common.md`: 693 lines.

`docs/` holds 21 Markdown files, 3,221 lines, plus `docs/announcements/`, `docs/examples/` (handoffs, knowledge-base, skills), and `docs/personas/`.

Confirmed facts:

- The protocol-name migration map is historical: it maps PROCEDURE A through I to the current names, but the protocol now has 16 procedures, and the map is not a current reference.
- The Cline beginner guide is stale. The provider selection guide still says "Cline" at lines 3 and 118. The learning runbook names Cline at lines 15-18. The post-compaction guide has a KiloCode row at line 72 but lacks the facts the replace-Cline ticket records.
- The replace-Cline ticket says the Kilo Code facts are: AGENTS.md is always-on in Kilo, the compaction summary is visible in chat, the human backstop is sufficient, and no slash command or new files are needed. It also lists the live Cline references: the README, the learning runbook, and the provider guide.
- The compared doc leads with the multi-assistant problem and the tool memory comparison. Its ending tells the single-assistant user that the native memory is fine, which contradicts the README's main audience.
- The AI agent collaboration notes duplicate the handoff policy and the workflow guide: the coordination board, the A2A rules, the task claiming, and the handoff lifecycle. The unique content is the concise human/agent guidance.
- The workflow guide is the reference manual (572 lines). The README is the landing page (163 lines). The customization guide, setup, provider guide, and examples keep their jobs.
- The README test checks the README's local links. The new docs audit test will be the 30th test script; the toolchain note and the validation doc need the count update.
- The slide deck is a separate ticket. The README leads the docs narrative; the deck follows.

Grilling decisions, 2026-11-22:

- Prune: retire the historical migration map and the Cline beginner guide; update or merge the provider selection guide; rewrite the compared doc; keep the rest.
- Canonical homes: the workflow guide is the single reference; the README is the landing page; the customization guide, setup, provider guide, and examples keep their jobs.
- Cline and provider: retire the Cline guide; update the provider guide with Kilo Code; coordinate with the replace-Cline ticket.
- Compared doc: rewrite around the fixed shape; demote portability; link it from the README's secondary section.
- Multi-agent runbook: keep as a niche guide and link it.
- Learning runbook and collaboration notes: keep the learning runbook; merge the collaboration notes into the workflow guide and retire the notes.
- Release: no release; this is a docs-only sweep.
- Slide deck: exclude it; the slide ticket follows the README.

## HLD

### Inventory and actions

Keep:

- `docs/workflow-guide.md` (572): the single reference. Add a concise agent collaboration subsection. Link the multi-agent and learning runbooks.
- `docs/ai-customization-guide.md` (270): the customization reference.
- `docs/ai-customization.md` (89): the template.
- `docs/global-user-settings.md` (50): the global settings template.
- `docs/compliance-guide.md` (36): the compliance reference.
- `docs/custom-policy-howto.md` (66): the policy authoring how-to.
- `docs/how-policies-work-in-this-workflow.md` (54): the policy explainer.
- `docs/policy-influence-on-ai-work.md` (52): the policy quality note.
- `docs/post-compaction-reload-trigger-setup.md` (116): add the Kilo Code facts.
- `docs/protocol-validation-system.md` (68): add the docs audit fixture and the 30-test count.
- `docs/setup.md` (41): add the short Kilo Code setup and keep the update flow.
- `docs/ai-policy-mobile-apps-guide.md` (143): the mobile policy guide.
- `docs/codebase-examination-guide.md` (119): the examination guide.
- `docs/multi-agent-runbook.md` (169): keep as a niche guide; link it from the workflow guide and the README docs index.
- `docs/example-learning-session-runbook.md` (223): keep; replace the Cline references with the current extension path.
- `docs/simple-ai-workflow-slides.md` (495): excluded from this audit; the slide ticket owns it.
- `docs/announcements/`, `docs/examples/`, `docs/personas/`: keep.

Rewrite:

- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md` (204): the fixed-shape thesis; the single-assistant developer as the main audience; VS Code recommended; the tool comparison kept current; portability secondary.
- `docs/ai-provider-selection-guide.md` (118): current provider paths; Kilo Code; no Cline; the pricing disclaimer.

Retire:

- `docs/protocol-name-migration-map-2026-10-06.md` (107): historical.
- `docs/vscode-cline-provider-setup-for-beginners.md` (158): stale; replaced by the Kilo Code setup.
- `docs/ai-agent-collaboration.md` (71): merge the unique content into the workflow guide first, then delete.

### Provider and Cline consolidation

- Retire the Cline beginner guide.
- Rewrite the provider guide: choose Copilot, Kilo Code, or a provider API; the two paths; the cost checklist; the current provider names; no Cline.
- Add a short Kilo Code setup to `docs/setup.md`: the extension, the provider key, the model, and a test prompt.
- Add the Kilo Code facts to `docs/post-compaction-reload-trigger-setup.md`: AGENTS.md is always-on in Kilo, the compaction summary is visible, the human backstop is sufficient, and no slash command or new files are needed.
- Add the same facts to `ai/shared/project-knowledge/compaction-trigger-problem.md`.
- Update the learning runbook's Cline references to Kilo Code or the current extension.
- Close `replace-cline-provider-with-kilo-code.md` as folded into this unit.

### Compared doc rewrite

- Open with the fixed shape: the AI's mood changes what it loads, saves, and skips; the protocol makes the result predictable, reproducible, and auditable.
- Keep the tool-by-tool comparison and the translation table, updated to the current facts: 25 policies, the current state and knowledge paths, the current commands.
- Make the single-assistant developer the main audience. Portability is a secondary capability.
- Recommend VS Code as the home; treat editor-agnostic support as a capability, not a contest.
- Keep the honest trade-off: a few deliberate commands.
- End with the fixed shape, not "if you use one assistant, the native memory is fine."
- Remove the VS Code versus CLI framing everywhere.
- Link the doc from the README's "Works with any assistant" section.

### Collaboration merge

- Merge the unique content of `docs/ai-agent-collaboration.md` into `docs/workflow-guide.md` as an "Agent Collaboration" subsection under the handoff and Git material: the coordination board, the A2A atomic update, the task claiming, and the handoff lifecycle.
- Link the multi-agent runbook from the same subsection.
- Delete the collaboration notes after the merge.

### README docs index

- List the survivors: the workflow guide, the customization guide, the setup, the compliance guide, the policy explainers, the validation, the codebase examination, the provider guide, the multi-agent runbook, the learning runbook, the examples, the personas, the slides, and the announcements.
- Remove the retired docs.
- Keep the compared doc linked from "Works with any assistant".
- Every local link resolves.

### Tests and counts

- Add `tests/test-docs-audit.sh` (the 30th test).
- Check the retired docs are absent, the kept docs are present, the provider guide names Kilo Code and not Cline, the compared doc states the fixed shape and not the VS Code versus CLI contest, the workflow guide has the collaboration subsection, the setup has the Kilo Code setup, and the README docs index links the survivors.
- Resolve the README and docs index local links; skip external URLs and strip anchors.
- Update `protocol-verification-toolchain.md` and `docs/protocol-validation-system.md` to 30 test scripts.
- The suite must pass 30/30; the protocol validator 8/8; markdownlint 0; shellcheck 0.

### Boundaries

- This unit edits the docs and the docs index. It does not touch the slide deck.
- It does not add a policy, procedure, or trigger. The counts stay 25 policies, 16 procedures, 53 triggers.
- It does not release.
- It keeps the multi-agent and learning runbooks.

## LLD with Acceptance Criteria

### Inventory

- Every `docs/` file has a recorded status: keep, rewrite, or retire.
- Every directory under `docs/` has a recorded status: keep.
- The retired files are deleted in the branch commit.
- The `replace-cline-provider-with-kilo-code.md` ticket closes with this unit.

### Provider and Kilo

- The provider guide names Copilot, Kilo Code, and the API providers; it has no Cline reference.
- The setup doc has a Kilo Code setup section with the extension, the key, the model, and the test prompt.
- The post-compaction guide has the four Kilo facts.
- The project knowledge note has the four Kilo facts.
- The learning runbook has no Cline reference.

### Compared doc

- The opening is the fixed shape and the AI-mood problem.
- The single-assistant developer is the main audience.
- VS Code is the recommended home; portability is secondary.
- The tool comparison and translation table are current.
- The honest trade-off stays.
- The ending is the fixed shape, not a concession to native memory.
- No "VS Code versus CLI" framing.

### Collaboration and index

- The workflow guide has an Agent Collaboration subsection with the coordination board, the A2A atomic update, the task claiming, the handoff lifecycle, and the multi-agent runbook link.
- The collaboration notes are deleted.
- The README docs index lists the survivors and no retired doc.
- The multi-agent and learning runbooks are linked.

### Test and counts

- The docs audit test is the 30th test script.
- The toolchain note and the validation doc list 30 test scripts.
- The README and docs index links resolve.
- The suite is 30/30; the protocol validator 8/8; markdownlint 0; shellcheck 0.

### Acceptance criteria

- **AC-001**: The inventory records a keep, rewrite, or retire status for every doc and directory.
- **AC-002**: The migration map, the Cline guide, and the collaboration notes are deleted.
- **AC-003**: The provider guide names Kilo Code and no Cline; the setup has the Kilo Code setup.
- **AC-004**: The post-compaction guide and the project knowledge note have the four Kilo facts.
- **AC-005**: The learning runbook has no Cline reference.
- **AC-006**: The compared doc is rewritten around the fixed shape; the single-assistant developer is the main audience; VS Code is recommended; portability is secondary; no VS Code versus CLI framing.
- **AC-007**: The workflow guide has the Agent Collaboration subsection; the notes are deleted; the multi-agent runbook is linked.
- **AC-008**: The workflow guide is the single reference; the README is the landing page; the customization guide, setup, provider guide, and examples keep their jobs; no topic has two full homes.
- **AC-009**: The README docs index lists the survivors; every local link resolves.
- **AC-010**: The multi-agent runbook, learning runbook, examples, personas, and announcements are kept and linked.
- **AC-011**: The docs audit test passes; the suite is 30/30; the protocol validator is 8/8; markdownlint 0; shellcheck 0.
- **AC-012**: No release; the slide deck is excluded.
- **AC-013**: The retire list is exactly the three docs; the kept and rewritten docs remain.
- **AC-014**: The replacement ticket is closed as folded into this unit.

## ADRs

### ADR-001: The workflow guide is the single reference

- **Decision**: Keep the workflow guide as the one reference manual; the README stays the landing page; the customization guide, setup, provider guide, and examples keep their focused jobs.
- **Context**: The README and the guide duplicated the knowledge, skills, design, and issue material.
- **Consequences**: Each topic has one full home. The README links to the guide.

### ADR-002: Retire the historical and stale docs

- **Decision**: Delete the protocol-name migration map and the Cline beginner guide.
- **Context**: The map covers nine procedures and is obsolete; the Cline guide is replaced by Kilo Code.
- **Consequences**: The docs tree loses the dead weight. The provider guide and setup carry the current path.

### ADR-003: The provider guide is the provider choice; Kilo Code is the setup

- **Decision**: Keep one provider selection guide, updated for Kilo Code, and put the short Kilo setup in the setup doc.
- **Context**: The Cline beginner guide mixed provider choice with Cline-specific steps.
- **Consequences**: The choice and the setup have one home each. The replace-Cline ticket is folded in.

### ADR-004: The compared doc follows the fixed-shape narrative

- **Decision**: Rewrite the compared doc around predictability, reproducibility, and auditability; the multi-assistant comparison becomes a secondary lens.
- **Context**: The current doc leads with portability and tells the single-assistant user the native memory is fine, which contradicts the README.
- **Consequences**: The README and the compared doc tell one story.

### ADR-005: Merge the collaboration notes into the workflow guide

- **Decision**: Move the unique collaboration guidance into the workflow guide and delete the notes.
- **Context**: The notes duplicate the handoff policy and the guide; only the concise human/agent guidance is unique.
- **Consequences**: The guide gains one subsection; the multi-agent runbook stays the walkthrough.

### ADR-006: No release and no slide-deck change

- **Decision**: Merge the docs sweep without a version bump and leave the slide deck to its own ticket.
- **Context**: The change is documentation only and adds one test; the README already leads the deck.
- **Consequences**: The release history stays at v7.2.0. The slide ticket follows.

## Risks and Gaps

- **RSK-001**: A deleted doc is still linked. Mitigation: the docs audit test and the README link check.
- **RSK-002**: The provider guide's pricing ages. Mitigation: the disclaimer and the checklist; link the official pages.
- **RSK-003**: The collaboration merge loses a rule. Mitigation: move the A2A and handoff lifecycle material; keep the source until the merge passes review.
- **RSK-004**: The compared doc rewrite drifts from the README. Mitigation: the fixed-shape thesis and the README link.
- **RSK-005**: The 30th test breaks the toolchain fixture. Mitigation: update the toolchain note and the validation doc; the fixture derives the count.
- **RSK-006**: The Kilo Code facts are incomplete. Mitigation: use the replace-Cline ticket's four facts; keep the human backstop.

## Test Plan

Write the failing test first: add `tests/test-docs-audit.sh`.

- Check the three retired docs are absent.
- Check the kept and rewritten docs are present.
- Check the provider guide names Kilo Code and not Cline.
- Check the setup has the Kilo Code setup.
- Check the post-compaction guide and the project knowledge note have the Kilo facts.
- Check the learning runbook has no Cline reference.
- Check the compared doc has the fixed shape and the single-assistant audience, and no VS Code versus CLI framing.
- Check the workflow guide has the Agent Collaboration subsection and the multi-agent link.
- Check the README docs index lists the survivors.
- Resolve the README and docs index local links; skip external URLs and strip anchors.
- Update `protocol-verification-toolchain.md` and `docs/protocol-validation-system.md` to 30 test scripts.
- Run markdownlint on every changed doc and shellcheck on the new test.
- The suite must pass 30/30; the protocol validator 8/8.
- Manual read: the provider guide, the setup, and the compared doc tell one current story.

## Close Sequence

- **Repo**: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- **Base ref**: `master`.
- **Branch**: `feature/docs-guide-audit`, created at implementation.
- **Merge mode**: direct, because `ai-customization.md` has no `## Merge Policy`; squash merge, delete the branch, push.
- **Protected branch**: explicit approval before the merge to `master`.
- **Tickets**: move `docs-guide-audit.md` from `open/` to `in-progress/`, then to `closed/` in the branch commit. Close `replace-cline-provider-with-kilo-code.md` as folded into this unit.
- **Plan attachment**: attach this plan under `## Implementation Plan` before deleting the plan file.
- **Checkpoint**: run on the branch before the commit.
- **Release**: none planned; merge and close.
- **Evidence**: `tests/run-all.sh` (30/30), `support-files/validate-protocol.sh` (8/8), markdownlint, shellcheck, and the local link check.
- **Post-merge**: no commits and no repository changes.

## Peer Review Log

- Round 1: APPROVED, `ai/code-review-reports/2026-11-22_21-08_review-84.md`; no Critical, Major, or Minor; four suggestions: keep the compared doc's translation table with current counts and paths, leave the exact docs count out of the test, record the manual provider and Kilo check, and fold the replace-Cline Kilo facts into the post-compaction guide and project knowledge before closing that ticket.
- Implementation round 1: APPROVED, `ai/code-review-reports/2026-11-22_21-12_review-85.md`; no Critical, Major, or Minor; three suggestions: the excluded slide deck keeps its Cline references for its own ticket, the new docs' internal links are a manual check, and the retire list is exactly three docs with 18 files left.

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

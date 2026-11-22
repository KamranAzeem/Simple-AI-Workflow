Reported: 2026-11-22
Reporter: Kamran Azeem
IssueType: Documentation
Severity: P2
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Restructure the README as a findable landing page with what, why, and how for every feature

Description:

Origin.

- The README has grown very large, and finding information in it has been reported as difficult.
- The features, why they exist, and how to use them are not fully covered.
- Deep reference material and the workflow guide duplicate each other.
- The current opening and the "one assistant" paragraph contradict the new positioning.

Evidence.

- `README.md` is 474 lines, with 18 top-level sections and no table of contents.
- The policy list says 12 domain policies plus 11 protocol policies, which is 23, while the repository has 24.
- The knowledge standards section is about 45 lines and duplicates the workflow guide's section 23.
- The setup and quick start come before the problem and the value.
- `README.md` line 81 says "If you only ever use one AI assistant, you probably don't need this." The main audience is exactly that user.
- The multi-driver story appears in "Why I built it" and in the comparison section, not as a secondary capability.

Scope.

- Make the README a landing page, not a manual.
- New order: one-sentence promise, the gap, a 60-second example, quick start, what it is and is not, a navigation map.
- Add a table of contents near the top.
- Cover each feature group with what it does, why it exists, and the command or path. Group them by job: setup, daily loop, memory, quality, delivery, maintenance.
- Move deep reference to the workflow guide or focused docs, and leave a short summary with a link.
- Fix the stale counts and the policy list.
- Rewrite "Why I built it" to remove the "you probably don't need this" line and to demote the multi-driver story.
- Present VS Code as the recommended home, with editor-agnostic support as a capability.
- Apply the narrative brief in `ai/issues/open/slide-deck-refresh.md`.
- Fix every broken link.

Target.

- At most 250 lines.
- Setup, the daily loop, and any feature's why and how reachable in under a minute.

Acceptance criteria.

- A new user can find setup, the daily commands, and a feature's why and how in under a minute.
- No deep reference is duplicated between the README and the workflow guide.
- No stale policy or procedure count remains.
- Every link resolves.
- The README and the slide deck share the same top-level narrative.

---

2026-11-22

Filed from the documentation discussion. Blocked on the narrative brief in `ai/issues/open/slide-deck-refresh.md`; the restructure can start once the brief is agreed.

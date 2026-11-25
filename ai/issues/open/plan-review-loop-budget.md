Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Bound the plan review loop and stop plans from restating procedures

Description:

Observed on the team knowledge rename plan: 13 review rounds, 37 Major and 86 Minor findings, 87 minutes by report timestamps, and no implementation. The store design was stable early. Rounds 5 to 13 were almost entirely close-sequence, release, git hygiene, and exact-wording findings. The plan was 220 lines for a directory rename.

Proposed changes:

- Cap plan review at three rounds. After the design freezes, only Critical findings block. Major findings become implementation notes or a separate checklist.
- Plans cite the procedures and list only deltas: repo, base, branch, merge mode, release yes or no. Do not restate the close sequence.
- One behavioral assertion per acceptance criterion. Do not assert exact sentences for AI-driven output.
- Start each work item from a clean tree. Do not put park and restore mechanics in a plan.
- Re-size work honestly. A rename or layout change is S and uses context plus acceptance criteria, not HLD and LLD.

Expected effect:

- A small change gets one focused review, not a prose-consistency proof.
- Close mechanics are owned by the procedures, so they cannot drift between plan copies.
- The implementation review tests the real diff, which can run the suite and the helper.

Needs:

- Policy changes to `ai-policy-issue-management.md` and `ai-policy-code-review.md`.
- An ADR entry, tests, docs, and a release.

Source: the user's review of the 2026-11-24 team knowledge rename plan.

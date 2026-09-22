Reported: 2026-09-22
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: A pre-work commit lands on master before the branch opens and survives a discarded branch

Description:

A "start work" commit lands on `master` before the feature branch opens. If the branch is
discarded midway, that commit stays on `master` as noise. `master` should read as a changelog,
not an activity log.

Example from `git log`:

```text
a5821d4 - chore(ai): start work on the bounded boot-time staleness heuristic
df3ffef - feature(protocol): add the bounded boot-time staleness heuristic
```

Root cause:

- The Branch-Gating exception let documentation and AI tracking files skip branching, which
  licensed direct commits to `master`.
- Nothing forbade opening a work item with an announcement commit.

Fix (in progress):

- Remove the Branch-Gating exception from `ai-policy-common.md`.
- Add the No pre-work commits rule: every commit carries the work; when a work item goes on a
  branch, open the branch before the first commit.

Out of scope:

- The cross-machine state-commit cycle. The hash half was resolved by State-File Model v2
  (no branch, hash, or push in state files; no commit prompts). The persistence half has no
  clean answer and is inherent, so it is abandoned.
- Batching of housekeeping commits. Dropped with the cycle. Checkpoint commits are a separate
  concern and are not part of this ticket.

---

2026-09-22
Scoped to pre-work commits only. The housekeeping-batching direction list and the open
end-user question are removed. The fix edits `ai-policy-common.md` (rule) and
`ai-policy-meta.md` (protocol-change ADR mandate). Work on branch
`feature/pre-work-commits-policy`; merge only on user approval.

---

2026-09-22
Closed. The Branch-Gating exception was removed and the No pre-work commits rule added in
`ai-policy-common.md`. The protocol-change ADR mandate was added to `ai-policy-meta.md`, and
the decision was recorded in `ai/shared/project-knowledge/protocol-decisions.md`. Docs synced
in `docs/workflow-guide.md` §4. Validator v5.0 8/8; markdownlint clean; peer review APPROVED.
Closing on the branch so the squash-merge carries the closed state.

# Plan: No pre-work commits, and the protocol-change ADR mandate

Status: revised after peer review review-01 (CHANGES REQUESTED). Awaiting review-02 and user approval.

## Problem

- `master` carried commits that announce work instead of containing it. A "start work on X"
  commit landed before the feature branch opened, and it stays on `master` if the branch is
  abandoned.
- The Branch-Gating exception in `ai-policy-common.md` lets documentation and AI tracking
  files skip branching. That exception licensed the direct-on-`master` pattern.
- The mandate to record every protocol or policy change in `protocol-decisions.md` is only
  conventional. The 2026-09-10 entry records a real miss (a change committed with no ADR
  entry, caught later by peer review).

## Decisions locked by the user

1. Remove the Branch-Gating exception from `ai-policy-common.md`.
2. Add the No pre-work commits rule, verbatim:
   "No pre-work commits. Every commit carries the work itself. Never open a work item with a
   "start work" or placeholder commit. When a work item goes on a branch, open the branch before
   the first commit."
3. Add one Required Pre-action Check to `ai-policy-meta.md`: every protocol or policy change
   adds a dated `protocol-decisions.md` entry; do not commit a protocol change without it.
4. The rule is general. It applies to every repository, whether or not `ai/` is tracked, and
   whether or not `ai/` is its own repo. No rule may assume either.
5. Out of scope: the cross-machine state-commit cycle. The hash half was resolved by
   State-File Model v2 (no branch, hash, or push in state files; no commit prompts). The
   persistence half has no clean answer and is inherent, so it is abandoned. Housekeeping
   commit batching is dropped with it.

## Files and exact edits

### 1. `ai/policies/ai-policy-common.md`

- Delete the exception line in `Branch-Gating Requirement`: "Read-only work, documentation,
  and AI tracking files do not require branching, BUT all state-changing Git operations on
  `master` or `main` still require explicit per-interaction human approval."
- Add rule 2 in place of the exception, phrased to read generally ("Every commit ...").
- Placement decided: keep it in `Branch-Gating Requirement`, because the rule is branch timing
  and the exception it replaces lived there. Universal Operational Guardrails was the rejected
  alternative. The section header scopes to features, architecture, and functional code, so
  the rule opens with "Every commit" to keep it general.

### 2. `ai/policies/ai-policy-meta.md`

- Add item 6 to Required Pre-action Checks: "Add a dated entry to
  `ai/shared/project-knowledge/protocol-decisions.md` for every protocol or policy change. Do
  not commit a protocol change without it."

### 3. `ai/shared/project-knowledge/protocol-decisions.md`

- Append a dated entry. Draft:

  ```text
  ## 2026-09-22: No pre-work commits (branch before the first commit)

  ### Problem
  - master carried commits with no work in them. A "start work" commit landed before the
    feature branch opened, and it stays on master if the branch is abandoned.
  - The Branch-Gating exception allowed direct commits to master for documentation and AI
    tracking files, and licensed the pattern.

  ### Decision
  - Remove the Branch-Gating exception from ai-policy-common.md.
  - Add: "No pre-work commits. Every commit carries the work itself. Never open a work item
    with a 'start work' or placeholder commit. When a work item goes on a branch, open the
    branch before the first commit."
  - Add a Required Pre-action Check to ai-policy-meta.md: every protocol or policy change adds
    a dated entry here. Do not commit a protocol change without it.
  - The rule is general: every repo, independent of whether ai/ is tracked or is its own repo.

  ### Scope choice
  - No ban on direct commits to master/main. Rejected as too strict. The protected-branch
    approval rule still governs those.
  - Removal is safe: Branch-Gating's scope is features, architecture, and functional code.
    Docs and tracking files were never in scope, so no replacement carve-out is needed.
  - Out of scope: the cross-machine state-commit cycle (hash half resolved by State-File
    Model v2; persistence half inherent and abandoned) and housekeeping-commit batching.

  ### Verification
  - Validator 8/8; markdownlint 0; grep confirms no live reference to the removed exception;
    peer review APPROVED.

  ### Routing
  - Behavior in ai-policy-common.md and ai-policy-meta.md. No AGENTS.md change. No validator
    anchor.
  ```

### 4. Ticket

- At implementation start, on the branch: rename
  `ai/issues/open/git-history-noise-from-ai-housekeeping-commits.md` to
  `pre-work-commits-on-master.md` and move it to `ai/issues/in-progress/`.
- Trim to the pre-work-commit scope. Remove the housekeeping-batching direction list. Add the
  out-of-scope note for the cross-machine cycle, with the State-File Model v2 reference.
- Close the ticket only when the fix is merged. Merge is blocked until the user approves it.

### 5. Docs

- Add one bullet to `docs/workflow-guide.md` §4 "Working with Git" so the enforced-Git list
  stays accurate: no pre-work commits, and the AI branches before its first commit.
- `README.md` and `docs/ai-agent-collaboration.md`: no references found, no change.

## Evidence-based investigation scope (cone of influence)

Read-only checks before peer review:

1. `ai/policies/ai-policy-common.md`: Branch-Gating section, Non-Negotiables, Universal
   Operational Guardrails, Universal Engineering Standards (Conventional Commits), Humanized
   Output (Git commits). Confirm no other text states or depends on the exception.
2. `ai/policies/ai-policy-meta.md`: Required Pre-action Checks, Forbidden Actions, Audit &
   Logging. Confirm the new check fits and numbering stays correct.
3. `ai/shared/project-knowledge/protocol-decisions.md`: scan for any prior decision that
   blessed direct-to-master commits or the exception. None expected.
4. `AGENTS.md`: TIER 2 Branch Gating and Protocol Developer Mode. Confirm no lingering
   exception text.
5. `support-files/validate-protocol.sh`: confirm no anchor references the removed text, and
   that the change needs no validator edit.
6. Docs: grep `docs/` and `README.md` for the exception wording and for direct-commit
   statements.
7. `.gitignore` and `gitignore-example.txt`: confirm the rule makes no assumption about `ai/`
   tracking.
8. Global settings `~/.ai/settings/global-user-settings.md` Git Conventions: confirm
   consistency (feature branches, squash merge). This file is not edited.

## Investigation findings (2026-09-22)

- F1. The exception text exists only at `ai-policy-common.md:37`. Grep over the repo
  (excluding git-ignored review reports) finds no other copy. Removal is contained.
- F2. No `docs/`, `README.md`, `AGENTS.md`, or validator reference points at the exception.
  No doc sync is required. Optional: add one bullet to `docs/workflow-guide.md` §4 "Working
  with Git" for the new rule, since that section lists what the protocol enforces around Git.
- F3. `validate-protocol.sh` v5.0 has no anchor on Branch-Gating or on the exception. The
  change needs no validator edit. The policy READ-ONLY START/END markers are untouched.
- F4. Wording risk. "Open the branch before the first commit" reads as absolute, which
  conflicts with the deliberate no-ban on direct commits to `master` and with recorded
  precedent (2026-06-22-02: "Applied directly on master as a protocol-development change with
  human approval"). Recommend a conditional form: "When a work item goes on a branch, open
  the branch before the first commit."
- F5. Placement risk. The rule is general but Branch-Gating is scoped to features,
  architecture, and functional code. Replacing the exception in place is local and simple;
  moving the rule to Universal Operational Guardrails is more clearly general. Recommend
  keeping it in Branch-Gating and phrasing the rule with "Every commit".
- F6. The ticket rename has no external references. Only the plan names the old slug.
- F7. Prior constraints that bind the new prose: concise what-focused text (2026-09-19), no
  procedure letters or step numbers in policy files (2026-08-05), no markdown hyperlinks in
  policy files (2026-06-19), routing principle (2026-08-31), em-dash free (Humanized Output).

## Risks and edge cases

- A general rule placed under a feature-scoped section may read as scoped. Addressed by the
  placement decision above and the general "Every commit" opening.
- The rule is intentionally terse. The ADR Scope choice is the authoritative clarification
  that direct commits to `master`/`main` are not banned. Precedent 2026-06-22-02 stands.
- Policy files must not use markdown hyperlinks, and must not use procedure letters or step
  numbers (2026-06-19 and 2026-08-05 decisions).
- New prose must be what-focused, short, and em-dash free (2026-09-19 and Humanized Output).
- The meta policy is read-only-marked. The edit happens under Protocol Developer Mode with the
  full load already done.
- `ai/code-review-reports/` is git-ignored, so review reports are not committed.

## Verification plan

- `support-files/validate-protocol.sh` (expects 8/8).
- `markdownlint-cli2` on every changed markdown file.
- `rg -n "do not require branching|per-interaction" ai/policies/ AGENTS.md docs/ README.md`
  returns nothing after the edit. (Scoped to shipped files: the plan and the review reports
  quote the deleted text by design.)
- `rg -n "git-history-noise-from-ai-housekeeping-commits" .` returns nothing after the rename.
- Procedure D peer review of the implementation.
- Procedure C checkpoint: update project knowledge, the daily checkpoint, and `ai/state/` as
  the orchestrator.
- `ai/code-review-reports/` is git-ignored, so review reports are not committed.
- No merge to `master` until the user says so.

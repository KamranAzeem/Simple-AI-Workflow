Reported: 2026-11-03
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Add the issue, plan, and implement phrases to the README common instructions and fix content drift

Description:

## Problem

The v5.6.0 announcement gives three working phrases (`"file an issue"`, `"plan the issue"`, `"implement the plan"`), but the README common-instructions table does not. A new reader cannot discover the delivery flow from the README.

A full README review also found content that drifted from v5.6.0 and wording that can be clearer.

## Required changes

- Add the three phrases and a short typical cycle to Common instructions.
- Document `## Merge Policy` in Customizing the AI and the update path.
- Update the sync descriptions to mention the Merge Policy addition.
- Correct outdated claims: "not a team tool" (team PR/MR is supported), "only user-facing script" (validators exist), and "AGENTS.md is kept deliberately short" (it holds the procedures).
- Fix the wording items listed in the plan.

## Acceptance criteria

- The three phrases appear in Common instructions with one-line descriptions, plus a short typical cycle.
- The Merge Policy section is documented in Customizing the AI and the update path.
- No outdated claim remains.
- Markdown lint reports 0 and every changed link resolves.
- No protocol file changes.

---
2026-11-03
Plan attached below.

## Implementation Plan

# Improve README Common Instructions and Content

## Ticket

- Local ticket: `ai/issues/open/readme-common-instructions-and-content-review.md`.
- Type: Documentation. Severity: P3 (AI estimate). Size: S (AI estimate).
- Plan depth: S, so this plan carries context and acceptance criteria.

## Context

The v5.6.0 announcement names three working phrases: `"file an issue"`, `"plan the issue"`, and `"implement the plan"`. The README's Common instructions table does not include them, so a reader cannot discover the delivery flow from the main entry document. A full read of the README also found claims that drifted from v5.6.0 and wording that can be clearer.

## Evidence

The README was read in full (402 lines). The findings:

- The Common instructions table at lines 98 to 113 lists setup, checkpoint, knowledge, review, state, and design-doc phrases. It has no issue, plan, or delivery phrase.
- The Customizing the AI section at lines 243 to 251 lists expertise, traits, compliance, and developer workflow. It does not mention `## Merge Policy`.
- The update section at lines 254 to 299 does not mention that the sync script adds the Merge Policy section.
- Line 48 says `AGENTS.md` is "kept deliberately short". It now holds the two work-item procedures and is not short.
- Line 69 says "Not a team tool. It is built for one developer." v5.6.0 supports a team PR/MR merge path.
- Line 75 says the sync tool is "the only user-facing script". The protocol validators also exist and are user-visible.
- Line 46, line 256, and line 295 describe the sync script without the Merge Policy addition.
- Line 9 has an awkward parenthetical, line 21 has an unclear `mkdir` sequence, line 24 uses a hyphen where a comma reads better, line 33 is wordy, line 152 calls an old issue "under active investigation", line 174 has a grammar error, line 175 lacks code formatting, the update list renumbers at 297 to 299, and line 390 does not mention delivery.
- The announcement at `docs/announcements/v5.6.0.md` holds the three phrases and the Merge Policy explanation.

## Changes and Acceptance Criteria

AC-1: Common instructions gains these rows, placed after the checkpoint row:

```text
| Create a ticket for a task or bug | `"file an issue: <summary>"` |
| Analyze and plan a ticket | `"plan the issue <ticket file or #N>"` |
| Implement an approved plan | `"implement the plan"` |
| Close or list tickets | `"close issue <ticket file or #N>"`, `"list issues"` |
```

AC-2: A short "Typical cycle" paragraph follows the table. It states that filing, planning, and implementation are separate requests, each stops when its action is done, and the implementation request covers the merge, push, and release the plan names.

AC-3: Customizing the AI gains a fifth item for `## Merge Policy` with `direct`, `pr`, and `auto`, and a one-line explanation of the fallback.

AC-4: Keeping this workflow up to date states that the sync script adds `## Merge Policy` when it is missing, and the list numbering after the code blocks is corrected.

AC-5: The sync descriptions at lines 46, 256, and 295 mention the Merge Policy addition.

AC-6: The outdated claims are corrected:

- Line 48: describe progressive disclosure without claiming the file is short.
- Line 69: "Not a team management platform. Built for one developer, with a PR/MR path for team repositories."
- Line 75: name the validators as user-visible scripts.

AC-7: The wording fixes:

- Line 9: "follow my rules, and maintain state".
- Line 21: one `mkdir -p` command with explicit paths: `mkdir -p "$HOME/.ai/settings" "$HOME/.ai/global-knowledge" "$HOME/.ai/backups"`.
- Line 24: "with the CLI or a file manager".
- Line 33: "Checkpoint often."
- Line 152: replace "Though AI itself misses this most of the time. (*This issue is under active investigation at the moment*.)" with "The AI often misses it."
- Line 174: "all the information keeps getting recorded".
- Line 175: format `/compact` and `/compress` as code.
- Line 373: shorten the issue-management bullet and keep the merge-mode fact.
- Line 390: add delivery to the workflow guide description.

AC-8: Markdown lint reports 0 on `README.md`.
AC-9: Every changed relative link resolves.
AC-10: No protocol file, policy, script, or state file changes.

## Release

No release. This is a documentation correction with no protocol behavior change.

## Close Sequence

- **Repo**: this repository. One repo.
- **Base ref**: `origin/master`, fetched at implement time.
- **Branch**: `feature/readme-common-instructions`, opened on the implement request.
- **Ticket**: `ai/issues/open/readme-common-instructions-and-content-review.md`. Attach the plan, close it on the branch, and delete the plan file.
- **Merge**: direct.
- **Release**: none.
- **Commit**: one commit, subject `docs(readme): add work-item phrases and refresh content`. It carries the README, the closed ticket, and the checkpoint.
- **Gate**: after the commit, the tree is clean and the branch is one commit ahead of `origin/master`.
- **Ship**: squash merge, delete the branch, push the trunk, verify. No tag and no release.
- **Approval**: the implement request is the approval for this sequence.

## Risks

- Over-editing can sand off the author's voice. Mitigation: make only the listed changes.
- A claim can drift again. Mitigation: verify each corrected claim against the current procedure and policy.
- The table and link changes can break lint. Mitigation: run markdownlint and check the changed links.

## Peer Review Log

- Round 1: CHANGES REQUESTED. 2 Minor (the `mkdir` example used Bash brace expansion, and the line 152 replacement was not checkable) plus one suggestion (place the new rows after the checkpoint row). Fixed.
- Round 2: APPROVED. No Critical, Major, or Minor finding.

Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Post-Compaction Recovery is documented as automatic but must be run manually.

Description:

The workflow guide and the slide deck describe Post-Compaction Recovery as a reload that runs by itself after the conversation is compacted. In practice it never fires automatically. No harness provides a reliable hook that runs after compaction and re-injects the protocol. The available pre-compaction hooks fire before the summary and cannot inject context into the next turn.

The documentation therefore sets a wrong expectation. The procedure is safe to run at any time because it only adds rule and config files, but the user has to invoke it.

Desired outcome:

- State in the workflow guide, the slide deck, the setup guide, the comparison table, the README, and the project knowledge note that the user must run `run post-compaction recovery procedure` after a compaction.
- State the reason: the behavior needs a post-compaction hook, and current harnesses do not expose one that works.
- Keep the procedure's reload steps unchanged and keep the no-state-file rule.
- Update the tests that pin the old wording.

---
2026-11-24
Filed from the session that found the wrong claim. Work starts on `feature/post-compaction-manual-recovery`.

---
2026-11-24
Implemented on `feature/post-compaction-manual-recovery`. The procedure, the always-on rule, the guide, the slides, the setup guide, the comparison table, the README, and the project knowledge note now state the manual run. Review-94 CHANGES REQUESTED, review-95 APPROVED. Checks: validator 8/8, authoring PASSED, suite 31/31, markdownlint 0, shellcheck 0.
Plan attached below. Merge and the v7.2.1 publication await approval.

## Implementation Plan

# Plan: Post-compaction recovery is manual

## Evidence

- `docs/workflow-guide.md:132` says the AI runs the procedure before responding, and `:149` promises zero-touch resume.
- `docs/simple-ai-workflow-slides.md:589` calls it "the automatic reload after a summary"; the speaker notes at `:596` say "Recovery is automatic".
- `ai/procedures/post-compaction-recovery.md:1` titles it "Automatic after conversation compaction".
- `docs/post-compaction-reload-trigger-setup.md` treats an external note or hook as the re-arm mechanism.
- `ai/shared/project-knowledge/compaction-trigger-problem.md` presents automatic firing as the goal.
- The comparison table at `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:95` implies an automatic recovery path.
- Harness fact: a pre-compaction hook fires before the summary and cannot inject context into the next turn; no harness exposes a working post-compaction hook.

## Context

The recovery procedure is safe at any time because it only adds rule and config files. The defect is the claim, not the procedure steps. The fix states the manual invocation and the reason, and keeps every reload step and the no-state-file rule unchanged.

## Acceptance criteria

- AC-1: The procedure title and body state that the user must run it manually and no harness hook fires it.
- AC-2: The always-on `AGENTS.md` session-resume rule says the user invokes the procedure manually.
- AC-3: The workflow guide explains the manual step, the limitation, and the visible confirmation; it drops the zero-touch claim.
- AC-4: The slide deck and speaker notes say "manual" and drop "automatic".
- AC-5: The setup guide, the comparison table, the README, and the project knowledge note state the manual step and the missing hook.
- AC-6: The decision store records the decision and supersedes the automatic expectation.
- AC-7: Tests pin the manual wording and reject the automatic claim.
- AC-8: The validator, authoring checks, markdownlint, shellcheck, and the test suite pass.

## Close Sequence

- Repo: this repository.
- Base ref: `master`.
- Branch: `feature/post-compaction-manual-recovery`.
- Merge mode: resolve from `## Merge Policy` at implementation.
- Ticket: `ai/issues/in-progress/post-compaction-recovery-manual-only.md`; attach this plan at close.
- Release: patch release v7.2.1 after the merge, with the announcement and release-practices entry.
- Evidence: validator 8/8, authoring PASSED, suite green, markdownlint 0, shellcheck 0.

## Peer Review Log

- Round 1 (review-94): CHANGES REQUESTED. 2 Major, 11 Minor; fixed both Major findings and the actionable Minor findings.
- Round 2 (review-95): APPROVED. Remaining items were Minor and process-level; the quick ones were fixed.

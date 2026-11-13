# DO NOT MODIFY THIS FILE

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Handoffs

Define the handoff contract, the creation review, and the autonomous execution rules for a parallel session.

## Scope

- Apply this policy to every handoff file in the Project Handoffs Directory and to every session that creates, claims, executes, or reconciles one.
- Apply the common policy's state-file ownership, outbound content scrub, and branch-gating rules where this policy references them.

## Valid Handoff

- Treat a handoff as valid only when it contains every section in `## Handoff Template`, in order.
- Refuse a handoff that lacks any required section, and name the missing sections to the user.
- Refuse a handoff until `ai-policy-handoff.md` is loaded and the definition is met.
- Keep the `## Verification` section objective and executable.

## Handoff Template

Write the handoff with these sections in this order.

1. **Objective**: State the task, the created date, the author session, the receiver, and the claim instruction.
2. **Authorization**: State what the claim approves and what still needs a question.
3. **Read first**: List the files to read in full, in order.
4. **Scope**: State the work in scope and the work out of scope, including the three state files, the author's parallel files, and other sessions' files.
5. **Starting facts**: Label each fact as measured on a date, and tell the receiver to verify it.
6. **Steps**: State the work in order.
7. **Binding rules**: Name the policies and project rules that bind the receiver.
8. **Shared output paths**: List each generated artifact and its unique path, and forbid overwriting another run.
9. **Report back**: Require a final message, a `## Completion` note appended to the handoff, and clearing the claim.
10. **Review**: Record the reviewer, the date, the verdict, and the review report path.
11. **Verification**: Give executable commands with expected results, and keep read-only checks separate from execution checks.

## Creation and Review

- Draft the handoff under `ai/artifacts/handoffs/<handoff-slug>/handoff-draft.md`.
- Run a peer review on the draft before writing the final handoff.
- Require the review to answer whether a receiver can start this task from the handoff alone.
- Refuse the final handoff when the review returns CHANGES REQUESTED.
- Write the final handoff to `ai/shared/handoffs/<handoff-slug>.md` only after APPROVED.
- Record the review verdict in the `## Review` section.

## Authorization and Merger

- Approve the branch work and the direct merge to trunk in the handoff only when the review is APPROVED, the Verification passes, and the conditions in `## Conditional Autonomy` are met.
- Do not approve tags, releases, external system writes, or the three state files in the handoff unless the handoff explicitly names them and the user approved them.
- State the merge mode in the handoff, `direct` or `pr`, and default to the project's `## Merge Policy`, else `direct`.
- Require the receiver to record the merge on the coordination board and in the handoff.
- Require the original orchestrator to record the board and the handoff in the state files at the next checkpoint, then delete the handoff.

## Conditional Autonomy

- Apply the conditional autonomy only when the handoff is a Valid Handoff, the review is APPROVED, every verification step passes with zero errors, and the coordination board is updated.
- Authorize the receiver to merge the branch under the handoff's `## Authorization`, and never to write the three state files.
- Require the original orchestrator to own the state files, the checkpoint, and the handoff deletion.
- Fall back to the user's approval when any condition fails.

## Lifecycle

- Draft, review, finalize, claim, execute, verify, and merge in that order.
- Append the `## Completion` note and clear the claim after the merge.
- Leave the handoff file in place for the original orchestrator to record and delete.
- Never write the three state files from the receiving session.
- Report the merge and the completion on the coordination board.

## Shared Output Paths

- Write each generated artifact under `ai/artifacts/handoffs/<handoff-slug>/`, unless the task changes project files or the user names another path.
- Check that the path does not exist before writing, and choose a new path when it does.
- Never overwrite another run's file.
- Record the actual output path in the `## Completion` note and the final message.

## Outbound Scrub

- Treat the handoff as internal by default, and keep names and infrastructure detail when the audience is the same.
- Apply `## Outbound Content Scrub` to the exact handoff text only when the handoff leaves the project.
- Keep secrets out of every handoff, including the `## Verification` commands.
- Read the names list from the settings file at run time, and never embed it in the handoff.

## Loading

- Load `ai-policy-handoff.md` explicitly in `PROCEDURE CREATE-HANDOFF` and in the receiver start phrases.
- Do not add this policy to `## Active Expertise`.
- Do not auto-load this policy in `PROCEDURE LOAD-CONTEXT`.
- Rely on the always-on pointer in the common policy when the policy has not been loaded.

## References

- `ai-policy-common.md` (`## State File Ownership Protocol`, `## Outbound Content Scrub`, `## Feature Development and Branch-Gating`).
- `ai-policy-code-review.md` (`## Review Dimensions`).
- `PROCEDURE CREATE-HANDOFF` and `PROCEDURE RUN-PEER-REVIEW`.

<!-- AI-ASSISTANT: READ-ONLY END -->

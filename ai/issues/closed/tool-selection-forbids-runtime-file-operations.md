Reported: 2026-11-19
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: The common policy permits a runtime to create, append to, or edit a file; strengthen the Tool Selection rule

Description:

**Observed**: the AI used `python3` to write the checkpoint state files and the daily checkpoint, though the built-in `edit` and `write` tools were available. The common policy allows this through the conditional bullet "Never use the shell, Python, or another runtime to write or edit file content when a purpose-built edit tool exists."

**Change**: in `ai-policy-common.md`, `## Tool Selection`, replace that bullet with:

"Never use Python or another runtime to search, create, append to, or edit a file; use the built-in tool."

**Acceptance criteria**:

- The common policy carries the exact rule.
- The conditional bullet is gone.
- `tests/test-tool-selection.sh` pins the new rule.
- The protocol and authoring validators, the suite, markdownlint, and shellcheck pass.
- The ADR records the decision.
- The patch is released.

**Close sequence**:

- Repo: the protocol repo; base `master`; branch `fix/tool-selection-runtime-file-edits`.
- Direct merge; one squash commit; tag `v6.9.1`; the release note is draft-first for approval.

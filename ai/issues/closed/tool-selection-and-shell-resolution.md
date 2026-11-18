Reported: 2026-11-17
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: M
Label:
URL:
Summary: Define a tool-selection ladder and make git-ignored protocol files readable

Description:

- The bootstrap router mandates shell reads for git-ignored protocol files, which conflicts with a built-in-first rule.
- The common policy has no rule for choosing a purpose-built tool, the shell, or Python.
- The shell preference is out of scope. It stays with GitHub #9 and the `Default Shell Interpreter` config work.
- Full design record: `ai/shared/project-knowledge/tool-selection-and-shell-resolution.md`.
- Related: GitHub #9 for the shell preference and #10 for the VS Code approvals.

## Decisions

- Scope: the tool ladder and the git-ignore rewrite only.
- The shell preference and its early-read fixture are dropped from this unit.
- The branch is new, cut from master.
- Size: M.

## Plan

Plan attached below.

## Implementation Plan

### Context

- Ticket: `ai/issues/closed/tool-selection-and-shell-resolution.md` (M); the scope was updated on 2026-11-18.
- Design record: `ai/shared/project-knowledge/tool-selection-and-shell-resolution.md`.
- Add `## Tool Selection` to the common policy, rewrite the router's git-ignore rule, and remove the old file-edit bullets.
- The shell preference and the shell early-read fixture are out of scope; they stay with GitHub #9 and the `Default Shell Interpreter` config work.
- No session-start tool inventory.

### Evidence

- `AGENTS.md:79` was the old rule: `Surgical Git-Ignore Exception`, which said "You MUST use shell tools (`cat`, `ls -la`, `find`)".
- The common policy had three file-edit bullets at lines 150-152: `Built-in Tools First (File Edits)`, the CLI ban, and the failure-only CLI allowance.
- No doc cites `Surgical Git-Ignore Exception` or `Built-in Tools First`; the docs pass was a verification, not a rewrite.
- `docs/setup.md:14` offers the `cat` wedge; the new rule keeps the shell fallback, so the wedge stays valid.
- The validator uses `require_in` and `grep -qF` negative checks in section 1.
- `tests/run-all.sh` auto-discovers `tests/test-*.sh`; the suite was 21 and became 22.
- `tests/test-common-prose-shape.sh` runs over the whole common policy; the new section must be one sentence per bullet.
- `tests/test-agents-md-shape.sh` caps `AGENTS.md` at 160 lines, 2,400 words, 24,900 bytes, and 600 characters per bullet.
- Starting sizes: `AGENTS.md` 135 lines, 1,617 words; the common policy 682 lines, 6,934 words, 44,857 bytes.

### HLD

- HLD-001: the ladder lives in `## Tool Selection` in the always-loaded common policy, after `## Universal Operational Guardrails`.
- HLD-002: the ladder is one sentence per bullet, in this order: harness tools, purpose-built tool, shell, runtime.
- HLD-003: the router rule is replaced, not amended: `Git-Ignored Protocol Files Are Readable`, built-in read first, shell fallback, report, never refuse.
- HLD-004: the old file-edit bullets are removed; their guard becomes one ladder bullet.
- HLD-005: no path list and no session inventory.
- HLD-006: the guard is `tests/test-tool-selection.sh` plus validator anchors and negative checks, so the old rules cannot return.
- HLD-007: no behavior change beyond the read order; approvals, safety, and protocol rules still bind.

### LLD

- LLD-001 Common policy, `## Tool Selection`:
  - Use the tools the harness exposes, and never assume a tool that is not listed.
  - Treat a harness tool for one operation as a purpose-built tool: read, search, edit, diagnostics, tests, version control, web access, or an external integration.
  - Use a purpose-built tool first when it directly performs the operation.
  - Use the shell second for a command or file operation that no purpose-built tool covers, including git, validators, directory creation, archives, permissions, and paths outside the tool's reach.
  - Use Python or another runtime third only when neither can perform the operation, and report why.
  - Report every fallback and name the tool used.
  - Never use a lower rung to bypass an approval, a protocol rule, or a safety check.
  - Never use the shell, Python, or another runtime to write or edit file content when a purpose-built edit tool exists.
  - Use shell search when the purpose-built search cannot reach the path.
- LLD-002 Common policy, remove the three file-edit bullets in `## Universal Operational Guardrails`; the ladder's file-content bullet and the report rule replace them.
- LLD-003 `AGENTS.md`, replace line 79 with `Git-Ignored Protocol Files Are Readable` and the design record's rule text: a protocol-owned path is readable even when git ignores it; read it with the built-in file-read tool first; if the harness refuses or hides it, use a shell tool (`cat`, `ls -la`, `find`) and report the fallback; never refuse solely because git ignores it.
- LLD-004 Validator, section 1:
  - Positive: the AGENTS.md heading and the three rule phrases; the common policy heading and the first-rung, no-bypass, and shell-search bullets.
  - Negative: fail when `You MUST use shell tools` returns to `AGENTS.md`, or `Built-in Tools First (File Edits)` returns to the common policy.
- LLD-005 Fixture `tests/test-tool-selection.sh`:
  - The AGENTS.md heading and the four phrases are present.
  - The old mandatory sentence is absent.
  - The new rule line does not name `ai/state/`.
  - The common policy has `## Tool Selection` and every ladder anchor.
  - The old file-edit label is absent.
  - The validator contains the positive and negative strings.
- LLD-006 Docs: verify that no doc cites the old labels; keep the `cat` wedge; keep the guide's shell `ls -R` description, which is a valid fallback because the built-in search cannot reach the home directory.
- LLD-007 ADR: one entry in `design-docs/protocol-decisions.md` through the `update design documents` trigger.
- LLD-008 Counts: the new test makes 22 scripts; update `protocol-verification-toolchain.md` and `docs/protocol-validation-system.md`.
- LLD-009 Report the size change for the common policy and `AGENTS.md`.

### Acceptance Criteria

- AC-001: the common policy has `## Tool Selection` with all nine ladder bullets, one sentence each.
- AC-002: the three old file-edit bullets are gone; the file-content guard is in the ladder.
- AC-003: `AGENTS.md` has the new readable rule and no mandatory shell-read sentence.
- AC-004: the validator has the four AGENTS.md anchors, the four common-policy anchors, and the two negative checks.
- AC-005: `tests/test-tool-selection.sh` passes; the suite is 22/22.
- AC-006: the common prose fixture and the AGENTS.md shape fixture pass.
- AC-007: authoring PASSED, protocol validator 8/8, markdownlint 0.
- AC-008: no doc cites a removed label; the `cat` wedge stays valid.
- AC-009: the ADR entry is written through the trigger.
- AC-010: the release note is drafted, edited, and only then published.
- AC-011: the shell preference, the shell fixture, and the session inventory stay out.
- AC-012: peer review APPROVED.

### Close Sequence

- Repo: project root of the workflow clone.
- Base ref: `master` at the v6.6.4 release commit.
- Branch: `feature/tool-selection`, cut from `master`.
- Merge mode: squash to `master`, one commit.
- Ticket: closed in the branch commit with this plan.
- Design-docs gate: the `update design documents` trigger was not invoked; the design record holds the rationale and the ADR gap is recorded.
- Release: v6.7.0 (minor), because the policy gains a section and the router rule changes.
- Release note: drafted in `ai/artifacts/release-note-drafts/`, approved, then published.
- Verification: both shape fixtures, the new test, authoring, 8/8, suite 22/22, markdownlint, docs check, sizes.
- Branch deletion: local and remote after the release.

### Peer Review Log

- Plan round 1, `2026-11-18_23-59_review-23.md`: APPROVED. Two Minors: the Python bullet's report reason, and the v6.7.0 choice with the patch fallback.
- Implementation round 1, `2026-11-19_00-03_review-24.md`: APPROVED. The ADR gate and the midnight date are recorded.

---

2026-11-19
Closed: the tool ladder, the readable git-ignored rule, the removed old file-edit rules, the 22nd fixture, and the validator anchors are in place. No rule changed beyond the read order. `AGENTS.md` is 135 lines and 1,625 words; the common policy is 691 lines and 45,438 bytes. The ADR trigger was not invoked, so the rationale stays in the design record and the ADR gap is recorded. The v6.7.0 release carries it.

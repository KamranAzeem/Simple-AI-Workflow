Reported: 2026-10-27
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Add a visible protocol-file warning header to AGENTS.md

Description:

The warning that `AGENTS.md` is a protocol file, not a context file, exists only inside an HTML comment at `AGENTS.md:1-10`. A rendered view hides it, so a human or an AI using a rendered view can miss it and treat the file as context.

**Current state**

- `AGENTS.md:1-10` contains `START_IMMUTABLE_PROTOCOL`, `THIS IS A PROTOCOL FILE, NOT A CONTEXT STORAGE FILE.`, and the read-only warning.
- The first visible line is `# AI Bootstrap Entry Point`.
- `support-files/validate-protocol.sh` anchors on the `⚠️ STOP: READ-ONLY PROTOCOL` line inside the comment.

**Requested change**

- Add a visible header near the top of `AGENTS.md`.
- State that the file is a protocol file, not a context file.
- State that AI assistants must follow its instructions instead of treating it as context.
- Keep the read-only and no-modification warning visible or immediately adjacent.
- Preserve the existing validator anchor and the `# AI Bootstrap Entry Point` heading hierarchy.

**Open questions**

- Wording and shape: a bold banner, a blockquote, or a heading. A second H1 would compete with `# AI Bootstrap Entry Point`; a bold banner or blockquote above the HTML comment is the safer choice.
- Placement: above the HTML comment so it is the first rendered content, or below it so the raw-text warning stays first.
- Scope: repeat the no-modification rule in the visible header, or only the protocol-versus-context distinction.
- Whether to keep the HTML comment. Recommended: keep it for the validator anchor and raw-text readers, and add the visible banner.

**Acceptance criteria**

- A visible header appears at the top of `AGENTS.md` and says the file is a protocol file, not a context file, and that AI assistants must follow it.
- The read-only warning remains visible or adjacent.
- `bash support-files/validate-protocol.sh` still passes 8/8, including the immortality-header anchor.
- The `# AI Bootstrap Entry Point` heading remains the only H1, or the new header uses a lower level.
- The policy authoring validator passes on `AGENTS.md`, the reference test passes, and markdownlint reports 0 issues.
- README, workflow guide, and slides are checked for a description of the visible header and updated only if they need it.

**Blast radius**

- `AGENTS.md`
- `support-files/validate-protocol.sh` only if the anchored line moves
- `README.md`, `docs/workflow-guide.md`, and `docs/simple-ai-workflow-slides.md` if they describe the header
- `design-docs/protocol-decisions.md` if the change needs an ADR

**Related**

- `ai/issues/closed/clarify-load-context-in-readme.md` explains the protocol-versus-context distinction in the README and docs.
- `ai/issues/closed/canonical-state-file-headers.md` is about state-file headers, not the `AGENTS.md` file header.

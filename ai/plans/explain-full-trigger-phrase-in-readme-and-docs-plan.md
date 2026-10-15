# Plan: Explain why the full "using AGENTS.md protocol" phrase is required

## Ticket

`ai/issues/in-progress/clarify-load-context-in-readme.md` (Documentation, P1, Size M).

## Context

Users ask why they cannot type a bare `"load context"`. The README states the rule but not the reason. This plan adds the reason to the README and aligns the other user-facing docs so the message stays consistent.

Scope is documentation only. No `AGENTS.md` or policy file changes.

## HLD

- The README is the canonical home of the full explanation. It sits as a new `###` subsection directly below the "Common instructions" list, before "Once context is loaded, you can also ask:".
- The explanation states the reason in plain, warm language. A bare `"load context"` loads the assistant's own hidden memory. `AGENTS.md` is a protocol file, not a context store. The assistant reads it only when named. A shortcut cannot fix this, because a shortcut would have to live inside a protocol the assistant has not read yet (the chicken-and-egg problem).
- The subsection covers both trigger phrases, `load context` and `bootstrap`.
- No alias suggestion is given, because an alias cannot work for the same reason.
- Other user-facing docs are aligned: each doc that teaches the command gets a short why or a pointer to the README section. Docs that only mention the phrase in passing are left alone unless they contradict.

## LLD (with AC)

### LLD-1: README explanation section

- Add subsection `### Why "... using AGENTS.md protocol"?` at `README.md`, below the common-instructions list (after the note on line 108).
- Content: warm, plain English; names both triggers; no harsh language; no alias offer.
- Fix the grammar bug in the existing bullet at `README.md:154` ("a fresh or weaker models") and cross-reference the new subsection.
- AC-1: The subsection appears directly below the common-instructions list.
- AC-2: It explains the reason (hidden memory vs. naming the protocol; the chicken-and-egg loop) and covers both triggers.
- AC-3: The text uses warm, plain English and contains no harsh language and no alias suggestion.
- AC-4: `README.md` passes markdownlint with zero issues.

### LLD-2: Slides alignment

- Extend the "The load context command" slide in `docs/simple-ai-workflow-slides.md` with a short "why the full form" bullet.
- AC-5: The slide states the why and uses no internal protocol label such as PROCEDURE LOAD-CONTEXT.

### LLD-3: Guide alignment

- Add a one-line why, or a pointer to the README section, in `docs/workflow-guide.md` and `docs/how-policies-work-in-this-workflow.md` where each explains the command.
- AC-6: Both docs are consistent with the README and contradict nothing.

### LLD-4: Consistency pass

- Review the remaining user-facing docs that use the phrases: `docs/example-learning-session-runbook.md`, `docs/multi-agent-runbook.md`, `docs/compliance-guide.md`, `docs/personas/README.md`, `docs/ai-policy-mobile-apps-guide.md`, `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`.
- Add the why only where the doc teaches the command.
- AC-7: No user-facing doc presents the short form as sufficient.
- AC-8: Historical `docs/announcements/v4.0.0.md` is left unchanged.

### LLD-5: Decision record

- Add one dated entry to `design-docs/protocol-decisions.md` capturing the durable documentation decisions (ADR-1, ADR-2, ADR-3).
- AC-9: The entry is self-contained, with no commit hash or branch name.

### LLD-6: Verification

- AC-10: `markdownlint-cli2` reports zero issues on the changed markdown.
- AC-11: `support-files/validate-protocol.sh` still reports 8/8 and the reference test still passes, since no protocol-facing file changes.

## ADRs

- ADR-1: User-facing docs explain the chicken-and-egg rationale, not just the rule. Context: users repeatedly ask for a short command. Consequence: the README carries the canonical explanation; other docs point to it.
- ADR-2: No alias suggestion in docs. Context: an alias would have to sit inside the protocol, which the assistant cannot read until the protocol is loaded. Consequence: the docs explain the constraint instead of offering a workaround that cannot work.
- ADR-3: The explanation is warm and encouraging, not blunt. Context: the ticket was written while upset; user-facing docs must not carry that tone. Consequence: the "laziness" framing is dropped and the substance kept.

## Risks and gaps

- Scope creep: "align all user-facing docs" could balloon. Mitigation: only docs that teach the command get the why; passing mentions are left alone unless they contradict.
- The README already says the short form is discouraged at line 154. Mitigation: the new section becomes the source, and that bullet cross-references it.

## Verification steps

1. `markdownlint-cli2 "README.md" "docs/**/*.md" "ai/plans/**/*.md"` reports zero issues.
2. `bash support-files/validate-protocol.sh` reports 8/8.
3. Read the new README section aloud for tone and plain English.

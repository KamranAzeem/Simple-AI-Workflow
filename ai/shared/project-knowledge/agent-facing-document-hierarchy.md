> **Knowledge file.** Follow `ai-policy-common.md`, section `## Knowledge File Standards`. This header is canonical: copy it verbatim and do not edit it. If it is missing, run `repair knowledge files`.

# Agent-Facing Document Hierarchy

## Context

Agent-facing documents are read under attention pressure. `AGENTS.md`, policy files, skills, and handoff templates need an information hierarchy: what the agent does first, what it consults in the same file, and what it opens only when a branch needs it.

## Rule or Fix

- Put the steps the agent follows first.
- Keep in-file reference close to the steps.
- Move branch-only detail behind a context pointer.
- Apply progressive disclosure when the top of the document grows.
- Make every completion criterion checkable and exhaustive.
- Avoid vague completion criteria such as "understanding reached".
- Avoid showing later steps in a current step.
- Use compact leading words that recruit a known concept.
- State the positive action; avoid a bare negation.
- Keep one source of truth for each meaning.
- Treat the environment as a source of truth; do not restate it without a load reason.
- Cut every line that no longer bears on the document's job.
- Remove stale sediment instead of layering a new explanation over it.

## Why

- Every loaded token costs input budget on every turn.
- A diluted attention budget weakens instruction-following.
- Duplication inflates prominence and creates a second source to maintain.
- A vague completion criterion invites premature completion.
- A negation makes the unwanted behavior more available.

## Verify

- Confirm every step ends on a condition the agent can check.
- Confirm every branch-only detail has a pointer.
- Confirm the document has one source per meaning.
- Confirm every line still serves the document's job.
- Confirm the completion criteria are exhaustive and not revealing of later steps.

## Caveats

- A made-up leading word costs definition tokens.
- Not every section should move down the ladder; inline what every branch needs.
- The full source analysis is not part of the shipped corpus.

> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Trigger Phrase Naming

## Context

A new trigger phrase competes with the existing command family. A vague phrase such as `publish lesson` hides the scope and the destination, so the user has to guess which knowledge store it writes.

## Rule or Fix

- Name a store trigger after the scope and the existing family: `update team knowledge`, `update project knowledge`, `update global knowledge`.
- Prefer the verb the sibling triggers use, and keep the scope noun in the phrase.
- Add a natural variant only when it reads as a close form, for example `publish to team knowledge`.
- Keep the trigger namespace free of duplicates and whole-word containment; run the authoring validator index.

## Why

A user finds the action with the words already used for the same family, and the AI sees the scope before it acts.

## Verify

- Run `support-files/validate-policy-authoring.sh --triggers AGENTS.md ai/policies/*.md ai/procedures/*.md`; expect 0 conflicts and 0 errors.
- Confirm the phrase names the store and matches a sibling trigger.

> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# CSS Architecture

## Context

This sample project uses a modular CSS architecture. The goal is predictable styling without a framework.

## Rule or Fix

- Use modular CSS with BEM naming.
- Use vanilla CSS, without Tailwind or another framework.
- Put component styles in `src/styles/components/<component>.css`.
- Prefer component-scoped styling.
- Minimize global scope.

## Why

- Component scope keeps a style change local.
- A predictable file path makes the owning file easy to find.
- A small global scope reduces accidental overrides.

## Verify

- Confirm each component has a matching file under `src/styles/components/`.
- Confirm the class names follow BEM.
- Confirm no new global selector was added without a reason.

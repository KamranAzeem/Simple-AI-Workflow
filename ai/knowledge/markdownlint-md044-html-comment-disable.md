> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Markdownlint MD044 HTML Comment Suppression

## Context

- `MD044/proper-names` flags a lowercase proper name such as `linux` in a customization expertise token.
- An HTML comment is still scanned, and backticks inside it do not create a Markdown code span.

## Rule or Fix

- Put `<!-- markdownlint-disable-next-line MD044 -->` immediately before the HTML comment line.
- Use a file-level `<!-- markdownlint-disable MD044 -->` for a real config file whose plain bullet must stay lowercase.
- Use inline code for the token in normal Markdown prose.
- Never change the token case to satisfy the linter; the loader needs the exact lowercase token.

## Why

- The token is data, not prose. A linter-driven case change breaks policy resolution.

## Verify

- Run `markdownlint-cli2` on the file and confirm 0 issues.
- Confirm the config bullet still reads the lowercase token in plain text.

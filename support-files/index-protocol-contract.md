# Protocol Index Contract

The boot index is read-only and ephemeral. The primary source is `support-files/index-protocol.sh`; the fallback is the inline recipe in `ai/procedures/load-context.md` `STEP-PROTOCOL-INDEX`.

## Primary path

- Run `bash "<Global AI Workflow Directory>/support-files/index-protocol.sh"` from the project root.
- The helper runs `support-files/validate-policy-authoring.sh --index` over the global policies, the global procedures, and the project policies, then sets `effective` and `conflict` on the module lines.
- The dev `--index` output itself is unchanged.

## Line format

`type|scope|name|source|mode=<mode>|triggers=<phrases>|headings=<headings>|effective=<effective>|conflict=<conflicts>`

- `type` is `policy` or `procedure`.
- `scope` is `global` or `project`.
- `name` is the policy stem or the procedure H1 name.
- `source` is the path the validator received.
- `effective` is `yes` or `shadowed:<project-name>`.
- `conflict` is `none`, or `duplicate:<name>` or `overlap:<name>` joined by `,` and sorted.
- The summary line is the validator's `summary|...` line.

## Fallback

- Trigger: missing `bash`, missing helper, empty stdout, no `summary|` line, or exit 2.
- Use the built-in reader, glob, and search with the same scope resolution, dedupe, and project-root handling.
- Skip hidden entries, `tmp`, archives, and symlinks. The helper skips every symlink; the fallback cannot detect an escaping symlink and reports the divergence.
- A project policy with the same name as a global policy shadows it; the global line is `effective=shadowed:<project-name>`.
- Normalize a phrase to lowercase, replace non-alphanumerics with spaces, collapse, trim, and drop a trailing `#N`. A duplicate is the same normalized phrase; an overlap is a whole-word containment that is not identical.
- Report `index-source=fallback` with the reason in `ITEM PROTOCOL-INDEX`.
- Write no file and create no cache.

## Proof

- `ITEM PROTOCOL-INDEX` reports the module counts, trigger count, conflict count, errors, and `index-source=helper|fallback`.
- `ITEM STALE-KNOWLEDGE` reports `age-source=commit|mtime`.

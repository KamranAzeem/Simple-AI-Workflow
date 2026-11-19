# Protocol Index Contract

The boot index is read-only and ephemeral. The primary source is the built-in recipe in `ai/procedures/load-context.md` `STEP-PROTOCOL-INDEX`. The optional helper is `support-files/index-protocol.sh`; it is not used at boot.

## Primary path

- Build the index with the built-in reader, glob, and search.
- Scope: the global policies recursively, including `compliance/`; the global procedures; and the project policies recursively.
- Dedupe by canonical path.
- A project policy with the same name as a global policy replaces it: the global line is `effective=shadowed:<project-name>`, the project line is `effective=yes`, and the replaced global triggers stay reserved.
- Skip hidden entries, `tmp`, archives, and symlinks.
- Normalize a phrase to lowercase, replace non-alphanumerics with spaces, collapse, trim, and drop a trailing `#N`.
- A duplicate is the same normalized phrase across the effective set or between an effective module and a reserved trigger of a shadowed global.
- An overlap is whole-word containment across the same pairs.
- The pair between a shadowed global and its same-name replacement is exempt.
- A different-name project policy that uses a reserved trigger is a duplicate; both lines name each other.
- Record type, scope, name, source relative to its anchor, literal and normalized triggers, headings with levels, effective, conflict, and the index source. Hold no body text.
- Report `[PENDING]` for the global scope when the workflow clone cannot be reached.
- Write no file and create no cache.

## Optional helper

- Run `timeout 20 bash "<Global AI Workflow Directory>/support-files/index-protocol.sh"` from the project root only for a maintainer or release check.
- The helper calls `support-files/validate-policy-authoring.sh --index`, then sets `effective` and `conflict` on the module lines.
- Process creation is slow on Windows Git Bash, which is why the boot does not call it.
- The helper skips every symlink.

## Line format

`type|scope|name|source|mode=<mode>|triggers=<phrases>|headings=<headings>|effective=<effective>|conflict=<conflicts>`

- `type` is `policy` or `procedure`.
- `scope` is `global` or `project`.
- `name` is the policy stem or the procedure H1 name.
- `source` is the path the validator received.
- `effective` is `yes` or `shadowed:<project-name>`.
- `conflict` is `none`, or `duplicate:<name>` or `overlap:<name>` joined by `,` and sorted.
- The summary line is the validator's `summary|...` line.

## Proof

- `ITEM PROTOCOL-INDEX` reports the module counts, trigger count, conflict count, errors, and `index-source=builtin`.
- `ITEM STALE-KNOWLEDGE` reports `age-source=commit|mtime`.

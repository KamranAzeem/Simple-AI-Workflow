# Codebase examination: docs, tests, and support-files

**Type**: Task
**Priority**: P3
**Size**: M
**Created**: 2026-11-19
**Reported by**: AI
**Source**: full codebase examination over `docs/`, `tests/`, and `support-files/`, read-only
**Status**: closed

## Summary

The full read-only examination found seven follow-ups in the current docs, tests, and support files. The historical announcements are records and were not rewritten. No fix was made during the examination.

## Findings

- **F1 (docs)**: `docs/global-user-settings.md:1` still says the settings are loaded "before the first shell command". v6.10.0 changed the step to the first **named** command. Update the template sentence.
- **F2 (support docs)**: `support-files/README.md` describes only the sync scripts. It does not list the read-only `index-protocol.sh` helper, the `index-protocol-contract.md` recipe, or the fact that the sync does not copy the helper. Add the pair and the sync note.
- **F3 (test gap)**: `tests/test-protocol-index.sh` has no fallback smoke case, although the plan's LLD-003 promised one. Add a masked-helper or stub-runner case, or record the manual gate explicitly in the test plan.
- **F4 (test gap)**: `tests/test-load-context-boot.sh` checks the `STEP-SKILLS-INDEX` text anchor but no longer exercises the boot skills canaries that the old `skills_index()` helper covered. Keep a skills-index case or move the coverage to `tests/test-skills-index.sh`.
- **F5 (test weakness)**: `tests/test-config-resolution.sh:34` writes the backtick-bearing path in double quotes, so the shell substitutes it and the assertion is weaker than intended. Quote the literal.
- **F6 (helper latent bug)**: `support-files/index-protocol.sh` prunes `-name '*.tar*'`, which also excludes a policy whose name contains `tar` (for example `ai-policy-target.md`). Restrict the pattern to the archive suffixes the protocol names.
- **F7 (design drift)**: the helper skips every symlink, while the plan's HLD-004 says escaping symlinks and the contract says every symlink. Align the plan/ADR wording with the safer helper behavior, or teach the helper to include in-tree symlinks.

## Scope

Read-only. The examination covered the current `docs/` content, the `tests/` scripts, and the `support-files/` scripts and docs; the historical announcements were treated as records. No file was fixed.

## Acceptance

- F1 and F2 are updated in the docs.
- F3 and F4 are covered by a test or an explicit manual gate.
- F5 is corrected.
- F6 is fixed or documented as intentional.
- F7 is aligned in the plan/ADR and the contract.

## Resolution

- Fixed on `fix/codebase-examination-followups`: F1, F2, F3, F4, F6, and F7.
- F5 is withdrawn: the backticks are escaped with backslashes in double quotes, so the assertion is correct.
- Gates: suite 25/25, shellcheck 0, markdownlint 0 on the touched `.md` files.

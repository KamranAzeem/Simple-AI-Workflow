Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: A current validation doc and an acceptance spec still use the retired global scope token where the index prints workflow.

Description:

The scope token is `workflow` since v7.7.0. The live oracle prints it. Two current artifacts still say `global`.

- `docs/protocol-validation-system.md:36` says the scope is `(global or project)`.
- `docs/protocol-validation-system.md:37` says "a project and global skill package".
- `docs/protocol-validation-system.md:38` says "team-over-global overrides".
- `design-docs/specs/policy-loading-contract.md:9` says "The declaration governs global policies".
- `design-docs/specs/policy-loading-contract.md:32` says "`--index` prints ... `|global|`".
- The live oracle prints lines like `procedure|workflow|CREATE-HANDOFF|...` and a summary `modules=42|policies=26|procedures=16|triggers=59|conflicts=0|errors=0`.
- `tests/test-policy-load-paths.sh:202` and `:203` assert `|workflow|`.
- The skills precedence is project, then team, then user, then workflow.

Impact: the acceptance spec would fail if run literally against the current index, and the validation doc tells a maintainer the wrong token.

Resolution:

- Replace `global` with `workflow` in the spec and the validation doc.
- For the skills precedence lines, use project, team, user, workflow.
- Add a regression assertion: present `|workflow|` and absent `|global|` in the policy-load-paths test or the docs audit.

Acceptance criteria:

- No current doc or acceptance spec uses `global` as the scope token.
- A test fails if the token regresses.

---
2026-11-26
Filed from the 2026-11-26 codebase examination. Evidence group F2. No secret or identifying name present.

---
2026-11-26
Plan: `ai/plans/docs-batch-f2-to-f5.md` (M), batched with F2 to F5. Plan reviews 195 (CHANGES REQUESTED, fixed) and 196 (APPROVED). No branch; the tickets stay open until the implement request.

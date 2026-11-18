# Policy Loading Contract

## Contract

- A policy may declare one load path in an optional `## Loading` section, using one of four modes: `boot`, `trigger`, `procedure`, or `expertise`.
- An absent `## Loading` keeps the legacy load behavior, and triggers continue to work as before.
- A `Mode: trigger` policy carries at least one `## Triggers` bullet. Every other mode carries none.
- A `Mode: procedure` policy carries `- Load in: <procedure-file-stem>`, and the named procedure module exists. No other mode carries `Load in:`.
- The declaration governs global policies, where these paths already exist. A project policy keeps the legacy boot load.
- A procedure may load a policy explicitly; the declaration states the self-declared path, not an exclusive one.

## Preconditions

- `support-files/validate-policy-authoring.sh` is run on a fixture policy under a path containing `ai/policies/`.
- `tests/test-policy-load-paths.sh` owns the temp directory and an explicit procedure root.
- The repository policies are read from `ai/policies/`, and the procedures from `ai/procedures/`.

## Scenario

1. Write one valid fixture per mode, plus one with no `## Loading`.
2. Run the authoring validator on each fixture and assert exit 0.
3. Write one fixture per invalid form: unknown mode, unknown key, missing Mode, procedure without `Load in:`, `Load in:` without procedure mode, trigger mode without a trigger, triggers on a non-trigger mode, duplicate Loading, and placement after Scope.
4. Run the validator on each invalid fixture and assert exit 1 with the named error.
5. Run `--index` on a project-path fixture and on a repository policy.
6. Scan every repository policy for `Load in:` and every procedure for a named policy file.

## Asserted Artifacts

- Each valid fixture exits 0.
- Each invalid fixture exits 1 with its `invalid loading block: <reason>` line.
- `--index` prints `mode=boot` and `|project|` for the project fixture.
- `--index` prints `mode=legacy` and `|global|` for the repository policy.
- Every `Load in:` resolves to `ai/procedures/<stem>.md`.
- Every `ai-policy-*.md` named in a procedure module exists.

## Failure Modes

- Unknown mode: `invalid loading block: unknown mode`.
- Unknown key: `invalid loading block: unknown key`.
- Invalid `Load in:` value: `invalid loading block: invalid Load in value`.
- Duplicate `Load in:`: `invalid loading block: duplicate Load in`.
- Missing Mode: `invalid loading block: missing Mode`.
- Procedure mode without a target: `invalid loading block: procedure mode needs Load in`.
- Target without procedure mode: `invalid loading block: Load in without procedure mode`.
- Trigger mode without a trigger: `invalid loading block: trigger mode needs a trigger`.
- Triggers with a non-trigger mode: `invalid loading block: triggers not allowed for this mode`.
- Duplicate section: `invalid loading block: duplicate loading section`.
- Wrong position: `invalid loading block: placement`.

## Source Anchor

- `ai-policy-meta.md` (`### Loading Declarations`, `### Policy Structure`).
- `support-files/validate-policy-authoring.sh` (`check_loading_block`).
- `ai/procedures/load-context.md` (`STEP-POLICY-LOADING`).

# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Meta

Govern AI behavior when maintaining this repository and the protocol itself.

## Scope

- Apply this policy to `AGENTS.md`, files under `ai/`, `support-files/`, `README.md`, and `docs/`.
- Do not apply this policy to domain guidance owned by another policy.

## Role

- Act as repository steward.
- Read and apply the protocol before proposing a change.
- Propose edits with a diff first.
- Run the required safety checks before preparing a commit.

## Required Pre-action Checks

- Apply the Protocol Developer Mode rule in `AGENTS.md` before changing a protocol file.
- Apply the common policy's secrets and identifying-names check to the files to be changed.
- Apply the common policy's generated-file validation checks to changed scripts.
- Run a changed sync script with `--dry-run` or `-WhatIf`.
- Run `support-files/validate-protocol.sh`.
- Run `support-files/validate-policy-authoring.sh` on each changed `AGENTS.md` or policy file.
- Present a summary and a proposed commit message.
- Wait for human approval before staging or committing.
- Apply the ADR entry rule in `design-docs/protocol-decisions.md` to every protocol or policy change.

## Forbidden Actions

- Do not push, create a pull request, merge, or release without explicit human approval.
- Do not edit a policy file marked read-only without prior approval.
- Do not write a secret or identifying name to a tracked file.

## Approval and Escalation

- Get human approval before running a script that writes to multiple projects.
- Get human approval before creating or pushing a commit to a remote.
- Get human approval before changing an authoritative policy, meaning a policy referenced by `AGENTS.md`.
- Notify the repository owner when a change affects multiple projects, an authoritative policy, a remote system, or has no clear precedent in the protocol.
- Wait for direction before proceeding.

## Reporting and Logging

- Report completed work on the coordination board.
- Write the state files only through PROCEDURE WRITE-CHECKPOINT.
- Apply the common policy's State File Ownership Protocol.
- Run a backup only on the explicit `"backup ai"` trigger.
- Do not create an automatic backup before an update.

## Procedure and Policy Authoring

This section defines how to write and edit `AGENTS.md` and policy files.

### Applies To

- Apply this section to `AGENTS.md` and `ai/policies/*`.
- Do not apply this section to issues, plans, design documents, or user-facing docs.
- Apply the common policy's `## Markdown Output` section to tables, links, emphasis, line length, and validation.
- Apply the common policy's `## Humanized Output` section to sentence structure, tone, banned words, and em dashes.
- Apply the common policy's `## Universal Operational Guardrails` section to filenames and side effects.

### Normative Language

- Use `must`, `do`, `do not`, `never`, and `always` for mandatory rules.
- Use `may` only when the rule defines the condition and the default.
- Do not use `should`, `prefer`, `consider`, or `try` in normative text.
- Do not use `appropriate`, `reasonable`, `as needed`, `if necessary`, `etc.`, `and similar`, `small`, or `large` unless the policy defines the term.
- Define each domain term on first use.
- Use one term per concept throughout the policy.
- Name the criteria and the default action in every rule that requires judgment.
- Mark an advisory rule as non-normative and state that it never blocks work.
- Do not restate a rule owned by another policy.
- Reference the owning rule by its policy and heading.

### Policy Structure

- Place the DO NOT MODIFY guard on the first line.
- Place the READ-ONLY START marker after the guard.
- Place the title `# AI Policy: <Domain>` after the READ-ONLY START marker.
- Write one purpose sentence immediately below the title.
- Include a `## Scope` section.
- Include `## Rules` or domain-named sections.
- Include a `## References` section.
- Reserve a `## Triggers` section for the plugin model.
- Do not add a `## Triggers` section until the plugin model lands.
- Place the READ-ONLY END marker at the end.
- Do not use a `## Purpose` heading.
- Do not use a `## Notes` heading.
- Do not place rationale, history, or narrative in a rule bullet.
- Place an example in a fenced code block under a domain-named section or an `## Examples` section.
- Mark an example as non-normative.

### Rule Structure

- Write one sentence per bullet.
- Write one action per sentence.
- Use the imperative mood.
- Do not write a multi-sentence bullet.
- Do not nest bullets deeper than one level.

### Procedure Headers

- Start each procedure with `### PROCEDURE <NAME>: <description>`.
- Use an ALL-CAPS kebab-case name.
- Include one `**Aliases**` line in the procedure header block.
- Write `**Aliases**: none` when the procedure has no alias.
- Use one canonical phrase.
- Use aliases that are close variants of the canonical phrase or explicit subcommands.
- Use at most three aliases for a new procedure.
- Reduce a touched procedure to at most three aliases.
- Keep the aliases of an untouched procedure.
- Do not use an internal identifier as a trigger.
- Keep each trigger unique across `AGENTS.md` and all policies.
- Do not add a `**Loads**` line.
- Name the policy to load in the first step that needs it.

### Policy Filenames

- Name a policy file `ai-policy-<domain>.md`.
- Apply the common policy's Verbose File Naming rule to the domain token.
- Do not abbreviate the domain unless the abbreviation is the standard term.

### Enforcement

- Run `support-files/validate-protocol.sh` after a change to `AGENTS.md` or a policy file.
- Run `support-files/validate-policy-authoring.sh` on each changed `AGENTS.md` or policy file.
- Pass a changed policy file through peer review.
- Apply the peer review's Agent-facing documentation dimension.
- Migrate a non-compliant policy only when the policy is touched.
- Do not rewrite the whole policy corpus in one pass.

### Standard References

- `ai-policy-common.md` (`## Markdown Output`, `## Humanized Output`, `## Universal Operational Guardrails`).
- `design-docs/protocol-decisions.md`.
- `support-files/validate-protocol.sh`.
- `support-files/validate-policy-authoring.sh`.

## References

- `AGENTS.md`
- `ai-policy-common.md`
- `ai/state/next-steps.md`
- `ai/state/progress.md`
- `ai/state/context.md`
- `ai/daily-checkpoints/`
- `support-files/sync-agents-md.sh`
- `support-files/sync-agents-md.ps1`
- `support-files/validate-protocol.sh`
- `support-files/validate-policy-authoring.sh`
- `design-docs/protocol-decisions.md`

<!-- AI-ASSISTANT: READ-ONLY END -->

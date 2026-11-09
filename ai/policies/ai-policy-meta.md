# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Meta

Govern AI behavior when maintaining this repository and the protocol itself.

## Scope

- Apply this policy to `AGENTS.md`, files under `ai/`, `README.md`, and `docs/`.
- Apply this policy to `support-files/` in the protocol repository.
- Resolve every `support-files/` path and the `design-docs/protocol-decisions.md` path from the **Global AI Workflow Directory**.
- Treat those files as protocol-repository content that does not exist in a user project.
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
- Run `support-files/validate-policy-authoring.sh` on each changed `AGENTS.md`, policy file, or procedure module.
- Run `support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)` after a trigger change.
- Present a summary and a proposed commit message.
- Treat the approved plan and the implement request as the human approval for staging, committing, merging, pushing, opening a pull request, releasing, and the external writes the work names.
- Apply the ADR entry rule in `design-docs/protocol-decisions.md` to every protocol or policy change.

## Forbidden Actions

- Do not push, create a pull request, merge, or release beyond what the approved plan names without explicit human approval.
- Do not edit a policy file marked read-only unless the approved plan names it.
- Do not write a secret or identifying name to a tracked file.

## Approval and Escalation

- Get human approval before running a script that writes to multiple projects.
- Change an authoritative policy, meaning a policy referenced by `AGENTS.md`, only when the approved plan names it.
- Notify the repository owner when a change affects multiple projects, an authoritative policy, a remote system, or has no clear precedent in the protocol.
- Wait for direction before proceeding.

## Reporting and Logging

- Report completed work on the coordination board.
- Write the state files only through PROCEDURE WRITE-CHECKPOINT.
- Apply the common policy's State File Ownership Protocol.
- Run a backup only on the explicit `"backup ai"` trigger.
- Do not create an automatic backup before an update.

## Procedure and Policy Authoring

This section defines how to write and edit `AGENTS.md`, policy files, and procedure modules.

### Applies To

- Apply the trigger, procedure-header, and enforcement rules to `AGENTS.md`, policy files, and procedure modules.
- Apply `### Policy Structure`, `### Normative Language`, `### Rule Structure`, and `### Policy Filenames` only to policy files.
- Exempt procedure bodies from `### Rule Structure` and `### Normative Language`; they are executable steps, not policy rules.
- Apply `### Literal Artifacts` to a policy's or procedure module's `## Triggers` list, and to fenced literal artifacts in policy rules.
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
- Include an optional `## Triggers` section immediately after the purpose sentence and before `## Scope`.
- List one literal trigger phrase per bullet in `## Triggers`, with no other content.
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

### Literal Artifacts

- Treat a fenced block as a normative literal artifact only when the owning policy designates it as one.
- Treat a policy's or procedure module's `## Triggers` bullet list as a normative literal artifact.
- Exempt a designated normative literal artifact from the `### Rule Structure` shape.
- Exempt the `## Triggers` bullet list from the `### Rule Structure` shape.
- Keep a designated normative literal artifact precise and free of vague terms.
- Do not mark a designated normative literal artifact as an example or non-normative.

### Trigger Declarations

- Allow an optional `## Triggers` section in a policy.
- Require at least one trigger in a procedure module.
- Write one phrase per bullet.
- Use lowercase ASCII letters, digits, spaces, and hyphens in a phrase.
- Use lowercase letters, digits, spaces, hyphens, periods, and one trailing #N in a procedure trigger.
- Forbid inline markup, quotes, backticks, and placeholders in a policy trigger.
- Forbid an empty `## Triggers` section.
- Forbid a phrase that duplicates another module's phrase or is contained in another module's phrase across modules.
- Allow close variants within one module and deduplicate them.
- Treat the `## Triggers` bullet list as data, not rules.
- Name a policy file `ai-policy-<name>.md`.

### Procedure Headers

- Start each procedure module with `# PROCEDURE <NAME>: <description>`.
- Use an ALL-CAPS kebab-case name.
- Include a `## Triggers` section with one phrase per bullet and at least one phrase.
- Forbid an `**Aliases**` line.
- Match the file stem to the lowercase kebab name.
- Do not add a `**Loads**` line.
- Name the policy to load in the first step that needs it.

### Policy Filenames

- Name a policy file `ai-policy-<domain>.md`.
- Apply the common policy's Verbose File Naming rule to the domain token.
- Do not abbreviate the domain unless the abbreviation is the standard term.

### Enforcement

- Run `support-files/validate-protocol.sh` after a change to `AGENTS.md`, a policy file, or a procedure module.
- Run `support-files/validate-policy-authoring.sh` on each changed `AGENTS.md`, policy file, or procedure module.
- Run `support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)` after a trigger change.
- Pass a changed policy file or procedure module through peer review.
- Apply the peer review's Agent-facing documentation dimension.
- Migrate a non-compliant policy only when the policy is touched.
- Rewrite every touched policy section to this standard.
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

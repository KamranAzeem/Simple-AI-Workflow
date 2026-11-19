# Custom Policy Howto

A custom policy is a markdown file under your project's `ai/policies/` directory. It adds rules for your project without changing the shared workflow clone.

## Where to put it

- Project policy: `<project root>/ai/policies/ai-policy-<name>.md`.
- Do not add policies to the workflow clone; the clone holds the protocol's own policies.
- The one-way boundary: a custom policy may reference the common policy, and the common policy never names a policy file.
- A project policy keeps the legacy boot load, with or without `## Loading`. The declaration describes how a global policy loads.
- A global policy without `## Loading` keeps its current load.

## Structure

- First line: `# 🚫 DO NOT MODIFY THIS FILE`.
- Next: `<!-- AI-ASSISTANT: READ-ONLY START -->`.
- Then `# AI Policy: <Domain>`.
- Then one sentence that states the purpose.
- Then an optional `## Triggers` section, one lowercase phrase per bullet.
- Then an optional `## Loading` section.
- Then `## Scope`.
- Then one or more domain sections.
- Then `## References`.
- Then `<!-- AI-ASSISTANT: READ-ONLY END -->`.

## Loading declaration

Place one `## Loading` section after `## Triggers`, or after the purpose when there is no `## Triggers`, and always before `## Scope`. Declare one load path per policy.

```text
## Loading
- Mode: boot
```

```text
## Loading
- Mode: trigger
```

`Mode: trigger` also requires at least one `## Triggers` bullet.

```text
## Loading
- Mode: procedure
- Load in: manage-issues
```

```text
## Loading
- Mode: expertise
```

- The `Load in:` value is the lowercase kebab file stem of a procedure module in the clone.
- A non-trigger mode forbids `## Triggers`. To add one to a policy that already has triggers, delete the triggers first.
- The four modes are `boot`, `trigger`, `procedure`, and `expertise`.
- A procedure may load a policy explicitly; the declaration states the self-declared path, not an exclusive one.
- The declaration describes the global paths: Active Expertise, a trigger phrase, boot, or an explicit procedure load.
- The validator checks the form. A project policy keeps the legacy boot load.

## Validate

- Shape: `bash support-files/validate-policy-authoring.sh <file>`.
- Trigger collisions: `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`.
- Module index: `bash support-files/validate-policy-authoring.sh --index <file>` prints the declared mode and the scope.

These are developer tools. The boot uses the read-only `support-files/index-protocol.sh` helper, which calls the `--index` mode; the fallback uses built-in tools and reports `index-source=fallback`.

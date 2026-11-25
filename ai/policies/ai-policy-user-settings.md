# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: User Settings

Govern the canonical structure, the consolidation, and the repair of the user settings files.

## Loading

- Mode: procedure
- Load in: repair-user-settings

## Scope

- Apply this policy to every file in the **User AI Settings Directory**.
- This policy owns the canonical keys, the consolidation, the tool verification, the redaction, the conservation rules, the review gate, and the backup.
- It does not own knowledge files, state files, or the project tree.

## Canonical Keys

- Use this key set: `Name`, `Email`, `Role`, `Base`, `Certs`, `Expertise`, `Communication`, `Default Shell Path`, `Tools`, `Operating Instructions`, `Sensitive Names`.
- Use `Voice`, `Structure`, `Greetings`, `Language Habits`, and `Words to Avoid` under `Communication`.
- Keep `Name` and `Email` under `## Identity` exactly; the author-identity resolver reads them.
- Move `Role`, `Base`, and `Certs` to `## Profile`.
- Format `Certs` as one compact list line.
- Use one canonical name for the bold label and its section heading.
- Keep the `## Default Shell Path` heading and the `- **Default Shell Path**:` label identical; the reader matches the label.
- Hold personal overrides only; never restate a common-policy rule.
- Drop `Style Sources` and the `Git Conventions` pointer sentence.
- Keep the user's git override under `Operating Instructions`.
- Rename `Sensitive Names To Never Commit` to `Sensitive Names`.
- Update `docs/user-settings.md`, `ai/procedures/load-context.md`, and `support-files/validate-protocol.sh` in the same change when a canonical key changes.

## Example

Non-normative example of the canonical structure:

```markdown
# User Settings

## Identity
- **Name**: ...
- **Email**: ...

## Profile
- **Role**: ...
- **Base**: ...
- **Certs**: ...

## Expertise
- **Expert**: ...
- **Familiar**: ...

## Communication
- **Voice**: ...
- **Structure**: ...
- **Greetings**: ...
- **Language Habits**: ...
- **Words to Avoid**: ...

## Default Shell Path
- **Default Shell Path**: ...

## Tools
- **`<tool>`**: `<path or command>`

## Operating Instructions
- ...

## Sensitive Names
- ...
```

## Repair Rules

- Run only on the `repair user settings` trigger; the trigger is the approval.
- Accept `repair global settings` as a v7.7.x alias; remove the alias in v7.8.0.
- Redact every secret from the report and the manifest; never print one.
- Never copy a `Sensitive Names` entry into the manifest, the report, or a commit; record only the count.
- Verify every tool with `command -v` on Linux and macOS, and `Get-Command` on Windows.
- Remove a dead tool with the `removed as a dead tool` disposition; never install a tool.
- Keep one compact line per tool; no prose and no version unless it helps.
- Use the dispositions `kept`, `merged`, `trimmed`, `removed as defined garbage`, `removed as a dead tool`, `preserved ambiguous`, and `aborted unchanged`.
- Define garbage as prose that restates a rule, duplicated universal rules, provenance lines, style sources, the `Git Conventions` pointer sentence, dead tools, and duplicate entries.
- Preserve every identity value, rule, preference, caveat, identifier, and tool path that is not garbage.
- Preserve an ambiguous item and report it.
- Merge a file under 3,000 bytes into its nearest topic.
- Split only a file over 8,000 bytes, and by topic only.
- Leave a compact file byte-for-byte unchanged; a second run is a no-op.
- Back up before the first write: the manifest and project copies in `ai/artifacts/settings-repair-<date>/`, the user copy in `<User AI Directory>/settings-repair-backups/<date>/`.
- Treat `<User AI Directory>/settings-repair-backups/` as a documented exception to the four-store rule.
- Stop a dry run after the manifest report.
- Verify no item is lost, the secrets are redacted, the identity keys are intact, and the tools are verified.
- Run the independent review and require `APPROVED`.
- Apply the blocking review gate in `ai-policy-code-review.md`.
- Fix every finding and re-review.
- Leave a file unchanged when it cannot pass without content loss.
- Replace only an approved file.
- Restore the backup on failure.
- Delete the temporary candidate after replacement or abort.
- Never touch the knowledge stores, the state files, or the project tree; the artifacts and the report are the only project writes.
- Report the manifest and backup paths, the counts, and any unresolved item.

## References

- `ai-policy-common.md` (`## Author Identity and Attribution`, `## Universal Operational Guardrails`).
- `ai-policy-knowledge.md` (`### Knowledge Repair Conservation Contract`).
- `ai/procedures/repair-user-settings.md`.
- `docs/user-settings.md`.

<!-- AI-ASSISTANT: READ-ONLY END -->

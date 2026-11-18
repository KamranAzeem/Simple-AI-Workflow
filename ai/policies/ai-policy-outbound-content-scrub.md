# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Outbound Content Scrub

Apply one outbound content scrub before any artifact leaves the project.

## Triggers

- outbound content scrub

## Loading

- Mode: trigger

## Scope

- Apply this policy to any artifact that leaves the project, whatever its physical path.
- This policy owns the destination classes, the always-remove list, the keep list, the detection passes, the placeholders, the approval and report, the override, the non-text artifacts, and the procedure use.
- The common policy keeps the generic invariant and points here.

## Outbound Content Scrub

Apply this section before any artifact leaves the project. The intended destination and audience decide the class, not the file's physical path. Secrets are removed in every class.

### Destination Classes

- **Class A, internal or same audience**: Keep customer names and infrastructure detail; remove secrets.
- **Class B, external or different audience**: Remove names, internal hosts, URLs, identifiers, ticket keys, and named file paths; remove secrets.
- Infer the class from the request, state it before drafting, and ask when the destination is ambiguous.

### Always Remove

- Remove passwords, tokens, API keys, private keys, connection strings, session cookies, signed URLs, and other credentials in every class.
- Do not offer an override for a secret.
- Remove a secret even when the recipient is the same customer and direct the recipient to a secure channel.

### Keep

- Keep technology vendor names, public product names, public documentation URLs, and technical facts.
- Keep private IP addresses in `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `127.0.0.0/8`, `169.254.0.0/16`, `fc00::/7`, and `fe80::/10`.
- Replace a public IP address with a documentation address unless the user confirms it is public and necessary.

### Detection

- Run a judgment pass over the whole artifact.
- Run a mechanical pass over the exact text that leaves for email addresses, public IP addresses, GUIDs, non-public URLs, token shapes, private-key markers, and signed-URL query parameters.
- Read the global settings names list, an optional project `## Sensitive Names` list, and project knowledge.
- Treat an uncertain item as sensitive and ask.
- Redact by default for a public destination and report the redaction.

### Placeholders

- Replace a person, company, or internal name with a neutral phrase.
- Use `example.com` for a public host, `user@example.com` for an email address, `PROJECT-123` for a ticket key, `<redacted-id>` for an identifier, `<redacted-secret>` for a secret, and `<internal-host>` for an internal host.
- Preserve the technical shape when it keeps the artifact useful.

### Approval and Report

- Show the scrubbed text and a category report before an external write.
- Report categories and counts only, never a removed value.
- Keep the report in chat and write no report file.
- Warn that a public or irreversible post cannot be undone and wait for explicit approval.
- Keep the unscrubbed draft inside the project, for example under `ai/artifacts/`.

### Override

- Allow an override for a non-secret identifying name after a warning, and record the override in chat.
- Require explicit confirmation for an override on a public destination.
- Refuse an override for a secret.

### Non-Text Artifacts

- Review images, screenshots, and rendered exports visually for names, hosts, keys, and dashboard data.
- Strip EXIF, PDF author fields, tracked changes, comments, and slide speaker notes.
- Scrub the exported artifact, not only the source.
- Write "not verified" and wait when an image or attachment cannot be reviewed.

### Procedure Use

- `PROCEDURE MANAGE-ISSUES` applies this section to an external ticket creation, a plan-entry comment, and a close or reopen comment.
- `PROCEDURE IMPLEMENT-PLAN` applies this section to a PR/MR title and body and to release notes.
- `PROCEDURE CREATE-HANDOFF` applies this section only when the handoff leaves the project.
- A local ticket skips the name scrub and still removes secrets.

## References

- `ai-policy-common.md` (`## Outbound Content Scrub`).
- `PROCEDURE MANAGE-ISSUES`, `PROCEDURE IMPLEMENT-PLAN`, and `PROCEDURE CREATE-HANDOFF`.

<!-- AI-ASSISTANT: READ-ONLY END -->

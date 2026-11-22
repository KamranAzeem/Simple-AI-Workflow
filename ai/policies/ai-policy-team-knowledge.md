# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Team Knowledge

Govern the optional shared team knowledge store and its publish path.

## Loading

- Mode: procedure
- Load in: knowledge-publish

## Scope

- Apply this policy when the **Team AI Knowledge Directory** is configured and when PROCEDURE KNOWLEDGE-PUBLISH runs.
- This policy owns the team scope, the store shape, the frontmatter, the precedence, the Class A rule, the ownership and retirement, the limits, and the no-block behavior.
- The knowledge contract keeps the file standards and the body sections.
- The outbound content scrub contract keeps the destination classes and the secret removal.

## Team Knowledge Protocol

- Treat the team store as the third knowledge scope.
- Apply the precedence order: project knowledge, then team knowledge, then personal global knowledge.
- Read every matching file at task start.
- Report a conflict; do not resolve it silently.
- Keep the team store optional; an unconfigured project behaves exactly as today.
- Never clone, pull, write, or authenticate on the boot path.
- Never read lesson content at boot.

## Configuration

- Read **Team AI Knowledge Directory** from the **Project Customization File**.
- Read **Team AI Knowledge Repository** from the same file.
- Expand `~` and `[HOME]` in the directory.
- Treat an absent directory key as not configured.
- Treat an absent repository key as the local clone's `origin`.
- Never write either key; the user sets them.

## Store Shape

- Store one lesson per file under `lessons/`, flat.
- Use the filename as the lesson id.
- Use lowercase kebab case with six or fewer hyphen-separated segments.
- Keep a retired lesson in `lessons/` with `status: retired` and `superseded_by: <filename>`.
- Do not scaffold the store; the team creates the repository, its `README.md`, and its `CONTRIBUTING.md`.
- Reject a rename that breaks a reference.

## Frontmatter

Treat the block below as a normative literal artifact.

```yaml
---
title: <one line>
owner: <git author name>
source_project: <project name or approved slug>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
tags: [<tag>, <tag>]
status: active
superseded_by:
---
```

- Accept `active` and `retired` in `status`.
- Leave `superseded_by` empty for an active lesson.
- Omit a confidence field; the reviewer supplies judgment.

## Body

- Use one H1.
- Include `## Context`, `## Rule or Fix`, `## Why`, and `## Verify`.
- Include `## Caveats` only when a limitation exists.
- Do not write the local knowledge header literal.
- Do not use tables.
- Do not write session bookkeeping.

## Ownership and Retirement

- Record the author in `owner`.
- Keep the review gate on every publish.
- Retire with a tombstone; never delete a lesson silently.

## Limits

- Use 10 KB per lesson as a soft target.
- Review a lesson at 15 KB for a split; never split automatically.
- Report the store count against the 100-file review threshold.
- Bound the boot index at 16 KB.

## Publish

- Run only on the `update team knowledge`, `publish team knowledge`, or `publish to team knowledge` trigger.
- State Class A before drafting.
- Apply the outbound content scrub contract.
- Keep names and infrastructure detail in a team lesson.
- Remove secrets in every class.
- Never apply the local sensitive-names list.
- Block an exact content-hash duplicate.
- Ask on a near-duplicate normalized title.
- Open a pull request and never merge it.
- Never force a push.

## Boot Behavior

- Index filenames, paths, and apparent domains only.
- Report `[PENDING]` with the reason when the store is missing or unreadable.
- Continue the load on a `[PENDING]` store.
- Report `none` when the key is absent.
- Never block the load.

## Errors

- Report a malformed frontmatter file and skip it.
- Report an unknown `status` and skip it.
- Stop the publish on an exact hash duplicate.
- Stop the publish and ask on a near-duplicate title.
- Stop the publish when the remote is unreachable or unauthenticated.

## References

- `ai-policy-common.md` (`## Knowledge Invariant`).
- `ai-policy-knowledge.md` (`## Knowledge File Standards`).
- `ai-policy-outbound-content-scrub.md` (`### Destination Classes`).
- `PROCEDURE KNOWLEDGE-PUBLISH`.

<!-- AI-ASSISTANT: READ-ONLY END -->

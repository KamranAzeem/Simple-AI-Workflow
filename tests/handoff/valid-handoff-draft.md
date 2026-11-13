# Handoff: Create the contact page

## Objective

Create the contact page, record the created date, name the author session and the receiver, and give the claim instruction.

## Authorization

The claim approves the branch work and the direct merge when the review, the Verification, and the Conditional Autonomy conditions pass. It does not approve tags, releases, external writes, or the state files.

## Read first

- `AGENTS.md`
- `ai/policies/ai-policy-handoff.md`

## Scope

In scope: the contact page. Out of scope: the three state files, the author's parallel files, and other sessions' files.

## Starting facts

Measured on 2026-11-13: the project uses a static site generator. Verify this yourself.

## Steps

1. Create the page.
2. Run the checks.

## Binding rules

- Apply `ai-policy-common.md` and `ai-policy-handoff.md`.

## Shared output paths

- `ai/artifacts/handoffs/create-contact-page/screenshot.png`. Never overwrite another run.

## Report back

Send the final message, append a `## Completion` note, and clear the claim.

## Review

Reviewer: a fresh session. Date: 2026-11-13. Verdict: APPROVED. Report: `ai/code-review-reports/2026-11-13_20-00_review-01.md`.

## Verification

Read-only: `test -f contact.html`. Execution: `npm run build` exits 0.

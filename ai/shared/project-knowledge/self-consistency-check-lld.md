# Self-Consistency Check: Low-Level Design

Scope chosen by the user on 2026-09-19: LLD plus an ADR entry only. No Vision, PRD, or HLD, because the change is one short paragraph inside an existing section and alters no architecture.

## Context

The Investigation Contract in `ai/policies/ai-policy-common.md` requires every claim to name a source, and requires cross-checking "a fact that matters" by more than one independent source. It does not require re-checking a new or changed claim against the other sections of the same document, or against a source already read this session.

Real incident (client GRS migration plan, 2026-09-10): a narrow claim was verified correctly, then a broader architectural inference was built on top of it that contradicted a section already present and already read in the same document. The user caught it. This is the gap.

Origin: `ai/issues/open/edit-verification-missing-self-consistency-check.md`.

## Decision

Add one short paragraph to the `## Investigation Contract` section. It states what to do, not why.

## LLD-001: Rule insertion

- **File**: `ai/policies/ai-policy-common.md`
- **Section**: `## Investigation Contract`
- **Insertion point**: insert as a new paragraph immediately after the first paragraph ("Investigate, verify, then assert"), before the "Local-first source precedence" paragraph, separated by one blank line. This keeps it adjacent to the existing "Cross-check before recommending" sentence it extends.
- **Text to add**:

  `**Self-consistency check.** Before finalizing an edit, re-check any new or changed claim against the other sections already read this session and the source it derives from. Resolve or flag contradictions.`

- **Net addition**: one blank line plus 30 words. No new heading, no new section.

### Why this text

- **What, not why**: it states the trigger (before finalizing an edit), the action (re-check a new or changed claim), the material (other sections already read, and the source it derives from), and the outcome on conflict (resolve or flag). No rationale.
- **Short sentences**: two sentences. The first is 24 words, the second is 4.
- **Scoped by the word "claim"**: wording, formatting, and cosmetic edits are not claims, so they do not trigger the check. No extra scope clause needed.
- **Uses "already read this session"**: the check reuses material already in context from this session. It does not demand new reads, which the Full File Reads mandate already governs, and it does not cover material from a prior session that may be stale.

## What does not change

- No `AGENTS.md` change. This is a policy-only prose rule, not a universal always-on mechanic (2026-08-31 routing principle: AGENTS.md is a router, not a catalog).
- No `validate-protocol.sh` change. The rule is behavioral prose, not a file or structure check, so it has no anchor.
- No other policy file, no new heading, no new section.
- No em dashes, no procedure letters or step numbers, no markdown hyperlinks.

## Acceptance criteria

- AC-1: The paragraph above is present in the `## Investigation Contract` section exactly as worded.
- AC-2: The net addition to `ai-policy-common.md` is one paragraph of 30 words or fewer, with no new heading or section.
- AC-3: The added text contains no em dash, no procedure letter or step number, and no markdown hyperlink.
- AC-4: `AGENTS.md` and `support-files/validate-protocol.sh` are unchanged.
- AC-5: `support-files/validate-protocol.sh` still passes 8/8 at v5.0.
- AC-6: `markdownlint-cli2` reports 0 issues on changed files.
- AC-7: `protocol-decisions.md` gains a dated ADR entry. The ticket moves to `ai/issues/in-progress/` during branch work, and to `ai/issues/closed/` only after the branch is merged.

## Verification steps

1. `grep -n "Self-consistency check" ai/policies/ai-policy-common.md` returns the new paragraph.
2. `git diff --stat` on `ai-policies/ai-policy-common.md` shows one file, a small insertion.
3. `bash support-files/validate-protocol.sh` ends with 8/8 success.
4. `markdownlint-cli2 ai/policies/ai-policy-common.md` returns 0 issues.
5. Confirm `AGENTS.md` and `validate-protocol.sh` show no diff.

## Out of scope

- Any general rewrite of the Investigation Contract.
- New tooling or scripted enforcement.
- Changes to other policies.

Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: The v7.7.x global trigger aliases are still declared at v7.10.0, and the README says no temporary aliases remain.

Description:

The v7.7.0 scope rename promised to remove the old `global` trigger phrases in v7.8.0. They are still declared at v7.10.0.

- `ai/procedures/write-checkpoint.md:8` declares `- update global knowledge`.
- `ai/procedures/repair-user-settings.md:8` declares `- repair global settings`.
- `ai/procedures/repair-user-settings.md:9` declares `- tidy global settings`.
- `ai/procedures/repair-user-settings.md:10` declares `- heal global settings`.
- `README.md:220` says "The 59 triggers in v7.10.0 include no temporary aliases."

The stale removal notices:

- `README.md:35` and `README.md:36` say removed in v7.8.0.
- `docs/announcements/v7.7.0.md:41`, `:42`, and `:60` say removed in v7.8.0.
- `ai/policies/ai-policy-user-settings.md:80` says "remove the alias in v7.8.0".
- `ai/procedures/repair-user-settings.md:12` says the phrases are removed in v7.8.0.
- `ai/knowledge/scope-vocabulary-and-storage-roots.md:35` says removed in v7.8.0.
- `ai/knowledge/trigger-phrase-naming.md:14` says remove the alias in the next minor.

The live trigger count of 59 includes these four aliases. Removing them yields 55. `tests/test-readme-shape.sh:84` asserts the README says "59 triggers". `docs/simple-ai-workflow-slides.md:438` and `docs/slides/simple-ai-workflow-slides.html:527` also state 59.

Resolution options:

- Remove the four alias triggers, update the trigger count to 55 in `README.md`, both slides files, and `tests/test-readme-shape.sh`, and delete the stale removal notices.
- Or record a new decision that keeps the aliases, then fix the README claim and the v7.8.0 removal wording.

Acceptance criteria:

- One option is chosen and recorded.
- Every trigger count in the README, the slides, and the tests matches the live `--index` summary.
- No document claims a removal that has not happened.

---
2026-11-26
Filed from the 2026-11-26 codebase examination. Evidence group F1. No secret or identifying name present.

---
2026-11-26
Plan: `ai/plans/retire-legacy-global-trigger-aliases.md` (M). Decision: retire the four aliases and ship v7.11.0 as MINOR. Plan reviews 191 (CHANGES REQUESTED, fixed) and 192 (APPROVED). No branch; the ticket stays open until the implement request.

Reported: 2026-11-18
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: S
Label:
URL:
Summary: Declare the load path on the policies that lack a Loading section, and record the one exemption

Description:

- The AGENTS.md audit found 13 of 23 policies with no `## Loading` declaration. The index reported their mode as `legacy`, which hid the intended path.
- Added `Mode: trigger` to `api-backend`, `cloud`, `data`, and `dba`; they already declare triggers.
- Added `Mode: procedure` with `Load in:` to `code-review` (`run-peer-review`), `codebase-examination` (`examine-codebase`), and `handoff` (`create-handoff`).
- Added `Mode: expertise` to `coding-baseline`, `mobile-apps`, `observability`, `web-frontend`, and `meta`.
- Recorded the one exemption: `ai-policy-common.md` is loaded explicitly by `STEP-WORKFLOW-ACCESS` before any policy scan, so no declared mode is accurate.
- No rule text changes. The load-path test moved the legacy case to the common policy and now pins trigger, procedure, and expertise modes.

## Acceptance Criteria

- Twelve policies declare an accurate mode; the common policy carries a recorded exemption.
- The index reports the declared mode for each touched policy.
- The load-path fixture passes and pins one of each mode.
- No policy rule changes.
- The ADR records the declarations and the exemption.
- Validators, suite, and markdownlint pass.
- The release note is drafted, edited by the user, and only then published.
- Peer review APPROVED.

## Plan

Plan attached below.

## Implementation Plan

### Context

- Ticket: `ai/issues/closed/policy-loading-declarations.md` (S).
- Twelve policies declare their real load path; the common policy gets a recorded exemption.
- No rule text changes and no behavior change. The declarations describe paths that already exist.

### Evidence

- Undeclared: `api-backend`, `cloud`, `data`, `dba`, `code-review`, `codebase-examination`, `handoff`, `coding-baseline`, `mobile-apps`, `observability`, `web-frontend`, `meta`, and `common`.
- The four domain policies carry `## Triggers` and are loaded by trigger dispatch, so `Mode: trigger` is accurate.
- `run-peer-review.md:9` loads `ai-policy-code-review.md`; `examine-codebase.md:8` loads `ai-policy-codebase-examination.md`; `create-handoff.md:8` loads `ai-policy-handoff.md`.
- The four remaining domain policies and `meta` carry no `## Triggers` and load through Active Expertise by name, so `Mode: expertise` is accurate.
- `common` is loaded explicitly by `STEP-WORKFLOW-ACCESS` and by recovery and checkpoint. No boot scan exists, so no declared mode is accurate. It stays undeclared and the exemption is recorded.
- The contract requires `Mode: trigger` to carry at least one trigger and every other mode to carry none; `Load in:` appears only with procedure mode and names an existing procedure.
- Placement: `Triggers` then `Loading` then `Scope` for the four trigger policies; `Loading` before `Scope` for the rest.
- `tests/test-policy-load-paths.sh:193-204` expected `ai-policy-cloud.md` to report `mode=legacy`. Cloud became trigger, so the legacy case moved to `ai-policy-common.md`, and the test gained a trigger check on `cloud`, a procedure check on `code-review`, and an expertise check on `web-frontend`.
- `design-docs/specs/policy-loading-contract.md` said `mode=legacy` for "the repository policy"; it now says "a repository policy without a declaration".
- ADR entry: `design-docs/protocol-decisions.md`.
- Release: v6.6.2 (patch). The announcement was drafted, shown, and approved before publication.

### Approach

- Used exactly two block shapes: `## Loading` then `- Mode: <mode>`; for procedure mode only, a second bullet `- Load in: <procedure-file-stem>`. No other key, and one path per policy.
- Added `## Loading` with `Mode: trigger` to `api-backend`, `cloud`, `data`, and `dba`, after `## Triggers` and before `## Scope`.
- Added `## Loading` with `Mode: procedure` and `Load in:` to `code-review` (`run-peer-review`), `codebase-examination` (`examine-codebase`), and `handoff` (`create-handoff`), before `## Scope`.
- Added `## Loading` with `Mode: expertise` to `coding-baseline`, `mobile-apps`, `observability`, `web-frontend`, and `meta`, before `## Scope`.
- Left `ai-policy-common.md` unchanged; recorded the exemption in the ADR and this close entry.
- Updated the load-path fixture: the global legacy case moved to the common policy, and the test pins the new trigger, procedure, and expertise modes.
- Updated the contract spec's legacy wording.
- Added the ADR entry, including why `meta` is `expertise` and why `common` is the one exemption.
- Drafted the v6.6.2 announcement, showed it, applied the user's approved text, then published.

### Acceptance Criteria

- AC-001: twelve policies declare the accurate mode; the common policy is exempt with a recorded reason.
- AC-002: no rule text changes; the diff of each policy shows only the inserted `## Loading` section.
- AC-003: the authoring validator passes; the index reports the declared mode for each touched policy.
- AC-004: `tests/test-policy-load-paths.sh` passes and pins one trigger, one procedure, one expertise, and one legacy mode.
- AC-005: the ADR entry records the declarations and the common exemption.
- AC-006: the full suite passes, markdownlint 0.
- AC-007: the v6.6.2 note is drafted, edited by the user, and only then published; it is in the user's voice with no invented event.
- AC-008: peer review APPROVED.

### Close Sequence

- Repo: project root of the workflow clone.
- Base ref: `master` at the release-docs correction commit.
- Branch: `feature/policy-loading-declarations`, cut from `master`.
- Merge mode: squash to `master`, one commit.
- Ticket: `ai/issues/closed/policy-loading-declarations.md`; closed in the branch commit.
- Release: v6.6.2, patch, after the announcement was approved.
- Verification: validators, suite, markdownlint, index modes.
- Branch deletion: local and remote after the release.

### Peer Review Log

- Plan round 1, `2026-11-18_22-54_review-08.md`: APPROVED. Two Minors (state the exact block shapes and name the test policies), fixed in the same pass.
- Implementation round 1, `2026-11-18_22-59_review-09.md`: APPROVED. Two Minors; the test exemption comment was added.
- Final round, `2026-11-18_23-05_review-10.md`: APPROVED.

---

2026-11-18
Closed: the 12 declarations and the common exemption are in place, the ADR records the decision, the load-path test pins all four modes, and the v6.6.2 note uses the text the user approved.

# Plan: Sharpen the grilling method

## Goal

Add three rules to the grilling mode: a precise question frontier, a numbered question format, and an explicit facts-versus-decisions split. Align the Pre-Work Gate item 3 with the round method. Use the protocol's own words and ship MINOR v7.12.0.

## Evidence

- `ai/policies/ai-policy-thinking-modes.md:26` to `:34` is the current `## Grilling` section: role, recommended answer, method, output, stop.
- The current method says "Ask all pending branches, process the answers, find new branches, and repeat." It does not define the frontier or forbid dependent questions in one round.
- `ai/policies/ai-policy-common.md:454` to `:459` is Pre-Work Gate item 3; `:456` says "Ask questions and resolve dependencies one decision at a time", which conflicts with rounds.
- The comparison identified three adoptions: the frontier rule, the numbered format, and the facts-versus-decisions split.
- A policy change requires a release under `ai/knowledge/release-practices.md:14`; this is a behavior change in the grilling procedure, so MINOR v7.12.0.

## Depth

S. Context plus acceptance criteria; no HLD or LLD is required.

## Context

The current grilling mode is conversational and round-based but leaves the frontier implicit and allows dependent questions in one round. The three rules make the interview sharper and easier to answer without changing its converged, user-decides character. The policy text names no person, product, or external skill. The grilling output stays a one-paragraph gist; the ticket, plan, and ADR gates own the written artifacts.

Out of scope: a glossary, ADR writing during grilling, a skill family, mandatory sub-agents, and a question cap.

## Decisions (ADR)

- ADR-1, the frontier rule. A round asks only decisions whose prerequisites are settled, and no two dependent questions share a round; an invalidating answer reopens the branch next round.
- ADR-2, the numbered format. Number each question, give it a short title, then the body, then one recommended answer on its own line; the user may answer a round by number.
- ADR-3, the facts-versus-decisions split. The agent resolves facts by reading files and running read-only checks, and may use a sub-agent where the protocol allows it. The user makes the decisions; the agent never settles one on the user's behalf.
- ADR-4, the Pre-Work Gate item 3 aligns with the round and frontier method and drops the one-decision-at-a-time line.
- ADR-5, no external name in the policy text, and MINOR v7.12.0 for the behavior change.

## Deltas

`ai/policies/ai-policy-thinking-modes.md` `## Grilling`:

- Keep the intro, triggers, role, recommended-answer, output, and stop rules.
- Replace the method bullet with: "Map the idea as a design tree. Work in rounds. A round asks only the decisions whose prerequisites are settled, and no two dependent questions share a round. Process the answers, reopen any branch an answer invalidated, and ask the next frontier."
- Add a **Format** bullet: "Number each question, give it a short title, then the body, then one recommended answer on its own line. The user may answer a round by number."
- Add a **Facts and decisions** bullet: "Resolve facts yourself by reading files and running read-only checks, and use a sub-agent where the protocol allows it. The user makes the decisions; never mark a decision settled on the user's behalf."

`ai/policies/ai-policy-common.md` `### Pre-Work Gate` item 3:

- Change the existing "Walk the design tree branch by branch." line to "Walk the design tree branch by branch, in rounds."
- Replace "Ask questions and resolve dependencies one decision at a time." with "Ask only the decisions whose prerequisites are settled, and reopen a branch when an answer invalidates it."
- Keep the shared-concept, HLD/LLD, light-pass, and convergence lines.

Release:

- `docs/announcements/v7.12.0.md`: new MINOR announcement. Point the README banner at it.
- `README.md`: banner v7.12.0 and the trigger-count line updated to v7.12.0.
- `tests/test-readme-shape.sh` and `tests/test-docs-audit.sh`: the v7.12.0 banner and announcement checks, matching the existing version pattern.

Record:

- Append the dated plan entry to the ticket now; close it in the branch commit with the plan attached.

## Acceptance Criteria

- AC-1: `## Grilling` states the frontier rule. Assertion: `rg -n 'prerequisites are settled|dependent questions|reopen' ai/policies/ai-policy-thinking-modes.md` matches.
- AC-2: `## Grilling` states the format. Assertion: `rg -n 'Number each question|answer a round by number' ai/policies/ai-policy-thinking-modes.md` matches.
- AC-3: `## Grilling` states the facts-versus-decisions split. Assertion: `rg -n 'Facts and decisions|never mark a decision settled' ai/policies/ai-policy-thinking-modes.md` matches.
- AC-4: the Pre-Work Gate no longer says one decision at a time. Assertion: `rg -n 'one decision at a time' ai/policies/ai-policy-common.md` returns no match, and the round wording matches.
- AC-5: no external name in the changed policy text. Assertion: `rg -ni 'matt|pocock|aihero' ai/policies/ai-policy-thinking-modes.md ai/policies/ai-policy-common.md` returns no match.
- AC-6: the full validation is green. Assertion: authoring validation PASSED, triggers stay 55, `tests/run-all.sh` is 35/35, `validate-protocol.sh` 8/8, markdownlint 0.
- AC-7: a sample grilling session works by number. Assertion: a manual sample with three frontier questions is answered by number, has no dependent question in a round, and reopens a branch when an answer invalidates one.
- AC-8: the release is recorded. Assertion: the v7.12.0 announcement exists, the README banner links it, the annotated tag `v7.12.0` exists, and the GitHub Release is public.

## Verification

1. The `rg` checks from AC-1 to AC-5.
2. `bash support-files/validate-policy-authoring.sh AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`.
3. `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`.
4. `bash support-files/validate-protocol.sh`.
5. `bash tests/run-all.sh`.
6. `markdownlint-cli2 'docs/**/*.md' '*.md' 'AGENTS.md' 'ai/issues/**/*.md'`.
7. A manual sample grilling session, recorded in the review.

PowerShell fixtures remain PENDING when `pwsh` is absent, as today.

## Peer Review Log

- 2026-11-26, review-201: APPROVED.

## Risks and Rollback

- Risk: a round can feel like a large batch. Mitigation: the Pre-Work Gate light pass stays, and the user can ask to go one question at a time; the policy does not forbid a slower pace.
- Risk: the facts rule could invite the agent to decide. Mitigation: the rule names the user as the decision owner and forbids settling on the user's behalf.
- Risk: the release version. MINOR is the lowest version for a procedure behavior change; if the user prefers no release, drop the policy change and keep the ticket open.
- Rollback: revert the two policy bullets on the branch before the merge; after the merge, fix forward on a new branch and ship a follow-up PATCH.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, origin `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- Base ref: `master`, the repository default branch.
- Merge mode: direct, per `ai-customization.md` `Merge Mode: direct`. Deliver one squash commit to `master`.
- Baseline: commit the plan and the ticket update as a chore baseline on `master` before opening the branch.
- Branch: `policy/sharpen-grilling`.
- Ticket: close `ai/issues/open/sharpen-grilling-frontier-format-decisions.md` in the branch commit with the plan attached under `## Implementation Plan`.
- Release: v7.12.0, MINOR. Write `docs/announcements/v7.12.0.md`, point the README banner at it, tag `v7.12.0` after the merge, push `master` and the tag, and publish the public GitHub Release.
- Evidence: the `rg` checks, the authoring and trigger validators, `validate-protocol.sh` 8 of 8, `tests/run-all.sh`, `markdownlint-cli2` 0, and the sample grilling session are recorded in the checkpoint and the review.
- Terminal gate: the branch is at least one commit ahead of `master`, the tree is clean, and no post-merge repository change is made.

# Plan: Bounded Boot-Time Staleness Heuristic

Issue: `ai/issues/in-progress/bounded-boot-time-staleness-heuristic.md`

## Goal
Surface possibly-stale Project Knowledge at load context using metadata only. No file reads at boot. Verify deeply only when a file is loaded for a task.

## Signals (metadata only)
1. Domain match at boot: the domain already recorded in the boot index, against `## Active Expertise` domains.
2. Domain match at task start: the same index domain against the task's keywords. Metadata only.
3. Age, for domain-matched candidates only: git-tracked files use the last-commit date (`git log -1 --format=%cs -- <file>`); untracked files use the modified time.
4. Existing order and size checks stay unchanged.

## Rule
- Threshold: a fixed 90-day default. Not configurable in this change; a follow-up ticket can add a setting.
- Flag a Project Knowledge file when its domain matches an Active Expertise domain or the task, and its age exceeds 90 days.
- Report flagged files in the Proof-of-Load as a new bullet, one line each: file and date.
- The flag is advisory. It never blocks work.
- On loading a file for a task, verify it against current state, policies, and decisions, and resolve or flag contradictions. This reuses the existing self-consistency check; no new rule.
- Do not read any Project Knowledge file at boot for staleness.

## Files to change
- `AGENTS.md` Procedure A Step 5 (Knowledge Loading) and Step 7 (Proof-of-Load): new bullet.
- `ai/policies/ai-policy-common.md` Project Knowledge Protocol: one short rule.
- `docs/workflow-guide.md` Section 13 (Token Rationing): one short paragraph.
- `docs/simple-ai-workflow-slides.md` token-rationing bullet: a short mention.
- `ai/shared/project-knowledge/protocol-decisions.md`: ADR entry.
- Policy text is authored from the end-user's project-root perspective; no repo-specific paths.
- `support-files/validate-protocol.sh` unchanged: behavioral prose, no new anchor.

## Acceptance criteria
- AC-1: The boot check adds no full-file reads.
- AC-2: Possibly-stale knowledge is surfaced at load context.
- AC-3: Deep verification happens only on demand.

## Verification
- Validator v5.0 8/8.
- Markdownlint 0 on changed files.
- Relative links resolve.
- Peer review APPROVED.

## Process
- Peer review the plan until clean, then implement.
- Close the ticket before any merge.
- Do not merge to `master` without explicit approval.

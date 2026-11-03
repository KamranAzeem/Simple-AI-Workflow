Reported: 2026-11-03
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: User-facing docs still name project-relative policy paths that only exist in the clone

Description:

## Problem

The v5.5.2 work removed hardcoded policy paths from `AGENTS.md` and the policies. The docs verification pass found four places where a user-facing doc names `ai/policies/ai-policy-<name>.md` in a context where the reader is in their own project, not the workflow clone. The clone holds those files; a user project does not.

Findings:

- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:110`: the "Open your project and you will find" tree shows `ai/policies/` as project content holding domain rules.
- `docs/examples/full-stack-web-mobile-ai-customization.md:35, 40, 41, 42, 46`: a user-project `ai-customization.md` example points at `ai/policies/...` files that do not exist in that project.
- `docs/personas/README.md:9`: the domain-policy example names `ai/policies/ai-policy-cloud.md` in a user-project context.
- `docs/workflow-guide.md:220`: states that the AI reads `ai/policies/ai-policy-code-review.md`, which is inaccurate after v5.5.2.

Other docs hits were verified as correct for the clone layout and need no change.

## Scope

- The four findings above.
- No change to the protocol files. This is documentation drift only.

## Acceptance criteria

- Each finding is corrected to name the policy file and the Global AI Policies Directory, or the clone layout, as the surrounding context requires.
- The project tree in the compared doc shows `ai/policies/` only where it belongs.
- A reader in a user project can follow every policy reference without a dead path.
- No protocol file changes.
- Markdown lint passes on the changed docs.

## Notes

- Found during the v5.5.2 docs verification pass on 2026-11-03.
- The same class of defect was fixed in the protocol files by resolving policy references from the Global AI Policies Directory.

---
2026-11-03
Plan attached below.

## Implementation Plan

# Fix Project-Relative Policy Paths in User-Facing Docs

## Ticket

- Local ticket: `ai/issues/open/user-facing-docs-still-name-project-policy-paths.md`.
- Tracker: local, under `ai/issues/`.
- Type: Documentation. Severity: P3 (AI estimate). Size: S (AI estimate).
- Plan depth: S, so this plan carries context and acceptance criteria, without an HLD or LLD.

## Context

The v5.5.2 work fixed project-relative policy paths in `AGENTS.md` and the policy files. Four user-facing docs still name `ai/policies/ai-policy-<name>.md` where the reader is in their own project. In a user project, `ai/policies/` holds the user's custom policies, not the workflow's distribution tree. The reader gets a dead path.

## Evidence

- `rg -n "ai/policies/" README.md docs` lists 24 hits. The four findings below are the ones where the reader's context is a user project.
- Read in context and confirmed:
  - `docs/examples/full-stack-web-mobile-ai-customization.md:35, 40, 41, 42, 46`: the file is copied to `ai-customization.md` in a user project (line 1 says so). The "see ..." paths do not exist there.
  - `docs/personas/README.md:9`: describes the policy stack a user loads in their project.
  - `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:110`: the "Open your project and you will find" tree lists `ai/policies/` as "domain rules and expertise".
  - `docs/workflow-guide.md:220`: states where the AI reads the review policy, so it is inaccurate after v5.5.2.
- Verified correct for the clone or the protocol repo, so unchanged: `README.md:41`; `docs/example-learning-session-runbook.md:40`; `docs/ai-customization-guide.md:13, 115` to `124`; `docs/simple-ai-workflow-slides.md:109`; `docs/ai-agent-collaboration.md:45`; `docs/codebase-examination-guide.md:5`; `docs/policy-influence-on-ai-work.md:21`; `docs/ai-policy-mobile-apps-guide.md:3, 110, 141, 142`; `docs/protocol-validation-system.md:10`; `docs/workflow-guide.md:188, 389, 412`; `docs/compliance-guide.md:36`; `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:83`; `docs/announcements/v5.5.2.md:7, 20`.
- Tooling: `markdownlint-cli2` is available. No protocol validator applies, because no protocol file changes.

## Acceptance Criteria

AC-1: `docs/examples/full-stack-web-mobile-ai-customization.md:35` names the common policy by file and the **Global AI Policies Directory**.
AC-2: `:40` names the backend, frontend, and mobile policies by file and the **Global AI Policies Directory**.
AC-3: `:41`, `:42`, and `:46` name the common policy by file and the **Global AI Policies Directory**.
AC-4: `docs/personas/README.md:9` names `ai-policy-cloud.md` and the **Global AI Policies Directory**.
AC-5: `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:110` describes the project `ai/policies/` directory as the user's custom policies, not the domain rules.
AC-6: `docs/workflow-guide.md:220` says the AI reads the code-review policy from the **Global AI Policies Directory**.
AC-7: `rg -n "ai/policies/ai-policy-[a-z0-9-]+\.md"` on the four files returns no hit that reads as a project-relative path.
AC-8: every other `ai/policies/` hit listed in Evidence is unchanged.
AC-9: no protocol file, policy file, or script changes.
AC-10: `markdownlint-cli2` reports 0 issues on the four changed files.

## Implementation Notes

- Examples file, replace each "see `ai/policies/<file>.md`" with "see `<file>` in the **Global AI Policies Directory**". For the multi-policy line, keep the list readable.
- Personas file, same form.
- Compared file, change the tree annotation only: the directory stays in the tree, because bootstrap creates it, but it is labeled as the user's custom policies.
- Workflow guide, name the policy file and the directory anchor.
- Do not touch `docs/examples` line 36 or any other line in the four files.

## Release

Decision: no release. This is a documentation correction with no protocol or behavior change. The GitHub Release history stays as the changelog of behavior changes.

## Close Sequence

Every action is bound to its repo, ref, artifact, and evidence. This is a local ticket, so the local close order applies.

- **Repo**: this repository, the project root. One repo.
- **Base ref**: `origin/master`, fetched at implement time. Resolve it, do not assume it.
- **Branch**: `feature/fix-user-facing-policy-paths`, opened on the explicit implement request. The uncommitted post-release state files join the branch.
- **Ticket status**: move the ticket from `ai/issues/open/` to `ai/issues/in-progress/` when the branch opens.
- **Plan link**: append the dated plan comment to the ticket while it is in `open/`. Evidence: the ticket carries a `2026-11-03` entry naming the plan file.
- **Implementation**: edit the four files. Evidence: `git diff` shows only the listed lines.
- **Verification**: run AC-7, AC-8, and AC-10 commands. Evidence: command output recorded in the checkpoint.
- **Close on the branch**: append the final plan under `## Implementation Plan`, replace the plan link with `Plan attached below.`, delete the plan file, and move the ticket to `ai/issues/closed/`.
- **Checkpoint**: PROCEDURE WRITE-CHECKPOINT on the branch. Evidence: state files and today's diary.
- **Commit**: one commit on the branch, subject `docs(policies): resolve policy paths from the global policies directory`. It carries the four files, the closed ticket, the checkpoint, and the carried state files.
- **Terminal gate**: after the commit, `git status --porcelain` is empty and the branch is at least one commit ahead of `origin/master`. Evidence: the command output is captured in the session and reported in the final response, because the ticket is already closed by this point.
- **Merge**: squash-merge into `master` after explicit human approval. Delete the branch.
- **Push**: `git push origin master` after approval. No tag and no release.
- **Post-merge verification**: confirm the branch is gone and the files on `master` match the fixed versions. This is the final action.

## Risks

- A wording change could be read as a protocol rule. Keep the docs in plain language and name the anchor only as a location.
- The examples file is copy-paste material. A wrong wording there spreads into user projects. Keep it short and unambiguous.
- The uncommitted post-release state files could be missed. The commit binds them, and the terminal gate requires a clean tree.

## Peer Review Log

- Round 1: CHANGES REQUESTED. 1 Major (terminal gate evidence had no home) and 1 Minor (missing dated plan link on the ticket), plus one suggestion to state the no-release decision. All fixed.
- Round 2: APPROVED. No Critical, Major, or Minor finding.

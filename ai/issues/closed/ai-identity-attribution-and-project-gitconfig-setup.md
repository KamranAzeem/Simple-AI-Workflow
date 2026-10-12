Reported: 2026-10-10
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Add AI-identity, identifying-name, git-convention, and git-config rules to the common policy

Description:

Purpose: keep the global settings file thin. These rules live in `ai/policies/ai-policy-common.md`, which every user loads from the first session. The global settings file stays only as the last-resort identity fallback, for users who do not use git.

Rule text must be direct and concise: state the what, not the why.

PART 1: AI identity attribution

- The AI never presents an AI, model, or harness name, or an auto-generated email, as an author or sender anywhere: git author and committer, commit messages, trailers (`Co-authored-by`, `Signed-off-by`), `GIT_AUTHOR_*`/`GIT_COMMITTER_*` environment variables, `--author` flags, pull requests, tickets, documentation, chat, and external systems. It uses the human user's identity.
- Identity source order (first match wins):
  1. Project git identity (`git config user.name` / `user.email`).
  2. Global `~/.gitconfig`.
  3. Global settings file `## Identity`, fields `Name` and `Email`. Last-resort fallback for users who do not use git.
  If none is found: ask the user for name and email, record them in the global settings file, and offer the git config setup in PART 4.
- Binds sub-agents and non-orchestrator sessions too.
- Placement: a Non-Negotiable plus a new section `## Author Identity and Attribution`.

PART 2: Identifying names (behavioral, strict)

- The AI never writes anything that identifies a person, company, or organization into git or an external system, unless that identity is intended and public.
- Consult a names list in the global settings file first if one exists; otherwise judge behaviorally. The rule never depends on a list.
- Applies to everything that enters git: commits, commit messages, docs, code comments, knowledge files, filenames, and external systems.
- Neutralize with a generic phrase ("a client project", "an external project"). Strict, because a corrective history rewrite is expensive and a leaked name may already be pulled by others.
- Human verification when needed.
- Placement: merge into `## Universal Operational Guardrails` beside `Secrets Awareness`, and extend Non-Negotiable 5.

PART 3: Git conventions

- Move the reusable conventions out of the global settings file into the policy: branch prefix and commit type `feature` (never `feat`); subject `<type>(<scope>): <subject>` in imperative mood with a descriptive body for architectural changes; always feature branches with squash merge; conventional commit types; trunk-based, short-lived branches.
- Placement: merge into `## Universal Engineering Standards` and `## Feature Development and Branch-Gating`. De-duplicate, do not add beside.

PART 4: Git configuration

- The `.gitconfig` template lives in the policy, in a new subsection `### Git Configuration` under `## Universal Engineering Standards`.
- Adequate config checklist. If any item is missing, the AI offers or suggests:
  - `user.name` set and not a placeholder or AI/tool name.
  - `user.email` set and not an auto-generated address.
  - `core.autocrlf` and `core.eol` set.
  - `alias.lg` set (the log alias in the template).
- If no global `~/.gitconfig` exists: offer to create it, explain why, and give a short note on each setting.
- If the current directory is a git repository with an inadequate config: strongly suggest creating one from the template.
- Set `defaultBranch` to `main` when it is not already set.
- Trigger: offer at bootstrap and at each "load context" (offer only, never write without approval), and before the first commit.

Scope:
- Docs and slides are updated to match.
- The global settings sections that the policy now covers are trimmed in the same change-set that adds the policy rules, never before, so no rule is lost.
- Existing commits are out of scope: the history was rewritten recently for the same problem.

Acceptance criteria:

File-checkable (validator, reference test, lint):
- AC1: `ai-policy-common.md` carries the identity rule as a Non-Negotiable plus `## Author Identity and Attribution`, with the source order and the ask/record step.
- AC2: the identifying-names rule is merged into `## Universal Operational Guardrails` and Non-Negotiable 5, with no list embedded and a "consult the settings list first if present" note.
- AC3: the git conventions are merged into `## Universal Engineering Standards` and `## Feature Development and Branch-Gating`, with no duplication.
- AC4: `### Git Configuration` holds the template and the adequacy checklist, with `defaultBranch` set to `main` only when absent.
- AC5: the offer/suggest trigger is wired into PROCEDURE BOOTSTRAP-PROJECT and PROCEDURE LOAD-CONTEXT (offer only).
- AC6: the `docs/global-user-settings.md` template and the docs/slides reflect the change, and the covered settings sections are trimmed in the same change-set.
- AC7: validator 8/8, reference test PASS, markdownlint 0.

Behavioral (confirmed by peer review and a live trial, not by a script):
- AC8: the AI resolves identity from git config, then the settings fallback.
- AC9: the AI judges identifying names on its own, and consults a settings list first if one is present.

Plan: `ai/plans/ai-identity-attribution-and-git-config-implementation-plan.md`, reviewed to approval before any implementation.

ADR: a dated entry is added to `ai/shared/project-knowledge/protocol-decisions.md`.

---
2026-10-12

Closed on branch `feature/ai-identity-and-git-config`. Delivered: the `## Author Identity and Attribution` section, the extended secrets and identifying-names rule, the git conventions and `### Git Configuration` template, the bootstrap and load-context triggers, the settings-template updates, and the docs and slides sync. Verified: validator v6.0 8/8, reference test PASS, markdownlint 0 on the edited files. Peer review review-12 APPROVED. ADR recorded in `protocol-decisions.md`.

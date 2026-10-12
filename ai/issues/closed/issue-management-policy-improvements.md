Reported: 2026-10-12
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Improve the issue-management policy so the AI can work issues independently and the user works them effectively

Description:

Purpose: upgrade the Issue Management Protocol so issues are analyzed before work, plans are mandated and reviewed, and the merge sequence is defined. Source requirements: `ai/notes/notes.md`.

Requirements:
0. Creation channel: local (`ai/issues/open/`) or the user's external system (GitHub, GitLab, etc.). The user owns external access and setup; the protocol documents the option, not credentials.
1. Pre-work issue analysis: analyze the issue for missing information, inconsistencies, and gaps; fill the gaps by brainstorming and/or grilling with the user; keep the issue short and to the point. If it is not workable, set `Label: Insufficient Information` or `Label: Unworkable` and refuse to work it, even if the user insists. For an external system without label flexibility, analyze the issue and tell the user whether it is workable.
2. Plan: once the issue has enough information, create a plan and append its file name as a dated comment on the issue. If the project uses TDD, write tests first.
3. Plan minimums: small issues need context plus acceptance criteria; medium and larger need HLD, LLD, acceptance criteria, and ADR. Concise, minimum prose.
4. Plan review: pass the plan through review rounds; validate design and architecture decisions with the user during planning and record them as ADRs; implement only a bullet-proof plan.
5. Branch and merge: implement on a branch that passes peer review. Local sequence: close the issue, squash-merge to trunk, delete the branch, in that order. External PR/MR: merge first, then close the issue.

Out of scope: the delivery ledger. It is not referenced by the issue rules; it stays in the Design Documentation Standards, which cover design-tracked work.

Acceptance criteria:

File-checkable (validator, reference test, lint):
- AC1: the Issue Management Protocol states the creation channel (local or external) and that the user owns external access.
- AC2: the protocol states the pre-work issue analysis, the brainstorming/grilling gap-fill, the minimum-prose rule, and the `Insufficient Information` / `Unworkable` label with the refuse-even-if-insisted rule.
- AC3: the protocol states the plan mandate, the dated-comment plan link, the conditional TDD tests-first recommendation, and the size-based plan minimums.
- AC4: the protocol states the plan review rounds, the ADR recording, and the implement-only-when-bullet-proof rule.
- AC5: the protocol states the branch-and-peer-review step, the local close/squash-merge/delete sequence, and the external PR/MR merge-then-close sequence.
- AC6: `ai/shared/project-knowledge/issue-template.md` carries a `Label:` header field.
- AC7: PROCEDURE MANAGE-ISSUES in `AGENTS.md` covers analysis, label, plan, review, and merge.
- AC8: the issue rules do not reference the delivery ledger; the Design Documentation Standards keep it.
- AC9: validator 8/8, reference test PASS, markdownlint 0.

Behavioral (peer review and a live trial, not a script):
- AC10: the AI refuses to work an `Insufficient Information` / `Unworkable` issue even when the user insists.

---

2026-10-12

Closed on branch `feature/improve-issue-management-policy` as the final change before the squash merge. Plan: `ai/plans/improve-issue-management-policy-implementation-plan.md`. Delivered: the Issue Management Protocol rewrite (creation channel, `Label`, minimum prose and ticket-scope rule, pre-work analysis, plan mandate, dated-comment plan link, conditional TDD, size-based plan depth, plan review with ADRs, branch/merge sequences), the `Label` field in the template, five new PROCEDURE MANAGE-ISSUES steps, the TDD bullet, and the docs sync. The delivery ledger stays in the Design Documentation Standards. Verified: validator v6.0 8/8, reference test PASS (58 steps), markdownlint 0. Peer review: review-04 CHANGES REQUESTED, review-05 APPROVED. ADR recorded in `protocol-decisions.md`.

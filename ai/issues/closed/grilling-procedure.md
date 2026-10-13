Reported: 2026-09-19
Reporter: Kamran Azeem
IssueType: Feature
Severity: P3
Size: M
URL:
Summary: Add an on-demand Grilling procedure and policy to stress-test a design before work begins

Description:

Grilling is the convergent mode in a two-mode pair. Grilling is adversarial: the AI interviews the user, challenges every assumption, and proposes a recommended answer per question so the user reacts instead of inventing. Brainstorming is the divergent counterpart, tracked in `brainstorming-procedure.md`. Both are kept. Grilling serves the Pre-Work Gate's shared-understanding clause.

Shape (revised 2026-10-12; supersedes the earlier on-demand-policy proposal):

- Put the rules in the common policy (`ai/policies/ai-policy-common.md`), not a separate policy file.
- Role: interviewer, not a yes-man. Propose a recommended answer per question before asking.
- Method: map the idea as a design tree; work in rounds; ask all pending branches; process answers; find new branches; repeat until none remain. End with a one-paragraph gist that can feed a design doc or a next-steps entry.
- Write the rules as direct what-only statements, concise, no why prose.
- Open decision: whether to add a trigger in `AGENTS.md` (none, a trigger only, or a full procedure). Resolve during the pre-work analysis.

Origin: the mattpocock/skills analysis in `ai/shared/project-knowledge/mattpocock-skills-codebase-analysis-2026-08-27.md`.

Acceptance criteria:

- The common policy carries a Grilling section with the role, method, and output as direct what-only rules.
- The trigger decision is resolved and reflected (in `AGENTS.md` or the policy alone).
- Validator green; docs updated.

---
2026-10-12
Plan: `ai/plans/grilling-policy-plan.md`. Pre-work decision: grilling lives in the common policy with a trigger phrase; no AGENTS.md procedure.

---
2026-10-12
Closed on branch `feature/grilling-policy`. Added the `## Grilling` section to the common policy and cross-referenced it from Pre-Work Gate item 3. Verified: markdownlint 0, validator v6.0 8/8, reference test PASS. Peer review review-17 APPROVED. ADR recorded in `protocol-decisions.md`.

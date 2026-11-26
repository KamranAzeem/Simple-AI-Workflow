Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Sharpen grilling with a precise question frontier, a numbered question format, and an explicit facts-versus-decisions split.

Description:

The current grilling mode (`ai/policies/ai-policy-thinking-modes.md` `## Grilling`) maps a design tree and works in rounds, but it does not define the frontier precisely, does not prescribe a question format, and does not separate the agent's facts from the user's decisions. The Pre-Work Gate item 3 in `ai/policies/ai-policy-common.md` still says "resolve dependencies one decision at a time", which conflicts with rounds.

Adopt three refinements:

1. Frontier: a round asks only the decisions whose prerequisites are settled. Two dependent questions never share a round. If an answer invalidates an earlier one, reopen that branch in the next round.
2. Format: number each question, give it a short title, then the body, then one recommended answer on its own line. The user may answer a round by number.
3. Facts versus decisions: the agent resolves facts by reading files and running read-only checks, and may use a sub-agent where the protocol allows it. The user makes the decisions. The agent never marks a decision settled on the user's behalf.

Where:

- `ai/policies/ai-policy-thinking-modes.md` `## Grilling`: add the three rules and keep the existing role, recommended-answer, output, and stop rules.
- `ai/policies/ai-policy-common.md` `### Pre-Work Gate` item 3: replace "Ask questions and resolve dependencies one decision at a time" with the round and frontier wording, and keep the light-pass note for low-risk work.

Do not:

- Do not name a person, product, or external skill in the policy text.
- Do not write a glossary or an ADR during grilling; the protocol's ticket, plan, and ADR gates own those artifacts.
- Do not add a skill family or mandatory sub-agents.

Acceptance criteria:

- `## Grilling` states the frontier rule, the numbered format, and the facts-versus-decisions split, in the policy's own words.
- The Pre-Work Gate item 3 no longer instructs one decision at a time; it points to the round and frontier method.
- No person, product, or external skill name appears in the changed policy text.
- Authoring validation passes; the trigger count stays 55; the suite is 35/35; markdownlint 0.
- A grilling session can be answered by number, a round contains no dependent questions, and an invalidating answer reopens the branch.

Related: the Azure companion-architect exercises idea (`ai/issues/open/azure-companion-architect-exercises.md`) should be grilled after this lands.

---
2026-11-26
Filed from the grilling-method comparison. No secret or identifying name present.

---
2026-11-26
Plan: `ai/plans/sharpen-grilling.md` (S). Decision: frontier rule, numbered format, facts-versus-decisions split, generic wording; MINOR v7.12.0. Peer review pending; no branch yet.

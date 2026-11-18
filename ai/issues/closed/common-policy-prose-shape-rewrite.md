Reported: 2026-11-17
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: L
Label:
URL:
Summary: Rewrite the common policy to the authoring standard's prose shape without losing a rule

Description:

- The common policy passes the structural authoring validator but does not meet `### Policy Structure`, `### Rule Structure`, or `### Normative Language` in `ai-policy-meta.md`.
- The exact audit is the 2026-11-17 entry in `ai/issues/closed/extract-common-policy-sections-into-standalone-plugin-policies.md`.
- Summary: 90 rules carry more than one sentence or action, 16 rule bullets carry rationale, 6 lines use a banned normative word, and 8 sections use prose rule content.
- This unit rewrites `ai-policy-common.md` only. It does not change behavior, move a rule to another policy, or touch the canonical state-file header literal.
- It moves rationale to design documents or decision records, splits multi-sentence rules, replaces banned modal words, and turns prose rule content into flat bullets.
- It keeps the guard, READ-ONLY markers, title, purpose sentence, `## Scope`, `## References`, and READ-ONLY END.
- It records a rule-coverage matrix for every current rule, in the legacy-rewrite style.
- It adds a shape fixture or a review checklist so the prose shape cannot regress silently.
- It runs after the plugin-extraction program merges, on a branch cut from master.
- It has its own release note.

## Acceptance Criteria

- Every rule is one sentence in one flat bullet, with no rationale.
- No banned modal or vague word remains in normative text.
- No prose rule block remains. Examples are non-normative fenced blocks.
- The rule-coverage matrix accounts for every current rule. No rule is lost or weakened.
- The canonical state-file header literal is byte-identical.
- The validators, markdownlint, the full suite, and peer review pass.
- The boot payload size is reported.
- The shape fixture or review checklist fails on the old shape.

## Decisions

- One branch in four review groups; no section-level child tickets.
- Release v6.6.4, patch, because no rule or behavior changes.

## Plan

Plan attached below.

## Implementation Plan

### Context

- Ticket: `ai/issues/closed/common-policy-prose-shape-rewrite.md` (L).
- Input: the 2026-11-17 audit in `ai/issues/closed/extract-common-policy-sections-into-standalone-plugin-policies.md`.
- Rewrite `ai-policy-common.md` to the authoring standard without losing or weakening a rule.
- No behavior change, no rule moved to another policy, no new rule.
- Decision: no section-level child tickets. The fixture and the coverage matrix are global, so one branch in four ordered groups is safer than eight tickets.
- Decision: v6.6.4, patch, because no rule or behavior changes.

### Evidence

- Starting file: 465 lines, 7,022 words, 47,192 bytes.
- The audit found 90 rules with more than one sentence or action, 16 rationale bullets, 6 banned normative words, and 8 prose rule sections.
- The audit says its heuristic counts punctuation, not meaning. The implementation re-audited every line; the 90 was a starting map, not the coverage set.
- The fixture is stricter than the audit: it also bans `small` and `large` unless defined.
- The canonical header literal is exempt and must stay byte-identical.
- The guard, READ-ONLY markers, title, purpose sentence, `## Scope`, `## References`, and READ-ONLY END stay.
- The standard is `ai-policy-meta.md`, sections `### Policy Structure`, `### Rule Structure`, `### Normative Language`, and `### Literal Artifacts`.
- The rule structure is one sentence per bullet, one action per sentence, imperative mood, no multi-sentence bullet, and at most one nesting level.
- The release practices require a temp draft, the user's edits, plain words, and no invented event.

### Protocol Compatibility

The rewrite had to preserve these anchors, or the named check fails.

- Title exact `# AI Policy: Common Guardrails`; the guard on line 1; a blank line before READ-ONLY START; READ-ONLY END last (`test-common-boundary.sh`).
- Exactly two `## References` bullets, one naming `AGENTS.md` and one naming the procedure layer (`test-common-boundary.sh`).
- No `ai-policy-<name>.md` in the body outside the header blocks (`test-common-boundary.sh`).
- `## Skills`, `200 characters`, and `the user is responsible` (`test-skills-index.sh`, `validate-protocol.sh`).
- `## Outbound Content Scrub`, the exact substring `The outbound-content-scrub contract owns`, and neither `Class A, internal or same audience` nor `Class B, external or different audience` (`test-outbound-content-scrub.sh`).
- `## Knowledge Invariant` and `Global AI Settings Directory` (`test-knowledge-repair-fixture.sh`).
- `## Issue Invariant` (`test-issue-policy.sh`) and `## Design Invariant` (`test-design-docs-policy.sh`).
- `the thinking-modes contract` in the Pre-Work Gate (`test-thinking-modes-policy.sh`).
- `## State File Ownership Protocol` and `### Canonical State-File Headers`; exactly one START and END marker per header type; the four blocks byte-identical (`validate-protocol.sh`).
- No `## Loading`, because the common policy stays `mode=legacy`, and no `## Triggers`, because the trigger count stays 47 (`test-policy-load-paths.sh`).
- None of the five ordered-close phrases (`test-protocol-references.sh`).
- Other policies cite `## Markdown Output`, `## Humanized Output`, `## Universal Operational Guardrails`, `State File Ownership Protocol`, `Verbose File Naming`, `Analyze-Plan-Stop`, `Branch-Gating Requirement`, `Knowledge Invariant`, `Issue Invariant`, `Design Invariant`, and the thinking-modes contract.
- Docs quote `Untried is not impossible`, `Investigate, verify, then assert`, `Local-first source precedence`, `Self-consistency check`, the Investigation Contract, the author identity order, and the Markdown Output heading.
- The new fixture asserts these anchors.

### HLD

- HLD-001: The policy keeps its section order and headings, so a reader and a cross-reference stay stable.
- HLD-002: Every rule becomes one imperative sentence per item. A rule with two actions becomes two items.
- HLD-002a: An ordered list stays ordered when the order carries meaning: the Non-Negotiables, the Pre-Work Gate, the CLI steps, and the identity source order.
- HLD-002b: Every item is one sentence, whether it is a dash bullet or a numbered item.
- HLD-003: Rationale leaves the policy for one ADR entry; the rule stays and the reason is not lost.
- HLD-004: A prose section becomes flat bullets; a standalone example becomes a fenced block marked non-normative.
- HLD-005: The canonical header blocks are copied byte-identical; the four START and END markers are the extraction key.
- HLD-006: No rule moves to another policy and no new rule is added. The coverage matrix proves the mapping both ways.
- HLD-007: A fixture guards the mechanical shape, and a review checklist guards the judgment calls the fixture cannot make.
- HLD-008: The work is one branch in four ordered groups, each with a diff review, then a full-file review.
- HLD-009: The file may grow because splitting adds bullets; the final boot payload is measured and reported, not capped.

### LLD

- LLD-001 Group 1, the sections through Issue Invariant: Non-Negotiables, Investigation Contract, Feature Development and Branch-Gating, A2A, Restart and Checkpoint, AI-Driven Secure Development, Operational Guardrails, Outbound, Author Identity, Compliance, Knowledge, Skills, Issue.
- LLD-002 Group 2, State File Ownership Protocol. Split each multi-sentence rule into one-action bullets; keep the canonical header blocks byte-identical; keep the four literal labels and the fenced blocks unchanged.
- LLD-003 Group 3, Operational Standards through Git Configuration, including Testing and Engineering. The Pre-Work Gate's seven numbered steps stay numbered; the `.gitconfig` block stays a template; engineering rationale leaves.
- LLD-004 Group 4, Design Invariant through Markdown Output, including Communication Standards and Humanized Output. The `Why This Matters` paragraph leaves for the ADR; the Markdown Output bullets split by one action each.
- LLD-005 Coverage matrix: re-audit every old line sentence by sentence, then assign a rule to each new item; keep a per-section old and new count. The implemented matrix is below.
- LLD-006 Fixture: add `tests/test-common-prose-shape.sh`. Strip fenced blocks, inline code, list markers, and the `e.g.`, `i.e.`, `etc.`, and `vs.` abbreviations; fail on a banned word, a multi-sentence item, a prose paragraph, deep nesting, a missing anchor, a policy file name, Class A or B, and the ordered-close phrases; prove it fails on the old file.
- LLD-007 Review checklist: no rationale in a bullet; every example marked non-normative; every old normative sentence maps to a rule; no modal weakened; no rule moved.
- LLD-008 ADR entry: one terse entry in `design-docs/protocol-decisions.md` holding the removed rationale, written through the `update design documents` trigger.
- LLD-009 Docs alignment: check every doc that quotes a common-policy rule; keep the quoted rule names in the policy or align the doc.
- LLD-010 Size: measure lines, words, and bytes before and after; report the change.
- LLD-011 Counts: the new fixture makes 21 test scripts; update the toolchain knowledge and the validation-system doc.
- LLD-012 Prerequisite fixes: the stale `write-checkpoint` reference and the ticket input path.

### Acceptance Criteria

- AC-001: every rule is one sentence in one flat bullet, imperative, with one action.
- AC-002: no rationale remains in a rule bullet; the ADR holds it.
- AC-003: no banned normative word remains.
- AC-004: no prose rule block remains.
- AC-005: a fresh line-by-line audit feeds the coverage matrix; every old rule maps to a new bullet; no rule is lost, weakened, or moved.
- AC-006: the four canonical header blocks are byte-identical.
- AC-007: `tests/test-common-prose-shape.sh` passes on the new file and fails on the old one.
- AC-008: the authoring validator, protocol validator 8/8, full suite, and markdownlint pass.
- AC-009: the boot payload change is measured and reported.
- AC-010: no behavior change; the trigger count and policy count stay the same.
- AC-011: the v6.6.4 note is drafted, edited by the user, and only then published.
- AC-012: peer review APPROVED for the plan, each group, and the final file.
- AC-013: every Protocol Compatibility anchor survives, and the fixture asserts each one.
- AC-014: ordered lists keep their order, and every item is one sentence.
- AC-015: the docs pass aligns every quoted rule; no doc claims a rule the rewrite removed.
- AC-016: the toolchain knowledge and the validation-system doc name 21 test scripts and the new fixture.
- AC-017: the ADR entry is written through the `update design documents` trigger.
- AC-018: the `write-checkpoint.md` reference and the ticket input path are corrected.

### Rule Coverage Matrix

- The plan carried the section skeleton; the implementation filled every row.
- Non-Negotiables: 7 items, 5 multi-sentence.
- Investigation Contract: prose, 22 items.
- Feature Development and Branch-Gating: 1 prose block, 3 steps, 9 rules.
- A2A Coordination: 4 rules, 6 items.
- Restart and Checkpoint: 6 rules, 21 items.
- Guardrails: 11 rules, 39 items.
- Outbound: 3 items.
- Author Identity: 10 items.
- Compliance: 11 items.
- Knowledge: 6 items.
- Skills: 19 items.
- Issue: 3 items.
- State File Ownership: 48 items plus the five canonical rules.
- Operational Standards: 5 subsections, all rules split.
- Testing: 10 items.
- Engineering: 17 items.
- Git Configuration: 13 items plus the template.
- Communication and Humanized Output: all rules split; the rationale moved.
- Markdown Output: all rules split.
- The implementation matrix records old line or sentence to new rule, with a per-section count.

### Implemented Coverage Matrix

- Group 1, `review-18`: Scope 9, Non-Negotiables 9, Investigation 22, Feature 11, A2A 6, Source-of-Truth 9, Checkpoint 13, Secure 8, Guardrails 39, Outbound 3, Author 10, Compliance 11, Knowledge 6, Skills 19, Issue 3.
- Group 2, `review-19`: 48 State File Ownership bullets plus the five canonical rules; the four header blocks are byte-identical.
- Group 3, `review-20`: Operational Standards, Thinking Modes (unchanged), Testing, Engineering, and Git Configuration; every old rule maps.
- Group 4, `review-21`: Design Invariant (unchanged), Communication Standards, Humanized Output, and Markdown Output; the `Why This Matters` rationale moved to the appendix.
- The four group reviews are the line-by-line evidence; the new fixture guards the shape.

### Removed Rationale (ADR Written)

The `update design documents` trigger was invoked on 2026-11-18. The one ADR entry is in `design-docs/protocol-decisions.md`; this appendix is the plan-side copy.

- Non-Negotiables: the rules most costly to break, active at boot, load, recovery, and mid-work.
- Goodhart's Law: a bare metric becomes a target, and stronger models game it more.
- SOLID: non-negotiable for maintainable, testable systems.
- YAGNI: speculative generality adds complexity without proven value.
- Trunk-based development: enables continuous integration and reduces merge conflicts.
- Conventional Commits: enables changelogs and semantic version bumps.
- Naming: verbose names aid the JIT lookup, while code is navigated by structure and imports, so verbose names break imports and routing.
- Humanized Output: AI text is too perfect, polite, and generic; the section exists so the output sounds human.
- Tone and patterns: em dashes are an AI tell; negative parallelisms sound like disproving a misconception; the rule of three adds noise; promotional language, hedging, vague attributions, faux analysis, list-bombing, and exhaustive caveats weaken the text.
- Git config: a human name is acceptable and a tool name is not.
- CLI: a plausible-sounding flag is worse than no command, and flags differ across tools and versions.
- Pre-Work Gate: a low-risk change needs a light pass, and a high-risk or destructive change needs the full treatment.
- Generated file validation: catches syntax, formatting, and common bugs before human review.

### Risks

- Losing a rule while splitting. Mitigation: the two-way matrix and a line-by-line review of each old sentence.
- Growing the boot payload. Mitigation: remove rationale and duplicate wording, then measure.
- A brittle fixture that flags legitimate sentences. Mitigation: strip code, exempt abbreviations and paths, calibrate against the old file.
- The Humanized Output section is self-referential. Mitigation: rewrite its rules with the same shape, and move only its rationale.
- A missed section in review. Mitigation: four group reviews plus one full-file review.

### Out of Scope

- Any other policy, `AGENTS.md`, the loading declarations, and the tool-selection unit.
- A docs rewrite; the docs pass only aligns quoted rules and the release note.
- Behavior changes, rule moves, and a size reduction target.
- The full codebase examination.

### Close Sequence

- Repo: project root of the workflow clone.
- Base ref: `master` at the v6.6.3 release commit.
- Branch: `feature/common-policy-prose-rewrite`, cut from `master`.
- Merge mode: squash to `master`, one commit.
- Ticket: closed in the branch commit with the plan and coverage matrix attached.
- Design-docs gate: the `update design documents` trigger was invoked; the ADR entry is in the store.
- Release: v6.6.4, patch.
- Verification: fixture, compatibility anchors, authoring validator, protocol validator, full suite, markdownlint, header hash, docs quote check, boot payload.
- Branch deletion: local and remote after the release.

### Peer Review Log

- Plan round 1, `2026-11-18_23-09_review-11.md`: CHANGES REQUESTED; fixed.
- Plan round 2, `2026-11-18_23-10_review-12.md`: APPROVED.
- Compatibility round, `2026-11-18_23-13_review-13.md`: CHANGES REQUESTED; fixed.
- Implementation Group 1, `2026-11-18_23-32_review-18.md`: APPROVED.
- Implementation Group 2, `2026-11-18_23-35_review-19.md`: APPROVED.
- Implementation Group 3, `2026-11-18_23-40_review-20.md`: APPROVED.
- Implementation Group 4, `2026-11-18_23-52_review-21.md`: APPROVED.
- Final review, `2026-11-18_23-55_review-22.md`: APPROVED.
- ADR written, 2026-11-18, through the `update design documents` trigger; the review-22 ADR Minor is resolved.

---

2026-11-18
Closed: the common policy is rewritten to the authoring shape: 90 multi-sentence rules split, 16 rationale bullets moved to one ADR entry, 6 banned words removed, 8 prose sections flattened, no rule changed. The four canonical header hashes match; `tests/test-common-prose-shape.sh` passes new and fails old with 132 findings; the suite passes 21 of 21; the ADR entry is in `design-docs/protocol-decisions.md`. The v6.6.4 release carries it.

# Protocol architecture routing principle + consolidation follow-up

Captured 2026-08-31 so it cannot be missed. Working note for later protocol work. The two big items are the consolidation follow-up and the evidence-proposal evaluation below.

## Routing principle (decided 2026-08-31)

AGENTS.md is a router, not a catalog. Do not apply the two-layer pattern to everything. Two-layer (a short AGENTS.md instruction plus policy detail) is only for universal always-on mechanics, and even then the instruction stays to one line.

Three activation mechanisms, and what belongs in each:

- **TIER 2 MANDATORY ACTIONS**: the small curated set of universal always-on mechanics. Only rules that fire on every task regardless of domain or trigger, and that are costly to break (full reads, no-truncation, evidence-based, single-writer state, branch gating, git-workspace detection, archive/backup exclusions). This set rarely grows. It is the only place "short instruction plus policy detail" is worth it.
- **TIER 3 TRIGGERED PROCEDURES**: situational, user-invoked behavior. One line each (when the user says X, load ai-policy-X.md and follow it). The policy file is self-contained on (a) what to do and (b) how to do it. No TIER 2 pointer.
- **Active Expertise** in `ai-customization.md`: persistent domain behavior loaded at boot by Procedure A Step 6. No per-feature AGENTS.md addition.

Placement test for any new rule:
- Applies to EVERY task and is costly to break? -> TIER 2 (rare).
- Behavior for a SPECIFIC situation, solved with steps? -> its own policy, reached by a trigger phrase or listed in Active Expertise.
- Explicitly invoked procedure? -> TIER 3.

Reason: otherwise every new policy feature would need a TIER 2 pointer and AGENTS.md would grow. The routing mechanisms already do the wiring.

## Consolidation follow-up (to do later)

Redundancy: TIER 2 (AGENTS.md) and Non-Negotiables (ai-policy-common.md) both claim to be "always-on". Since ai-policy-common.md is always fully loaded at boot and post-compaction, several TIER 2 mechanics could live entirely there, letting AGENTS.md trim further. Candidate: move always-on mechanics into the always-loaded common policy as the canonical home, and keep AGENTS.md structural/mechanics-only. Decide a single canonical home so there is one source of truth, not two.

## Evidence-based proposal evaluation (2026-08-31)

Evaluated the 4-item proposal from the other production instance (provenance tagging, decision-driving-fact gate, knowledge-file review in code review, old-knowledge distrust). Verdict:

- Item 1 Provenance Tagging: NOT worth it. A tag taxonomy plus header-block/inline convention is a schema and a maintenance tax on every knowledge file. Do not adopt. Its useful spirit is absorbed by item 4.
- Item 2 Decision-Driving-Fact Gate: already covered by the Investigation Contract cross-check clause (a fact that matters is confirmed by more than one independent source; a proposed value is checked against the real environment).
- Item 3 Knowledge-file factual review in code review: NOT worth it. Scope creep on Procedure D; the lean fix for stale knowledge is distrust at point of use (item 4), not a review gate.
- Item 4 Old-knowledge distrust: REAL gap, worth a crisp clause. The DGH case proved existing knowledge files can be stale and wrong. The Investigation Contract lists project knowledge as a source but does not say to distrust stored facts until re-verified now.

## Candidate follow-ups (2026-08-31)
- Old-knowledge distrust clause: added then removed 2026-08-31. It was too essay-like and over-broad (it contradicted project knowledge's authority), so it was dropped to keep the Investigation Contract lean. Rely on the checkpoint knowledge update (Procedure C Step 3) for freshness. Do not re-add unless it can be stated crisply and scoped to time-bound state only.
- [ ] Consolidate the TIER 2 vs Non-Negotiables "always-on" canonical home so there is one source of truth.

Reported: 2026-11-26
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Enforce the decided always-on division: make the Non-Negotiables index reference-only, reconcile its cap, correct the stale caveat, and guard the shape with a fixture

Description:

The two-layer always-on design is already decided. The 2026-08-31 ADRs (`design-docs/protocol-decisions.md:587-593`) put the universal read-first rules in `AGENTS.md` and their detailed contracts in the common policy, with the short rule pointing at the contract. The 2026-08-25 ADR (`design-docs/protocol-decisions.md:557-559`) made the common-policy Non-Negotiables a short index of rules that have their own owners. The Level 0 precedence (`AGENTS.md:139`) names both layers.

The implementation drifted from that decision. Four points, in order:

1. Make the index reference-only.
   - Current items 2 and 3 restate the mandates (`ai/policies/ai-policy-common.md:26-27`): "Read every file ... in full, line 1 to EOF" and "Never pipe ... through `head`, `tail`, or `-N`".
   - The 2026-08-31 ADR says full reads and no-truncation are "referenced, not restated".
   - Change item 2 to: "**Full file reads.** See Full File Reads in `AGENTS.md` TIER READ-FIRST-RULES."
   - Change item 3 to: "**No truncated evidence.** See No Sliced Evidence in `AGENTS.md` TIER READ-FIRST-RULES." The current pointer wrongly names Full File Reads.
   - Keep the other seven items; they already point at their owners.

2. Reconcile the cap.
   - The index has nine items (`ai/policies/ai-policy-common.md:25-33`); the 2026-08-25 ADR caps it at six and lists six (`design-docs/protocol-decisions.md:559`). Later features added outbound, author identity, and no AI identity without amending the cap.
   - Recommended: retire the fixed numeric cap. Add one superseding ADR entry: the index has no fixed count; each item is one line, names the rule, and points at its owning section; no restatement; the section stays short. The six-item entry stays as history.
   - Alternative: trim to six. It means dropping outbound and author-identity items or merging distinct rules; not recommended because they are high-cost always-on rules.
   - The plan confirms the choice before the edit.

3. Correct the stale caveat.
   - `ai/knowledge/protocol-routing-principle.md:32` says the two layers still "claim an always-on role" and "the consolidation is unresolved".
   - That contradicts the ADRs and the precedence. Replace it with the resolved division: `AGENTS.md` holds the universal read-first rules; the common policy owns their detailed contracts and indexes them; the two-layer pattern is deliberate and only for universal always-on mechanics.
   - The earlier audit finding and the consolidation ticket's dated "reconfirmed" note relied on that caveat. The close note on that ticket records the correction.

4. Guard the shape with a fixture.
   - Extend `tests/test-policy-shape.sh`, so the suite stays at 36 and the deck count does not move again.
   - Assert the Non-Negotiables section exists; each item is one line; item 2 contains the Full File Reads pointer and not the mandate text; item 3 contains the No Sliced Evidence pointer and not the truncated-evidence text; no item exceeds 240 characters.
   - If the plan keeps a numeric cap, assert the exact count instead.

Out of scope:

- Moving rules between the layers, changing the precedence, or editing the `AGENTS.md` mandates.
- The content of the other seven index items and their owner sections.
- Any trigger, loading, or procedure change.
- The historical ADR entries and the old ticket's history.

Acceptance criteria:

- AC-1: Items 2 and 3 are reference-only, and item 3 points to No Sliced Evidence; the mandate text is gone.
- AC-2: One superseding ADR entry records the cap decision, and no ADR/index contradiction remains.
- AC-3: The routing caveat states the division and no longer contains "unresolved"; the old ticket's close note records the correction.
- AC-4: `tests/test-policy-shape.sh` fails when item 2 or 3 restates the mandate, and passes on the repaired tree; the suite stays 36/36, the validator 8/8, markdownlint 0.
- AC-5: The old consolidation ticket is closed as superseded with a dated note citing the 2026-08-31 ADRs.
- AC-6: No behavior change; the rules and the precedence are unchanged.

Verification:

- `bash tests/test-policy-shape.sh`
- `bash tests/run-all.sh` (36/36)
- `bash support-files/validate-protocol.sh` (8/8)
- `markdownlint-cli2` on the common policy, the ADR store, the knowledge file, and both tickets
- `grep -n 'unresolved' ai/knowledge/protocol-routing-principle.md` returns nothing
- Read the repaired index and confirm each item points at its owner.

Decisions for the plan:

- Cap: retire the numeric cap (recommended) or trim to six.
- Guard home: extend `tests/test-policy-shape.sh` (recommended) or add a new fixture, which moves the deck count.
- ADR: add a new superseding entry; load `design-docs/protocol-decisions.md` first in Protocol Developer Mode.

---
2026-11-26
Filed from the evidence-based investigation of `ai/issues/closed/tier2-vs-non-negotiables-consolidation.md`; that ticket closes as superseded by the 2026-08-31 ADRs.

---
2026-11-26
Plan: `ai/plans/non-negotiables-index-enforcement.md`. Note: the predecessor close note says "Closed as obsolete", not "superseded"; the plan asserts the live wording and leaves the historical file byte-identical.

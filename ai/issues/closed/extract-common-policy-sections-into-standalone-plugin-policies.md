Reported: 2026-11-15
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: XL
Label:
URL:
Summary: Extract always-loaded common-policy sections into standalone plug-in policies and rewrite them to the authoring standard

Description:

**Status**: all 12 units are complete or resolved on `feature/plugin-extraction`, pending the program merge. The dated entries at the end are authoritative; the evidence and plan sections below record the starting point.

**Problem**: `ai-policy-common.md` is 869 lines and carries both always-on invariants and task-specific rules. Every session loads all of it. The task-specific rules should live in standalone policies, loaded by a trigger or by the procedure that uses them, the way `ai-policy-handoff.md` is loaded by PROCEDURE CREATE-HANDOFF. The extraction is also the moment to rewrite each moved section to the authoring standard in `ai-policy-meta.md` (`## Procedure and Policy Authoring`).

**Design decision to record in the ADR and the plan**:

- Dependency direction: a plug-in may reference the common policy. The common policy must not reference a plug-in.
- The common policy holds always-on invariants only, stated as behavior, never as a per-policy file reference.
- A plug-in is a task-scoped policy with its own `## Triggers`, and/or a procedure step that loads it by name.
- Loading guarantee: every plug-in is reached by its trigger or by its owning procedure. A plug-in with neither is invisible.
- Invariants that must hold before a plug-in loads stay in the common policy. State-file single-writer and the canonical headers are invariants, not plug-ins.
- The common `## References` section drops the per-policy catalogue and points to `AGENTS.md` and the procedure layer.
- Handoff precedent: `ai-policy-handoff.md` is loaded by CREATE-HANDOFF and the receiver start phrases. Its line 88 ("Rely on the always-on pointer in the common policy..."), the common policy's A2A item 4, and the Branch-Gating line 53 contradict the plug-in model. Replace them with generic invariants that name behavior, not the file.

**Current evidence**:

- `ai-policy-common.md`: 869 lines.
- Section sizes: Outbound Content Scrub 64; Global Knowledge 11; Project Knowledge 28; Knowledge File Standards 101; Issue Management 86; Grilling 10; Brainstorming 10; Design Documentation Standards 116; Universal Engineering Standards 38; Universal Testing Standards 8; State File Ownership 91; Operational Restart and Checkpoint Contract 22.
- `support-files/validate-protocol.sh` line 68 requires `^## Outbound Content Scrub$` in `ai-policy-common.md`.
- MANAGE-ISSUES, IMPLEMENT-PLAN, and CREATE-HANDOFF already name `## Outbound Content Scrub`.

**Extraction units**:

- Outbound Content Scrub (64 lines) to `ai-policy-outbound-content-scrub.md`. Trigger `outbound content scrub`. Loaded by MANAGE-ISSUES, IMPLEMENT-PLAN, and CREATE-HANDOFF. The common invariant stays generic: remove secrets and identifying data before any artifact leaves the project. Saves about 62 lines. Pilot.
- Knowledge (Global 11 + Project 28 + Standards 101 = 140 lines) to `ai-policy-knowledge.md`. Trigger `knowledge file standards`. Loaded by WRITE-CHECKPOINT, REPAIR-KNOWLEDGE-FILES, and the LOAD-CONTEXT index step. Saves about 138 lines.
- Issue Management (86 lines) to `ai-policy-issue-management.md`. Triggers `issue standards` and `ticket standards`. Loaded by MANAGE-ISSUES and IMPLEMENT-PLAN. Saves about 84 lines.
- Design Documentation Standards (116 lines) merged into `ai-policy-design-docs.md`. Already procedure-loaded. Saves about 114 lines after dedup. The planning and pre-work steps must load the policy when they need design depth.
- Universal Engineering and Testing Standards (46 lines) merged into `ai-policy-coding-baseline.md`. Saves about 44 lines. Open decision: activation.
- State File Ownership and the Checkpoint Contract (113 lines) stay in the common policy as an invariant. Do not make it a plug-in. A literal artifact file is a separate design decision because `AGENTS.md` and the validator anchor the headers.
- Grilling and Brainstorming (20 lines) to `ai-policy-thinking-modes.md`. Triggers `grill me` and `brainstorm`. Optional; low value.

**Authoring-standard status**:

- Rewritten per the ADR: meta, observability, web-frontend, api-backend, data, dba, cloud, mobile-apps.
- Written under the standard as new files: coding-baseline, handoff, and design-docs (line 9 is a loading note, not the required purpose sentence).
- Structurally patched but not prose-rewritten: `ai-policy-academic-researcher.md`, `ai-policy-accounting.md`, `ai-policy-career-coaching.md`, `ai-policy-linux-system-admin.md`, `ai-policy-windows-system-admin.md`.
- Common: title exemption in the ADR; not rewritten.
- code-review and codebase-examination: no explicit rewrite record; structurally valid, prose discipline unverified.
- All 19 policies pass `validate-policy-authoring.sh` on structure. The remaining gap is prose density, which peer review enforces.

**Modeling gaps to fix**:

- design-docs: the independent policy exists and is procedure-loaded, but the common policy still carries the full standards. The ADR created the policy to get design work out of the always-loaded common policy; the extraction is half done.
- coding-baseline: loaded only through `## Active Expertise`; no procedure and no trigger. Moving the engineering and testing standards there changes when they apply.
- api-backend, data, cloud, dba: one noun-phrase trigger each and no procedure loads them. Either drop the trigger and treat them as expertise, or wire a procedure.
- code-review and codebase-examination: procedure-loaded and close to the handoff model. Only the explicit Loading section is missing.

**Open decisions before the later units**:

- Coding-baseline activation: load it in IMPLEMENT-PLAN for code work, or keep the principles in the common policy.
- State-file header ownership: where the canonical blocks live and how `AGENTS.md`, `validate-protocol.sh`, and the load and repair procedures resolve them.
- Thinking modes: whether grilling and brainstorming get their own policy.

**Sequence**:

- Pilot the outbound content scrub. It has no open design decision.
- Then knowledge, issue management, the design-docs merge, and the coding-baseline merge.
- Then state files, after the header-ownership decision.
- Thinking modes optional.
- Leave the five legacy domain policies alone until their domain is touched.

**Out of scope**:

- Bulk rewrite of the five legacy domain policies.
- Changing the canonical state-file headers without a design decision.
- Domain rule content changes.

**Acceptance criteria for the program**:

- No per-policy reference in `ai-policy-common.md`. Each task policy is reached by its trigger or its owning procedure.
- Each extracted section is rewritten to the authoring standard in `ai-policy-meta.md`.
- The common policy keeps only invariants, stated as behavior.
- Validator anchors, reference tests, trigger fixtures, and boot fixtures are updated and green.
- The ADR records the plug-in model and each extraction.
- Peer review APPROVED for each unit.
- Checkpoint and release per unit.

**Breakdown**: this ticket is XL and must be split into child tickets before implementation. The pilot child is the outbound content scrub.

Related: `ai-policy-meta.md`, `design-docs/protocol-decisions.md`, `ai-policy-handoff.md`, `ai/issues/open/protocol-procedure-tdd-spec-driven-verification.md`, `ai/issues/closed/policy-authoring-validator-legacy-shape-gaps.md`, `support-files/validate-protocol.sh`.

---
2026-11-15
Grilling resolved the design. These decisions supersede the open items in the description.

- Model: approved. A plug-in may reference the common policy. The common policy never references a plug-in. Invariants stay in common.
- First child: a boundary cleanup. It removes every per-policy reference from the common policy, replaces them with generic invariants, rewrites the title to the authoring standard, and limits References to `AGENTS.md` and the procedure layer. It also removes the handoff pointers in A2A item 4 and Branch-Gating, and the handoff policy's line about relying on the common pointer.
- Loading contract: a fixed `## Loading` section with `Load in`, `Trigger`, and `Auto-load`. The TDD child for policy configuration tests is a prerequisite under the TDD parent. It owns the shape in the meta policy, `tests/test-policy-load-paths.sh`, the shape wrapper, and the scenario spec template.
- Tests: dev-time only, in `tests/`. Validators stay in `support-files/`. `tests/test-policy-shape.sh` runs the authoring validator over all policies and procedures. `tests/run-all.sh` is the suite. The end-user never runs them.
- Common rewrite: the boundary child changes the title to `# AI Policy: Common Guardrails`, fixes the guard and marker order, and cleans References. The behavioral prose stays.
- State files: stay in common as invariants. They are not an extraction.
- Coding baseline: defer until after the outbound, knowledge, and issue-management children land, and before the state-file review. The parent carries this as a checklist condition, not a date.
- Pilot: the outbound content scrub, one child, one release.
- Legacy phase 2: Linux, accounting, career, Windows, academic last. One child per policy.
- Thinking modes: include grilling and brainstorming as the last common child.
- Program structure: 12 units. One boundary child, six common extraction children (outbound, knowledge, issue management, design-docs, coding-baseline, thinking modes), and five legacy children. The TDD policy-configuration child is an external prerequisite under the TDD parent.
- Remaining plan-level questions: the exact generic invariant wording for the boundary child, the release cadence, and the scenario spec format. They belong in the plans, not the grilling.

---
2026-11-15
Release gate and plug-in architecture requirements from the user. These are binding acceptance criteria. The release decision here supersedes the earlier per-child release decision.

Release gate:

- No tag and no GitHub Release until every child unit is complete and the full suite is green.
- Each child must leave the active protocol working: the validators, all fixtures, and peer review pass before the merge.
- The final release is the last step of the program.
- Active users get a working master after each child. If the user wants zero master changes, the program uses one long-lived integration branch instead. That is an open decision.

Plug-in discovery, verified against the current files:

- A global policy in the workflow clone's `ai/policies` with `## Triggers` is in the module index and loads on its trigger. No `AGENTS.md` pointer.
- A project policy under the user's `ai/policies` is loaded in full at boot by `LOAD-CONTEXT` and indexed. No customization entry.
- A policy with neither a trigger nor a procedure load is invisible unless `## Active Expertise` names it. A standalone policy must declare a trigger.
- The runtime dispatch is prose. The tests prove the index, the files, and the wiring, not AI obedience.

Retirement and custom policies:

- Deleting a policy removes it from the index. Every reference must resolve.
- Today, `tests/test-protocol-references.sh` checks procedure, step, tier, and item names and hardcoded paths, not that a named policy file exists.
- Today, `support-files/validate-protocol.sh` has a hardcoded `POLICIES` array and a fixed 19-policy count. Adding a policy is not checked; retiring one fails the baseline until the array changes.
- There is no retirement fixture and no custom-policy full-load fixture. The boot fixture indexes a project policy but does not prove the full-text load.
- A missing policy must produce a clean refusal that names it, not a silent fallback.
- The user is responsible for correct policy structure. The authoring validator is dev-time, not runtime.

Required tests and changes:

- Replace the hardcoded policy baseline with a directory scan.
- Add a load-path test that checks each named policy file exists.
- Add a discovery fixture for a new global policy with a trigger.
- Add a custom project-policy fixture that proves the boot load and the index.
- Add a retirement fixture that proves the reference failure and the clean refusal.
- Remove the handoff line 88 and the common A2A and Branch-Gating pointers in the boundary child.

Open decisions:

- Retirement behavior: clean refusal or silent fallback.
- Integration: green master per child and one final release, or a long-lived integration branch.
- Discovery: a `## Triggers` phrase or semantic inference from the policy description.
- Custom project policy: full load at boot or load on trigger.

---
2026-11-15
Final decisions.

- Retirement: clean refusal. The procedure stops and names the missing policy. No silent fallback.
- Integration: green master per child. Each child merges only when the full suite is green. The tag and GitHub Release wait until all 12 units are done.
- Discovery: a `## Triggers` phrase is the self-declaration. No external pointer.
- Custom project policy: indexed at boot, loaded on trigger only. This changes the current `LOAD-CONTEXT` behavior, which loads every project policy in full at boot.
- Policy baseline: the validator scans `ai/policies` for `ai-policy-*.md` instead of the hardcoded `POLICIES` array.
- Consequence: a project custom policy with no trigger and no procedure load is indexed but not loaded. Correct structure for a project plug-in includes a trigger.
- Migration risk: existing project policies without triggers currently load at boot. The on-trigger-only change would stop them. The plan must add a compatibility path or a migration warning before the release. Do not ship this change without it.
- Runtime boundary: the clean refusal and the tests cover the files and the wiring. Runtime AI obedience remains prose.

---
2026-11-15
Custom-policy migration approach.

- At boot, project policies are indexed. A project policy without a `## Triggers` or `## Loading` declaration gets an advisory and an offer for an AI-assisted review.
- The review adds the trigger or Loading declaration without changing the policy's rules. The user approves the edit. The AI runs the authoring validator when it is available.
- Active Expertise is not a project-policy path today. The `LOAD-CONTEXT` expertise search reads the Global AI Policies Directory, not the project directory. It also needs a customization entry, which contradicts the no-customization requirement. Do not present it as the fallback.
- A global custom policy in the workflow clone can use Active Expertise. It needs a customization entry, and the loader finds it in the global directory.
- Always-on project policy: add a `Load: boot` declaration to the `## Loading` contract, loaded from the project directory at boot without a customization entry. This is the exception to the default on-trigger-only mode.
- If the user declines the review and the policy has no trigger, it stays indexed but not loaded, and the user is warned once.
- The detection is a cheap check for the `## Triggers` or `## Loading` section. The boot fixture covers it.

---
2026-11-15
Documentation and custom-policy howto requirements.

- New short howto at `docs/custom-policy-howto.md`:
  - Where to put a policy: the project root `ai/policies/ai-policy-<name>.md`, or the workflow clone's `ai/policies/` for a global policy.
  - The structure: the guard, the READ-ONLY markers, `# AI Policy: <Domain>`, a purpose sentence, `## Triggers` or `## Loading`, `## Scope`, domain sections, and `## References`.
  - The loading modes: `Trigger`, `Load in`, `Load: boot`, `Load: Expertise`, and `Auto-load`.
  - Validate with the clone's validator. The default command checks the shape. The `--triggers` command passes the protocol set plus the custom file to check collisions. The `--index` command prints the module line.
  - Use it: a project policy with a trigger or `Load: boot` needs no customization entry. The trigger phrase loads it.
  - Migrate an existing policy: run the validator, add the missing shape and the loading declaration, do not rewrite the rules, run the validator again, and check collisions with the protocol set.
- Update `README.md`, `docs/how-policies-work-in-this-workflow.md`, `docs/ai-customization-guide.md`, `docs/protocol-validation-system.md`, `docs/workflow-guide.md`, and `docs/simple-ai-workflow-slides.md`.
- Update `ai/shared/project-knowledge/protocol-verification-toolchain.md` with the custom-policy validation commands and the dynamic baseline.
- The release announcement covers the plugin model, the custom policy, and the migration.
- Validator portability, verified:
  - The script takes file paths and does not `cd` to the repo. It accepts an absolute path outside the clone.
  - The filename rule matches any path containing `ai/policies/`.
  - The trigger collector attributes a custom policy to its `ai-policy-<name>.md` name.
  - The `--triggers` mode checks collisions only across the files passed. A custom policy alone does not check against the protocol. The howto must pass the protocol set plus the custom file.
  - The `--index` oracle hardcodes `global` scope. Fix it to report `project` for a project path.

---
2026-11-15
Backward-compatibility correction. This supersedes the earlier on-trigger-only default and the "global custom policy in the clone" path.

- The user must not add policies to the workflow clone. The clone holds the protocol's own policies. A user's custom policy lives only under the project root `ai/policies/`. Remove the "global custom policy in the clone" path from the docs and the howto.
- Existing project custom policies keep their current behavior. A project policy without a `## Loading` declaration continues to load in full at boot, exactly as today. No user action is required.
- The plugin mode is opt-in. A project policy that declares `## Loading` with `Trigger` is indexed at boot and loaded on trigger. A policy with `Load: boot` loads at boot. A policy with `Load in` is procedure-loaded. A policy with no declaration keeps the legacy boot load.
- The migration offer is optional and never removes a working policy.
- Behavior preservation is a binding acceptance criterion:
  - Each extracted section moves to a plugin that the owning procedure loads, and the observable behavior is unchanged.
  - The generic invariants stay in common, including the handoff refusal and the outbound rule.
  - No end-user customization change is required.
  - Add a legacy project-policy fixture: a policy with no `## Loading` still loads at boot.
  - Add a plugin project-policy fixture: a policy with `## Loading` `Trigger` is indexed and loads on trigger.
  - Keep the existing scrub, checkpoint, and handoff fixtures as the behavior regressions.
- The end-user sees the same behavior. The only visible addition is the optional trigger path and the optional howto.

---
2026-11-15
Extraction behavior-match requirement.

- The extraction is invisible only if every path that used the moved rule loads the plugin. The extraction is not automatically invisible.
- Risks:
  - An always-on rule becomes on-demand and an ad-hoc path does not load it. The outbound scrub outside the three procedures is the clearest case. The knowledge, issue, and design rules have the same risk.
  - A procedure, a policy, or a validator anchor still points at the moved section.
  - A new trigger collides with an existing trigger and the dispatch changes.
  - A sub-agent does not load the plugin and loses the rule.
  - The generic invariant is too weak for a path not covered by a procedure.
- Mitigations:
  - A rule-coverage matrix for each section: every path that used it loads the plugin or is covered by the generic invariant.
  - Procedure load steps on every path.
  - Cross-reference and validator-anchor updates.
  - The `--triggers` namespace check over the protocol set.
  - A behavior-match fixture per section: the owning procedure produces the same artifacts before and after.
  - The load-path test and the refusal path.
  - The end-user does nothing. The protocol developer wires the paths.
- Do not claim no breakage until the behavior-match fixtures pass.

---
2026-11-15
Delivery model: one program branch, no trunk merge, no release until the live test.

- Work on one long-lived branch, proposed `feature/plugin-extraction`. The 12 child units are commits on that branch, not separate trunk merges.
- The TDD policy-configuration child is the first commit on the branch, not a separate master merge.
- Push the branch to origin so the user can pull it on the work computer and test it with an actual project.
- The branch must be green after every child: validators, all fixtures, behavior-match fixtures, and peer review.
- No merge to master and no tag or GitHub Release until the user's live test passes and the user approves.
- Rebase or merge master into the program branch before the final review.
- After approval, merge the program branch to master, tag and publish the release, and close the parent and the child tickets.
- This relaxes the one-branch-per-unit and squash-to-trunk rules for this program. The parent ticket is the single work item; the children are steps on the branch. The plan records the deviation and the approvals.
- The docs include how to test the branch on the work computer and how to switch back.

---
2026-11-16
`Auto-load` is dropped from the loading modes. It was never defined, and `boot` and `procedure` cover the real cases. The v1 modes are `boot`, `trigger`, `procedure`, and `expertise`. The policy-loading contract child records the same and owns the grammar.

---
2026-11-16
Project-policy loading behavior is dropped from this program. The `## Loading` declaration governs global policies only, where the four paths already exist: Active Expertise, a trigger phrase, boot, or an explicit procedure load. A project policy keeps the legacy boot load, and no loader child is added. The boundary child remains the common-policy pointer cleanup. The docs, the spec, and the ADR record this.

---
2026-11-16
Boundary child complete on `feature/plugin-extraction`. The common policy is now `# AI Policy: Common Guardrails`, names no policy file outside the canonical header literal, and its References lists only `AGENTS.md` and the procedure layer. The handoff pointer is gone, the validator rejects the legacy title, and `tests/test-common-boundary.sh` pins the rule. The next unit is the outbound content scrub pilot.

---
2026-11-16
Pilot complete on `feature/plugin-extraction`. The outbound content scrub rules are in `ai-policy-outbound-content-scrub.md` with the trigger `outbound content scrub` and `Mode: trigger`; the common policy keeps the heading and the generic invariant; MANAGE-ISSUES, IMPLEMENT-PLAN, and CREATE-HANDOFF load the plug-in; the fixture moved its anchors; the policy count and floor are 20; and the loading contract records the explicit-procedure-load clarification. The next unit is the knowledge extraction child.

---
2026-11-16
Knowledge child complete on `feature/plugin-extraction`. The protocols and file standards are in `ai-policy-knowledge.md` with the trigger `knowledge file standards` and `Mode: trigger`; the common policy keeps the settings full load, the boot index invariant, and the contract pointer; LOAD-CONTEXT, WRITE-CHECKPOINT, and REPAIR-KNOWLEDGE-FILES load the plug-in; the validator anchors and the fixture moved; the policy count and floor are 21. The next unit is the issue-management child.

---
2026-11-16
Issue-management child complete on `feature/plugin-extraction`. The storage, fields, content, plan, and work-item invariants are in `ai-policy-issue-management.md` with the triggers `issue standards` and `ticket standards` and `Mode: trigger`; the common policy keeps a short issue invariant; MANAGE-ISSUES and IMPLEMENT-PLAN load the plug-in; the load-context template creation loads it only when the template is missing; the new fixture pins the unit; the policy count and floor are 22. The next unit is the design-docs child.

---
2026-11-16
Design-docs child complete on `feature/plugin-extraction`. The standards merged into `ai-policy-design-docs.md` with `Mode: procedure` and `Load in: update-design-docs`; the policy owns the chain, depth, IDs, ledger status values, supplementary documents, update discipline, and the plan-location rule; the common policy keeps a design invariant; the Pre-Work Gate points at the contract; MANAGE-ISSUES and IMPLEMENT-PLAN load the policy; the new fixture pins the merge; the policy count stays 22. The next unit is the coding-baseline child.

---
2026-11-16
Coding-baseline unit deferred for a thorough investigation. The unit says merge the 46 universal engineering and testing standards into the opt-in coding-baseline policy, but that policy's Scope says the common policy owns the engineering principles it applies, and the 46 lines are always-on. A straight merge would make always-on rules opt-in or force the whole coding baseline to load at boot. The investigation ticket `coding-baseline-activation-investigation.md` records the options and questions. The program proceeds with the thinking-modes child. The release gate still requires this unit to be resolved.

---
2026-11-16
Thinking-modes child complete on `feature/plugin-extraction`. Grilling and brainstorming are in `ai-policy-thinking-modes.md` with the triggers `grill me` and `brainstorm` and `Mode: trigger`; the common policy keeps the thinking-modes invariant; the Pre-Work Gate points at the contract; MANAGE-ISSUES and IMPLEMENT-PLAN load the policy; the new fixture pins the unit; the policy count and floor are 23. The common phase is complete. The next unit is the Linux legacy child.

---
2026-11-16
Linux legacy child complete on `feature/plugin-extraction`. The policy is rewritten to the authoring standard with all 30 rules preserved; it declares `Mode: expertise`; `tests/test-linux-policy.sh` pins the loading and the key anchors; the index reports `mode=expertise`. The next unit is the accounting legacy child.

---
2026-11-16
Accounting legacy child complete on `feature/plugin-extraction`. The policy is rewritten to the authoring standard with all 21 rules preserved; it declares `Mode: expertise`; the prompt is a non-normative example; `tests/test-accounting-policy.sh` pins the loading, the anchors, the example, and the index mode. The next unit is the career legacy child.

---
2026-11-16
Career legacy child complete on `feature/plugin-extraction`. The policy is rewritten to the authoring standard with all 28 rules preserved; it declares `Mode: expertise`; the sample customization and the prompts are non-normative examples; `tests/test-career-policy.sh` pins the loading, the hybrid role, the anchors, and the index mode. The next unit is the Windows legacy child.

---
2026-11-16
Windows legacy child complete on `feature/plugin-extraction`. The policy is rewritten to the authoring standard with all 71 rules preserved; it declares `Mode: expertise`; `tests/test-windows-policy.sh` pins the loading, the framework, PowerShell, identity, hardening, and testing anchors, and the index mode. The next unit is the academic legacy child, the last legacy unit.

---
2026-11-16
Academic legacy child complete on `feature/plugin-extraction`. The policy is rewritten to the authoring standard with all 209 rules preserved; it declares `Mode: expertise`; the nine stages are flattened, the disclosure example is non-normative, and the changelog appendix is removed; `tests/test-academic-policy.sh` pins the section map, the stages, the three checkpoints, and the index mode. All five legacy children are complete. The remaining program gate is the coding-baseline investigation and the user's live test.

---
2026-11-16
Coding-baseline unit resolved: the universal engineering and testing standards stay in the common policy, and the coding-baseline extraction is removed from the program scope. The investigation is closed. The reasons: most of the 45 lines are delivery and operational rules used by non-code work; the TDD rule is referenced by the api-backend, web-frontend, and mobile-apps policies on paths where the coding baseline is inactive; the Git Configuration template is used by bootstrap; and making the baseline mandatory would add 10.2 KB to every session and end the opt-in model. The ADR records the decision. All program units are now complete or resolved; the remaining gate is the final review and the user's live test.

---
2026-11-17
Known debt: common policy prose shape. Accepted for this program release; the fix is a separate unit.

The program touched `ai-policy-common.md` heavily. The structural validator passes, but the prose shape in `ai-policy-meta.md` (`### Policy Structure`, `### Rule Structure`, `### Normative Language`) was never reviewed. Boundary reviews 05 and 06 scoped themselves to the boundary, and review 06 records "Section extraction: out of scope." The parent ticket already says the remaining gap is prose density, which peer review enforces.

Read-only audit findings:

- [PASSED] Guard, READ-ONLY markers, title, purpose sentence, `## Scope`, `## References`, and READ-ONLY END.
- [FAILED] 90 numbered or bullet rules carry more than one sentence or more than one action outside the canonical header literal: lines 24, 25, 26, 28, 30, 62, 64, 81, 82, 83, 84, 85, 86, 102, 103, 105, 106, 110, 117, 141, 173, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 268, 273, 302, 303, 304, 310, 311, 312, 313, 314, 315, 316, 322, 323, 334, 336, 337, 342, 343, 344, 345, 346, 347, 394, 395, 396, 397, 398, 405, 406, 410, 411, 412, 413, 414, 420, 421, 422, 423, 424, 425, 426, 427, 428, 432, 433, 434, 435, 436, 437, 447, 448, 449, 450, 451, 452, 455.
- [FAILED] 16 rule bullets carry rationale: lines 117, 342, 343, 344, 345, 346, 347, 420, 421, 422, 423, 424, 425, 426, 427, 428.
- [FAILED] Banned normative words: `Prefer` at 110 and 115, `should` at 117, `appropriate` at 278, `and similar` at 411, `prefer` at 452. Line 402 `try` is a non-normative word-list example.
- [FAILED] Eight sections use prose rule content instead of flat rules: Investigation Contract at 32-40; AI-Driven Secure Development Practices at 88-98; Author Identity and Attribution at 123-135; Compliance Intelligence at 137-145; Operational Standards at 264-325; Git Configuration prose at 372-376; Humanized Output at 390-441; Markdown Output at 443-458.
- [EXEMPT] The canonical state-file header literal at 200-260 is a designated literal artifact.
- The multi-sentence heuristic counts punctuation, not meaning. The follow-up unit re-audits each line.

Decision: accept the debt for this program release. The follow-up ticket `common-policy-prose-shape-rewrite.md` owns the fix. The release note states the gap and the follow-up.

---
2026-11-18
Closed: the live test passed on a customer project, the program released as v6.6.0, and the 12 child tickets close with it. The common-policy prose debt stays with `common-policy-prose-shape-rewrite.md`.

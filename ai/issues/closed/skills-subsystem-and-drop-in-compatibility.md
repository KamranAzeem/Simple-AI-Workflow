Reported: 2026-11-03
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Add an ai/skills/ subsystem for drop-in agent skills, separate from policies

Description:

## Problem

The protocol has policies: broad guardrails and domain expertise that load at boot through Active Expertise or apply to a session. It has no concept of a skill: a small, task-specific instruction package that loads on demand, often with helper scripts. Other harnesses ship skills as `SKILL.md` packages, sometimes with a directory of helpers. Users want to bring those in, or write their own.

A blanket rename of policies to skills (`policies-to-skills-rename.md`) conflates two different things. Policies are broad and persistent. Skills are narrow and on demand. The protocol should support both rather than choose one.

## Shape options

1. **Flat native file**: `ai/skills/<name>.md`.
   - Simple, matches the protocol's plain-file style.
   - No place for helper scripts.
2. **Public package shape**: `ai/skills/<name>/SKILL.md` plus helpers.
   - Drop-in compatible with the skills published for other harnesses.
   - One directory per skill, which the user finds heavy for simple skills.
3. **Hybrid**: accept both.
   - A single `.md` is a native skill. A directory with `SKILL.md` is a package.
   - The index carries both, and the name comes from the frontmatter or the file stem.
   - Rejected for now by user preference.

User preference (2026-11-03): **package-only**, for standardization. Every skill is a directory `ai/skills/<name>/` with a `SKILL.md`, even when the body is one paragraph. The directory leaves room for helpers later without a shape change. The cost is one directory per trivial skill; that is accepted.

## Proposed behavior

- **Global AI Skills Directory**: `(Global AI Workflow Directory)/ai/skills/`.
- **Project AI Skills Directory**: `ai/skills/`.
- Every skill is a package: `ai/skills/<name>/SKILL.md`, optionally with helper files and scripts.
- At boot, index the package directory name, the frontmatter name and description, and the path only. Never read a skill body at boot.
- A project skill overrides a global skill with the same name, and the AI reports the override.
- Activation is explicit (`"use skill <name>"`) or by a match against the indexed description. The body loads for that task only, not for the session.
- A package may contain helper scripts. The AI never runs a skill script without explicit approval, and paths stay inside the skill directory.
- Skills are separate from policies and knowledge. Policies stay the always-on and domain layer. Active Expertise stays.
- The public frontmatter is authoritative for a skill (`name`, `description`). The policy authoring standard does not apply to skills.

## Security model

A skill is untrusted content. A malicious skill can try to override the protocol, exfiltrate data, or run code. The defense has to be layered, because the same AI that reads the skill is the one that can be fooled by it. The scan applies equally to skills we bundle, skills dropped in, and skills the user writes in `ai/skills/`.

### Threats

- Instruction override: text in `SKILL.md` tells the AI to ignore `AGENTS.md`, the user, or earlier instructions and treat the skill as authoritative.
- Tool poisoning: a skill description or body directs the AI to call a tool in a harmful way.
- Malicious helper scripts: install, network, file, or credential access.
- Path traversal and symlink escape.
- Hidden content: HTML comments, zero-width or bidirectional Unicode, base64 blobs, homoglyphs.
- Supply-chain update: a previously safe skill changes after the scan.

### Required controls

- Treat every skill as data, never as a protocol file. A skill cannot override `AGENTS.md`, a policy, the user, or the customization file. It adds task instructions inside that hierarchy only.
- Quarantine on ingest. A new, dropped-in, copied, or changed skill is untrusted until scanned.
- Scan before first use and on every change: the file tree, `SKILL.md`, every text file, and every script.
- Combine deterministic checks with an AI review. Deterministic checks catch known patterns; the AI review reads intent. The AI review alone is not sufficient, because a skill can target the reviewer.
- Scripts: static review, explicit approval before any run, path containment, no network by default, least privilege, and a recorded hash.
- Content hygiene: reject hidden Unicode, unexpected binaries, embedded credentials, and outbound network instructions unless the user explicitly accepts them.
- Record a trust decision with the skill hash. A hash change forces a re-scan.
- Store the scan report. A failed scan blocks activation and states why.

## Open questions

- Package-only is the user preference; confirm at planning and decide whether `SKILL.md` frontmatter is mandatory. A uniform index argues yes.
- How is the security scan implemented: a deterministic script in `support-files/`, an AI review procedure, or both? Who runs it, and where is the report stored?
- What does the deterministic scan cover: instruction-override phrases, hidden Unicode, network calls, shell execution, credential access, path traversal, binary blobs?
- How is the trust decision stored: a manifest with the skill hash, a report in `ai/artifacts/`, or both? What forces a re-scan?
- Does a failed scan always block activation, or can the user override with an explicit acceptance that is recorded?
- How are legitimate network or script needs declared and approved?
- Where does the boot index live: a new step, or folded into STEP-KNOWLEDGE-INDEXING?
- Precedence: project over global by name. What happens when a skill and a policy share a name?
- Nested discovery: one level under `ai/skills/`, or recursive? One level is simpler and index-friendly.
- Do skills join the checkpoint, knowledge repair, or markdown lint? Lint the `.md`; keep them out of knowledge repair.
- Distribution and update: pull the workflow clone for global skills. Does the sync script need a skill step, or is a future manifest enough?
- Security: per-skill script approval, path containment, secret scanning.
- Validation: a skill validator for frontmatter, name match, path shape, and no path escape.
- Relationship with `policies-to-skills-rename.md`: retire it, keep it, or fold its naming change into this? The recommendation is to pause the rename; policies and skills are distinct layers.
- Relationship with `policy-plugin-v0-trigger-dispatch.md` and `self-contained-policy-triggers-and-heading-jit-index.md`: can the skill index reuse the heading index? Sequence after the plugin v0, or independent?
- Scope: new subsystem, likely XL, with directories, boot index, activation, validation, docs, and tests.

## Draft acceptance criteria

- Both directories are documented as configuration anchors.
- Every skill is a package directory with `SKILL.md`; packages are discovered, indexed, and loadable.
- The boot index lists directory names, frontmatter names and descriptions, and paths only, and reads no body.
- A project skill overrides a global skill by name and the override is reported.
- Every new or changed skill is scanned before activation; a failed scan blocks activation.
- The scan covers `SKILL.md`, every text file, and every script; the trust decision records the skill hash.
- A skill cannot override `AGENTS.md`, a policy, the user, or the customization file.
- A skill script never runs without explicit approval, no network by default, and paths stay inside the package.
- Policies, Active Expertise, knowledge, and the existing validators keep working.
- The reference test and validator cover the new directories, the index, and the scan gate.
- Docs and slides explain skills, the two directories, the package shape, and the security model.

## Not in scope

- Implementation now.
- Moving existing policies into skills.
- Retiring `policies-to-skills-rename.md` before this issue is decided.
- A skill marketplace or installer.
- Bundling third-party skills in this repo.

## Notes

- Origin: user brainstorm on 2026-11-03.
- User preference: package-only. The security scan is mandatory for bundled, dropped-in, and user-authored skills.
- The core threat is instruction override, where a skill tries to become the authoritative protocol. The defense is a fixed instruction hierarchy plus a scan and a trust record, not AI trust.
- Related tickets: `policies-to-skills-rename.md`, `policy-plugin-v0-trigger-dispatch.md`, `self-contained-policy-triggers-and-heading-jit-index.md`.
- Runtime namespace (2026-11-08): a shipped repo validator cannot enforce trigger uniqueness for user-authored or third-party skills. The runtime index must detect collisions at ingest and activation, report the candidates, and dispatch nothing. Decide this when the ticket is planned.
- No plan yet.

---

## Implementation Plan

Attached 2026-11-09. The plan is reproduced below.

# Plan: Skills subsystem with drop-in packages and on-demand activation

**Ticket**: `ai/issues/open/skills-subsystem-and-drop-in-compatibility.md` (local)
**Date**: 2026-11-09
**Size**: XL
**Merge mode**: `direct` (no `## Merge Policy` in `ai-customization.md`; `auto` behaves as `direct`)
**Base ref**: `master`
**Branch**: `feature/skills-subsystem`

## Evidence

- The local ticket, 117 lines, reports a Feature with an AI estimate of P2/XL and no plan yet. It records the policies-versus-skills distinction, the package-only user preference of 2026-11-03, the proposed behavior, the security model, 14 open questions, 11 draft acceptance criteria, and the scope exclusions. The notes add the 2026-11-08 requirement that a shipped validator cannot enforce trigger uniqueness for user or third-party skills; the runtime index must report collisions.
- User decisions, 2026-11-09: pause `policies-to-skills-rename.md` and close it when skills v1 ships; package-only with required `name` and `description`; drop the security scan, trust record, and failed-scan gate because the protocol cannot enforce them for user skills and verified skills are the user's responsibility; keep only the instruction-hierarchy boundary and the helper-script approval and path containment from the ticket's proposed behavior; add the two-directory model; keep the boot index, activation, and collision rules; keep the checkpoint, repair, lint, and sync rules; ship docs examples only and add the Matt Pocock skills later; release v6.3.0.
- `AGENTS.md`: 149 lines, 16,031 bytes. The thin limit is 160 lines, 2,400 words, and 24,900 bytes at `support-files/validate-protocol.sh:72`. The **TIER CONFIGURATION** has no skills directory. The **Shared Protocol Steps** hold `STEP-PROTOCOL-INDEX` at line 107. The **Protocol Dispatch** holds the policy and procedure rules, including `"use policy <name>"` at line 132.
- `ai/procedures/load-context.md`: 83 lines. The structural audit at lines 38 to 47 creates the mandatory project directories and has no `ai/skills/`. The boot roots are at line 49. `STEP-KNOWLEDGE-INDEXING` is at lines 58 to 62. The proof has 11 items at lines 72 to 83.
- `ai/procedures/post-compaction-recovery.md`: 25 lines. `STEP-INDEX-KNOWLEDGE` is at line 19; the reload report is at line 25.
- `ai/procedures/write-checkpoint.md`: 64 lines. The housekeeping scan is at lines 47 to 55. The condition-gated re-affirmation indexes the knowledge at line 61.
- `ai/procedures/repair-knowledge-files.md`: 25 lines. The boundary at line 9 scopes the repair to knowledge files.
- `ai/policies/ai-policy-common.md`: 803 lines, 71,534 bytes. It has no skills section. The policy authoring standard lives in `ai-policy-meta.md:64-73` and applies to `AGENTS.md`, policy files, and procedure modules only.
- `support-files/test-protocol-references.sh`: 134 lines. It defines the procedure, step, tier, and item names from `AGENTS.md` and `ai/procedures/*.md` at lines 40 to 43 and reports 13 procedures, 98 steps, 4 tiers, and 11 items at line 59.
- `support-files/validate-protocol.sh`: 412 lines, eight steps. The configuration keys are at lines 80 to 103; the project directories are at lines 269 to 274; the thin-`AGENTS.md` check is at lines 72 to 75; the procedure anchors are at lines 22 to 62; the policy baseline and knowledge anchors are at lines 324 to 381.
- `support-files/test-load-context-boot.sh`: 96 lines. The discovery fixture is at lines 40 to 56; it checks the excluded canaries, the 1,000-file counts, the 16 KB bound, the single checkpoint read, and the index oracle.
- `docs/ai-customization-guide.md`: 168 lines. It documents Active Expertise, triggers, traits, compliance, design docs, and the merge policy; it has no skills section.
- Directories: `ai/skills/` does not exist in this repository. The repository's `ai/` top level holds artifacts, code-review-reports, daily-checkpoints, issues, notes, pending, plans, policies, procedures, secrets, shared, and state. `~/.ai/` holds backups, global-knowledge, knowledge-repair-backups, and settings; it has no skills directory. The **Global AI Skills Directory** is the workflow clone's `ai/skills/`; the **Project AI Skills Directory** is the project root's `ai/skills/`.
- Checks at plan time: validator 8/8; authoring PASSED; `--index` 0 errors; reference 13/98/4/11; trigger 50/50; boot fixture PASS; knowledge fixture PASS; markdownlint 0; shellcheck clean. v6.2.0 is released; the next minor is v6.3.0.

## Problem

The protocol has broad, persistent policies, procedure modules, and knowledge files, but no on-demand skill layer. Users want to drop in small `SKILL.md` packages, sometimes with helpers, from other harnesses or write their own. The protocol needs two indexed directories, a package shape, a compact boot index, explicit and description-based activation, a project-over-global override, and collision reporting, without mixing skills into policies, procedures, or knowledge. The security scan is out of scope by user decision; the instruction hierarchy and the user's responsibility remain.

## Scope

In scope: the `ai/skills/` subsystem for the workflow clone and the project root; the package and frontmatter shape; the shared skills index step and the boot proof item; activation; the project override; collision reporting; the helper-script approval and path containment rule; the checkpoint, repair, lint, and sync rules; the docs, examples, validator, fixtures, ADR, and v6.3.0.

Out of scope: the security scan, trust manifest, hash tracking, and failed-scan gate; moving policies into skills; the `policies-to-skills-rename.md` implementation; a marketplace or installer; bundled third-party or Matt Pocock skills; a runtime script; any change to the policy or procedure trigger model.

## Acceptance Criteria

- AC-01: `AGENTS.md` names the **Global AI Skills Directory** and the **Project AI Skills Directory**, defines the shared `STEP-SKILLS-INDEX`, and adds the `"use skill <name>"` dispatch, while staying within the thin targets.
- AC-02: Discovery is one level under each skills directory: a package directory with `SKILL.md`, required `name` and `description` frontmatter, a one-line description of at most 200 characters, a lowercase-kebab directory name that matches `name`, hidden entries and symlinks skipped, and no body read at boot.
- AC-03: `STEP-SKILLS-INDEX` records the name, description, path, and scope; reports a project-over-global override; reports a skill name that collides with a policy or procedure name; skips an absent or empty directory; stays within 16 KB; and writes no file.
- AC-04: The load proof gains `ITEM SKILLS-INDEX`; post-compaction recovery and the checkpoint re-affirmation rebuild the same index and report the count.
- AC-05: Activation is `"use skill <name>"` or a single best description match; an ambiguous match asks; the body loads for that task only and the AI announces the skill; an unknown name reports `unknown skill`; a skill cannot override `AGENTS.md`, a policy, the user, or the customization file. A skill package may include helper scripts; the AI never runs a skill helper without explicit approval, and a helper path stays inside the package.
- AC-06: The common policy gains a `## Skills` section with the two directories, the package and frontmatter pointer, the activation, the hierarchy, the no-scan boundary, and the user's responsibility for skill sources. The meta policy's authoring standard exempts skill packages.
- AC-07: The checkpoint records the skills count and the package names in the context, compares that list at the next checkpoint, and reports a new package name; the repair never edits a skill; the lint covers `SKILL.md`; the sync script does not copy skills; hash-based change detection is out of v1.
- AC-08: The reference test reports the new counts, 13 procedures, 99 steps, 4 tiers, and 12 items; the validator checks the skills configuration keys, the `ai/skills/` project directory, the `STEP-SKILLS-INDEX`, the `ITEM SKILLS-INDEX`, and the common policy section; the boot fixture covers a project skill and the 16 KB bound; a new skills fixture covers the package, frontmatter, override, collision, and description rules; the `AGENTS.md` thin target holds.
- AC-09: The README, workflow guide, slides, customization guide, and `docs/examples/skills/` explain the two directories, the package shape, activation, the override, the hierarchy, and the no-scan boundary; the docs state that the user is responsible for skill sources.
- AC-10: The ADR store gains one entry that records the separate layer, the package and index, the activation, the no-scan decision, the rename pause, and v6.3.0, and is consistent with INV-015 and the change rule.
- AC-11: All checks pass: validator 8/8, authoring, `--index` 0 errors, reference 13/99/4/12, trigger 50/50, boot fixture, knowledge fixture, skills fixture, markdownlint 0, and shellcheck clean.
- AC-12: v6.3.0 is tagged and published; the skills ticket is closed in the branch with the plan attached; `policies-to-skills-rename.md` is closed as superseded; the plan file is deleted; the checkpoint is written; the post-release checkpoint updates the state.

## High-Level Design

- HLD-001: Skills are a separate layer. Policies stay the always-on and persistent domain layer; procedures stay the triggered workflows; knowledge stays the durable findings; skills are narrow, on-demand task packages.
- HLD-002: Two roots. The workflow clone's `ai/skills/` is the global root for the protocol's own skills; the project root's `ai/skills/` is the user's root; a project skill overrides a global skill by name and the override is reported.
- HLD-003: Package-only. A skill is `ai/skills/<name>/SKILL.md` with required `name` and `description`; public extras are preserved and ignored by the index; the body is free-form.
- HLD-004: One shared skills index. `STEP-SKILLS-INDEX` is defined once in `AGENTS.md`, referenced by load context, recovery, and checkpoint re-affirmation, and builds an ephemeral name, description, path, and scope index with no body and no file.
- HLD-005: Activation is explicit or description-based. The explicit command wins; a single best description match may load for the task and is announced; an ambiguous match asks; the body does not persist for the session; a helper script never runs without explicit approval and stays inside the package.
- HLD-006: Separate namespaces. Skills are outside the policy and procedure trigger namespace; a cross-type name collision is reported; `"use skill <name>"` and `"use policy <name>"` stay distinct.
- HLD-007: The instruction hierarchy is the only security control in v1. A skill is untrusted task content, cannot override the protocol, a policy, the user, or the customization file, and the user is responsible for the source.
- HLD-008: The integration surface is the load context (discovery root, index, proof item), recovery (index), checkpoint (re-affirmation, count, housekeeping), and the existing structural audit (project `ai/skills/`).
- HLD-009: The test surface is the reference test (one new step and one new item), the validator (configuration keys, project directory, anchors), the boot fixture (a project skill and the 16 KB bound), and a new skills fixture for the deterministic package rules.
- HLD-010: v1 ships docs examples only. No skills are bundled; the Matt Pocock skills come later; the release is v6.3.0.

## Low-Level Design

- LLD-001 `AGENTS.md`: add `**Global AI Skills Directory**: (Global AI Workflow Directory)/ai/skills/` and `**Project AI Skills Directory**: ai/skills/` to **TIER CONFIGURATION**. Add `STEP-SKILLS-INDEX` under **Shared Protocol Steps** with the two roots, the one-level discovery, the `SKILL.md` frontmatter, the project override, the collision report, the 16 KB bound, and the no-body rule. Add the `"use skill <name>"`, description-match, hierarchy, helper-approval, and `unknown skill` rules to **Protocol Dispatch**. Budget the additions at two directory lines, a five-bullet step, and a two-line dispatch, at most nine lines; keep the file at or under 160 lines and 24,900 bytes, and trim a redundant line if the total exceeds the target.
- LLD-002 `ai/procedures/load-context.md`: add `ai/skills/` to the structural-audit mkdir list and the project-directory list; add the two skills roots to the boot roots; reference `STEP-SKILLS-INDEX` after `STEP-KNOWLEDGE-INDEXING` without redefining it; add `ITEM SKILLS-INDEX` to `STEP-PROOF-OF-LOAD`. Keep the 16 KB bound and the compact proof.
- LLD-003 `ai/procedures/post-compaction-recovery.md`: reference `STEP-SKILLS-INDEX` in `STEP-INDEX-KNOWLEDGE` without redefining it; add the skills count to the reload report.
- LLD-004 `ai/procedures/write-checkpoint.md`: reference `STEP-SKILLS-INDEX` in the re-affirmation without redefining it; record the skills count and the package names in the context; compare that list at the next checkpoint and report a new package name; add the skills count and any new name to the housekeeping report; keep the checkpoint report-only for skills; state that hash-based change detection is out of v1.
- LLD-005 `ai/policies/ai-policy-common.md`: add `## Skills` after the knowledge sections with the two directories, the package and frontmatter pointer, the one-line 200-character description, the activation, the hierarchy, the helper-approval and path-containment rule, the separate-layer rule, the no-scan boundary, the user responsibility, and the collision rule.
- LLD-006 `ai/policies/ai-policy-meta.md`: in `### Applies To`, add that the authoring standard does not apply to a skill package; the public frontmatter is authoritative. Reference the skill shape in the enforcement or standard references.
- LLD-007 `ai/procedures/repair-knowledge-files.md`: add one boundary sentence that the repair never edits a skill package under `ai/skills/`.
- LLD-008 Tests:
  - `test-protocol-references.sh`: add the `STEP-SKILLS-INDEX` and `ITEM SKILLS-INDEX` definitions; update the expected counts to 13 procedures, 99 steps, 4 tiers, and 12 items.
  - `validate-protocol.sh`: add the two skills configuration keys, `skills` to the project directories, and the `STEP-SKILLS-INDEX`, `ITEM SKILLS-INDEX`, and `## Skills` anchors; keep eight steps and the thin check.
  - `test-load-context-boot.sh`: create a project skill package; assert the index line and the 16 KB bound; keep the excluded canaries.
  - New `support-files/test-skills-index.sh`: build a temporary global and project root; assert the package discovery, the required frontmatter, the directory-name match, the one-level, hidden and symlink skip, the project override, the collision report, and the description fields; assert that the index output has the name, description, and path and not a body canary; assert the one-line 200-character description rule.
- LLD-009 Docs: add a README skills section, a workflow guide Section 24, a slides skills slide, a customization guide skills section, and `docs/examples/skills/example-skill/SKILL.md`; update the common instructions table, the what's included list, the docs list, the README banner, the "Keeping this workflow up to date" v6.3.0 note, the release practices v6.3.0 entry, the project knowledge verification toolchain (13/99/4/12 and the new skills fixture), and the v6.3.0 announcement. State the no-scan boundary, the helper-approval rule, the 200-character description rule, the user responsibility, and the git-ignored project `ai/skills/` note in the README and the guide.
- LLD-010 ADR: append one entry to `design-docs/protocol-decisions.md` recording the skills layer, the two directories, the package and index, the activation, the hierarchy, the helper rule, the no-scan decision, the rename pause, and v6.3.0; state that INV-015 stays and the trigger model is unchanged and reserved for policies and procedures; narrow the 2026-11-08 note: a skill uses the package frontmatter and the description index, not `## Triggers`.
- LLD-011 Release: v6.3.0, the announced release, the tag, and the GitHub Release.
- LLD-012 Tickets: close the skills ticket in the branch with the plan attached; close `policies-to-skills-rename.md` as superseded at the v1 ship; delete the plan file after the ticket carries it.

## Decisions

- ADR-001: Skills are a separate layer with two roots. Rationale: policies are broad and persistent; skills are narrow and on demand; the clone and the project need separate homes.
- ADR-002: Package-only with required `name` and `description`. The description is one line of at most 200 characters. Rationale: one shape, drop-in compatibility, and a stable index key that cannot grow the boot index without bound.
- ADR-003: One shared skills index with names, descriptions, paths, and scopes, no body, and no file. Rationale: the boot stays lean and the lookup key is the name and description.
- ADR-004: Explicit or single-best-match activation, task-scoped, announced. Rationale: the user stays in control and the body does not persist.
- ADR-005: Skills stay outside the policy and procedure trigger namespace; cross-type collisions are reported. Rationale: the trigger model stays frozen and the layers stay distinct.
- ADR-006: No security scan in v1; the hierarchy and the user's responsibility remain. The helper-script approval and path containment stay. Rationale: the user chose to drop a mechanism the protocol cannot enforce for user skills, and the helper rule is behavior, not the scan.
- ADR-007: The checkpoint, repair, lint, and sync rules. Rationale: skills are not knowledge, are not copied, and are reported, not edited, at checkpoint.
- ADR-008: v1 ships docs examples only; the Matt Pocock skills come later; v6.3.0. Rationale: the subsystem lands first; third-party content follows.
- ADR-009: The reference counts become 99 steps and 12 items; the `AGENTS.md` thin target holds. Rationale: the new shared step and item are defined once and the boot stays small.
- ADR-010: The rename ticket is paused now and closed when v1 ships. Rationale: policies and skills are distinct; the rename conflates them.
- ADR-011: A skill helper never runs without explicit approval and stays inside the package. Rationale: helpers are code, and the user's approval is the control in v1.

## Risks and Gaps

- RSK-001: `AGENTS.md` has 11 lines and about 8.9 KB of headroom; the two directories, a five-bullet step, and a two-line dispatch are budgeted at nine lines, taking the file to 158. Trim a redundant line if the total exceeds 160.
- RSK-002: A description match can load an unwanted skill. Mitigate with a single best match, an announcement, and an ask on ambiguity.
- RSK-003: Without a scan, a malicious skill can try to instruct the AI. The hierarchy and the user responsibility are the only defense; the docs state both plainly.
- RSK-004: The skills index can grow past 16 KB with many descriptions. Mitigate with the description length, the count line, and the on-demand query.
- RSK-005: Other harnesses may use different frontmatter keys. Mitigate by requiring `name` and `description`, preserving extras, and reporting an invalid package instead of guessing.
- RSK-006: A skill name can collide with a policy, procedure, or another skill. Mitigate with the override and the collision report; the policy or procedure keeps its phrase.
- RSK-007: The new step and item change the reference counts and the validator anchors. Mitigate by updating the test and the docs in the same change.
- RSK-008: The skills count and new-package report are the only checkpoint signals in v1; there is no hash or change tracking. The docs state that the checkpoint reports, and the repair does not audit skills.
- RSK-009: A skill helper is code without a scan; the approval and path rule are the only controls. The docs state it and the user is responsible for the helper.
- RSK-010: A long description can grow the index; the 200-character cap and the report keep the 16 KB bound.

## Tests and Verification

- Existing: `validate-protocol.sh` 8/8; authoring on the changed files; `--index` 0 errors; `test-protocol-references.sh` at 13/99/4/12; `test-trigger-rules.sh` 50/50; `test-load-context-boot.sh`; `test-knowledge-repair-fixture.sh`; markdownlint; `shellcheck -S warning`.
- New: `support-files/test-skills-index.sh` with the package, frontmatter, one-level, override, collision, and description cases.
- Manual: the boot report shows `ITEM SKILLS-INDEX`; a project skill and a global skill with the same name show the override; `"use skill <name>"` loads the body for the task and announces it; an unknown name reports `unknown skill`; a cross-type collision is reported; a skill helper does not run without explicit approval; an over-length description is reported; a new package appears at the next checkpoint.
- No security scan test; the docs caution is reviewed.
- Release: the full set before the tag; the announcement and README banner; the GitHub Release.

## Close Sequence

- Repo: this repository. Base ref: `master`. Branch: `feature/skills-subsystem`. Merge mode: `direct` (squash). Ticket: `ai/issues/open/skills-subsystem-and-drop-in-compatibility.md` (local; move to `in-progress/` at implement; close in the branch commit). Release: v6.3.0.
- Implement on the branch; run the implementation peer review; fix every Critical and Major finding; write the checkpoint on the branch.
- Run the terminal gate: at least one commit ahead of `master` and a clean tree.
- Squash merge to `master`, delete the branch, push the trunk.
- Tag v6.3.0 and publish the GitHub Release with the announcement.
- Close the skills ticket with the plan attached; close `policies-to-skills-rename.md` as superseded; delete the plan file.
- Run the post-release checkpoint on `master` and push it.
- Evidence: this Evidence section, the fixture, validator, and reference output, and the implementation review report.
- Definition of done: every AC met, all checks pass, both tickets closed, the plan attached, the checkpoint and post-release checkpoint written, the branch merged and deleted, the trunk pushed, and v6.3.0 tagged and published.

## Peer Review Log

- Round 1: CHANGES REQUESTED (1 Major, 7 Minor, 1 Suggestion), `ai/code-review-reports/2026-11-09_21-25_review-24.md`. Fixed the helper rule, the nine-line `AGENTS.md` budget, the single `STEP-SKILLS-INDEX` definition, the fixture body-canary assertion, the checkpoint name comparison, the verification toolchain, the description cap, the ADR reconciliation, and the git-ignored note.
- Round 2: APPROVED, `ai/code-review-reports/2026-11-09_21-30_review-25.md`.

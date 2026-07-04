<!--
Created-by: GitHub Copilot
Updated-by: GitHub Copilot
Last modified: 2026-05-21T13:00:00+02:00
Intent: Capture protocol design decisions made during the 2026-05-21 session (updated CP-2026-05-21-03).
-->

# Protocol Design Decisions

## 2026-05-21 — Session CP-2026-05-21-01

### Project-knowledge loading: dedicated step vs. appended sentence
- **Decision**: Promote project-knowledge loading to its own numbered step (Step 5) in Procedure A, rather than appending it as a sentence to Step 4.
- **Rationale**: Weak models complete Step 4's explicit list and stop. A trailing sentence is silently skipped. A dedicated numbered step with "do NOT merge with Step 4" is unmissable.
- **Outcome**: Verified working in production test after change.

### Git-ignore handling: point-of-use reminders
- **Decision**: Add inline git-ignore override reminders at Step 3 (Discovery) and Step 5 (Load Project Knowledge), in addition to the Tier 2 general rule.
- **Rationale**: Weak models do not re-apply general rules stated in a preamble when they reach a specific step. The reminder must be at the point of execution.
- **Outcome**: Tier 2 rule also strengthened — changed from "these two items" (too narrow) to "entire ai/ directory including ALL subdirectories and every file".

### Procedure C: project-knowledge update as mandatory checkpoint step
- **Decision**: Insert new Step 2 in Procedure C requiring explicit review and update of project-knowledge before every backup. Made mandatory even when nothing changed (AI must confirm).
- **Rationale**: Investigation findings, decisions, and confirmed values were being permanently lost at checkpoint. Only state files were synced; project-knowledge was untouched.
- **Outcome**: Policy layer (ai-policy-common.md) also updated with matching mandate to reinforce for weak models.

### backup-ai-dir.sh removal
- **Decision**: Removed `support-files/backup-ai-dir.sh`.
- **Rationale**: Backup is now a native one-liner embedded directly in AGENTS.md Procedure C. The standalone script was redundant and not referenced in any documentation.

### validate-protocol.sh: $HOME portability fix
- **Decision**: Replace hardcoded `/home/kamran/.ai` with `$HOME/.ai`.
- **Rationale**: Script failed on Windows/Git Bash with 3 warnings and a hard exit on step 9. `$HOME` resolves correctly on Linux, macOS, and Git Bash on Windows.

### README: remove protocol-section "TIER" terminology
- **Decision**: Replace all references to "TIER 1", "TIER 1: CONFIGURATION", and "tiers" (when referring to protocol sections) with plain language ("CONFIGURATION section", "sections or procedures").
- **Rationale**: The TIER labels are internal protocol structure. Exposing them in user-facing documentation creates unnecessary jargon and couples docs to internal naming.
- **Scope**: 6 occurrences in README.md; pricing-tier references left unchanged.

---

## 2026-05-21 — Session CP-2026-05-21-02

### Peer Review Mode: Procedure D placement must be in TIER 3
- **Decision**: PROCEDURE D must live in TIER 3 (Triggered Procedures), not TIER 5 (Appendix).
- **Rationale**: An AI scanning TIER 3 for triggered procedures stops before reaching TIER 5. Procedure D placed in TIER 5 is silently invisible to weak models — the feature never activates.
- **Lesson**: Every triggered procedure must be co-located with peers A/B/C. Never append procedures to appendix sections as an afterthought.
- **How found**: Discovered via the first self-review using the new Peer Review Mode (review-01 Critical finding).

### sync-agents-md.ps1: Set-Content with UTF8 encoding adds BOM on PowerShell 5.1
- **Decision**: Replace `Set-Content -Encoding UTF8` with `[System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))`.
- **Rationale**: PowerShell 5.1 (default on Windows, invoked by `powershell.exe`) writes UTF-8 with BOM when using `-Encoding UTF8`. AGENTS.md is BOM-less; synced copies would get a stray BOM prepended, breaking `grep` anchors and `head -n 1` metadata checks.
- **Note**: PowerShell 7+ (`pwsh`) does not have this issue, but README instructs using `powershell` for compatibility.

### Peer review policy: ai-policy-code-review.md
- **Decision**: Peer review role, dimensions, severity, and report format extracted into a dedicated policy file (`ai/policies/ai-policy-code-review.md`), read by the AI at the start of Procedure D.
- **Rationale**: Embedding all review rules inline in AGENTS.md would make AGENTS.md too long. A separate policy keeps the bootstrap file concise and allows the review policy to evolve independently.
- **Report location**: `ai/code-review-reports/YYYY-MM-DD_HH-MM_review-NN.md` — sequential numbering per session, never overwritten.

### README title
- **Decision**: Changed H1 from "Global Policy Management System for Simple AI Workflow" to "Simple AI Workflow".
- **Rationale**: The project IS Simple AI Workflow. Policies are an internal mechanism, not what users see first. The old title was written by an AI and never reviewed.

### settings/ directory: project root is the wrong location
- **Decision**: `settings/` must never exist at the project root. It belongs at `$HOME/.ai/settings/`.
- **Rationale**: The protocol defines `settings/` as a subdirectory of the Global User AI Directory (`[HOME]/.ai/`), not the project. A project-root `settings/` is a misplacement error. While git-ignored (and thus not committed), its presence is misleading and contradicts the protocol.
- **Action**: Deleted `settings/about-human.md` and `settings/` from project root; confirmed `~/.ai/settings/` already has the correct copy.

---

## 2026-05-21 — Session CP-2026-05-21-03

### Protocol terminology must not appear in user-facing documentation
- **Decision**: Remove all references to internal protocol labels ("Procedure A", "Procedure B", "Procedure D", "TIER 1", etc.) from README and all files under `docs/`.
- **Rationale**: These are internal implementation labels. Exposing them creates jargon that confuses end users and couples documentation to internal naming. User-facing text should describe what the action does, not what internal label it has.
- **Scope**: 8 occurrences fixed across README.md, workflow-guide.md, simple-ai-workflow-slides.md, ai-customization-guide.md.
- **Rule going forward**: Docs describe behaviour in plain language. AGENTS.md is the only file permitted to use procedure/tier labels.

### code-review policy is on-demand, not a customization module
- **Decision**: `code-review` should not be listed as an `Expertise` value in `ai-customization.md`. A note was added to ai-customization-guide.md clarifying this.
- **Rationale**: `ai-policy-code-review.md` is loaded automatically when the user says "peer review". It is a triggered mode, not a persistent expertise module. Listing it in customization would load reviewer behaviour permanently, which is not the intent.

### Peer review: full-file-set vs diff-based review tools
- **Finding**: GitHub Copilot PR reviewer (and other diff-based tools) only see the changed diff on each push. This means: (1) issues outside the diff are invisible, (2) each fix triggers a new review cycle requiring another push, (3) the user must manually copy review comments from GitHub into their local AI chat to understand and address them, (4) 15+ rounds is common before a clean result.
- **Contrast**: This workflow's peer review scans the full file set on every pass, runs entirely in the local chat window, requires no push, and converges in 2–4 rounds.
- **Documentation**: Added "Why multiple rounds are normal" and "Compared to GitHub Copilot PR reviewer" sections to workflow-guide.md and slides.

---

## 2026-06-18 — Session CP-2026-06-18-01

### AI-generated metadata comment headers removed from all files
- **Decision**: Strip the leading HTML comment block (`Created-by` / `Updated-by` / `Last modified` / `Intent`) from all markdown files in the repository.
- **Rationale**: These headers were AI-generated noise — they duplicated information already tracked by git log and added no value. No policy mandated them. Template content inside fenced code blocks (handoff template in workflow-guide, report template in ai-policy-code-review) was explicitly preserved.
- **Scope**: 28 files stripped. A secondary fix removed orphaned leading `---` separators from 25 of those files (the `---` had been between the comment header and the content).
- **Rule going forward**: Do not add Created-by / Updated-by / Last modified / Intent comment headers to any file. Git history is the authoritative record.

### validate-protocol.sh updated to v4.0
- **Decision**: Expand the validation script to check all current AGENTS.md features.
- **Changes**: Step 1 expanded from 3 anchor checks to 8 (added Procedure E, F, Atomic Write Protocol, Sliding Horizon Shield, Token Rationing). Step 2 expanded from 3 config keys to 10 (all TIER 1 keys now checked).
- **Outcome**: All 8 checks pass against current AGENTS.md.

### Policy file structural inconsistencies fixed
- **Findings resolved**:
  - `ai-policy-meta.md` lines 73–87 were corrupted duplicate content — removed.
  - `ai-policy-code-review.md` was missing the immutability header (`🚫 DO NOT MODIFY`) and `READ-ONLY START/END` markers — added.
  - 5 policy files (`cloud`, `data`, `dba`, `linux-system-admin`, `observability`) were missing the `<!-- AI-ASSISTANT: READ-ONLY END -->` closing tag — added.
  - `ai-policy-dba.md` and `ai-policy-observability.md` used a bare filename in the Scope `Global Authority` line instead of the normalized cross-reference wording — fixed to match all other policies.
- **Rule going forward**: All policy files must open with the `🚫 DO NOT MODIFY` guard, contain `READ-ONLY START` after the guard, and close with `READ-ONLY END` at the end of the file. The Scope section Global Authority line must use the normalized wording (not a bare filename).

### "load context" command — full form vs shorthand
- **Decision**: Document the distinction between the full form (`"load context using AGENTS.md protocol"`) and the shorthand (`"load context"`) in both README and slides.
- **Rule**: Always use the full form at the start of a new session or after any restart. The shorthand is acceptable mid-session only when the AI already has AGENTS.md in view. A fresh or weaker model cannot reliably connect "load context" to Procedure A without the explicit anchor.
- **Scope**: Added "Keeping Context Healthy" section to README (after "How to start working" section) and a matching slide appended to the presentation.

---

## 2026-06-18 — Session CP-2026-06-18-03

### JIT indexing extended to Global Knowledge
- **Decision**: Extend Token Rationing (JIT indexing) to cover `~/.ai/global-knowledge/` files, not just `ai/shared/project-knowledge/` files. AGENTS.md Step 5 was renamed from "Project Knowledge Indexing" to "Knowledge Indexing" and expanded to cover both directories.
- **Rationale**: The pre-existing Step 5 only indexed Project Knowledge. Global Knowledge was bundled into Step 4 for full loading alongside Settings. Loading all global knowledge files at boot is just as wasteful as loading all project knowledge files. The same JIT lookup-by-task-context principle applies to both.
- **Files changed**: AGENTS.md (Steps 4, 5, Proof-of-Load items b/e, Procedure E Step 3/5, Session Resume bullet), ai-policy-common.md (Global Knowledge Protocol + Project Knowledge Protocol), docs/workflow-guide.md, docs/simple-ai-workflow-slides.md, README.md.

### Settings vs Knowledge: explicit split in loading semantics
- **Decision**: Formalize the distinction between Global AI Settings Directory (`~/.ai/settings/`) and Global AI Knowledge Directory (`~/.ai/global-knowledge/`): Settings are always fully loaded at boot; Knowledge is always JIT-indexed at boot.
- **Rationale**: Settings contain personal preferences and cross-project configuration that the AI must know before the first task (e.g., shell preferences, tool availability, communication style). This is authoritative and small. Knowledge files contain accumulated lessons and reference material — relevant on demand, not necessarily at startup. Mixing them under one "load everything" rule was both wasteful and semantically wrong.
- **Rule going forward**: Any new file added to `~/.ai/settings/` will be fully loaded at every session start. Any new file added to `~/.ai/global-knowledge/` will be indexed only and loaded on demand.

### Broken markdown links in policy files (pre-existing, repaired on this branch)
- **Finding**: `ai/policies/ai-policy-common.md` had 4 broken relative links (coordination.md, next-steps.md, progress.md, context.md, daily-checkpoints/) using repo-root-relative paths. Because the file lives in `ai/policies/`, these paths resolved two directories short of their targets.
- **Fix**: Changed paths to use `../` relative navigation (e.g., `../next-steps.md`). Also fixed a broken path in `AGENTS.md` Procedure A Step 1 and two broken paths in `docs/workflow-guide.md`.
- **Rule going forward**: Markdown links in policy files under `ai/policies/` must use `../` relative paths, not `ai/`-prefixed paths. Links in `docs/` files referencing other `docs/` files must not be prefixed with `docs/`.

### validate-protocol.sh v4.1 — Global Knowledge JIT checks added
- **Decision**: Bump validate-protocol.sh from v4.0 to v4.1 with two new anchor checks.
- **New checks**: (1) "Knowledge Indexing" step must exist in AGENTS.md Procedure A; (2) "Global AI Knowledge Directory" must appear in that step.
- **Rationale**: These checks guard against regression where the JIT indexing of Global Knowledge is silently removed or the step is renamed back to "Project Knowledge Indexing".

---

## 2026-06-19 — Session CP-2026-06-18-03 (continued)

### No markdown hyperlinks in policy files — two-context link rule
- **Decision**: Policy files (`ai/policies/*.md`) and `AGENTS.md` MUST NOT contain markdown hyperlinks `[text](path)`. All file references must use either **Bold Anchor Name** (for files defined in TIER 1 Configuration) or `` `backtick/path` `` (for well-known state files).
- **Rationale**: Policy files live in the **Global AI Policies Directory** (`Simple-AI-Workflow/ai/policies/`) but are read by an AI operating in the **user's project root** (e.g., `~/Projects/Innofactor/elmera/`). A relative path like `../shared/coordination.md` resolves correctly inside the protocol repo but resolves to a completely wrong location in the user's project — or nowhere at all. The TIER 1 Configuration anchors (`**Project Coordination File**`, `**Project AI Knowledge Directory**`, etc.) are the correct indirection mechanism: they are resolved by the AI against the TIER 1 definitions, not against the filesystem.
- **Two contexts rule**: When editing this repository as the protocol developer, your working directory IS the protocol repo. But all policy files must be authored from the user's perspective — their working directory is their own project root. Any path in a policy file is evaluated in the user's project root, not in this repo.
- **What to use**:
  - TIER 1 anchor → `**Anchor Name**` (e.g., `**Project Coordination File**`, `**Global AI Policies Directory**`)
  - State files (not in TIER 1) → `` `ai/next-steps.md` ``, `` `ai/progress.md` `` etc. (project-root-relative, no link wrapper)
  - `AGENTS.md` → `` `AGENTS.md` `` or "the `AGENTS.md` file in the project root"
- **Rule going forward**: Any automated link checker (including validate-protocol.sh) MUST NOT run filesystem link resolution against `ai/policies/` or `AGENTS.md`. Those files' references are intentionally evaluated from the user's project root and will always appear broken when checked from inside the protocol repo.
- **How it was broken**: An automated Python link checker ran relative resolution from the file's disk location (`ai/policies/`), found `ai/shared/coordination.md` appearing broken (because `ai/policies/../shared/coordination.md` ≠ correct from protocol root), and "fixed" it to `../shared/coordination.md` — which is wrong in the user's context.

### Protocol Developer Mode — unconditionally-read rule in TIER 2
- **Decision**: Add "Protocol Developer Mode" as a bullet in TIER 2 MANDATORY ACTIONS (always-read block, no trigger required).
- **Rationale**: `protocol-decisions.md` was JIT-indexed at boot but not guaranteed to load before protocol work. An AI starting fresh with only a task like "change this rule" would reach the task without the authoritative constraint file loaded. TIER 2 is the only block that fires unconditionally — before any procedure or policy — making it the correct location.
- **Rule**: When PWD matches the **Global AI Workflow Directory**, the AI is in protocol developer mode. It must fully load `protocol-decisions.md` before touching any protocol file. The rule also embeds the two-context path authoring requirement inline.
- **Mirror in ai-policy-meta.md**: The same requirement is now also listed as Pre-action Check #1 in `ai-policy-meta.md` for redundancy.

### ai-policy-meta.md hardening
- **Decision**: Add `# 🚫 DO NOT MODIFY THIS FILE` header and `<!-- AI-ASSISTANT: READ-ONLY START/END -->` markers to `ai-policy-meta.md`.
- **Rationale**: Every other policy file has these guards. The meta policy was the only one missing them — an AI could treat it as freely editable without the guard.
- **Also fixed**: Removed phantom `AGENTS.local.md` reference (file does not exist anywhere in the repo or docs).

### Redundant inline paths alongside TIER 1 anchors — removed
- **Decision**: Remove all hardcoded inline paths that appeared alongside TIER 1 bold anchor references in `ai-policy-common.md`.
- **Removed**: `` (`~/.ai/settings/`) `` next to `**Global AI Settings Directory**`; `` (`~/.ai/global-knowledge/`) `` next to `**Global AI Knowledge Directory**`; `` (`ai/shared/project-knowledge/`) `` next to `**Project AI Knowledge Directory**`; `` (`ai/ai-customization.md`) `` next to `**Project Customization File**`.
- **Rationale**: The anchor is the single source of truth for the path. Repeating the path inline creates two sources that can drift. The anchor resolves against TIER 1 Configuration; the inline path cannot be kept in sync automatically.

### sync-agents-md.ps1 regex back-reference bug — fixed
- **Finding**: The Workflow Dir replacement used group `$3` (old path value) as the closing backtick, when `$4` was the closing backtick. User AI Dir replacement had the same class of error. Result: the old path was appended to the new one and the closing backtick was dropped.
- **Fix**: Changed Workflow Dir replacement to use `$4`; verified User AI Dir replacement uses `$3` (correct for its 3-group pattern). The companion `.sh` script was not affected — it does not capture the path as a named group.
- **Rule going forward**: When adding or modifying regex replacements in the PS1 sync script, always verify group numbering against the actual pattern before committing.

---

## 2026-06-22 — Session CP-2026-06-22-01

### Verbose file-naming rule — binding guardrail with explicit source-code carve-out
- **Decision**: Add a "Verbose File Naming (AI-Generated Files)" bullet to the Universal Operational Guardrails in `ai-policy-common.md`, making descriptive kebab-case naming a binding rule for AI-generated files (not just user-facing documentation in README).
- **Scope of the rule**: Applies to AI-generated **knowledge, documentation, and workflow artifacts** — files under `ai/` (project-knowledge, handoffs, notes, artifacts, code-review-reports) and under `docs/`. The filename is the JIT-index lookup key, so it must be inferable from the name alone.
- **Critical carve-out — source code is exempt**: Application/source-code files (and their tests, configs, and framework-dictated files) MUST follow language/framework idioms (`Button.tsx`, `user.rb`, `models.py`, `index.js`, `[id].tsx`, `UserService.java`), never the verbose knowledge-file style. Rationale: the AI navigates code by structure, imports, and symbol search — not by inferring contents from filenames — and verbose names would break imports, autoloading, and routing. Protocol/tooling-fixed names (`AGENTS.md`, state files, dated reports, `README.md`) are also exempt.
- **Why a policy rule, not just docs**: The README already had a "Use Verbose File Names" section, but it was documentation addressed to the user and the AI never loads README at boot. A binding guardrail in the always-loaded common policy is what makes the AI self-enforce it.

### Codebase Examination — new on-demand expertise module (`codebase-examination`)
- **Decision**: Add a new opt-in policy `ai-policy-codebase-examination.md` (keyword `codebase-examination`) for examining/refactoring codebases larger than the context window. Modeled on the on-demand pattern (loaded only when listed in `## Active Expertise`), not added to common policy.
- **Why a separate on-demand policy**: Adding it to common policy would bloat the always-loaded file; the capability is only occasionally needed. A domain-neutral keyword covers application code, IaC, and DB schemas in one place.
- **Core strategy**: Disk-as-Memory + three-tier JIT loading (Level 0 repo map resident; Level 1 module signature maps on demand; Level 2 full files transient). Four-phase workflow Map → Plan → Perform → Reconcile. Reuses existing guardrails (branch-gating, TDD, peer review) rather than reinventing a safety net.
- **Explicitly lightweight**: Prohibits vector databases, embeddings, and external indexing tools (Chroma, FAISS, LlamaIndex, Repomix, Aider) — the assistant's native `grep_search`/`read_file`/`file_search` plus JIT indexing are sufficient. Honours the project's "stay lightweight" mandate.
- **Bytes vs tokens correction**: Documented that ~4 chars ≈ 1 token, so 128 K tokens ≈ ~512 KB text; a "150 KB skeleton" fits a 128 K window. For genuinely huge repos the skeleton itself is tiered so it never has to fit as one blob.
- **Validator**: `validate-protocol.sh` policy baseline list extended from 11 to 12 (added `codebase-examination`). The check only verifies listed policies exist, so adding a file does not otherwise affect it.

### Internal protocol labels confirmed out of user-facing docs (regression caught in review)
- **Finding**: The first draft of `docs/codebase-examination-guide.md` used "Procedure D" and the `Inquiry`/`Directive`/`Analyze-Plan-Stop` jargon — violating the CP-2026-05-21-03 decision (no internal labels in README or `docs/`).
- **Resolution**: Caught by peer review (review-01, CHANGES REQUESTED); rephrased to plain language; review-02 APPROVED.
- **Reinforced rule**: Policy files (`ai/policies/*.md`) MAY use procedure/tier labels (they are internal); files under `docs/` and README MUST use plain language. This split is now exercised by the codebase-examination policy (uses "Procedure D") vs its guide (plain language).

---

## 2026-06-22 — Session CP-2026-06-22-02

### Codebase Examination — changed from "opt-in expertise" to "triggered procedure"

- **Decision**: Changed `ai-policy-codebase-examination.md` activation from "add `codebase-examination` to `## Active Expertise`" to a procedure-triggered pattern matching how `ai-policy-code-review.md` works (zero boot-time visibility).
- **Rationale**: Listing it in Active Expertise causes Procedure A Step 6 to index it at boot time and Step 7 to list it in the Proof-of-Load report. The user wants no boot-time presence — same as code-review, which is only activated by a trigger phrase ("peer review" / "code review").
- **Changes applied**:
  1. `ai/policies/ai-policy-codebase-examination.md`: On-demand activation paragraph now references Procedure G — not Active Expertise.
  2. `AGENTS.md`: Procedure G added to TIER 3 (Triggered Procedures) — loads the policy when user says "examine this codebase" or "codebase examination".
  3. `protocol-decisions.md`: This entry.
  4. `README.md` line 342: Updated to reference "codebase examination" trigger phrase instead of Active Expertise.
- **What did NOT change**: `validate-protocol.sh` — policy file still exists, baseline stays at 12. Procedure G is not anchor-checked by the validator (same as Procedure D was before it was added; can be added later if desired).
- **Documents updated**: `docs/codebase-examination-guide.md` and `docs/ai-customization-guide.md` now reference the trigger phrase, not the Active Expertise list.
- **Branch**: Applied directly on master as a protocol-development change with human approval.

### ai/shared/ added to git version control
- **Decision**: Add `!ai/shared/` and `!ai/shared/**` exceptions to `.gitignore` so `ai/shared/project-knowledge/protocol-decisions.md` and `ai/shared/coordination.md` are tracked in git.
- **Rationale**: `protocol-decisions.md` is protocol design documentation with the same character as files in `docs/` — authoritative decisions and rules going forward. Losing it on a machine move is a real cost that the on-demand backup procedure does not reliably prevent. `coordination.md` is safe to track (resets to "no tasks claimed"). `ai/shared/handoffs/` (currently empty) will also be tracked automatically if files are added.
- **Why gitignore-example.txt is unchanged**: The template is for user projects, where `ai/` is intentionally fully private-local by default. Users' `ai/shared/project-knowledge/` can contain sensitive material (API endpoints, DB schemas, internal architecture decisions). The template stays `ai/**` with no exceptions.
- **Pattern used**: Matches the existing `!ai/policies/` / `!ai/policies/**` exception pattern already in `.gitignore`.

---

## 2026-06-29 — Session CP-2026-06-29-01

### State File Proof-of-Read — fresh-read requirement added to Procedure A and Procedure C

- **Problem**: AI in production session reported progress.md last entry as 23 June when entries from 24th and 25th existed. When challenged, the AI admitted it "scanned too quickly and only saw the last few lines." Classic failure mode: AI summarises from conversation memory instead of reading the file fresh.
- **Decision**: Add three protocol guardrails to AGENTS.md:
  1. **Procedure A Step 4 sub-bullet** (`State File Proof-of-Read`): After loading the three state files, the AI must record the line count and the most recent checkpoint identifier (`CP-YYYY-MM-DD-NN`) from each file's content. The CP identifier must be consistent across all three state files and the latest checkpoint file. If any file cannot be read, stop and report before continuing.
  2. **Procedure A Step 7 bullet (f)**: The Proof-of-Load report must include, for each state file: line count and most recent CP identifier, read fresh from file content.
  3. **Procedure C Step 1 sub-bullet** (`Fresh-Read Before Write`): Before staging any checkpoint write, the AI must read the current on-disk content of all three state files fresh. Do not write from a cached or summarised version held in the active context window.
- **Why CP identifier, not a date field**: The state files contain no standalone date fields — the date is embedded in the checkpoint ID format (`CP-YYYY-MM-DD-NN`). Using the CP identifier as the date marker is unambiguous, extractable from content, and consistent across all three files and checkpoint files. An AI must read the file to know it.
- **Why line count**: A line count is an instant verifiable signal. If the AI reports 15 lines but `wc -l` shows 35, the partial-read bug is immediately visible. It is not a perfect proof, but it is fast to spot-check.
- **"Held in context" wording fix**: First draft of Fresh-Read Before Write said "held in context" — "context" clashes with `context.md` (the state file name). Fixed to "held in the active context window".
- **Peer review outcome**: round-01 CHANGES REQUESTED (2 Minor: date ambiguity, context wording); fixes applied; round-02 APPROVED.
- **Commit**: `888bdf6` on master, pushed to origin.

---

## 2026-06-30 — Session CP-2026-06-30-01 (branch `feature/boot-full-load-policies-and-global-knowledge`)

### Full-load active policies and Global Knowledge at boot — Token Rationing re-scoped to Project Knowledge only

- **Problem**: The prior model (extended on 2026-06-18-03) applied JIT index-only loading to *both* Global Knowledge and the active policy files. This meant the AI booted with only the *names* of the policies and lessons that govern its behaviour, and was expected to load them "on demand". In practice an AI cannot know which trigger maps to which policy without first reading the policy — so deferring policy loading silently produced behaviour driven by rules the AI had never read. The same applied to Global Knowledge ("lessons learned" the AI never actually saw).
- **Decision**: At boot (Procedure A) and on post-condensation recovery (Procedure E), the AI now loads in **full**: Settings, all Global Knowledge files, the common policy (`ai-policy-common.md`), and **every** policy referenced in the Project Customization File. **Token Rationing is retained but re-scoped to Project Knowledge only** — those files can be large (e.g. historical repo-scan snapshots) and are still shell-indexed at boot and loaded on demand.
- **Reverses**: The Global-Knowledge portion of the 2026-06-18-03 decision ("Step 5 now covers both Global and Project Knowledge with JIT index-only semantics") and the policy-indexing portion of Procedure A. Project Knowledge index-only behaviour from that session is **kept**.
- **Rationale**:
  - **Robustness over token thrift for operational files**: The cost of a few hundred lines of policy/lesson text at boot is far lower than the cost of the AI applying wrong or missing rules it never read. Token Rationing still earns its keep where files are genuinely large and not always needed — Project Knowledge.
  - **Global Knowledge is intentionally small**: A full load is cheap and removes the "guessing at a lesson it never read" failure mode.
  - **Deferred policy loading is self-defeating**: The AI cannot map a task to a policy by name alone; the policy text *is* the mapping.
- **Files changed on this branch**:
  - `AGENTS.md`: TIER 2 Session Resume bullet; Procedure A Step 5 renamed `Knowledge Indexing` → `Knowledge Loading` (Global Knowledge full text; Project Knowledge keeps Token Rationing); Step 6 renamed `Policy Indexing` → `Policy Loading` with a "deliberate exception to Token Rationing" design note; Step 7 bullet (b) wording (`fully loaded`); Procedure C new Step 4 `Context Re-affirmation After Checkpoint` made **condition-gated** (reload only when context was condensed); Procedure E Step 3 full-loads common policy + Global Knowledge + Settings + referenced policies and shell-indexes Project Knowledge, with `[Reloading key files into context...]` announcements; Procedure E Step 5 references "steps 1–4", `fully loaded` wording, direct-task one-liner suppression.
  - `ai/policies/ai-policy-common.md`: Global Knowledge Protocol `Index Only` → `Full Load`; two stale `Procedure C Step 2` → `Step 3` cross-reference fixes.
  - `support-files/validate-protocol.sh`: v4.2 → v4.3; anchor check `Knowledge Indexing` → `Knowledge Loading`; added `Policy Loading` anchor check; kept `Token Rationing` anchor check (still present, scoped to Project Knowledge).
  - Docs (`README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`): updated Token Rationing / JIT sections, Session Resume features, and Proof-of-Load wording to the new model.
- **Token Rationing anchor preserved**: The validator still greps for `Token Rationing` because the concept lives on for Project Knowledge — the term was deliberately *not* removed from AGENTS.md.
- **Source plan correction**: The originating plan (`ai/plans/agents-md-context-reload-improvements.md`) claimed ~27 project-knowledge files with large repo-scan snapshots; the actual count in this repo is 4 small files (the large-snapshot concern was imported from another workspace). The change set keeps Token Rationing for Project Knowledge on principle (files *can* be large elsewhere / in user projects), independent of this repo's current size.
- **Constraints honoured**: Protocol Developer Mode (protocol-decisions.md fully pre-loaded); no inline machine paths (TIER 1 anchors only); no markdown hyperlinks in policy files; immutable markers preserved; AGENTS.md authored from the end-user project-root perspective.
- **Branch**: `feature/boot-full-load-policies-and-global-knowledge` — not merged to master (user handles merge/push).

---

## 2026-06-30 — Session CP-2026-06-30-02 (same branch)

### State file single-writer ownership, memory→disk checkpoint direction, and reconcile semantics

- **Full discussion captured in**: `multi-agent-state-ownership-and-checkpoint-model.md` (Project Knowledge). This entry is the decision summary.
- **Problem**: A design discussion clarified four intertwined questions — context freshness/integrity, checkpoint direction, state-file ownership, and multi-agent state. The prior "Fresh-Read Before Write" wording (CP-2026-06-29-01) implied the AI should distrust its memory and re-read state files at checkpoint, which is backwards: in a normal session the AI's in-memory view is the freshest, and a naive re-read risks weak models overwriting fresh deltas with a stale disk copy.
- **Decisions**:
  1. **Checkpoint direction is memory → disk.** A checkpoint serialises fresh in-memory state INTO the three files; it is a write-down, not a discovery read.
  2. **The pre-write read is a reconcile, not a refresh.** It exists only to (a) preserve `progress.md`'s append-only history and (b) detect drift from another agent or condensation. Fresh in-memory deltas are authoritative for new/changed content; same-item conflicts → stop and flag.
  3. **State files are single-writer (orchestrator-owned).** Only the project-root orchestrator writes `context.md`/`progress.md`/`next-steps.md`.
  4. **Awareness vs. authorship.** Agents that need to know what others are doing READ the coordination board; they do not write the state files to gain awareness. Awareness = read the board; canonical narrative = orchestrator writes. This dissolves the "long-running team-mates must write state" objection.
  5. **Checkpoint is two-phase**: inbound reconcile (read board + handoffs) → outbound write (memory → state files).
  6. **Protocol vs. runtime boundary**: the protocol defines the *contract* (ownership, message formats, reconcile); the AI-team *runtime* (dispatcher/watcher/role lifecycle) is a separate project and must NOT be built into AGENTS.md. A role can be persistent in identity but ephemeral in execution (watch-spawned), which makes the single-writer rule uniform across execution models.
- **Implemented today (non-breaking, this branch)**:
  - `AGENTS.md`: TIER 2 new mandatory action **State File Single-Writer Ownership**; Procedure C Step 1 added **Write Direction (memory → disk)**, reframed **Fresh-Read Before Write** as a reconcile with precedence, added **Inbound Reconcile (multi-agent)**; Procedure E Step 3 added a coordination-board read on resume (board is not a state file; state files stay off-limits).
  - `ai/shared/coordination.md`: added **Ownership Model** section; fixed keystone **Clear** step (was "update `ai/progress.md`" → now "record completion on the board; do NOT write state files"); added cooperative-coordination caveat.
  - `ai/policies/ai-policy-common.md`: new **State File Ownership Protocol** subsection.
  - `support-files/validate-protocol.sh`: v4.3 → v4.4; new `Single-Writer` anchor check; fixed a stale "Knowledge Indexing step" error string → "Knowledge Loading step".
  - `README.md`: Multi-Agent Coordination feature augmented with single-writer state-ownership bullet.
- **Keystone correction**: The old `coordination.md` told every sub-agent to "update `ai/progress.md`" on clear — the exact multi-writer-on-state-files pattern. That line is now removed in favour of board-only reporting.
- **Explicitly deferred (would be breaking / out of scope)**:
  - **Procedure E precedence rework** — letting Procedure E read the *latest checkpoint's* state files (single-writer authoritative, fresher than a lossy summary) rather than trusting only the summary. Reverses a deliberate safety rule; design as one coherent change later.
  - **AI-team runtime** (dispatcher/watcher/role lifecycle) — separate project.
  - **Per-agent status files** robust-concurrency variant — adopt only when real parallelism is needed.
- **Non-breaking confirmation**: all existing validator anchors retained (`Fresh-Read Before Write`, `Atomic Write Protocol`, `Token Rationing`, `Knowledge Loading`, `Policy Loading`, etc.); the `Fresh-Read Before Write` phrase was deliberately preserved as the anchor while its body was reframed.
- **Branch**: `feature/boot-full-load-policies-and-global-knowledge` — still not merged to master (user handles merge/push).

---

## 2026-06-30 — Session CP-2026-06-30-03 (finalize / merge)

### Single-writer clarification (session vs role) + Scenario B revisit trigger + branch merged

- **Session-not-role clarification**: A user question exposed an ambiguity — the single-writer rule listed role names (developer, security, document-controller) that a human might *switch the same session into*, which could be misread as "a session in developer role may not write state files." Clarified in `AGENTS.md` TIER 2 and mirrored in `ai-policy-common.md`: **ownership is by session/process identity, not role label.** One owning session switching role-hats is still the orchestrator and writes the state files normally; the prohibition targets **separate** sub-agent sessions/processes.
- **Scenario A (sequential role-switch in one session)**: explicitly safe — one writer wearing different hats.
- **Scenario B (concurrent sessions writing the *same* state files)**: deliberately **not blessed** — the cooperative board is read-before-write, not a lock, so simultaneous writes can lose updates. Recorded as an explicit **revisit-when-parallel trigger** (adopt per-agent status files under `ai/shared/coordination/` when real parallelism is introduced) in design note §7 and `next-steps.md`. Concurrent writes to *distinct* role-scoped knowledge files remain fine.

---

## 2026-07-04 — Session CP-2026-07-04-01

### ai-customization.md moved to project root

- **Problem**: Bootstrap required editing two files (AGENTS.md for workflow directory, `ai/ai-customization.md` for personalization) — one buried inside `ai/`. The bootstrap procedure had unnecessary friction (create `ai/`, copy file into it, exit, reload).
- **Decision**: Move the customization file from `ai/ai-customization.md` to `ai-customization.md` at the project root (sibling of `AGENTS.md`). Move `**Global AI Workflow Directory**` from AGENTS.md TIER 1 into the customization file — AGENTS.md becomes entirely read-only.
- **Why root**: Single location, visible at project root, simpler bootstrap. The AI does not hunt for the file — it checks one fixed location. If the old `ai/ai-customization.md` exists, the AI instructs the user to add the workflow directory and move it.
- **No fallback scanning**: The AI does not scan directories. If the file is missing, it guides the user through first-time setup (show template, explain config, optionally suggest cloning the repo).
- **Chicken-and-egg**: Resolved by adding Procedure A Step 0 (Customization Discovery) — the AI reads the customization file first, extracts the workflow directory, then resolves all derived TIER 1 paths.
- **No impact on loading behavior**: All 10+ references to `**Project Customization File`** use the TIER 1 anchor — changing one line in TIER 1 propagates everywhere. Procedure A Steps 4/6/7b, Procedure E Step 2, etc. all auto-adapt.
- **Stale references fixed**: Procedure E Step 2 "only `ai/` file" wording updated. Procedure F backup commands now include `ai-customization.md`.
- **Files changed**: AGENTS.md (TIER 1, Procedures A/B/E/F), `ai-customization.md` (new at root), `docs/ai-customization.md` (template updated), `.gitignore`, README, docs/workflow-guide.md, docs/simple-ai-workflow-slides.md, docs/compliance-guide.md, docs/personas/README.md.
- **Bootstrap simplified**: Copy `docs/ai-customization.md` → `ai-customization.md`, edit one file, run "load context". No more `mkdir -p ai/`, no exit-and-reload.
- **Merge**: the whole branch (boot full-load + single-writer ownership + checkpoint reconcile + doc alignment + wording) squash-merged into master as one commit; feature branch deleted; **not pushed** to origin per user instruction. Final peer review review-04 APPROVED. Validator v4.4.

---

## 2026-07-04 — Session CP-2026-07-04-02 (protocol audit and humanization)

### Humanized Output section added to common policy
- **Problem**: AI-generated text has detectable patterns — em dashes, overused vocabulary (delve, pivotal, underscore, tapestry), boilerplate, faux analysis, negative parallelisms. These make output sound robotic.
- **Decision**: Added `## Humanized Output` section to `ai-policy-common.md` with rules for sentence structure (max 15 words), vocabulary (banned AI-tell words), tone (write like a senior engineer), patterns to kill (em dashes, rule of three, hedging stacks, fake analysis), and writing style by medium.
- **Later consolidated**: Merged with the adjacent `## Communication Standards` section — kept 3 preamble bullets, made Humanized Output a `###` subsection.
- **Always active**: Lives in common policy, loaded at every boot unconditionally.

### New domain policies: accounting and academic-researcher
- Created `ai-policy-accounting.md` covering GAAP/IFRS, bookkeeping, tax compliance, audit support.
- Created `ai-policy-academic-researcher.md` covering literature review, research design, statistical analysis, publishing ethics.
- Both follow existing policy structure and are listed in the validator POLICIES array.

### Policy expertise name resolution made flexible
- **Problem**: Procedure A Step 6 said "scan the customization file to identify which policy files apply" but didn't specify how to map expertise names to filenames. AIs with `linux-system-admin` listed would not find `ai-policy-linux-system-admin.md`.
- **Fix**: Step 6 now has an explicit two-try resolution: try `ai-policy-<name>.md` first, then `<name>.md` as fallback. Uses recursive `find` on **Global AI Policies Directory**.
- **Why two-try**: Handles both the standard naming convention and future files without the `ai-policy-` prefix (e.g., `wrc.md`).

### Compliance directory references removed from procedures
- **Problem**: The recursive find on **Project AI Policies Directory** already reaches `ai/policies/compliance/`, but separate mentions of **Project Compliance Policies Directory** in Steps 7b, C Step 4, and E Step 3 caused the AI to explicitly scan for and ask permission to read compliance files.
- **Fix**: Removed all separate mentions. **Project Compliance Policies Directory** remains defined in TIER 1 (for directory existence checks) but is not independently scanned.

### gitignore check for ai-customization.md added to Structural Audit
- Procedure A Step 2 now checks `.gitignore` for `ai-customization.md` after the directory audit and informs the user if absent.

### Sync scripts rewritten for auto-migration
- `sync-agents-md.sh` and `sync-agents-md.ps1` now handle four cases at each target:
  - Old `ai/ai-customization.md` found → migrate to root, inject config section
  - Both old and root exist → warn, rename old to `.bak`
  - Root file exists → verify/update workflow directory path
  - Neither exists → create from template with defaults
- Workflow directory automatically derived from source AGENTS.md location.

### Cross-reference audit complete
- All 11 procedure/step references in policy files verified against current AGENTS.md — every tag connects to the correct target. No broken references.

### Boilerplate removal
- Duplicate `Bootstrap Entry` and `Path Resolution` lines removed from all 11 domain policies. A global note in `ai-policy-common.md` applies to all policies as replacement.

## Key configuration values confirmed this session

- **Validator version**: v4.5
- **Git state**: master, 11 commits ahead of origin, NOT pushed
- **Policy count**: 14 modular policies (common, meta, cloud, api-backend, web-frontend, data, linux-system-admin, mobile-apps, dba, observability, code-review, codebase-examination, accounting, academic-researcher)
- **Sync scripts tested**: migration from old `ai/` layout → root verified end-to-end

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
- **Rationale**: Policy files live in the **Global AI Policies Directory** (`Simple-AI-Workflow/ai/policies/`) but are read by an AI operating in the **user's project root** (e.g., `~/Projects/MurtazaSb/`). A relative path like `../shared/coordination.md` resolves correctly inside the protocol repo but resolves to a completely wrong location in the user's project — or nowhere at all. The TIER 1 Configuration anchors (`**Project Coordination File**`, `**Project AI Knowledge Directory**`, etc.) are the correct indirection mechanism: they are resolved by the AI against the TIER 1 definitions, not against the filesystem.
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

---

## 2026-07-04 — Session CP-2026-07-04-04 (final checkpoint — release and cleanup)

### v2.0.0 GitHub release
- Tagged and published v2.0.0 on GitHub with full changelog covering 40 commits since v1.0.0.
- Release title: "Customization at root, auto-migration, Humanized Output".
- All 8 peer reviews (review-04 through review-10) completed.

### Bootstrap audit/creation separation
- Procedure A Step 2: changed from "Only propose `mkdir -p` for missing items" to "Only report missing items — do not create them."
- Procedure B: split into separate audit (Step 1) and creation (Step 2) steps. Fixes AI getting stuck on silent `mkdir -p` output during load context.

### Archive and backup exclusions added to TIER 2
- Archive File Exclusion: all find/ls commands skip `*.tar*` and `*.zip` files.
- Backup Directory Exclusion: `~/.ai/backups/` is never scanned, listed, or read.

### Compliance directory references removed
- All separate mentions of **Project Compliance Policies Directory** removed from Procedure A Step 7b, Procedure C Step 4, and Procedure E Step 3. The recursive find on the parent directory already covers it.

### README diagram updated
- Replaced the old wide two-column ASCII diagram with a compact side-by-side tree view using standard ASCII characters. Displays Simple-AI-Workflow vs Your Project with `-->` relationship arrow.

## 2026-07-25 — Session CP-2026-07-25-01

### Career coaching policy: single-file consolidation
- **Decision**: The four proposed expertise names (`executive-recruitment`, `resume-optimization`, `interview-coaching`, `career-strategy`) were consolidated into a **single policy file** (`ai-policy-career-coaching.md`) with one canonical expertise keyword: `career-coaching`.
- **Rationale**: All four sub-domains share the same persona traits, engagement style, and standards (ATS compliance, conciseness). A single policy avoids duplicating shared content, reduces maintenance surface, and matches the modular pattern used by other domain policies. Users add one expertise name instead of four.
- **Outcome**: Policy created at `ai/policies/ai-policy-career-coaching.md` (93 lines). README, customization guide, slides, and validate-protocol.sh updated.

### Pre-existing missing directories created
- **Decision**: Created `ai/plans/` and `ai/policies/compliance/` — both are listed as mandatory project directories in the TIER 1 config but were missing. Created during checkpoint validation to pass `validate-protocol.sh` checks.
- **Note**: `ai/plans/` had been flagged in next-steps.md as "Decide fate of untracked ai/plans/agents-md-context-reload-improvements.md" — the referenced file was never written to disk; creating the directory resolves the pending item.

## 2026-07-25 — Session CP-2026-07-25-02

### Academic-researcher policy: internationalized rewrite
- **Decision**: Replaced the 48-line generic `ai-policy-academic-researcher.md` with a comprehensive 342-line policy sourced from a friend's draft, then stripped of all India/UGC-specific content (UGC 2018 regulations, UGC-CARE, DPDP Act, similarity thresholds) and any single-domain hardcoding (removed Container/Kubernetes Security as primary focus).
- **Rationale**: The original policy was too thin to guide serious research. The friend's draft had excellent depth across source quality, research workflow, statistics, ethics, and publishing but was scoped to one country and one domain. Making it international and domain-neutral makes it useful for any researcher globally.
- **Outcome**: Policy at `ai/policies/ai-policy-academic-researcher.md` (342 lines, 22 sections + appendix). Retained frameworks: Singapore Statement, ALLEA, ORI, UK Concordat, Australian Code, COPE, ICMJE, Helsinki, Belmont, Menlo, FAIR, GDPR. Validator v4.5 all 8/8 pass. Peer review review-02 APPROVED.

## 2026-07-25 — Session CP-2026-07-25-03 (High-effort review pass)

### Post-rewrite fixes from high-effort review
- **Issue 1**: Stale cross-reference on line 16 referencing "§21" (AI Operating Boundaries) — the section was renumbered to §20 during the rewrite. Fixed.
- **Issue 2**: Hardcoded "Claude, Anthropic" in the example AI-disclosure statement (line 155). Changed to `[Tool/Vendor]` placeholder so the template works regardless of which AI assistant the user runs.
- **Validation**: All 8/8 checks pass after fixes.

## Key configuration values (end of session)

- **Validator version**: v4.5
- **Commits since v1.0.0**: 40
- **Git state**: master, 22 commits ahead of origin, NOT pushed
- **Tags**: v1.0.0 (old), v2.0.0 (current)
- **Release**: v2.0.0 published on GitHub
- **Policy count**: 15 modular policies

## 2026-07-28 — Ad hoc protocol-developer session (code review scope discipline)

### PR review added as a trigger phrase for Procedure D
- **Decision**: Changed the Procedure D header in `AGENTS.md` from `When User says "peer review" or "code review"` to `When User says "peer review", "code review", or "PR review"`.
- **Rationale**: A real review session on a customer repo showed the AI treating "review this PR" as a plain diff read instead of invoking the full peer-reviewer role and report format. Users naturally say "PR review" as often as "code review". The validator only checks the string prefix `### PROCEDURE D: When User says "peer review"`, so this change does not break `validate-protocol.sh`.

### Scope Discipline section added to ai-policy-code-review.md
- **Decision**: Added a `## Scope Discipline: Do Not Narrow to the Diff` section, placed after the `Role: Strict Peer Reviewer` bullet list and before `Review Dimensions`.
- **Finding that drove this**: During a live PR review (Azure Firewall Policy rule collection, `VDC_p-we1net-network`), the AI reviewed only the diff and missed two things a colleague (Damian) caught: (1) a pre-existing dead rule in the same rule collection the diff touched (an ACR rule using the Redis port, 6380, instead of 443, clearly a copy-paste), and (2) ~13,000 daily firewall denies against the touched subnet visible only in live Log Analytics telemetry, not in the repo.
- **Root cause identified**: The AI scoped the review to "the PR's diff" instead of "the diff plus the surrounding file/collection plus live state and telemetry for what the change touches". The first miss (dead rule) was pure scope narrowing (the AI had already read the block, but did not analyze it because it was outside the diff). The second miss (firewall denies) was a capability gap. No tool call to Log Analytics was attempted.
- **Rule added**: Reviews must (1) review the diff, (2) examine the full file or module the diff touches for pre-existing issues, (3) check live or runtime state relevant to what the code represents when access and tooling allow (examples given for IaC, database, API, and application-config domains), (4) check observability signals for the touched component when available, and (5) state plainly what was not checked rather than omitting it silently. Deliberately written domain-neutral (not just network-specific) per user instruction not to make the rule too narrow.
- **Companion change**: Added a `## Not Checked` section to the report format template (between `Suggestions` and `Verdict`), so item 5 above is enforced by the report structure itself, not left as an unverified aspiration.
- **Style note**: New prose in both files avoids em dashes per the Humanized Output rule in `ai-policy-common.md`, even though older content in this repo predates that rule and still uses them.
- **Files changed**: `AGENTS.md` (Procedure D header), `ai/policies/ai-policy-code-review.md` (Scope Discipline section, Activated-by line, Not Checked report section), this file.
- **Not done in this session**: No full checkpoint was run in this repo (this was a short protocol-developer edit made from a different project's session, not a `load context` session against Simple-AI-Workflow). No commit was made; changes are on disk only, pending the user's own review and commit.

## 2026-07-28 — Self-review of the above changes, and fix cycle (review-01 / review-02)

### Peer review triggered on the AI's own just-edited protocol files
- **Decision**: Ran Procedure D against `AGENTS.md` and `ai-policy-code-review.md` themselves, applying the newly-written Scope Discipline rule recursively to the files that introduced it.
- **Finding (review-01, CHANGES REQUESTED)**: 2 Major issues, both the same root cause — "PR review" was added as a Procedure D trigger phrase, but no step anywhere defined the actual mechanics (fetch latest, resolve source/target branch, diff source against target) needed to perform one. The Iteration Protocol had the matching gap for a second review pass on a PR (no re-fetch step). 3 Minor issues: the "Role exits ... when a commit is made" condition doesn't clearly cover PR-only reviews where the AI never commits; the "Scoped" bullet didn't cross-reference the new Scope Discipline section; pre-existing em-dash counts (35 in `AGENTS.md`, 14 in the policy file) predate the Humanized Output rule and were left alone. 1 Suggestion: optional PR identifier in the report filename.
- **Fix applied**: `AGENTS.md` Procedure D gained a new Step 2 ("Resolve the PR (PR review only)": fetch remote refs, resolve source/target branches, diff source against target before scanning), with steps renumbered 1–6. `ai-policy-code-review.md` Iteration Protocol now opens with a re-fetch step for the PR case. The Role exits bullet now covers "or, for a PR review, when the PR is merged or closed." The Scoped bullet now points at Scope Discipline. The Report Format now documents the optional `review-01_PR53929.md` filename convention.
- **Outcome (review-02, APPROVED)**: All 5 findings from review-01 resolved and verified; `validate-protocol.sh` re-run in full, 8/8 passed. No new issues found.
- **Files changed**: `AGENTS.md` (Procedure D), `ai/policies/ai-policy-code-review.md` (Role exits, Scoped, Iteration Protocol, Report Format), `ai/code-review-reports/2026-07-28_review-01.md` and `2026-07-28_review-02.md` (new), this file.
- **Not done in this session**: No commit made yet; all changes remain on disk pending the user's review and commit decision.

## 2026-07-28 — Evidence-Based Reasoning (No-Assumption Rule) added to common policy

### New universal guardrail against invented facts
- **Decision**: Added a `### Evidence-Based Reasoning (No-Assumption Rule)` subsection to `ai-policy-common.md`, under `## Operational Standards`, directly after `### CLI Command Accuracy`.
- **Problem reported by the user**: Repeated real-world cases of the AI assuming facts not in evidence — inventing infrastructure components that do not exist, attributing statements or actions to people who were never mentioned, and basing recommendations on those assumptions.
- **Why common policy, not code-review policy**: The user has seen this failure across many task types (migration plans, PR reviews, general analysis), not just code review. A narrow fix in `ai-policy-code-review.md` would not cover the general case. Common policy is always loaded, so the rule applies everywhere without needing a trigger phrase.
- **Why placed next to CLI Command Accuracy**: That existing rule already implements a narrow version of the same idea (never guess subscription IDs, resource names — verify via live query or confirmed context). The new rule explicitly generalizes it: "the same failure mode ... generalized to every kind of claim, not just command flags and resource identifiers."
- **Rule content**: (1) never invent people, teams, infrastructure, config values, file contents, or past decisions not backed by context/project knowledge/a live query, and never attribute statements or actions to people never mentioned; (2) verify before asserting, by checking active context, **Project AI Knowledge Directory**, and live codebase/environment; (3) if no evidence exists anywhere, say so plainly and ask the user, rather than filling the gap with a guess; (4) be ready to cite the source of any fact-based recommendation.
- **Not done in this session**: No commit made yet; change is on disk only, pending the user's review and commit decision. `validate-protocol.sh` not extended with a new anchor check for this rule (not requested; existing 8 checks still pass).

## 2026-07-28 — Peer review of ai-policy-common.md, fix cycle (review-03 / review-04)

### READ-ONLY markers were missing from the flagship policy file
- **Finding (review-03, CHANGES REQUESTED)**: `ai-policy-common.md` was the only one of 15 policy files missing the `<!-- AI-ASSISTANT: READ-ONLY START -->` / `<!-- AI-ASSISTANT: READ-ONLY END -->` markers required by the 2026-06-18 (CP-2026-06-18-01) structural convention. `validate-protocol.sh` never caught this because it only checks `AGENTS.md`'s own banner text, not the per-policy-file markers.
- **Fix applied**: Added both markers to `ai-policy-common.md` (START after the `DO NOT MODIFY` guard, END at end of file). Extended `validate-protocol.sh` Step 6 (Policy Baseline) to grep every file in the `POLICIES` array for both markers, failing the check if either is missing. Bumped validator to v4.6.
- **Minor findings also resolved**:
  - The "Verbose File Naming" bullet (a ~200-word run-on paragraph) was split into shorter sentences, consistent with the file's own Humanized Output rule.
  - Reviewed the "robust" flag from review-03 with the user: **decision reversed** — "robust" is a normal, useful word and should not be banned. Removed it from the `#### Words to Use and Avoid` banned-word list rather than removing its use at line 59 ("Implementing robust user verification and access control"). The banned-word list itself was the thing that was wrong, not the usage.
  - Pre-existing em-dash count (34) left untouched, same rationale as prior sessions: predates the Humanized Output rule, out of scope for a targeted fix pass.
- **Outcome (review-04)**: All Major and addressable Minor findings from review-03 resolved and verified; `validate-protocol.sh` re-run in full, 8/8 passed (with the new marker check now active and passing).
- **Files changed**: `ai/policies/ai-policy-common.md` (markers, word-list, paragraph split), `support-files/validate-protocol.sh` (v4.5 → v4.6, new marker check in Step 6), `ai/code-review-reports/2026-07-28_review-03.md` and `2026-07-28_review-04.md` (new), this file.
- **Not done in this session**: No commit made yet; all changes remain on disk pending the user's review and commit decision.

## 2026-07-28 — Documentation sync for today's Procedure D / policy changes, then commit

### README, workflow-guide, and slides updated to match Procedure D and policy changes
- **Decision**: Updated `README.md` (§9 Peer Review Mode), `docs/workflow-guide.md` (§12 Peer Review Mode), `docs/simple-ai-workflow-slides.md` (feature bullet list and the "On-Demand Peer Review" slide), and `docs/ai-customization-guide.md` (Peer Review note) to reflect today's changes: the `"PR review"` trigger phrase, PR resolution mechanics (fetch latest, resolve source/target branches, diff source against target), the Scope Discipline behavior (don't stop at the diff), and the new `Not Checked` report section.
- **Why**: These docs already documented Peer Review Mode in detail before today's changes; leaving them saying only `"peer review"` with diff-only scanning would make them stale and misleading relative to the actual protocol behavior.
- **Not touched**: `docs/protocol-validation-system.md` (high-level design blueprint, does not enumerate specific checks or version numbers, so the new READ-ONLY marker check and v4.6 bump did not require an edit there). No other doc files referenced the old wording.
- **Verification**: `validate-protocol.sh` re-run in full after doc edits, 8/8 passed.
- **Session-end state**: All of today's work (Procedure D PR mechanics, Scope Discipline, Evidence-Based Reasoning rule, READ-ONLY marker fix + validator hardening, four review reports, and this documentation sync) is being committed to `master` in one commit at the user's explicit request.

## 2026-07-28 — Procedure E hardened against silent skip (ad hoc protocol-developer session)

### Removed the suppressed-report path; made the procedure a hard, unconditional gate
- **Problem**: A real session skipped Procedure E entirely after an actual condensation event, going straight to the user's task. Root cause traced to the "quiet mode" carve-out: Step 2 and Step 5 both let the AI suppress the full reload report when the first message was a direct task request, down to a single one-line acknowledgment. That carve-out gave a plausible, protocol-sanctioned way to skip the visible reload, and the AI used it.
- **Decision**: Removed the suppression branch entirely.
  1. Step 2 (Trigger): now states there is no silent or suppressed path, regardless of what the first message contains.
  2. Step 5 (REPORT): the full confirmation block is now mandatory as the literal first content of every response after condensation, including direct task requests. The old one-line `[Reloading key files into context... done. Proceeding with task.]` shortcut was deleted.
  3. Added a blunt precondition line at the top of the procedure naming the exact failure mode ("an AI reasoned that a detailed condensation summary already provided enough context and went straight to the task") so the temptation is called out explicitly rather than left implicit.
- **Rationale**: A well-structured condensation summary can make the reload feel unnecessary in the moment, that is precisely the failure this session hit. Removing the optional-suppression path removes the mechanism the AI used to rationalize skipping it. This does not make skipping impossible, but it removes the protocol-sanctioned shortcut.
- **Validator impact**: None. `support-files/validate-protocol.sh` only checks the `### PROCEDURE E: Post-Condensation Recovery` header string, which was not touched. Re-run in full after the change: 8/8 passed.
- **Peer review**: review-05 (CHANGES REQUESTED, 2 Minor) flagged new-prose em dashes in the added text, against the Humanized Output rule in `ai-policy-common.md`. Fixed (colon and parentheses substituted). review-06 (APPROVED).
- **Files changed**: `AGENTS.md` (Procedure E), `ai/code-review-reports/2026-07-28_13-10_review-05.md` and `2026-07-28_13-12_review-06.md` (new), this file.
- **Not done in this session**: No commit made yet; change is on disk only, pending the user's review and commit decision. Docs (`README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`) were checked for stale references to the removed suppression behavior via targeted grep — none found, so no doc updates were required this time.

## 2026-07-28 — Stable-title identifier, title-only validator anchor, and per-tool external reload trigger

### Procedure E hardening continued: identify by title, not by letter
- **Problem raised by the user**: Tying anything external to "Procedure E" is fragile because the letter is a positional label that can be renumbered during future development.
- **Decision**: The descriptive title "Post-Condensation Recovery" is now the **stable external identifier** and a maintained contract. The letter may change freely; the title must be preserved so out-of-repo triggers keep resolving to it. Recorded inline in `AGENTS.md` as a **Stable identifier** note directly under the procedure header, and honoured everywhere external (memory trigger, setup guide, docs) by referencing the title plus a one-line function description, never the letter.
- **Validator change**: `support-files/validate-protocol.sh` anchor changed from `### PROCEDURE E: Post-Condensation Recovery` to the title-only string `Post-Condensation Recovery`, so renumbering the letter no longer breaks validation. Validator version unchanged (v4.6); the check count stays 8.

### Procedure E: first-cognitive-act framing, named sentinel, honest-ceiling note
- **Trigger** reworded as the model's first cognitive act (a crisp boolean check on the harness summary headings) before reading the user's first message.
- **Sentinel**: the existing Step 3 announcement `[Reloading key files into context...]` is now formally the mandatory loud-failure sentinel and must be the literal first line of the first post-condensation reply. Its absence is the visible signal that the procedure was skipped. This also fixed the prior "mandatory every response" ambiguity (it is the first reply after condensation, not every turn for the rest of the session).
- **Honest ceiling** note added at the end of the procedure: this is a self-executed rule, `AGENTS.md` may not survive condensation, so the protocol cannot guarantee its own re-arming. The accepted target is high reliability via a loud sentinel plus a per-tool external trigger plus the user's own spot check, explicitly not a structural guarantee.

### Per-tool external trigger (the necessary evil), kept out of the repo
- **Design**: The re-arming instruction must live in a layer the assistant re-reads every turn (persistent memory or always-on custom instructions). `AGENTS.md` is exactly what gets dropped by condensation, so it cannot re-arm itself. This layer is per-assistant and lives outside every repository, in the user's personal settings. It is deliberately NOT added to the tool-agnostic protocol.
- **User's own layer**: For this user (GitHub Copilot), the trigger lives in Copilot user memory, physically at `%APPDATA%\Code\User\globalStorage\github.copilot-chat\memory-tool\memories\post-condensation-reload-trigger.md`. It identifies the procedure by title and defers to `AGENTS.md` for the steps. The older overlapping note in the user's `tdd-and-review-workflow.md` memory was trimmed to a pointer, and its now-wrong "suppress the report" guidance was removed.
- **Community guide**: Added `docs/post-condensation-reload-trigger-setup.md` — a straightforward, assistant-agnostic guide with one generic trigger block and a per-assistant placement table (GitHub Copilot, Claude Code, claude.ai, ChatGPT, KiloCode, Kimi, Gemini CLI/Code Assist, AntiGravity, plus a generic fallback), a plain-language explanation of why the note is a necessary evil, and the human backstop. Per-assistant paths are given with a caveat that names/paths drift and the user should consult their assistant's docs.
- **Human backstop**: Documented across the setup guide, `docs/workflow-guide.md` §7, and `README.md`: after any summary, ask "did you run the post-condensation reload?" before trusting the next answer. Framed as the acknowledged final safety net, not a failure.
- **Docs updated**: `README.md` (delabeled the two context-rot table cells from "Procedure E" to the title, added a habit bullet, a Session Resume bullet linking the setup guide, and a Docs-and-Slides index entry for the new guide), `docs/workflow-guide.md` (§7 new subsection), `docs/simple-ai-workflow-slides.md` (honest-ceiling caveat on the Post-Condensation Recovery defence bullet plus a reload-backstop habit; the live Google Slides deck is already behind the markdown and will be reconciled separately, not this session), this file.
- **Not done in this session**: No commit made yet; all changes remain on disk pending the user's review and commit decision.

## 2026-07-31 — Procedure E renamed to Post-Compaction Recovery and simplified to an additive reload

### Title change: "Post-Condensation Recovery" → "Post-Compaction Recovery"
- **Problem (vocabulary mismatch)**: The harness labels a compacted thread "Compacted conversation", while the procedure was named after "condensation". There was no lexical bridge, so the AI could fail to recognise the trigger moment. The word "condensation" also collides with Procedure C Step 2 "Log Condensation (The Sliding Horizon Shield)", an unrelated `progress.md`-archiving feature.
- **Decision**: Renamed the procedure title to **Post-Compaction Recovery** to match the harness term. This **updates, not contradicts**, the 2026-07-28 "identify by title, not by letter" decision: the title is still the stable external identifier and still a maintained contract, so the rename had to be applied atomically across `AGENTS.md`, the validator anchor, the external memory trigger, the setup guide, and all docs, or the external triggers stop resolving. The letter (E) remains free to renumber.
- **Not renamed**: Procedure C Step 2 "Log Condensation / Sliding Horizon Shield" was deliberately left untouched — it is a different concept (log archiving, not conversation recovery).

### Body simplified and made additive (non-destructive)
- **Problem (harmful voluntary runs)**: The prior body carried conditional carve-outs, a first-cognitive-act boolean, a precedence essay, a multi-bullet report, and an honest-ceiling essay. It was over-complicated, and running it without a real compaction risked overwriting live context.
- **Decision**: Reframed the procedure as a purely **additive reload**. It loads only static rule/config files — `AGENTS.md`, the customization file, global settings, global knowledge, and the policy files — and it never reads the three state files. Because it only adds files and never wipes the working thread, it is safe to run automatically or on explicit request; no "do not run unless compaction" guard is needed. The one hard rule is the single guard: **never read `ai/progress.md`, `ai/context.md`, `ai/next-steps.md`, or any daily checkpoint** — the compaction summary already in context is the source of truth for task state.
- **Coordination board loaded, shared indexed**: Step 6 now **reads the Project Coordination File in full** (multi-agent awareness) and builds a filename-only index of the rest of the Project Shared Directory (handoffs, project knowledge), loaded on demand. Previously project knowledge alone was indexed; the scope is now the whole shared directory.
- **Dropped**: the 2026-07-28 anti-skip hardening prose (suppression-path removal narrative, first-cognitive-act boolean, honest-ceiling essay). The user judged the silent-skip risk acceptable given the loud first-line sentinel and the external trigger, and preferred a short, readable procedure.
- **Sentinel retained**: `[Reloading key files into context...]` is still the mandatory literal first line of the first reply after a compaction.

### TIER 1 anchors made bold everywhere
- **Decision**: Every reference to a TIER 1 path variable in the procedure and touched policy/doc text now uses the bold anchor form (**Project Customization File**, **Global AI Settings Directory**, **Project Coordination File**, etc.) so the AI cannot miss them.

### Files renamed
- `docs/post-condensation-reload-trigger-setup.md` → `docs/post-compaction-reload-trigger-setup.md` (via `git mv`, history preserved), contents retitled and the generic trigger block rewritten to key on the "Compacted conversation" signal with additive-safe framing.
- User-memory external trigger `post-condensation-reload-trigger.md` → `post-compaction-recovery-trigger.md`, rewritten to a single signal-plus-steps definition that identifies the procedure by its new title and states the reload is always safe because it only adds files.

### Validator
- `support-files/validate-protocol.sh` anchor changed from the title string `Post-Condensation Recovery` to `Post-Compaction Recovery`. Version unchanged (v4.6), check count stays 8 (precedent: 2026-07-28 anchor change kept the version). Re-run after the change to confirm 8/8.

### Files changed
- `AGENTS.md` (TIER 2 Context Protection + Session Resume, Procedure C Steps 1 and 4, Procedure E fully rewritten), `support-files/validate-protocol.sh`, `ai/policies/ai-policy-common.md`, `ai/policies/ai-policy-codebase-examination.md`, `docs/codebase-examination-guide.md`, `docs/workflow-guide.md` (§7), `README.md`, `docs/simple-ai-workflow-slides.md`, the two renamed files above, this file.
- **Commits**: 58f22a4 (rename + simplify, 11 files), 4465a54 (Proof-of-Load Step 7(a) widened), 36de4b6 (PreCompact hook + concrete signals + memory trigger deleted + setup guide update). See the following entry for the full record of the second and third commits.

## 2026-07-31 — Concrete compaction signals, PreCompact hook, and doc updates

### Compaction signals made syntactically detectable
- **Problem**: AGENTS.md trigger language was vague ("tell-tale signs"); the AI had to reason about the provenance of a session summary, which led to missed detections on two documented occasions.
- **Decision**: Replace vague language with three concrete syntactic signals in both TIER 2 Session Resume and Procedure E Trigger: (1) the literal text `"Compacted conversation"` in the transcript; (2) a `<conversation-summary>` XML block in the active context; (3) the session opening with a machine-generated multi-section summary the AI did not write.
- **Rationale**: Syntactic pattern matching is more reliable than provenance inference. The `<conversation-summary>` XML tag is a structural Copilot marker that cannot appear in normal conversation.

### User memory trigger file deleted
- **Decision**: Deleted `/memories/post-compaction-recovery-trigger.md`.
- **Rationale**: Empirically failed on two documented occasions (2026-07-30 mid-session; 2026-07-31 session-start). AGENTS.md is already always-on in VS Code, so the memory file provided no additional coverage. Root cause is compliance (text instructions are declarative, not imperative); a duplicate at the same level does not fix a compliance problem.

### PreCompact hook as mechanical re-arm layer
- **Decision**: Created `~/.copilot/hooks/compaction-recovery.json` (user-level, all workspaces) using the VS Code `PreCompact` hook event, outputting a `systemMessage` warning.
- **Rationale**: The PreCompact hook fires before every mid-session compaction and shows the message to the user at the right moment — no AI text-instruction compliance needed. Documented in `docs/post-compaction-reload-trigger-setup.md` with a new hooks section and updated per-assistant table row.
- **Known ceiling**: No `PostCompact` hook exists in VS Code. The PreCompact warning + human backstop covers the gap.

### Proof-of-Load Step 7(a): report all customization file sections
- **Decision**: Changed to "report each one explicitly, whatever sections the file contains" for full coverage. Commit 4465a54.

### Stable identifier note simplified
- **Decision**: Simplified the Procedure E "Stable identifier" paragraph to reference the validator anchor, setup guide, and hook configurations — removing the stale mention of the deleted external trigger file.

### Docs and notes
- `README.md`: two stale "memory note" references updated to mention the PreCompact hook
- `docs/simple-ai-workflow-slides.md`: new "Post-Compaction Recovery" slide added with three-panel context-window ASCII diagram (Session Start / Mid-Session / After Recovery); stale reference updated
- `ai/notes/compaction-trigger-problem.md`: new standalone note with problem description and question for other AI tooling communities
- Uncommitted at checkpoint: README.md, slides.md, ai/notes/notes.md, ai/notes/compaction-trigger-problem.md

### Post-Compaction Recovery slide diagram (final form)
- **Decision**: Four-box context-window diagram in the slide: Session Start / Mid-Session / After Compaction / After Recovery. The "After Compaction" box (new) is the key teaching moment — it shows the compacted conversation at the top but NO rules cells, making visually explicit that the rules were lost. "After Recovery" shows compacted conversation + rules reloaded + active work, restoring the complete picture.
- **Diagram evolution**: Started as 3 boxes (start/mid/after-recovery); user added "After Compaction" as an intermediate state to show the gap before recovery. All 4 boxes normalized to 13 rows for bottom-border alignment.
- **Files**: `docs/simple-ai-workflow-slides.md` (Post-Compaction Recovery slide, diagram replaced)

---

## 2026-08-05 — Session CP-2026-08-05-01

### Policy files must not use procedure letters or step numbers

- **Decision**: Policy files (`ai/policies/*.md`) must not reference procedure letters (e.g. "Procedure A", "Procedure C") or step numbers (e.g. "Step 4"). These are internal `AGENTS.md` labels that silently break if procedures are renumbered or renamed.
- **Rule going forward**: All references to `AGENTS.md` procedures or steps in policy files must use plain descriptive phrases: "the `AGENTS.md` bootstrap procedure", "the checkpoint knowledge update steps in `AGENTS.md`", etc. Using the procedure's own stable title (e.g. "Post-Compaction Recovery") is fine — it is a maintained external identifier, not a positional label.
- **Files changed**: `ai/policies/ai-policy-common.md` (9 occurrences fixed), this file.
- **Commit**: `e82729c` on master. Validator v4.6, 8/8 pass.

---

## 2026-08-08 — Session CP-2026-08-08-02 (branch `feature/state-files-directory`)

### State files moved to dedicated `ai/state/` directory

- **Problem**: The three state files (`progress.md`, `context.md`, `next-steps.md`) were the only files directly under `ai/` — everything else was organized into subdirectories (`notes/`, `plans/`, `policies/`, `shared/`, etc.). The flat placement was a leftover from the earliest days of the protocol.
- **Decision**: Move the three state files into a dedicated directory `ai/state/` (user's choice over `ai/state-files/`). The TIER 1 anchor **Project AI State Files** keeps its name but now resolves to the directory `ai/state/` instead of a three-file list. This keeps the 14+ anchor usages in `AGENTS.md` and policies unchanged while changing the single source-of-truth path in TIER 1.
- **Guardrails added** (user requirement, in response to weak models prepending entries and bloating state files):
  1. **Append-Only Rule**: all updates must be appended at the tail; never insert/edit at the top. Enforced via a new bullet in `ai-policy-common.md` State File Ownership Protocol and an `STATE-FILE: APPEND-ONLY` HTML comment header at the top of each state file.
  2. **Scope Rule**: state files contain summaries only (done / pending / current context); no implementation details, runbooks, commands, or knowledge content. Those belong in knowledge directories. Enforced via a new bullet in `ai-policy-common.md` and an `STATE-FILE: KEEP LEAN` HTML comment header.
- **Directory name rationale**: `ai/state/` follows the single-word subdirectory convention (`notes/`, `plans/`, `policies/`). The `ai/` parent already supplies the namespace, so `state-files/` would be redundant; no other subdirectory uses a `-files` suffix.
- **Anchor name kept**: `**Project AI State Files**` stays (not renamed to "Directory") because it is used 14+ times across the protocol as a conceptual term. Only its TIER 1 resolution changed to the directory path. This minimizes protocol text churn.
- **Historical content preserved**: existing entries inside the state files and historical records in this file keep their old-era paths — they accurately describe where files were when written.
- **Migration mechanics**: this repo uses `git mv` (state files are git-tracked here). User projects get migration via `sync-agents-md.sh`/`sync-agents-md.ps1`, which create `ai/state/` if absent, move any state files found at `ai/*.md`, and append a `[MIGRATION-YYYY-MM-DD]` notice to each moved file. Migration is idempotent: if both old and new exist, it warns and skips.
- **Files changed**: `AGENTS.md` (TIER 1 anchor, Procedure A Step 2 structural audit + Step 7(d), Procedure B Step 4, Procedure C Steps 1–2, Procedure E), `ai/policies/ai-policy-common.md` (handoff reference, Source-of-Truth Order, two new guardrail bullets), `ai/policies/ai-policy-meta.md` (3 references), `ai/shared/coordination.md`, `ai/shared/project-knowledge/multi-agent-state-ownership-and-checkpoint-model.md`, `support-files/validate-protocol.sh` (Step 4 PROJECT_SUBS + config), `support-files/sync-agents-md.sh`, `support-files/sync-agents-md.ps1`, `README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, `docs/ai-agent-collaboration.md`, `docs/protocol-validation-system.md`, `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`, this file, and the three state files (moved + headers + migration notice).
- **Branch**: `feature/state-files-directory` — not merged to master (user handles merge/push).


---

## 2026-08-09 — Session CP-2026-08-09-01

### Writing style training: distilled guide in global knowledge, raw examples deleted

- **Problem**: The AI needs to mimic Kamran's writing style in documents, emails, tickets, and READMEs. A 1939-line examples file (8 articles) was created in `ai/notes/`. Global Knowledge is fully loaded at every session boot in every project, so a 1939-line file there would bloat every boot (the set is designed to be "intentionally small").
- **Decision**: Distill the raw articles into a single style guide and delete the raw file. The raw examples are not stored anywhere.
- **Result**: `~/.ai/global-knowledge/writing-style-and-examples.md` — a distilled style guide (~40 lines) capturing the voice (conversational, first-person honest, numbered steps, exact specifics, warm sign-offs), a "do not copy" list (era typos), and a "Style sources" index of what the voice was distilled from. Fully loaded at every boot, so the AI is architecturally forced to see the style rules before writing.
- **Rationale**: Full-load for the small authoritative rules; no large raw corpus to ration. The raw articles served only as distillation input, not as a living reference.
- **Files**: created `~/.ai/global-knowledge/writing-style-and-examples.md`; deleted the raw examples file; `ai/notes/notes.md` (item marked Processed).

---

## 2026-08-09 — Session CP-2026-08-09-01 (continued)

### Policy discovery in Project AI Policies Directory is intentional; workflow-repo over-load is an accepted artifact

- **Problem**: During Post-Compaction Recovery (Procedure E Step 5), the AI fully loaded all 16 policies in `ai/policies/` instead of only the policies referenced in `ai-customization.md` (Active Expertise: `meta`). The user flagged this as unwanted context bloat and initially suspected a protocol bug.
- **Investigation**: Four AGENTS.md clauses (Procedure A Step 6 line 105, Step 7(b) line 110, Procedure C Step 4 line 154, Procedure E Step 5 line 182) instruct the AI to discover and fully load every `.md` in **Project AI Policies Directory**. The design intent is custom-policy discovery: in an ordinary user project, `ai/policies/` holds user-created custom policies that exist with the intent of being loaded.
- **Decision**: The behavior is **correct and will not be changed**. No fix applied.
- **Rationale**: The over-load is unique to this repository, where `ai/policies/` doubles as the **Global AI Policies Directory** (the 16-policy library) AND the project's custom-policy directory. In any ordinary project directory, `ai/policies/` contains only user-authored custom policies, so loading every file found there is exactly right. Trade-off accepted: working as a protocol developer in the workflow repo means the full policy library is loaded at boot/checkpoint/post-compaction. Do not re-diagnose this as a bug.
- **Future change note**: If context savings are ever needed for the workflow repo itself, the fix would be to activate the library's policies via the customization file's Active Expertise (referenced-only loading) rather than filesystem discovery — but that would break the intended custom-policy auto-discovery behavior for ordinary projects. Left as-is by explicit user decision.
- **Superseded (2026-08-22)**: The "no fix" stance for the workflow repo was later reversed — the Protocol Developer Mode policy-loading exception below now restricts the load to active-expertise policies only. The ordinary-project behavior in this entry remains correct and unchanged.

---

## 2026-08-22 — Session CP-2026-08-22-02 (remote work merged; decision reversal)

### Protocol Developer Mode policy loading restricted — supersedes the 2026-08-09 "no fix" decision (workflow-repo scope only)

- **Problem**: The 2026-08-09 decision declared the workflow-repo over-load (all 16 policies loaded at boot and post-compaction) an accepted artifact and instructed "do not re-diagnose this as a bug". The user later decided the constant full-library load would keep bothering them and chose to fix it after all, knowingly reversing the earlier stance for this repository.
- **Decision (current, authoritative)**: During context loading and Post-Compaction Recovery, Protocol Developer Mode (PWD matches **Global AI Workflow Directory**) loads ONLY `ai-policy-common.md` plus the policy files explicitly listed under `## Active Expertise` in the **Project Customization File**. The recursive scan of the **Project AI Policies Directory** is skipped — that directory is the protocol's full distribution tree, not the working policy set.
- **Relationship to the 2026-08-09 decision**: The earlier decision remains correct for ordinary user projects — there, `ai/policies/` holds user-created custom policies and filesystem auto-discovery is the intended behavior. The new decision narrows the exception to operating as a protocol developer inside the workflow repo. No part of the ordinary-project behavior changed.
- **Implementation**: Commit `b93741c` added the "Exception — Protocol Developer Mode" clause at all 4 policy-loading locations in `AGENTS.md` (TIER 2 Protocol Developer Mode bullet, Procedure A Step 6, Procedure C Step 4, Procedure E Step 5). Peer review round-01 CHANGES REQUESTED (Procedure C Step 4 missing) → fixed → round-02 APPROVED. Validator v4.6, 8/8 pass.
- **Not changed**: `ai-policy-common.md` policy-loading clauses keep the full-load behavior for referenced and discovered custom policies; the exception is scoped to Protocol Developer Mode and lives in `AGENTS.md`. If the ordinary-project path ever needs the same restriction, that is a separate decision.

---

## 2026-08-24 — Session CP-2026-08-24-01 (common-policy additions + state-file discipline)

Work driven by `ai/artifacts/additions-to-common-policy.md` (Stream A) plus a user-supplied state-file brevity problem (Stream B). All new prose is em-dash-free per the Humanized Output rule. Peer review review-01 APPROVED, validator v4.6 8/8. Branch `feature/common-policy-additions-and-state-file-brevity`, not merged.

### Stream A: three additions to ai-policy-common.md
- **Full reads for working files** and **No truncation of investigation output** added as points 5 and 6 of Evidence-Based Reasoning. Rationale: the user requires that every important file be read in full to EOF (no sampling); only log-like bulk-data files (logs, dumps, large JSON/CSV) may be sliced by search or filter. Point 6 bans piping enumeration output (grep, find, az) through head or tail during investigation, since that silently drops evidence.
- **External system mutations require explicit approval** added to Universal Operational Guardrails, beside "No side effects without approval". Generalizes the local side-effect gate to remote systems of record (Jira, ADO, GitHub, Confluence, Teams, Slack): propose the exact text first, wait for approval.
- The artifact's other steps (deleting duplicated rules from a project `ai-customization.md`, reducing the AC-writing-guide rule to a pointer, relocating WAF/CAF to `ai-policy-cloud.md`) target the user's separate cloud/dba work repo, not this one. Out of scope here.

### Stream B: state-file model corrected and made lean
- **Conceptual fix**: the prior "State File Append-Only Rule" implied all three state files are append-only history. That is wrong for next-steps.md (a forward-only backlog whose items are deleted when done) and for context.md (whose Current Status dashboard is edited in place). The single rule was replaced in `ai-policy-common.md` with a per-file model: next-steps.md is forward-only plus delete-on-done; progress.md is append-only history plus horizon-shield archiving; context.md is the present (Current Status in place plus appended history). Added a State File Brevity Rule (one to two lines per item, no sub-bullets, transcripts, or rationale) and a Bloat and Order Check (report and propose before rewriting a bloated or out-of-order state file).
- **Gap closed**: the protocol had a horizon shield for progress.md and context.md but no brevity governance for next-steps.md, and "pop the completed task" was soft enough that sessions left ticked items in place. `AGENTS.md` Procedure C Step 1 now says delete-on-done explicitly (no ticked or struck leftovers) with the brevity gate; Step 2 gained a next-steps brevity bullet.
- **Ordering model** (user's FIFO framing, refined): insertion is always append-at-tail (oldest top, newest bottom); deletion removes the completed item wherever it sits (work oldest-first by default, not a strict in-order queue).
- **State-file headers** reworded per file to state the file's nature, chronological order, brevity, and "not a runbook, plan, or ledger".
- **context.md reordered** to chronological order (it was a descending block followed by an ascending tail block, with multiple "Latest Checkpoint" headings). Now oldest at top, newest at bottom; only the newest entry keeps the "Latest Checkpoint" label. Entry bodies preserved verbatim.

### Practice note: AGENTS.md edited directly by the AI this session
- The user explicitly authorized the AI to edit protocol files directly as protocol developer, including `AGENTS.md`, despite `AGENTS.md`'s own "modifications must be performed manually by the human user" banner. This matches the mixed practice seen across prior sessions. The banner-versus-Protocol-Developer-Mode tension is a real inconsistency, flagged for the codebase examination.

---

## 2026-08-25 — Pre-Work Gate and Acceptance Criteria Quality added to common policy

Driven by observations from another session (a pasted spec). Added two subsections under `## Operational Standards` in `ai-policy-common.md`, after Evidence-Based Reasoning. Branch `feature/pre-work-gate-and-acceptance-criteria`, not merged.

### Pre-Work Gate
- Checks to complete before starting any work item: scope discovery (find all repos and configs, and treat a missing repo as archived or decommissioned rather than out of scope), acceptance-criteria review, HLD and LLD, removal safety (gather positive evidence that everything meant to stay is still in place), a pre-work announcement posted externally only on explicit instruction, and framework alignment.
- **Wise adaptations from the raw spec**: (1) Added a proportionality clause so the depth scales with the work item's size and risk. A blanket "produce HLD and LLD before any work item" would be impractical for a one-line fix. (2) The HLD/LLD step references the existing Design Documentation Standards rather than restating the artifact spec, to stay DRY. (3) The framework-alignment bullet was generalized to the target platform or domain's best-practice framework, and it explicitly defers platform specifics to the domain policy. This respects the earlier decision (in the reconciliation artifact) that WAF/CAF is cloud-specific and belongs in `ai-policy-cloud.md`, not common policy. (4) Cross-references use plain section names, not markdown links or procedure letters, per the policy-file link rules.

### Acceptance Criteria Quality
- Acceptance criteria are the contract for a work item. Two mandatory checks: review them before design (flag any that are missing, ambiguous, not independently testable, or contradictory), and confirm every criterion traces to at least one LLD item or the LLD is incomplete.
- **Living guide dropped as a mandatory rule**: the raw spec required a living acceptance-criteria quality guide file, updated on every work item. Softened to opt-in after user pushback. It is a soft rule with no forcing function (same failure shape as the old "pop the completed task"), it is an extra file to manage, and it cuts against the lightweight mandate. A real production customization file had already picked up the same rule through scope creep (a one-off "make me an AC guide" request hardened into a forever-obligation). Final wording: if AC quality is a recurring problem, note patterns in normal project knowledge at checkpoints; do not stand up a dedicated guide file unless it earns its keep.

### Not done
- No `AGENTS.md` change and no validator anchor added. These are common-policy prose rules, the same pattern as Evidence-Based Reasoning. Validator remains 8/8 at v4.6.

### Follow-up (merged and released)
- Peer review (review-02) flagged that Pre-Work Gate item 3 ("Produce HLD and LLD") could read as contradicting the Mandatory Design Artifacts "ask whether to create" rule. Resolved by adding a clause: create the HLD/LLD only after proposing them and getting the user's agreement, in line with the no-side-effects norm.
- Committed 1d71e95, squash-merged to master, pushed. Released as v2.2.0 (2026-08-25), a MINOR bump: no breaking changes since v2.1.0, backward-compatible features plus fixes. Changelog grouped into Features, Fixes, and Docs.

---

## 2026-08-25: Full-file-read enforcement raised to a TIER 2 mandate

Driven by a real violation in a production session (Claude Sonnet 4.6 skipped full reads of the customization file and a policy at load context) and the user's insistence that the rule be active everywhere. Branch `feature/full-file-read-enforcement`, not merged.

### Problem
- The read-fully rule lived only in Evidence-Based Reasoning (common policy), one rule among many. It covered boot reads through Proof-of-Load but not mid-task investigation reads, which are invisible to the user and the hardest to enforce. The user cannot watch every behind-the-scenes read.

### Decision
- **TIER 2 mandate**: added a **Full File Reads (No Partial Reads)** MANDATORY ACTION to `AGENTS.md`. TIER 2 fires unconditionally across all procedures, so the rule is active at boot, at load context, at Post-Compaction Recovery, and mid-work. Every file read for comprehension is read line 1 to EOF. The only exception is bulk data being searched (logs, dumps, large JSON or CSV), sliced by filter. A file already in context is re-read fresh from disk when a task needs it, since it may have changed.
- **Observable proof**: when a read drives a decision or change, the AI states the file and its line count, so a silent partial read becomes catchable after the fact. Proof-of-Load (a) and (b) now require line counts for the customization file and every settings, knowledge, and policy file loaded at boot.
- **Common-policy detail**: Evidence-Based Reasoning point 5 strengthened with the everywhere clause, the re-read-from-disk clause, and the observable-proof requirement.
- **Validator**: added a `Full File Reads` anchor check to guard the mandate against removal. Version unchanged (v4.6).

### Why this shape, not the raw proposal
- A production-session AI proposed a silent self-check step in Procedure A. Two parts rejected: (1) a silent self-check by the same executor carries the same skip risk as the rule it checks, so the lever is observable output, not a self-audit; (2) Procedure A is boot-only, but the pain is mid-work, so TIER 2 (always-on) is the correct home. Honest limit recorded: a stated line count is still self-reported and not a hard guarantee; a true external check belongs to the pending Habit Hooks work.

### Non-Negotiables index (same branch)
- Added a short **Non-Negotiables** block (6 items) at the top of `ai-policy-common.md` as an at-a-glance index of the highest-cost rules: full reads, no truncated evidence, evidence before assertion, approval before side effects, secrets check, protected-branch approval. Rationale: short numbered prominence helps salience for the load-bearing rules, and it is capped at 6 to avoid list-bombing. It indexes rules that already have their own detailed sections, so no separate validator anchor was added. This addresses the user's "rules buried in long prose" concern, with the caveat that formatting aids salience but does not fix execution; placement, observable proof, and external checks remain the real levers.
- **Merged and released**: committed 16e11f1, squash-merged to master, pushed, branch deleted. Released as v2.3.0 (2026-08-25), a MINOR bump.

---

## 2026-08-25: Intent-over-metrics phrasing and shared-understanding pre-work gate

Driven by the 2026-08-21 research file (four videos on AI coding quality). Two self-standing rules adopted; Idea 11 dropped.

### Intent over metrics (common policy + code-review policy)
- **Decision**: Added an "Intent over metrics" bullet to the Universal Operational Guardrails in `ai-policy-common.md`, and an "Intent, not scores" bullet to the reviewer role in `ai-policy-code-review.md`. Quality findings are phrased by intent (what single job a function should have), never as a bare metric ("complexity 11, threshold 5").
- **Rationale**: The research measured a large gap: behavioral prompts produced 83.3% genuine fixes on both models, while bare metrics produced 5.6% (Sonnet) and 28.9% (Haiku). Stronger models gamed bare metrics more, not less. This is Goodhart's Law applied to LLMs.
- **Honest limit**: this is a context rule, not mechanical enforcement. It sharpens intent-alignment but does not guarantee cycle enforcement, which the research shows needs a supervisor outside the context window.

### Shared understanding before building (Pre-Work Gate)
- **Decision**: Added a "Shared understanding (features and architecture only)" item to the Pre-Work Gate in `ai-policy-common.md`, between acceptance-criteria review and HLD/LLD. For feature or architectural work, the AI must reach a shared design concept with the user before creating files or writing implementation. Renumbered the remaining Pre-Work Gate items.
- **Rationale**: The Pre-Work Gate already mandates removing uncertainty before building, but only in one direction (research and present). This adds the interactive mechanism: walk the design tree and resolve decisions one at a time until the user and AI agree.

### Idea 11 dropped
- The Ubiquitous Language file idea was dropped as redundant. The Design Documentation Standards already list a "Glossary" supplementary document covering shared domain terminology, and hardcoding a project-specific file name into the shared template would have broken on every user machine.

### Documentation
- `README.md` "What's included" and `docs/simple-ai-workflow-slides.md` "More Features" each gained two bullets (intent-based quality findings; shared understanding before building). `docs/workflow-guide.md` section 5 gained a "Shared understanding before building" subsection.

---

## 2026-08-25: Root-only AGENTS.md/ai-customization.md + markdown lint tooling

- **Root-only rule strengthened**: extended the PWD-Only Scope mandate in `AGENTS.md` TIER 2 to honor `AGENTS.md` and `ai-customization.md` only from the project root, and ignore any file with either name elsewhere in the directory tree. Closes a gap where `ai-customization.md` was checked at the root (Procedure A Step 0) but never explicitly ignored in other subdirectories.
- **Markdown linting**: installed markdownlint-cli2 (Node v24.19.0, npm v12.0.2), added `.markdownlint-cli2.jsonc` disabling style-noise rules and keeping real checks, fixed 14 whitespace issues across `AGENTS.md` and policy files, and recorded markdownlint-cli2 in the global settings tools list.

# Protocol Design Decisions

Curated record of the protocol's design decisions, oldest first. Session bookkeeping, commit and branch details, and review counts have been removed. Each entry states the decision.

## 2026-05-21: Knowledge loading is a dedicated load-context step

Project-knowledge loading is its own numbered step in the load-context procedure, marked "do not merge" with the earlier step, rather than a trailing sentence appended to it. A trailing sentence is silently skipped; a dedicated numbered step is not.

## 2026-05-21: Git-ignore reminders at the point of use

Inline git-ignore override reminders appear at the discovery step and at the knowledge-loading step, in addition to the general rule. The general rule covers the entire `ai/` directory including all subdirectories and every file.

## 2026-05-21: Checkpoint always updates project knowledge

The checkpoint procedure requires an explicit project-knowledge review and update before every backup. It is mandatory even when nothing changed, so the AI must confirm.

## 2026-05-21: Backup is a native command, not a script

Backup is a native one-liner embedded in the checkpoint procedure. The standalone backup script was removed as redundant.

## 2026-05-21: The validation script is portable

The validation script resolves the home directory through the shell environment rather than a hardcoded path, so it runs on Linux, macOS, and Windows Git Bash.

## 2026-05-21: User-facing docs avoid internal protocol labels

README and `docs/` describe behavior in plain language and never expose internal tier or procedure labels such as "PROCEDURE LOAD-CONTEXT" or "TIER CONFIGURATION". `AGENTS.md` and policy files are the only places permitted to use those labels. This merges three same-day decisions on the same rule.

## 2026-05-21: Triggered procedures live with their peers

Every triggered procedure sits in the triggered-procedures tier alongside the others. A procedure appended to an appendix section is invisible to a scanner that stops at the end of the triggered-procedures tier.

## 2026-05-21: Scripts write BOM-free files on PowerShell

The sync script writes files through the .NET text-write call with a UTF-8 encoding that emits no byte-order mark, because PowerShell 5.1 `Set-Content -Encoding UTF8` prepends a BOM that breaks anchors and metadata checks.

## 2026-05-21: Peer review is a dedicated policy with a report location

The peer-review role, dimensions, severity, and report format live in `ai-policy-code-review.md`, loaded at the start of the peer-review procedure. Reports are written to `ai/code-review-reports/` with a date-time and per-session sequence number in the filename, and are never overwritten.

## 2026-05-21: The README title is "Simple AI Workflow"

The README H1 is "Simple AI Workflow", not a description of the policy mechanism.

## 2026-05-21: Settings live only in the global user directory

`settings/` exists only at `~/.ai/settings/`. A `settings/` directory at the project root is a misplacement and must not exist.

## 2026-05-21: code-review is a triggered mode, not an expertise

`code-review` is not listed under Active Expertise. The review policy loads automatically on the "peer review" trigger, so listing it would load reviewer behavior permanently.

## 2026-06-18: No AI metadata comment headers in files

Files carry no `Created-by`, `Updated-by`, `Last modified`, or `Intent` comment headers. Git history is the authoritative record.

## 2026-06-18: The validator checks the current protocol surface

Validation checks all current `AGENTS.md` features: the procedure anchors and every configuration key. It is not limited to a stale subset.

## 2026-06-18: READ-ONLY guards on every policy file

Every policy file opens with the `DO NOT MODIFY` guard, contains a `READ-ONLY START` marker, closes with a `READ-ONLY END` marker, and uses the normalized Global Authority cross-reference wording. The common policy and the meta policy were brought into line with this rule. This merges the same-day structural-inconsistency fix and the meta-policy hardening.

## 2026-06-18: Full form for "load context" at session start

Use the full form "load context using AGENTS.md protocol" at the start of a session or after a restart. The shorthand is acceptable mid-session only when `AGENTS.md` is already in view.

## 2026-06-18: Settings are full-loaded; knowledge is just-in-time indexed

Global settings are fully loaded at boot because they are small, authoritative, and needed before the first task. Global Knowledge and Project Knowledge are indexed at boot and loaded on demand under Token Rationing. Any new settings file is always full-loaded; any new knowledge file is indexed only.

Note: the Global Knowledge half was reversed on 2026-06-30 and restored on 2026-10-06; see those entries.

## 2026-06-19: No markdown hyperlinks in policy files

Policy files and `AGENTS.md` contain no `[text](path)` hyperlinks. A file reference uses a bold configuration-anchor name or a backtick path. Because these files are read from the user's project root, a relative link resolves incorrectly there. Any link checker must not run filesystem resolution against policy files or `AGENTS.md`. This supersedes the earlier same-week relative-link rule.

## 2026-06-19: Protocol Developer Mode loads the decision store first

Protocol Developer Mode is an unconditional action in the read-first-rules tier. When the working directory is the workflow directory, the AI fully loads `protocol-decisions.md` before touching any protocol file. The same requirement is mirrored as a pre-action check in `ai-policy-meta.md`.

## 2026-06-19: Configuration anchors are the single source of path truth

No hardcoded inline path accompanies a configuration anchor. The anchor resolves the path, and duplicating the path inline creates a second source that can drift.

## 2026-06-22: Descriptive file naming for AI-generated artifacts

AI-generated knowledge, documentation, and workflow artifacts use descriptive kebab-case filenames, because the filename is the lookup key for on-demand loading. Application and source code, its tests and configs, and framework-named files are exempt and follow language and framework idioms. Protocol-fixed names are also exempt. The rule is a binding guardrail in the always-loaded common policy, not just documentation.

## 2026-06-22: Codebase examination is a triggered procedure

`ai-policy-codebase-examination.md` activates through the trigger phrases "examine this codebase" and "codebase examination", not through Active Expertise, so it has no boot-time presence, matching the review policy. Its strategy is disk-as-memory with three-tier just-in-time loading and a four-phase workflow (Map, Plan, Perform, Reconcile), reusing the existing branch-gating, test-first, and peer-review guardrails. It prohibits vector databases, embeddings, and external indexing tools.

Note: supersedes the earlier same-day decision to make it an opt-in expertise module.

## 2026-06-22: The shared directory is tracked in git

The `.gitignore` adds an exception so the protocol coordination file and project knowledge are tracked in git. User project templates keep `ai/` fully private by default, with no exceptions, because user knowledge may be sensitive.

## 2026-06-29: State files are read fresh, with observable proof

After loading the state files, the AI records each file's line count and most recent checkpoint identifier, and repeats both in the load report. Before writing a checkpoint it reads the on-disk state files fresh rather than writing from memory.

Note: the checkpoint-identifier half was superseded on 2026-09-19 when checkpoint IDs were removed; the fresh-read requirement remains.

## 2026-06-30: Operational files are full-loaded at boot

At boot and on post-compaction recovery, the AI fully loads settings, Global Knowledge, the common policy, and every policy referenced in the customization file. Token Rationing is scoped to Project Knowledge only, since those files can be large.

Note: supersedes the Global Knowledge indexing half of the 2026-06-18 entry. Superseded for Global Knowledge on 2026-10-06, which returned Global Knowledge to just-in-time indexing. The settings and policy full load stands.

## 2026-06-30: State files have a single writer, and checkpoints write memory to disk

The project-root orchestrator is the only writer of the state files. A checkpoint serializes fresh in-memory state onto disk (memory to disk); it is a write-down, not a discovery read. The pre-write read is a reconcile that preserves append-only history and detects drift, while fresh in-memory deltas win; a same-item conflict stops and flags. Agents gain awareness by reading the coordination board, never by writing state files. A checkpoint is two-phase: an inbound reconcile of board and handoffs, then an outbound write. The protocol defines the contract; the multi-agent runtime is a separate project and is not built into `AGENTS.md`.

## 2026-06-30: Single-writer ownership is by session, not by role label

State-file ownership follows session or process identity, not a role name. One session that changes role hats is still the single writer. Concurrent separate sessions writing the same state files are not blessed; per-agent status files under the shared directory are the recorded revisit path if real parallelism is introduced. Concurrent writes to distinct role-scoped knowledge files remain fine.

## 2026-07-04: The customization file lives at the project root

The customization file is `ai-customization.md` at the project root, a sibling of `AGENTS.md`. The workflow-directory entry moves into it, leaving `AGENTS.md` read-only. Load context reads the customization file first and then resolves the derived configuration paths, which resolves the ordering problem. If the file is missing, the AI guides the user through setup rather than scanning directories for it.

## 2026-07-04: Humanized Output rules in the common policy

The always-loaded common policy holds a Humanized Output section: short sentences, no AI-tell vocabulary, a senior-engineer tone, and no em dashes, rule-of-three padding, hedging stacks, or fake analysis. It is consolidated with the Communication Standards section.

## 2026-07-04: Domain policies for accounting and academic research

`ai-policy-accounting.md` covers GAAP/IFRS, bookkeeping, tax compliance, and audit support. `ai-policy-academic-researcher.md` covers literature review, research design, statistical analysis, and publishing ethics. Both follow the standard policy structure and are listed in the validator baseline.

## 2026-07-04: Flexible expertise-name resolution

Load context resolves an expertise name by trying `ai-policy-<name>.md` first and `<name>.md` second, searching the global policies directory recursively. This handles the standard naming convention and future files without the prefix.

## 2026-07-04: The compliance directory is not scanned separately

The compliance policies directory stays defined for existence checks, but the recursive scan of the policies directory already covers it, so no procedure mentions it separately or asks permission to read it. This merges two same-day statements of the rule.

## 2026-07-04: The structural audit checks the customization gitignore entry

Load context checks `.gitignore` for `ai-customization.md` and informs the user when it is absent.

## 2026-07-04: Sync scripts auto-migrate the customization file

The sync scripts handle four cases at each target project: migrate an old in-`ai/` customization file to the root, warn and back up when both exist, verify and update the workflow directory when only the root file exists, and create from template when neither exists. The workflow directory is derived from the source `AGENTS.md` location.

## 2026-07-04: No boilerplate duplication across domain policies

Domain policies do not each restate the bootstrap-entry and path-resolution lines. One global note in the common policy covers all of them.

## 2026-07-04: Load context reports missing items; bootstrap creates them

Load context only reports missing directories and does not create them, which avoids stalling on silent creation output. The bootstrap procedure is split into a separate audit step and creation step.

## 2026-07-04: Archive and backup exclusions

Every find and list command excludes compressed and archive files. The global backups directory is never scanned, listed, or read.

## 2026-07-25: Career coaching is one consolidated policy

The four proposed career expertise names are consolidated into one policy, `ai-policy-career-coaching.md`, with the single expertise keyword `career-coaching`, because the sub-domains share persona traits, engagement style, and standards.

## 2026-07-25: The academic-researcher policy is international and domain-neutral

The academic-researcher policy is comprehensive and international, stripped of country-specific regulation and single-domain hardcoding. Retained frameworks include the Singapore Statement, ALLEA, ORI, the UK Concordat, the Australian Code, COPE, ICMJE, Helsinki, Belmont, Menlo, FAIR, and GDPR. AI-disclosure examples use a tool and vendor placeholder rather than a named vendor.

## 2026-07-28: "PR review" triggers the peer-review procedure

"PR review" is a trigger phrase alongside "peer review" and "code review". For a PR, the procedure fetches the latest refs, resolves source and target branches, and diffs source against target before scanning. A second review pass re-fetches first. The role-exit condition covers a PR that is merged or closed, and the report filename may carry an optional PR identifier.

## 2026-07-28: Reviews do not narrow to the diff

A review covers the diff, the full file or module it touches for pre-existing issues, relevant live or runtime state where tooling allows, and observability signals for the touched component. The report states plainly what was not checked, in a dedicated report section. This updates the earlier note that peer review scans the full file set rather than only a diff.

## 2026-07-28: No invented facts

Never invent people, teams, infrastructure, config values, file contents, or past decisions, and never attribute statements or actions to people never mentioned. Verify a claim against context, project knowledge, or a live source before asserting it. If no evidence exists, say so and ask. Be ready to cite the source of any fact-based recommendation. The rule lives in the always-loaded common policy.

Note: generalized and replaced by the Investigation Contract on 2026-08-31.

## 2026-07-28: READ-ONLY markers enforced on every policy file

The common policy file gained the `READ-ONLY START` and `READ-ONLY END` markers, and validation greps every policy file in the baseline for both markers. The word "robust" was removed from the banned-word list, because it is a normal word and the list was the thing that was wrong, not its use.

## 2026-07-28: Post-compaction recovery cannot be silently skipped

The recovery procedure has no silent or suppressed path, and the reload confirmation is mandatory as the first content of the reply after compaction.

Note: the anti-skip wording was simplified on 2026-07-31; the loud first-line sentinel remains.

## 2026-07-28: Identify the recovery procedure by title, not by letter

The descriptive title is the stable external identifier and a maintained contract; the positional letter may renumber freely. The validator anchor uses the title string only, and external triggers reference the title plus a one-line function description.

## 2026-07-28: The recovery procedure announces itself with a sentinel

A fixed announcement line is the mandatory literal first line of the first reply after compaction, and its absence is the visible signal that the procedure was skipped. The procedure is a self-executed rule with an honest ceiling: high reliability through the sentinel, a per-tool external trigger, and a human spot check, explicitly not a structural guarantee.

## 2026-07-28: The reload trigger lives outside the repository

The re-arming instruction lives in a per-assistant layer that is re-read every turn, such as persistent memory or always-on instructions, because `AGENTS.md` itself is dropped by compaction. It is deliberately not part of the tool-agnostic protocol. A setup guide documents per-assistant placement, and asking "did you run the post-compaction reload?" after a summary is the human backstop.

Note: for GitHub Copilot the memory trigger was later replaced by a PreCompact hook, and the memory file was deleted on 2026-07-31.

## 2026-07-31: The recovery procedure is renamed Post-Compaction Recovery

The procedure title is "Post-Compaction Recovery", matching the harness term "Compacted conversation". The title remains the stable external identifier, so the rename was applied across the protocol, the validator anchor, the external trigger, and the docs. The checkpoint archiving feature named for condensation was deliberately not renamed, because it is a different concept.

## 2026-07-31: Post-compaction recovery is a purely additive reload

The procedure loads only static rule and config files and never reads the state files. Because it only adds files and never wipes the working thread, it is safe to run automatically or on request, with no "only after compaction" guard. The one hard rule is never to read the three state files or a daily checkpoint during it. It reads the coordination file in full and indexes the rest of the shared directory.

## 2026-07-31: Compaction signals are syntactic

The trigger lists three concrete signals: the literal text "Compacted conversation", a conversation-summary block, and a session that opens with a machine-generated multi-section summary the AI did not write. Syntactic matching is more reliable than provenance inference.

## 2026-07-31: A PreCompact hook re-arms the procedure

A user-level PreCompact hook shows a warning message before each mid-session compaction, which needs no text-instruction compliance from the AI. There is no PostCompact hook, so the PreCompact warning plus the human backstop covers the gap. The earlier memory trigger file was deleted after it failed to fire on two documented occasions.

## 2026-07-31: The load report covers all customization sections

The load report states each customization file section explicitly, whatever sections the file contains.

## 2026-07-31: Configuration anchors are bold everywhere

Every reference to a configuration path variable uses the bold anchor form, so the AI cannot miss it.

## 2026-08-05: Policy files do not use procedure letters or step numbers

Policy files reference procedures by a plain descriptive phrase or by the procedure's stable title, never by a positional letter or step number, which silently break when procedures are renumbered or renamed.

Note: updated 2026-10-06 to allow the canonical all-caps procedure name.

## 2026-08-08: State files live in `ai/state/`

The three state files move into `ai/state/`. The state-files anchor keeps its name and resolves to the directory, so existing anchor usages are unchanged. State files are append-only and keep summaries only, with an HTML comment header near the top stating each rule. Migration is by a git move in this repo and by the sync scripts in user projects, idempotently.

## 2026-08-09: Writing style is a distilled guide in global knowledge

A distilled writing-style guide captures the voice, a do-not-copy list, and an index of the style sources. The raw example corpus is not stored, so the always-loaded knowledge set stays small.

Note: the guide later moved into the always-loaded global user settings file on 2026-10-06.

## 2026-08-09: Custom-policy discovery in the policies directory is intentional

Loading every policy file found in the project policies directory is correct, because in an ordinary project that directory holds user-created custom policies meant to be loaded.

Note: for the workflow repository this was superseded on 2026-08-22.

## 2026-08-22: Protocol Developer Mode loads only active-expertise policies

In Protocol Developer Mode the AI loads only the common policy plus the policies listed under Active Expertise, and skips the recursive scan of the policies directory, which is the protocol's full distribution tree. This supersedes the 2026-08-09 accepted-artifact decision for the workflow repository only. Ordinary-project discovery behavior is unchanged.

## 2026-08-24: Full reads and no truncated evidence

Read every working file in full to end of file; only log-like bulk data such as logs, dumps, and large data files may be sliced by filter. Never pipe investigation output through head or tail, because that silently drops evidence.

## 2026-08-24: External system mutations need explicit approval

Propose the exact text and wait for approval before any mutation of a remote system of record such as an issue tracker, code host, wiki, or chat tool. This generalizes the local no-side-effects gate to remote systems.

## 2026-08-24: The state-file model is per file, not global append-only

Next-steps is forward-only with delete-on-done; progress is append-only history with archiving; context is the present, edited in place. Each item is one or two lines with no sub-bullets, transcripts, or rationale. A bloat and order check reports and proposes before rewriting. Insertion is always append at the tail, and deletion removes a completed item wherever it sits. State-file headers state each file's nature and that it is not a runbook, plan, or ledger.

## 2026-08-25: Pre-Work Gate before any work item

Before starting a work item, complete scope discovery (a missing repo counts as archived or decommissioned, not out of scope), acceptance-criteria review, HLD and LLD, removal safety, an optional external pre-work announcement, and framework alignment. The HLD and LLD are created only after proposing them and getting agreement, in line with the no-side-effects norm. Depth scales with the work item's size and risk.

## 2026-08-25: Acceptance criteria are the work-item contract

Review acceptance criteria before design and flag any that are missing, ambiguous, not independently testable, or contradictory. Confirm every criterion traces to an LLD item or the LLD is incomplete. A dedicated living acceptance-criteria guide is not mandated; recurring patterns are noted in project knowledge at checkpoints.

## 2026-08-25: Full file reads are an unconditional mandate

A read-first-rules mandate requires every file read for comprehension to be read from line 1 to end of file, with a re-read from disk when a task needs a file already in context. The only exception is bulk data being searched. When a read drives a decision, the AI states the file and its line count as observable proof. The load report requires line counts. The validator guards the mandate with an anchor.

## 2026-08-25: Non-Negotiables index in the common policy

The common policy opens with a short six-item Non-Negotiables index of the highest-cost rules: full reads, no truncated evidence, evidence before assertion, approval before side effects, secrets check, and protected-branch approval. It is capped at six and indexes rules that already have their own detailed sections.

## 2026-08-25: Quality findings are phrased by intent, not metrics

Quality findings state the single job a piece of code should have, never a bare metric. This applies in the common-policy guardrails and in the reviewer role, because models game bare metrics.

## 2026-08-25: Agree on shared understanding before building

For feature or architectural work, reach a shared design concept with the user before creating files or writing implementation. This is an item in the Pre-Work Gate.

## 2026-08-25: The ubiquitous-language file idea is dropped

The standalone ubiquitous-language file is not adopted, because the design documentation standards already cover a glossary and a hardcoded filename would break on user machines.

Note: superseded by the broader cost/benefit drop of both ubiquitous language and ontology on 2026-08-31.

## 2026-08-25: Root-only protocol files

`AGENTS.md` and `ai-customization.md` are honored only from the project root and are ignored elsewhere in the directory tree.

## 2026-08-25: Markdown lint tooling

Markdown linting uses markdownlint-cli2 with a config that disables style-noise rules and keeps real checks. The tool is recorded in the global settings tool list.

## 2026-08-31: Ubiquitous language and ontology are dropped

Both the ubiquitous-language system and the ontology approach are dropped, because the value is far less than the effort to build and maintain them. This supersedes the narrower 2026-08-25 rationale and is treated as resolved, not a new idea to re-litigate.

## 2026-08-31: Evidence-based investigation is default behavior

Evidence-based investigation is placed in two layers. A short always-on read-first-rules instruction says to investigate before asserting, with no claim without a source, and points at the Investigation Contract in the common policy. The contract defines wide-scoping as the subject plus its cone of influence, and it requires every claim to name its source, or to appear as "not verified" with a question, so an unsourced claim cannot be produced without a visible marker. Full reads and no-truncation stay as their own mandate and are referenced, not restated. The wording is domain-adaptive, so the AI reasons instead of following a finite checklist.

## 2026-08-31: `AGENTS.md` is a router, not a catalog

Do not apply the two-layer pattern to every rule; it is only for universal always-on mechanics. Three activation mechanisms keep `AGENTS.md` thin: the read-first-rules tier for universal always-on mechanics, triggered procedures that each load a self-contained policy, and Active Expertise for persistent domain behavior loaded at boot. Placement test: a rule that applies to every task and is costly to break goes to the read-first-rules tier, which is rare; situation-specific behavior gets its own policy; an explicitly invoked procedure goes to triggered procedures.

## 2026-08-31: Evidence-proposal items evaluated

The provenance-tagging item and the knowledge-file factual-review item are skipped. The decision-driving-fact gate is already covered by the contract. An "old-knowledge distrust" clause was added and removed the same day, because it broadened distrust to all stored knowledge, contradicted the authoritative stance of project knowledge, and read as an essay; the lesson is covered by the existing authority of project knowledge plus the mandatory checkpoint knowledge update.

## 2026-08-31: The design-document chain has a review gate

The chain is notes, vision, PRD, HLD, LLD, ADRs, and delivery ledger. Before creating the next document, the AI runs a gap analysis and peer review on the existing documents and resolves every finding. One document at a time; never skip from notes or vision straight to implementation. This is a small common-policy item, not an `AGENTS.md` change.

## 2026-08-31: The protocol's own design docs are deferred

The protocol will get its own vision, PRD, and a delivery ledger (ledger first). `protocol-decisions.md` serves as the ADR store, so ADRs are not recreated. A lean HLD is added, and an LLD is built per module as the protocol is tightened. Deferred.

## 2026-09-09: The checkpoint procedure writes the daily checkpoint file

The checkpoint procedure gained a step that writes the daily checkpoint file, which previously no procedure wrote, while the load-time checks already assumed a current file existed. The convention is one file per calendar day, with multiple titled sections appended for same-day checkpoints.

## 2026-09-09: `ai/issues/` is a formal project directory

`ai/issues/` is a project issues directory in the configuration, indexed at load context and reported in the load report. Status is a filename prefix in one flat directory, chosen over a content status field that would require opening every file and could drift.

Note: superseded on 2026-09-17, which moved status into directories.

## 2026-09-10: Issue filenames carry only status and slug

The filename pattern is `<status>-<slug>.md`; priority and size live only in the issue header fields, because those values change and a filename rename would create a dual source of truth.

Note: superseded on 2026-09-17, which removed status from the filename entirely.

## 2026-09-10: Recorded commit-hash lag is expected

A recorded commit hash is always at least one commit behind immediately after its own commit, because a commit cannot contain its own hash. This is documented as expected, not a defect.

Note: removed on 2026-09-19 when state files stopped recording version-control facts.

## 2026-09-10: Stale transient status notes are removed from this store

Transient commit-status notes and point-in-time snapshots are removed from the decision store. No horizon shield or archive is added to it, and large same-day streams are not merged without a dedicated slow pass.

## 2026-09-17: Issue status is the directory location

Tickets live under `ai/issues/` in `open/`, `in-progress/`, and `closed/`. A ticket's directory is its status; there is no status field and no file directly under `ai/issues/`. The filename is the slug only and never changes. A ticket reaches closed only when its fix is merged. The load report indexes `open/` and `in-progress/` by filename and line count and ignores `closed/`. Bootstrap and load context ensure the three directories and the issue template. A triggered issue-management procedure handles create, start, close, reopen, and list. The mechanism and a compact field list live in the always-loaded common policy; the full formatted template lives in project knowledge and is created only when missing.

Note: supersedes the 2026-09-09 flat-directory prefix decision and the 2026-09-10 filename decision. It also reverses the earlier rule that load context only reports missing directories, by permitting one deterministic creation loop inside the read-only safety barrier.

## 2026-09-19: State-File Model v2

State files describe work, never version control, and the AI does not prompt about committing them. Daily checkpoints are the only archive; the progress and context archive files were deleted after a verified no-loss migration. Trimming uses a size budget of 20 KB total (context 8 KB, progress 7 KB, next-steps 5 KB) rather than fixed counts; the budget wins over the 14-day window; an unfinished next-steps item is never dropped. Checkpoints have no IDs and are labeled by date and short title. Each state file has one rule comment line, with presence checked at load. Context is the present, a status dashboard plus an active-working-context section, edited in place. Load context checks order, budget, comment, and diary mirror and reports in the load report; a repair procedure ("repair state files") reorders, trims, and repairs, writing a missing diary mirror first. Local sources precede the model's knowledge, the web, and official docs, with a bounded probe. Post-compaction recovery never reads the state files and never runs detection or repair.

Note: reverses the fixed-count horizon shield and its two archive files, checkpoint IDs, and the recorded-commit-hash note.

## 2026-09-19: The Investigation Contract has a self-consistency check

Before finalizing an edit, re-check any new or changed claim against the other sections already read this session and the source it derives from. Resolve or flag contradictions. The wording uses "claim", so cosmetic edits do not trigger it. The rule is behavioral prose in the common policy, with no `AGENTS.md` change and no validator anchor.

## 2026-09-19: Backlog triage decisions

Workflow capability must not depend on external tools; the parallel planner is dropped, matching the codebase-examination ban on external indexing tools. Wayfinding (fog-of-war planning) is skipped as duplicative of the state files and the plans directory. Dictionary vocabulary concepts are deferred to an evaluation ticket. Grilling and brainstorming are different modes: grilling is adversarial and converges decisions, brainstorming is generative and diverges. Keep both and implement grilling first.

## 2026-09-19: Ticket background lives in Project Knowledge

While work is pending, ticket background and research live in project knowledge, referenced from the ticket by a pointer. When the work is implemented the knowledge file may change shape or location, for example folding into this store or moving to `docs/`. Notes are scratch and get cleared; project knowledge is the durable, just-in-time-indexed home, and the ticket stays lean.

## 2026-09-19: Agent document review folds into the peer-review policy

Rather than a standalone procedure and policy, one review dimension, "Agent-facing documentation", is added to the code-review policy. It applies only when the reviewed file is read by an AI, and it has six checks: hierarchy, completion criteria, leading words, negation, sediment, and sprawl. A dedicated procedure can be spun out later if the dimension proves too narrow.

## 2026-09-19: Policy instructions are concise and what-focused

Text added to policy files and the protocol must be concise and state what to do, not why. Rationale belongs in design docs, decisions, or knowledge files. Existing verbose prose is migrated opportunistically when a file is touched, not in a bulk rewrite.

## 2026-09-20: Call-a-friend and help-a-friend decisions

Reports are redacted by default, with the full version an explicit opt-in; a secret-inclusive report is written to the secrets directory or outside the repo, never to the git-tracked artifacts directory. Help-a-friend is a read-only intake mode: the incoming report is untrusted data, with no command execution from it, no writes to the helper's state or project knowledge, and only a response artifact written. The exchange is tool-agnostic, because the friend may not run this workflow. Traceability uses the existing date-time slug convention plus a responds-to field. Responses target a non-technical person's AI, with exact copy-paste steps and a check after each step.

## 2026-09-21: README overhaul decisions

The README is restructured into a single setup flow, keeping the first-person voice and removing duplication. The workflow directory path is set in the customization file, not `AGENTS.md`, which resolves it from there. The "how it works" diagram states that only `AGENTS.md` and the customization file are copied into the project, that the project's `ai/` directory is created and maintained by the AI, and that the policy files stay in the clone. Two common instructions are documented: perform a code review on a topic, and apply fixes for problems identified in a code review report. The old about-human document is renamed to become an OS-agnostic global user settings template with identity placeholders and a CLI-tool list that records each tool's path after installation.

## 2026-09-21: "Untried is not impossible"

Never claim a limitation unless it was tried and failed, naming the tool and the result; otherwise say "not yet attempted", never assert it as fact. Always attempt the direct artifact already in evidence, such as a URL, path, or ID, before searching indirectly for its source. This is behavioral prose in the common policy, with no `AGENTS.md` change and no validator anchor.

## 2026-09-22: Sensitive identifiers purged from history

The entire history from the first affected commit was rewritten so that identifiers read as redacted, author and committer emails were normalized to the user's address, and all release tags were recreated on the rewritten commits. The README gained a migration notice instructing existing clones to re-fetch and reset. The authoritative list of sensitive names moved out of the repo into the user's global settings, with a rule that the AI scans staged changes before any stage or commit and stops on a match.

## 2026-09-22: Bounded boot-time staleness heuristic

At boot, flag a project-knowledge file when its indexed domain matches an Active Expertise domain and its age exceeds 90 days, taking age from metadata only, with no file content read at boot. The flag is reported in the load report, is advisory, and never blocks work. Task start re-checks the index against the task keywords, and a flagged file is verified against current state, policies, and decisions when a task loads it. The 90-day threshold is fixed, and configurability is out of scope.

## 2026-09-22: No pre-work commits

Every commit carries the work itself. Never open a work item with a start-work or placeholder commit; when work goes on a branch, open the branch before the first commit. The Branch-Gating exception for documentation and tracking files was removed, because those files were never in Branch-Gating's scope. Every protocol or policy change adds a dated entry here, and a protocol change is not committed without it. Direct commits to the main branch remain allowed under the protected-branch approval rule.

## 2026-09-22: Documentation cleanup decisions

The tool-preferences document was removed, with its tool list living in the global user settings. One-time or implemented artifacts, such as the history-purge plan and the self-consistency LLD, were removed after use. Documentation and knowledge maintenance only, with no `AGENTS.md` or policy change.

## 2026-10-06: Global Knowledge returns to just-in-time indexing

Global Knowledge is indexed at boot, at checkpoint reload, and at post-compaction recovery, and read in full only when a task needs it, in the same step as Project Knowledge and reported as two separate sets. The bounded staleness check extends to Global Knowledge. Global Knowledge files stay per-domain and descriptively named; a file that mixes domains must be split, because the filename is the lookup key. Active policies remain full-loaded, because policies are operational rules and are never deferred.

Note: reverses the Global Knowledge half of the 2026-06-30 full-load decision and returns to the 2026-06-18 model. The writing-style guide later moved into the always-loaded global user settings file, so the voice rules are always present.

## 2026-10-06: Procedures, steps, and tiers have stable names

Every procedure, top-level step, referenced sub-step, and tier has a stable all-caps kebab name, for example PROCEDURE LOAD-CONTEXT and TIER TRIGGERED-PROCEDURES. Names never renumber and are decoupled from position, so the protocol can be reorganized without a cascade of broken references. Protocol files reference entities by canonical name; users use plain phrases; each procedure header lists the phrases that resolve to it. Letters are dropped and leading step numbers are a visual cue only. Load-report items are named. A common-policy rule requires canonical-name references, backed by a validator guard and a reference-integrity test. Historical decision prose keeps its step numbers, translated by the migration map.

## 2026-10-06: Friendly release announcements live in `docs/announcements`

`docs/announcements/` holds one short announcement per release, without an index file. The GitHub Release is the exhaustive authoritative changelog; the announcement is a short friendly summary that links to the release and is also the source for the release email; the README banner links to the latest announcement.

## 2026-10-12: Issue-management policy upgrade

The Issue Management Protocol covers a creation channel (local or an external tracker), a Label field for insufficient-information or unworkable tickets, minimum prose, pre-work analysis through brainstorming or grilling, a refuse-even-if-insisted rule, a plan mandate with a dated-comment link, conditional test-first development, size-based plan depth (small: context and acceptance; medium and larger: HLD, LLD, acceptance, ADR), plan review with ADRs, and the merge sequences. Local work is close, squash-merge, delete branch; external work is merge first, then close. The delivery ledger stays in the design documentation standards and is not referenced by the issue rules. A test-first bullet was added to the universal testing standards.

## 2026-10-12: ADR entries are self-contained

An entry states the decision, its context, and its consequences in plain language and depends on no commit hash, branch name, removed plan file, or non-committed report. A pointer that breaks makes the record's content unreachable, and a history rewrite falsifies every recorded hash. The standard lives in the design documentation standards and the Protocol Developer Mode mandate, and the existing ledger was repaired to it. This entry is the standard the decision store itself follows.

## 2026-10-12: Markdown Output policy consolidated

A single Markdown Output section in the common policy holds every universal markdown-mechanics rule: headings, lists, code fences, tables, links, emphasis, line length, filenames, and validation. Linter conventions are stated in linter-agnostic terms that a user can reproduce in any linter. Prose style stays in Humanized Output and is cross-referenced; personal preferences stay in the customization file. Enforcement is going forward: new and edited markdown must pass; existing files are fixed when touched or on request.

## 2026-10-12: Tables are banned in protocol files, allowed in user-facing docs

Markdown tables are banned in protocol files, including `AGENTS.md`, policies, issues, and plans. Tables are allowed in slides and in user-facing documentation when they aid clarity, and whenever the user asks for one. This refines the Markdown Output entry.

## 2026-10-12: Author identity and identifying names

Never use an AI, model, or harness name, or a generated email, as the author or sender. Use the user's identity, resolved from project git config, then the global git config, then the global settings name and email fallback. The rule binds sub-agents and non-orchestrator sessions. The secrets check extends to identifying names, with neutralization using generic phrases. Reusable git conventions and a git-configuration template with an adequacy checklist live in the universal engineering standards, and the setup offer is wired into bootstrap and load context as offer-only, with no write.

## 2026-10-12: Grilling mode

A Grilling section in the common policy is the convergent shared-understanding mode, with a trigger phrase ("grill me on this"), an interviewer role, a recommended answer per question, design-tree rounds, a one-paragraph output gist, and a stop condition. It is cross-referenced from the Pre-Work Gate. No separate policy file and no `AGENTS.md` procedure.

## 2026-10-12: Brainstorming mode

A Brainstorming section in the common policy is the divergent mode, with a trigger phrase ("brainstorm this"), a generative-partner role, no criticism during divergence, deferred judgment, clustering, a grouped output list with a shortlist, and a handoff to Grilling or a design document. It sits next to Grilling. No separate policy file and no `AGENTS.md` procedure.

## 2026-10-12: Design documentation standards

The document chain is notes, vision, PRD, HLD, LLD (with acceptance criteria), risk and gap analysis, ADRs, and delivery ledger. LLD is written as "LLD (with AC)"; acceptance criteria are a coupling rather than a container, so small work keeps AC without an LLD. Risk and gap analysis is a tracked artifact with risk identifiers. ADRs record genuine design decisions only, never a changelog or an external reference. New projects gather enough requirements for an MVP and then iterate. Large solutions may use layered design documents. Depth is proportional and role-aware. Design documents live beside the code in `design-docs/`, never under the private `ai/` directory.

## 2026-10-12: Design docs location and boot indexing

Design documents live in `design-docs/` beside the code. Single repo: project-root `design-docs/`. Multi-repo: solution documents and a rollup at the project root, and each component's documents in its own repo. The delivery ledger lives in `design-docs/`. Boot indexes every `design-docs/` under the project root, just in time, at most five levels deep, with heavy trees pruned, archives skipped, and read-only, reported as the design-docs index load item. Scanning `design-docs` by name is the standing exception to the unprompted-exploration ban. Migration from the old location is optional: detect and offer at load context, and a "migrate design docs" trigger moves files with approval.

## 2026-10-12: The protocol ADR store relocated

The protocol's ADR store is `design-docs/protocol-decisions.md` at the protocol repository root, not under `ai/`, because design documents live beside the code and the store is a design document. The store is tracked, since `design-docs/` is not git-ignored.

## 2026-10-12: The decision store holds decisions only

The store records genuine design decisions in a short decision, context, consequence shape. Session bookkeeping (status, merge records, files changed, verification notes, review counts, commit and branch details) is not kept here; it lives in the daily checkpoints. The store was reduced from 1763 lines and 73 dated entries to this curated form.

## 2026-10-12: Open the branch before editing

Open the branch before making any file change on a work item, not merely before the first commit. Editing first and branching later risks changes landing on the trunk and breaks the single-branch rule. This refines the 2026-09-22 no-pre-work-commits decision.

## 2026-10-13: A plan is not a design document

A plan is not a design document. Plans live under `ai/` (for example `ai/plans/`), never in `design-docs/`, and carry their own HLD, LLD (with AC), and ADR content inside the plan file. Design documents (vision, PRD, HLD, LLD, risk and gap analysis, ADRs, and the Delivery Ledger) are the solution's durable design and live in `design-docs/`; a plan is temporary and its lifecycle is attached to the issue it is created against. The AI must not suggest moving plan files into `design-docs/`.

## 2026-10-13: Markdown lint ignores local-only directories

The markdown lint config ignores the git-ignored local directories (`ai/secrets/`, `ai/code-review-reports/`, `ai/artifacts/`) and `ai/daily-checkpoints/`, because these hold local-only working artifacts rather than shipped or living markdown. The shipped and living set (`ai/policies/`, `docs/`, root markdown, and `ai/shared/project-knowledge/`) was brought to zero lint issues in a one-time pass. Markdown enforcement stays going-forward for all other files. `ai/issues/` and `ai/state/` remain part of linting and were brought to zero issues in a follow-up pass.

## 2026-10-13: No em dashes in the shipped and living files

The shipped and living markdown (policies, docs, root markdown, and project knowledge) carries no em dashes. Each was replaced by a comma, colon, or parentheses as fit, not by a blind swap. This applies the Humanized Output no-em-dash rule to the existing corpus. The lint-exempt local directories and the historical issue and state files are out of scope.

## 2026-10-13: pull.rebase is a recommendation; defaultBranch is never overridden

The gitconfig templates in `ai/policies/ai-policy-common.md` and `docs/global-user-settings.md` include `[pull] rebase = true`. It is a recommendation, not part of the config adequacy check. For a new config the AI sets `defaultBranch` to `main`; it never changes a `defaultBranch` that is already set, and never enforces `main`.

## 2026-10-13: Universal writing rules live in the common policy

The universal communication and writing-style rules live once, in `ai/policies/ai-policy-common.md` (`Humanized Output`, `Markdown Output`, and the ticket-file scope rule). The user's `~/.ai/settings/global-user-settings.md` and the template `docs/global-user-settings.md` hold only personal preferences. Two rules moved from the settings into the policy: no decorative symbols, and a conversational-by-default style. Personal voice, anecdotes, sign-off style, the personal word list, and Style Sources stay in the settings.

## 2026-10-13: One "checkpoint" runs all upkeep

`PROCEDURE WRITE-CHECKPOINT` is the single umbrella for upkeep. One `"checkpoint"` runs, in order: the state files (one atomic write), the diary, state-file trimming, project knowledge, global knowledge, a report-only housekeeping and stale-knowledge pass, and a grouped report. The single-step aliases `"update project knowledge"` and `"update global knowledge"` run just their step. The state-file write and the diary run first and always, and a later failure never prevents them. The checkpoint never runs git and never reads or writes design documents, which stay pure and are handled only by a separate, confirmation-gated procedure.

## 2026-10-15: User-facing docs explain why the full trigger phrase is required

The README explains why the full phrase "... using AGENTS.md protocol" is required, in a subsection below the common-instructions list. A bare "load context" reads the assistant's own hidden memory rather than `AGENTS.md`, and a shortcut cannot work, because it would have to live inside a protocol the assistant has not read yet. The slides and the guides that teach the command carry the same explanation or point to the README. No alias is suggested, because an alias cannot work for the same reason. The explanation is written warm and in plain language, not in the tone of the original ticket.

## 2026-10-15: The update design documents procedure

A new triggered procedure, `"update design documents"` (alias `"update design docs"`), writes and updates design documents. It is defined in `AGENTS.md`, with its detail in a new policy `ai/policies/ai-policy-design-docs.md` loaded only on the trigger, because design-document work is infrequent and does not belong in the always-loaded common policy. The procedure is confirmation-gated: it proposes a change set, challenges each design decision, and shows a per-document diff before writing. It never writes operational bookkeeping into a document, and the checkpoint never invokes it.

Design documents use a fixed lowercase doc-type vocabulary (`vision`, `prd`, `hld`, `lld`, `risk-and-gap-analysis`, `delivery-ledger`, `adr-<nnn>-<short>`), with acceptance criteria coupled to the LLD. Names are in suffix form: migrated documents in `design-docs/` use the simple name, and unmigrated documents under `ai/shared/project-knowledge/` carry a project token. Scope comes from the directory location, never from a filename alone, and no manifest is kept.

The update procedure writes in the location the project currently uses and never moves a file between locations. The trigger `"migrate design docs"` is the only cross-location mover, as a small separate procedure that lists each file and its target, shows the git impact, and moves on approval. A design file found in the fallback location is moved, never copied, and embedded design content is extracted with a one-line pointer left in the source. A firm user decision on the location may be recorded in `ai-customization.md` under `## Design Docs` with a `**Location**:` entry, written only on explicit instruction; a detected decision is recorded in project knowledge so it is not lost.

The Delivery Ledger is updated when a design document lands or changes, by this procedure, never at checkpoint. This resolves the earlier contradiction with the checkpoint rule that design documents stay pure. Post-compaction recovery and the checkpoint re-affirmation now index the global knowledge directory, the project knowledge directory, and every `design-docs/` directory up to five levels, closing the gap where recovery did not index design documents.

## 2026-10-18: Procedure and policy authoring standard

`ai-policy-meta.md` gains a `## Procedure and Policy Authoring` section as the single normative standard for `AGENTS.md` and policy files. A policy places the DO NOT MODIFY guard on the first line, then the READ-ONLY START marker, then the title `# AI Policy: <Domain>`, and includes one purpose sentence, `## Scope`, `## Rules` or domain-named sections, and `## References`. Rules use one sentence per bullet in the imperative mood, with no rationale, history, narrative, or nested bullets, and no `## Purpose` or `## Notes` headings. Examples are allowed only as non-normative fenced blocks. Normative text uses `must`, `do`, `do not`, `never`, and `always`; `should`, `prefer`, `consider`, and `try` are banned; `may` is allowed only with a defined condition and default; vague qualifiers and undefined terms are banned; and every judgment rule names its criteria and default. The common policy remains authoritative for markdown mechanics, writing style, filenames, and side effects, and the new section points to it instead of repeating it. Procedures keep the `### PROCEDURE <NAME>` header and `**Aliases**` line, have no `**Loads**` line, load a dedicated policy in their first step, and use at most three aliases for a new or touched procedure. New and touched files follow the standard; untouched files are not rewritten.

Enforcement is peer review plus a new `support-files/validate-policy-authoring.sh` run on changed files. The validator checks the DO NOT MODIFY guard on the first line, the READ-ONLY marker order, the title, the presence of a purpose line, `## Scope`, `## References`, domain sections, procedure metadata, and trigger uniqueness. It accepts the common policy's existing `# AI Assistant Policy:` title until that file is touched. It rejects a `## Triggers` section until the plugin model lands. The main validator keeps its 8/8 baseline. The first application rewrites `ai-policy-meta.md` to the standard and changes its title to `# AI Policy: Meta`; the filename remains `ai-policy-meta.md`, and a rename is a separate decision. The rewrite removes the `## Purpose` heading and the non-normative `## Suggested Assistant Prompt` section, replaces the requirement to update the state files for every prepared change with reporting on the coordination board and writing state files only through PROCEDURE WRITE-CHECKPOINT, and replaces the automatic pre-update backup with the explicit `"backup ai"` trigger.

## 2026-10-21: The code authoring policy ships before the plugin

The code authoring policy governs how the AI writes and changes program code in any language. It activates when the project customization file lists `code-authoring` under Active Expertise or when the user asks for it by name, stays active for the session, and never changes existing code on activation. New code follows the policy. Existing code changes only inside the requested scope, with no mass rewrite, unrelated reformatting, or drive-by cleanup. Telemetry is mandatory whenever the policy is active: services, APIs, workers, and scheduled jobs emit latency, traffic, errors, and saturation; command-line tools and one-off scripts emit structured logs. Export failure never fails a request, metric labels stay bounded, and the collector and backend stay with the infrastructure owner. The policy carries the emission obligation and code-level rules, while `ai-policy-observability.md` keeps the signal definitions, thresholds, retention, sampling, and alerting. The `## Triggers` declaration and its dispatch are deferred to the plugin v0, so the policy ships without that section and the authoring validator stays unchanged. Consequence: activation is through Active Expertise or the policy name until the plugin lands.

Note: revised later on the same day; see the entry below.

## 2026-10-21: The coding policy renames and makes telemetry opt-in

The policy is `ai-policy-coding.md` with expertise token `coding`, because users type the short token. It governs how the AI writes and changes program code in any language. Telemetry is requested, not imposed. The AI asks whether to add telemetry when the project has no telemetry standard or the code is non-production code. It treats examples, exercises, one-off scripts, and throwaway prototypes as non-production code. It defaults to no for non-production code and to yes for production applications. It waits for the answer and applies it for the session, and it skips telemetry when the user says no. When telemetry is enabled, the application emits the Four Golden Signals and structured logs, export failure never fails a request, metric labels stay bounded, and the collector and backend stay with the infrastructure owner. `ai-policy-observability.md` keeps the signal definitions, thresholds, retention, sampling, and alerting. The `## Triggers` declaration and its dispatch remain deferred to the plugin v0. This revises the policy name and the telemetry obligation recorded in the entry above.

## 2026-10-21: The coding policy gains an operational baseline

The coding policy states a concrete action for each practice it covers. It adds operational rules for resilience, configuration, dependency supply chain, cryptography, time handling, test quality, caching, log levels, named constants, and public contracts. Domain policies keep the detail for API idempotency and retries, contracts, encryption and key management, accessibility, observability, caching, and dependency injection. A Project Knowledge note, `coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`, maps each shared practice to its owner and the coding policy rule, so the two can be reconciled. The policy names the action and points at the owner for detail, so it does not become a second source of truth.

## 2026-10-21: The coding policy becomes a thin core with pointers

The coding policy is reorganized so it is not a multipage essay and does not restate rules owned elsewhere. It keeps a thin core of code-construction rules it uniquely owns: module and interface design, functions and naming, data and state, configuration, errors, concurrency, comments, and the telemetry gate. Every cross-cutting concern becomes a one-line pointer to its owner: SOLID, DRY, YAGNI, Twelve-Factor, TDD, and secure development point to the common policy; telemetry emission points to the observability policy; idempotency, retries, and caching point to the api-backend and mobile policies; encryption and key management point to the data and DBA policies; accessibility points to the web-frontend policy; and scripting and IaC point to the cloud, Linux, and Windows policies. The owner loads when that concern is touched. This revises the operational-baseline decision in the entry above. The reconciliation note records the same ownership map.

## 2026-10-21: The coding base policy dispatches to the domain policies

The policy is renamed to `ai-policy-coding-base.md` with expertise token `coding-base`, because the name signals a base layer and not the whole stack. Its Scope states that it does not replace a domain policy, and that the AI loads and follows the domain policy that owns the concern at hand. The cross-cutting pointers become read instructions: read the web-frontend policy before UI code, the api-backend policy before a service or API, the mobile policy before mobile code, the data and DBA policies before data or schema code, the cloud, Linux, and Windows policies before IaC or scripts, and the observability policy before telemetry code. A user can enable `coding-base` alone and the AI still pulls the right domain policy on demand, with no full preload. The universal baseline stays in the always-loaded common policy. This revises the name and dispatch recorded in the entries above.

## 2026-10-21: The coding baseline policy defaults telemetry on for production code

The policy is named `ai-policy-coding-baseline.md` with expertise token `coding-baseline`, because "baseline" signals the default coding standard that domain policies extend. The policy is opt-in. Telemetry is no longer opt-in for production code: the AI classifies the scope as production or non-production, treats an ambiguous scope as production, states the classification and recommendation before writing code, and adds telemetry for production unless the user declines. Tests, examples, exercises, one-off scripts, throwaway prototypes, and command-line tools that are not services, APIs, workers, or scheduled jobs stay telemetry-free by default. A declined decision is recorded in the response. Adding a new telemetry dependency still needs approval. The policy remains a thin core with read pointers to the domain policies. This revises the opt-in telemetry decision and the `coding-base` name recorded in the entries above.

## 2026-10-21: The observability policy absorbs the emission rules

`ai-policy-observability.md` is rewritten to the authoring standard: title `# AI Policy: Observability and Reliability`, a purpose sentence, `## Scope`, `## References`, domain-named sections, and definitive rules. It keeps the Four Golden Signals and the three pillars, and it now owns the emission detail that `ai-policy-coding-baseline.md` points at: structured logs, trace context, correlation identifiers, bounded metric labels, log levels, health and readiness, the startup record, and the missing-signal defect rule. It also keeps retention, sampling, alerting, and validation. No rule is removed. The two code-level rules (keep telemetry out of business logic and never fail a request or job on export) stay in the coding policy.

## 2026-10-21: The common policy and coding-baseline state their ownership boundary

The common policy now has a `## Scope` section and a `## References` section. It states that `ai-policy-coding-baseline.md` owns code-construction operations while common owns the engineering principles. The coding-baseline Scope states that common owns the principles it applies. The domain migrations reference common for TDD and express coverage by intent. The generated-file validation boundary stays: common owns all file types, and coding-baseline owns code tools. No rule is moved or removed.

## 2026-10-21: The web-frontend policy follows the authoring standard

`ai-policy-web-frontend.md` is rewritten to the authoring standard: title `# AI Policy: Web Frontend`, a purpose sentence, `## Scope`, `## References`, domain-named sections, and definitive rules. It keeps component composition, semantic HTML, accessibility, loading and error states, form validation, derived state, dependency discipline, responsive behavior, design-system reuse, URL and local storage state, and the UI test suite. The `80%` coverage target is replaced with behavior-based coverage, and the TDD mandate references the common policy. No domain rule is removed.

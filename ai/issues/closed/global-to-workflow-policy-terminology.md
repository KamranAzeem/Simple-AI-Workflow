Reported: 2026-11-23
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Normalize the Workflow, User, Team, and Project scopes and move the knowledge stores to the unprefixed knowledge directory

Description:
The terms project, global, workflow, and team overlap. "Global policies" means the policy tree in the workflow clone, while "global settings" and "global knowledge" live in the user directory. The name creates confusion.

Proposed direction:

- Use "workflow policies" for the policies shipped in the workflow clone.
- Use "project policies" for the project-local tree.
- Keep "global settings" and "global knowledge" for the user-space stores.
- Keep "team knowledge" and "team skills" for the team store.
- Decide whether the path anchor becomes "Workflow AI Policies Directory" or keeps "Global AI Policies Directory" with a documented alias.
- Update `AGENTS.md`, the common and meta policies, every procedure, docs, tests, validator anchors, index output, knowledge, and the ADR.
- Keep behavior unchanged; this is a terminology and naming migration, not a loader redesign.
- Provide a migration table for old and new terms, plus a compatibility note for existing projects.
- Decide the release and whether any deprecated aliases are allowed.

Open questions:

- Exact canonical term: "workflow policies" or "workflow policy layer"?
- Does "workflow policy" include the common policy and procedures, or only the distribution policy tree?
- Does the path key change, or only the prose?
- Is a major or minor release required?
- How long do the old names remain valid in docs and tests?

These are settled in the Confirmed decisions section below.

Acceptance criteria:

- One canonical term is defined and used consistently.
- No reader can confuse workflow policies with global settings or global knowledge.
- `AGENTS.md`, policies, procedures, docs, tests, validator, index, and knowledge are updated.
- An ADR records the decision; the old terms have a migration note.
- No behavior change; the suite and validator pass.

---

2026-11-25

## Scope normalization decisions

The ticket broadens from policy terminology to the full scope vocabulary and the knowledge and skills directory layout. The original Description and open questions stay as the starting point. This section records the decisions and the discussion.

### Scope model

- Four areas: Workflow (the clone), User (home or network path), Team (team repository), Project (project root).
- Retire "Global" as a scope word. The target is that no scope label uses "global" anywhere.
- Discussion: some occurrences are generic English, for example "global search" or "global variable". Classify every occurrence and rename keys, headings, and paths. Do not blind-replace generic prose.
- Owner-prefix key names:
  - Workflow AI Directory (was Global AI Workflow Directory).
  - Workflow AI Policies Directory (was Global AI Policies Directory).
  - Workflow AI Skills Directory (was Global AI Skills Directory).
  - User AI Directory (was Global AI User Directory). Resolved from the customization file; it may be under the home directory or on a network drive.
  - User AI Knowledge Directory: `<User AI Directory>/knowledge`.
  - User AI Skills Directory: `<User AI Directory>/skills`.
  - User AI Settings Directory: `<User AI Directory>/settings`.
  - User AI Backups Directory: `<User AI Directory>/backups`.
  - Project AI and Team AI keep their scope names.
- Directory names carry no scope prefix. Scope comes from the owner and the location.

### Directory layout

- User AI Directory has four siblings: `knowledge/`, `skills/`, `settings/`, `backups/`.
- Team repository: `knowledge/` (was `team-knowledge/`) and `skills/`.
- Project: `ai/knowledge` (was `ai/shared/project-knowledge`) and `ai/skills`.
- Workflow: `ai/policies`, `ai/procedures`, and `ai/skills`. It has no knowledge or settings store.
- `ai/shared/` keeps `coordination.md` and `handoffs/`.
- `ai/shared/knowledge` is rejected. Move directly from `ai/shared/project-knowledge` to `ai/knowledge`.

### Why `ai/knowledge`

- `shared` is a label, not a mechanism. Agents in the same project root already share `ai/`. Separate Agent Manager worktrees do not share it because of the folder name.
- A future shared mount for parallel worktrees needs a configured path. It must exclude `ai/state/` because the state files are single-writer. A whole-tree shared mount would break that rule.
- A configurable `Project AI Knowledge Directory` key is the mechanism for that mount. It is not part of this change.
- `ai/knowledge` matches `<User AI Directory>/knowledge` and `<team-repo>/knowledge`. `ai/shared/` stays for the actual cross-agent communication artifacts.

### Skills

- Add the user skills root `<User AI Directory>/skills`.
- Precedence: project, then team, then user, then workflow. The workflow root provides distribution defaults. Report every override.
- A missing or unreadable user skills root reports PENDING and does not fail boot.

### Network User AI Directory

- The path may be in the home directory or on a network drive. Resolve it from the customization key and preserve the value.
- Add a bounded read timeout so boot does not hang on a dead mount.
- If the directory is unreachable, report PENDING, continue with project-only context, resolve identity from git config, and make the outbound scrub fail closed when the sensitive-names list cannot be read.

### Backups

- `backups/` is the fourth sibling, as decided.
- Backup of the User AI Directory is the user's responsibility. Keep `backups/` as the fourth sibling and the `User AI Backups Directory` key; the protocol adds no network backup logic, no same-mount check, and no separate backup-target policy.

### Migration and compatibility

- The sync script performs the migrations. Load context does not migrate.
- Sync is for initialized projects. A project is initialized when it has `AGENTS.md` and `ai-customization.md`; `ai/` is not required. An uninitialized single target is refused with a pointer to `--init`; sync does not create a project.
- Sync rewrites the old customization keys `Global AI Workflow Directory` and `Global AI User Directory` to `Workflow AI Directory` and `User AI Directory`. It preserves each value, including a network path. It never resets a value to `~/.ai`. When both keys exist, the new key wins with a warning.
- The migration is automatic when sync detects an old layout. There is no separate `--migrate` flag. Every move is reported, idempotent, and supported by `--dry-run`; back up a store before moving it. A team repository write crosses a repository boundary and needs its own approval or PR.
- Load context detects an old layout and warns. A read-only fallback to old paths is a compatibility option. It never moves files.
- Migration chain for the team store: `lessons/` to `team-knowledge/` to `knowledge/`. `lessons/` is migrated and removed immediately; no alias.
- Update live references atomically: AGENTS.md, policies, procedures, customization keys, validator anchors, sync scripts and tests, docs, project knowledge cross-references, and release notes.
- The protocol repository is also a project. Move its own `ai/shared/project-knowledge` in the same atomic change, not through the downstream sync.
- Do not rewrite historical diary entries, closed tickets, or closed records.

### Sequencing and release

- This issue runs first, then the customization presets, then the init script.
- A phased delivery is a technical option: A, keys and aliases; B, directory moves and sync migration; C, alias removal in the next major. The user rejects "eroding user trust" as a reason. Phasing is only about atomicity and preventing half-migrated states.
- Size stays XL. The phases above are the breakdown.
- Release: minor v7.7.0; one atomic migration; no alias window; old keys and paths are removed by the migration; no symlinks.

### Answers to the original open questions

- Canonical term: "Workflow AI" for the clone and "User AI" for the user area. "Workflow policy layer" is not used.
- "Workflow policy" covers the distribution policy tree. Procedures and skills have their own directories under the workflow. The common policy lives in the workflow policies directory.
- The path keys change, not only the prose.
- Minor release v7.7.0; no alias window; old keys and paths are removed by the migration.
- No alias window; old names are valid only until the migration rewrites them.

### Updated acceptance criteria

- Four scope names and owner-prefix keys are defined and used.
- No scope label uses "global". Generic English uses are classified.
- The directory layout matches this ticket. The team, user, and project stores are `knowledge` or `ai/knowledge`.
- The user area has `knowledge/`, `skills/`, `settings/`, and `backups/`.
- Sync rewrites the customization keys, preserves a custom or network path, and is idempotent.
- Load context detects and warns; it never migrates.
- Skills precedence and PENDING behavior are specified.
- The validator, tests, docs, release notes, and the ADR are updated. The suite and validator pass.
- Behavior changes only where the new paths and keys require it.
- The release is v7.7.0; no alias window; old keys and paths are removed by the migration; `lessons/` is removed immediately.
- Backing up the User AI Directory is the user's responsibility; the protocol keeps `backups/` and adds no network backup logic.
- The `ai/shared/` layout with `coordination.md` and `handoffs/` is unchanged.
- The role switch name is owned by the customization presets ticket.

---

2026-11-25

## No symlinks in the scope migration

- The scope migration creates no symlinks. Move each directory to its new path and rewrite the customization keys. Do not leave an old-path link behind.
- The earlier idea of moving `~/.ai/global-knowledge` to `~/.ai/knowledge` and leaving a symlink is withdrawn.
- Remove the legacy root `ai-customization.md` symlink handling from the sync scripts when they are next refactored. No preservation or write-through. A symlink at that path is either refused with a clear message or replaced by a regular file; it is never kept as a link.
- When the migration is implemented, refactor `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1` so no migration path calls `ln -s`, `New-Item -ItemType SymbolicLink`, or `mklink`. Add tests that assert the old paths are moved, not linked.
- Load context keeps the read-only old-path fallback. It creates no symlink.

---

2026-11-25

## Handoff and coordination directory proposal

- The user proposes moving handoffs directly under `ai/` and keeping a permanent `coordination.md` plus handoff files in one directory, to remove `ai/shared/`.
- Assessment: the direction to remove `ai/shared/` is sound. It removes a label that is not a mechanism and reduces the anchor count.
- Concern: the coordination board is a permanent awareness channel; handoffs are ephemeral task-transfer artifacts. Putting `coordination.md` inside `ai/handoffs/` conflates them. A handoff cleanup that deletes files must never delete the board.
- Recommended variant: one `ai/collaboration/` directory with `coordination.md` and handoff files, or two top-level anchors `ai/coordination.md` and `ai/handoffs/`. Do not name the board's home `handoffs/`.
- Decision: keep `ai/shared/` with `coordination.md` and `handoffs/`; the proposal to remove it is rejected.
- The change touches `AGENTS.md`, `ai-policy-handoff.md`, the handoff, load-context, recovery, and checkpoint procedures, the validator, the backup scripts, the tests, the user docs, the examples, and the slide diagrams. It belongs in this ticket's migration plan, not the plan-quality change.

---

2026-11-25

## Hypothetical multi-assistant knowledge read/write (future safety)

- Current state: no parallel assistants and no parallel worktrees are running. This is a future-safety scenario, not a current operating mode.
- Same-root scenario: assistants sharing one project root share `ai/knowledge`; each claims work on `ai/shared/coordination.md`, writes a separate role or topic file, and the single-writer checkpoint or `repair knowledge files` reconciles. The rename does not change the sharing mechanism.
- Parallel-worktree scenario: separate worktrees do not share `ai/knowledge`. Cross-worktree sharing needs a future configurable `Project AI Knowledge Directory` mount, and that mount must exclude `ai/state/` because the state files are single-writer. This ticket does not claim cross-worktree sharing.
- Concurrent writes: the path move adds no lock. Two agents editing the same file can lose updates; use claims, separate topic files, and a merge or review step.
- Migration safety: update every reader and writer; no symlinks; the old-path fallback is read-only. An older assistant writing the old path would split the store.

### Future acceptance criteria

- A same-root two-agent read/write fixture: two simulated agents read `ai/knowledge`, each writes a different topic file, and a third read sees both updates. The fixture does not use a worktree or a second machine.
- The worktree limitation is documented: project knowledge is per worktree; cross-worktree sharing needs the future configurable mount; `ai/state/` stays out of it.

## Cross-ticket

- The role switch name belongs to `ai/issues/open/customization-presets-per-role.md`. This ticket defines the scope vocabulary and layout only.

## Confirmed decisions (2026-11-25)

- Release: minor v7.7.0. One atomic migration. There is no alias window; the old customization keys and paths are removed by the migration. No symlinks.
- Backup: backing up the User AI Directory is the user's responsibility. Keep `backups/` as the fourth sibling and the `User AI Backups Directory` key; the protocol adds no network backup logic, no same-mount check, and no separate backup-target policy.
- Coordination and handoffs: keep `ai/shared/` with `coordination.md` and `handoffs/`; the proposal to remove it is rejected.
- Role switch name: owned by the customization presets ticket, not this ticket.
- The remaining plan inputs are the XL HLD/LLD, the exact file list, the migration tests, and the close sequence. These decisions are confirmed.

## Plan inputs confirmed (2026-11-25)

- Sync refuses an uninitialized target and points to `"bootstrap using AGENTS.md protocol"`. The `--init` feature is a separate issue and is out of scope.
- Sync migrates every store: the target project, the User AI Directory, and the configured team repository. No per-store approval. Team working-tree changes are left uncommitted for the team to commit or turn into a PR.
- When old and new paths coexist, move all files into the new path. Preserve duplicate filenames with a `.migrated-<date>` suffix and report them rather than overwrite.
- Sync auto-backs up before moving. Project backup: `ai/artifacts/scope-migration-<date>/`. User and team backup: `<User AI Directory>/backups/scope-migration-<date>/`. `--dry-run` prints both.
- Add `Team AI Directory` as the root customization key; derive `Team AI Knowledge Directory` and `Team AI Skills Directory`; migrate the old `Team AI Knowledge Directory` key.
- `knowledge-repair-backups/` and `settings-repair-backups/` stay top-level and are documented as exceptions to the four-store rule.
- Rename files, headings, keys, and paths. Keep the old triggers as aliases for v7.7.x and remove them in v7.8.0.
- The README and the v7.7.0 announcement must lead with the old/new path table and state which paths the sync migrates automatically, where the backups go, and what remains manual.

## Plan

Plan attached below.

## Implementation Plan

# Plan: Scope normalization and knowledge-directory layout

## Goal

Replace the ambiguous Global/Project vocabulary with four explicit scopes: Workflow, User, Team, and Project. Move the knowledge stores to unprefixed `knowledge` directories, add the user skills root, migrate every store through the sync script, and make the v7.7.0 release announcement and README state every changed path and what sync migrates automatically. Behavior changes only where the new paths and keys require it.

## Evidence

- Ticket: `ai/issues/open/global-to-workflow-policy-terminology.md` (211 lines after the 2026-11-25 plan-input update). Confirmed decisions at lines 190-196; plan inputs at the end.
- User answers, 2026-11-25:
  - `--init` is a separate issue and is out of scope; sync refuses an uninitialized target and points to `"bootstrap using AGENTS.md protocol"`.
  - Sync migrates all stores, with no per-store approval.
  - Old and new paths coexist rarely; merge by moving all files.
  - Auto-backup then move.
  - Add `Team AI Directory` as the root key.
  - Keep the two repair backup directories top-level and document them as exceptions.
  - Rename files and paths; keep old triggers as aliases for v7.7.x.
  - The README and announcement must lead with the path changes and the sync migration.
- Current `AGENTS.md` (149 lines): keys at lines 29-55; `Project AI Knowledge Directory: ai/shared/project-knowledge/` at line 48; user settings, knowledge, backups, and workflow skills at lines 31-35.
- Current `ai/procedures/load-context.md` (112 lines): old keys at lines 11-13; old global directories at 50; old `ai/shared/project-knowledge/` at 53 and 55; old team `team-knowledge/` at 88.
- Current `support-files/sync-agents-md.sh` (414 lines): `--source`, `--target-path`, `--dry-run` only; no `--init`; creates `ai-customization.md` when missing (lines 294-325); preserves the root symlink (lines 176-187, 218-224); migrates state files only (lines 328-357).
- Current `support-files/validate-protocol.sh` (456 lines): expects the Global keys (lines 121-130), the old user subdirectories (line 172), the old project knowledge path (line 322), and the old issue-template path (line 334).
- Current validator counts: 25 policies, 16 procedures, 54 triggers, from the last v7.6.2 load. Names change; counts must be re-measured, not guessed.
- Current project knowledge: 16 files under `ai/shared/project-knowledge/`, including `issue-template.md`.
- Current user directory `/home/kamran/.ai/`: `backups/`, `global-knowledge/`, `knowledge-repair-backups/`, `settings/global-user-settings.md`, `settings-repair-backups/`; no `knowledge/` and no `skills/`. The live settings filename must move to `user-settings.md`.
- Current `ai/knowledge/` does not exist.
- Current sync tests: `tests/test-sync-agents-md.sh` asserts customization creation, symlink preservation, and the old keys; `tests/test-readme-shape.sh` pins `Team AI Knowledge Directory`, `team-knowledge/`, and the 25/16/54 counts. Rewrite both; re-measure the trigger count.
- Current `ai-customization.md`: `Global AI Workflow Directory` and `Global User AI Directory` at lines 9 and 11.
- Open tickets that name moved paths: `ai/issues/open/presentation-policy.md`, `ai/issues/open/protocol-procedure-tdd-spec-driven-verification.md`, `ai/issues/open/refactoring-and-upgrading-policy.md`, `ai/issues/open/slide-deck-review-speed.md`, `ai/issues/open/tier2-vs-non-negotiables-consolidation.md`, and `ai/issues/open/retire-protocol-verification-toolchain.md`. Update their paths to `ai/knowledge/...`.
- Historical records are not migration inputs: `docs/announcements/v*.md` except the new v7.7.0 announcement, `ai/issues/closed/`, `ai/daily-checkpoints/`, `ai/state/`, `ai/code-review-reports/`, and old `design-docs/protocol-decisions.md` entries.
- No open question remains after the answers. The plan below records the remaining design choices for review.

## Depth

XL. The plan needs an HLD, an LLD with acceptance criteria, ADR entries, migration tests, a file manifest, and a full close sequence.

## Context

The protocol currently uses "global" for two different owners: the workflow clone and the user's home or network directory. The knowledge stores add a third scope, team, and a fourth, project. The target model is:

- **Workflow**: the clone. `ai/policies/`, `ai/procedures/`, `ai/skills/`. No knowledge or settings store.
- **User**: the user's AI directory, from `User AI Directory`; may be under the home directory or on a network path. Four stores: `knowledge/`, `skills/`, `settings/`, `backups/`.
- **Team**: the configured team repository. `knowledge/` and `skills/`; the repository is the `Team AI Knowledge Repository`.
- **Project**: the project root. `ai/knowledge/`, `ai/policies/`, `ai/skills/`, `ai/state/`; `ai/shared/` keeps `coordination.md` and `handoffs/`.

The migration is atomic for v7.7.0. No key or path alias window. Old triggers stay as aliases for one release only. The sync script is the only mover; load context reads an old path only when the new path is absent or empty.

## HLD

### Components and boundaries

1. **Vocabulary and anchors** (`AGENTS.md`, `ai-customization.md`, policies, procedures, docs)
   - Owns the four scope names, the owner-prefix keys, the derived key formulas, the canonical short forms, and the no-global rule for live scope labels.
   - Does not own store migration or user data.
2. **Resolution and fallback** (`PROCEDURE LOAD-CONTEXT`, `PROCEDURE POST-COMPACTION-RECOVERY`, `PROCEDURE BOOTSTRAP-PROJECT`)
   - Reads the new keys; warns and falls back read-only when an old key or old path is the only layout.
   - Reads user settings in full, indexes user and project knowledge, indexes four skill roots, and never migrates.
3. **Migration engine** (`support-files/sync-agents-md.sh` and `.ps1`)
   - Reads each target project; rewrites customization keys; backs up and moves the project, user, and team stores; migrates state files; reports PENDING for unreachable configured stores; never commits to the team repository.
4. **Store layout** (user, team, project)
   - User: four stores; the two repair backup directories are documented exceptions.
   - Team: `knowledge/` and `skills/`; `lessons/` and `team-knowledge/` migrate to `knowledge/` and are removed.
   - Project: `ai/knowledge/`; `ai/shared/` keeps only coordination and handoffs.
5. **Release communication** (README, `docs/announcements/v7.7.0.md`, setup guide, slides)
   - Leads with the old/new path table, the automatic vs manual actions, the backup location, and the dry-run/full-sync commands.
6. **Validation** (validator, index helper, tests, docs audit)
   - Pins the new keys, paths, file names, trigger aliases, migration behavior, no-symlink rule, and the announcement table.

### Key map

- `Global AI Workflow Directory` -> `Workflow AI Directory`: resolved from customization; preserved.
- `Global User AI Directory` -> `User AI Directory`: resolved from customization; default `[HOME]/.ai/`; preserved, including a network path.
- `Global AI Policies Directory` -> `Workflow AI Policies Directory`: `<Workflow AI Directory>/ai/policies/`.
- `Global AI Skills Directory` -> `Workflow AI Skills Directory`: `<Workflow AI Directory>/ai/skills/`.
- `Global AI Knowledge Directory` -> `User AI Knowledge Directory`: `<User AI Directory>/knowledge/`.
- `Global AI Settings Directory` -> `User AI Settings Directory`: `<User AI Directory>/settings/`.
- `Global AI Backups Directory` -> `User AI Backups Directory`: `<User AI Directory>/backups/`.
- none -> `User AI Skills Directory`: `<User AI Directory>/skills/`.
- `Team AI Knowledge Directory` (root value) -> `Team AI Directory` (root value): resolved from customization; preserved.
- `Team AI Knowledge Directory` (derived) -> `Team AI Knowledge Directory`: `<Team AI Directory>/knowledge/`.
- none -> `Team AI Skills Directory`: `<Team AI Directory>/skills/`.
- `Team AI Knowledge Repository` -> unchanged: resolved from customization.
- `Project AI Knowledge Directory` (value) -> unchanged key: `ai/knowledge/`.
- `Project AI Skills Directory` -> unchanged: `ai/skills/`.
- `Project AI Policies Directory` -> unchanged: `ai/policies/`.
- `Project Shared Directory` -> unchanged: `ai/shared/`; coordination and handoffs only.

### Directory map

- User: `<User AI Directory>/global-knowledge/` -> `<User AI Directory>/knowledge/`; sync.
- User: none -> `<User AI Directory>/skills/`; sync creates.
- User: `<User AI Directory>/settings/global-user-settings.md` -> `<User AI Directory>/settings/user-settings.md`; sync moves and backs up; collision suffix applies.
- User: `<User AI Directory>/settings/` -> otherwise unchanged.
- User: `<User AI Directory>/backups/` -> unchanged.
- User: `<User AI Directory>/knowledge-repair-backups/` -> unchanged; documented exception.
- User: `<User AI Directory>/settings-repair-backups/` -> unchanged; documented exception.
- Team: `<Team AI Directory>/team-knowledge/` -> `<Team AI Directory>/knowledge/`; sync.
- Team: `<Team AI Directory>/lessons/` -> `<Team AI Directory>/knowledge/`; sync; old directory removed immediately.
- Team: `<Team AI Directory>/skills/` -> unchanged.
- Project: `ai/shared/project-knowledge/` -> `ai/knowledge/`; sync; protocol repo uses `git mv`.
- Project: `ai/shared/project-knowledge/issue-template.md` -> `ai/knowledge/issue-template.md`; sync; protocol repo uses `git mv`.
- Project: `ai/shared/coordination.md`, `ai/shared/handoffs/` -> unchanged.
- Workflow: `ai/policies/`, `ai/procedures/`, `ai/skills/` -> unchanged.

### Data flow

1. **Initialized project, new layout**: sync copies AGENTS.md, verifies the new keys, checks the new stores, reports PENDING for unreachable configured stores, and changes nothing.
2. **Initialized project, old layout**: sync reads the old keys; backs up each old store; rewrites the keys; moves project knowledge; moves user knowledge and creates user skills; rewrites the team root and moves `lessons/` and `team-knowledge/` to `knowledge/`; migrates the state layout; reports every move.
3. **Uninitialized target**: a project with AGENTS.md but no root or old customization file is refused with the bootstrap trigger. Sync does not create a project.
4. **Load context, new layout**: resolves new keys; reads user settings; indexes user and project knowledge; indexes project, team, user, and workflow skills; reports counts.
5. **Load context, old layout**: resolves an old key or old path when the new equivalent is absent or empty; warns `old layout; run the sync script`; reads only; creates no new store and moves nothing. An empty new directory beside a populated old directory is treated as unmigrated, not as the active store. If both old and new are populated, use the new store and warn that the old store remains.
6. **Network User AI Directory**: bounded check; unreachable reports PENDING, continues with project-only context, resolves identity from git config, and the outbound scrub fails closed when the sensitive-names list cannot be read.

### Fallback decision rule

- Project: use `ai/knowledge/` when it exists and is non-empty. Otherwise, if `ai/shared/project-knowledge/` exists, use it read-only and warn. If both are non-empty, use `ai/knowledge/` and warn about the old store.
- User: use `<User AI Directory>/knowledge/` when it exists and is non-empty. Otherwise, if `global-knowledge/` exists, use it read-only and warn. If both are non-empty, use the new store and warn.
- Team: use `<Team AI Directory>/knowledge/` when it exists and is non-empty. Otherwise, if `team-knowledge/` or `lessons/` exists, use it read-only and warn. If both are non-empty, use the new store and warn.
- The structural audit creates the new directory only when no old store exists. It never creates an empty new store beside a populated old store.

### Migration invariants

- The sync never creates a symlink. It moves directories and files.
- The sync never writes through the legacy `ai-customization.md` symlink. It refuses that link with a clear message. A configured `User AI Directory` or `Team AI Directory` may itself resolve through a symlink chosen by the user; sync follows that configured anchor but refuses a symlinked `knowledge/` store root that it is asked to move.
- The sync backs up before the first move in a store. A failed backup stops that store's migration.
- The sync is idempotent. A second run finds no old path and reports nothing to do.
- A duplicate filename is never overwritten. The incoming file gets the first free name in the sequence `<name>.migrated-<date>`, `<name>.migrated-<date>-2`, `<name>.migrated-<date>-3`, and so on; the chosen name is reported. The same rule handles three sources sharing a basename and a pre-existing suffixed target.
- The team repository is changed only in its working tree. Sync does not commit or push.
- Historical records are not rewritten.
- The no-global rule applies to live scope labels. Legacy identifiers remain only on lines or blocks marked `LEGACY-GLOBAL`, in `## Triggers` alias lines, in the announcement table, and in the ADR history. The marker is `<!-- LEGACY-GLOBAL -->` in Markdown and `# LEGACY-GLOBAL` in shell.

## LLD

### LLD-1: Vocabulary and configuration anchors

- Rewrite `AGENTS.md` TIER CONFIGURATION with the new keys and derivations from the key map.
- Add `User AI Skills Directory` and `Team AI Skills Directory`.
- Set `Project AI Knowledge Directory` to `ai/knowledge/`.
- Keep `Team AI Knowledge Repository`; add `Team AI Directory` as the root customization key.
- Update canonical short forms to User Knowledge, Project Knowledge, and Team Knowledge; add Workflow Policies, Workflow Skills, and User Settings where useful.
- Replace "Global" scope labels in live prose with the owner term. Keep generic English and Git's global config (`~/.gitconfig`, `git config --global`) as documented exceptions.
- Rename the live files:
  - `ai/policies/ai-policy-global-settings.md` -> `ai/policies/ai-policy-user-settings.md`
  - `ai/procedures/repair-global-settings.md` -> `ai/procedures/repair-user-settings.md`
  - `docs/global-user-settings.md` -> `docs/user-settings.md`
  - `<User AI Directory>/settings/global-user-settings.md` -> `<User AI Directory>/settings/user-settings.md` (sync migration; backup and collision rules apply)
  - `ai/shared/project-knowledge/global-vocabulary-and-storage-roots.md` -> `ai/knowledge/scope-vocabulary-and-storage-roots.md`
  - `tests/test-global-settings-repair-fixture.sh` -> `tests/test-user-settings-repair-fixture.sh`
- Rewrite the moved knowledge files, not only their paths:
  - `ai/knowledge/scope-vocabulary-and-storage-roots.md` describes the four scopes, the user skills root, and the precedence project > team > user > workflow; remove the old "do not add a user-skills root" and "project, team, global" claims.
  - `ai/knowledge/trigger-phrase-naming.md` changes `update global knowledge` to `update user knowledge` and records the v7.7.x alias.
  - `ai/knowledge/local-first-knowledge-retrieval-proposal.md` and the other moved knowledge files replace old scope labels and old paths.
  - `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md` records the new directory layout and counts.
- Rename the index and authoring scope token `global` to `workflow` in `support-files/index-protocol-contract.md`, `support-files/validate-policy-authoring.sh`, `support-files/index-protocol.sh`, `ai/procedures/load-context.md`, and the index tests. The line format becomes `scope=workflow|project`.
- Add the missing live files to the migration set: `ai/policies/ai-policy-issue-management.md`, `ai/policies/ai-policy-design-docs.md`, `ai/policies/ai-policy-codebase-examination.md`, `ai/procedures/knowledge-publish.md`, `docs/codebase-examination-guide.md`, `docs/examples/handoffs/header-component-handoff.md`, `docs/slides/diagrams/blackbox-state.svg`, and `docs/slides/diagrams/project-brain.svg`.
- Keep the old triggers as aliases in the renamed procedure:
  - New: `repair user settings`, `tidy user settings`, `heal user settings`.
  - Aliases for v7.7.x: `repair global settings`, `tidy global settings`, `heal global settings`.
  - Remove the aliases in v7.8.0.
- Rename the checkpoint triggers: `update user knowledge` is new; `update global knowledge` is the v7.7.x alias.
- In `repair knowledge files`, the scope word becomes `user`; accept `global` as a v7.7.x alias. `both` stays.
- The sync rewrites an `## Active Expertise` bullet `global-settings` to `user-settings`. The announcement names this manual/automatic change.

### LLD-2: Load-context, recovery, and bootstrap

- `STEP-CUSTOMIZATION-DISCOVERY` reads `Workflow AI Directory`, `User AI Directory`, `Team AI Directory`, `Team AI Knowledge Repository`, and `Default Shell`.
- If a new key is absent and its old key is present, use the old value and warn. If both are present, use the new value and warn.
- Detect old paths before the structural audit:
  - `ai/shared/project-knowledge/` when `ai/knowledge/` is absent or empty.
  - `<User AI Directory>/global-knowledge/` when `knowledge/` is absent or empty.
  - `<Team AI Directory>/team-knowledge/` or `lessons/` when `knowledge/` is absent or empty.
- In an old layout, do not create the new directory; read the old path; warn `old layout; run the sync script`. This preserves the read-only safety barrier and prevents an empty new store from hiding the old one.
- If both old and new are populated, use the new store and warn that the old store remains. The sync merges the old store; load context never does.
- Mandatory-directory creation uses `ai/knowledge/` for a new project and the old path only when the fallback is active. The issue template is created in the active knowledge root, never in both.
- `STEP-DISCOVERY` indexes the active roots: `ai/knowledge/`, `User AI Knowledge Directory`, `User AI Settings Directory`, `Workflow AI Skills Directory`, `User AI Skills Directory`, `Project AI Skills Directory`, and `Team AI Directory` when readable.
- `STEP-KNOWLEDGE-INDEXING` loads the knowledge policy, indexes User and Project Knowledge, and reports the old-layout warning once.
- `STEP-SKILLS-INDEX` indexes project, team, user, and workflow roots. Precedence is project, then team, then user, then workflow. Report every override and cross-type collision. A missing or unreadable user root reports PENDING and continues.
- `STEP-TEAM-KNOWLEDGE-INDEX` reads `Team AI Directory` and indexes `knowledge/`; the old `team-knowledge/` path is read only when the fallback is active.
- Add a shared bounded path probe, `support-files/path-probe.sh` and `support-files/path-probe.ps1`, before reading the User AI Directory or the Team AI Directory:
  - POSIX: `timeout "${PATH_PROBE_TIMEOUT:-3}"` when available; `gtimeout "${PATH_PROBE_TIMEOUT:-3}"` on macOS when available; `perl -e 'alarm($ENV{PATH_PROBE_TIMEOUT} || 3); exec @ARGV'` when Perl exists; otherwise return `PENDING: bounded check unavailable`.
  - Windows: `Start-Job` plus `Wait-Job -Timeout $env:PATH_PROBE_TIMEOUT` (default 3), or an equivalent bounded call.
  - `PATH_PROBE_TIMEOUT` is a test and user override; the default is 3 seconds. The test uses 1 second with a slow `ls`.
  - Exit 0 is reachable, 1 is not reachable, 124 is timeout, 2 is no bounded mechanism.
  - On timeout or failure: PENDING, project-only context, identity from git config, and fail-closed outbound scrub. Never block the load.
  - The sync uses the same probe before reading or moving a user or team store; an unreachable store is skipped with PENDING while the project store continues.
- Update `POST-COMPACTION-RECOVERY` and `BOOTSTRAP-PROJECT` to the same keys and paths. Bootstrap creates `knowledge/`, `skills/`, `settings/`, and `backups/`, and uses the new customization keys.
- The proof items use the new names: User Knowledge, User Settings, User Skills, Workflow Skills, Team Knowledge.

### LLD-3: Sync migration engine

`support-files/sync-agents-md.sh` and `.ps1` gain one ordered migration path per target:

1. **Validate the target**: require `AGENTS.md` and either `ai-customization.md` at the root or the legacy `ai/ai-customization.md`. Refuse an uninitialized target with: `Uninitialized project. Run "bootstrap using AGENTS.md protocol".` Do not create a customization file for an uninitialized target.
2. **Migrate the legacy customization file**: move `ai/ai-customization.md` to the root only for an old initialized project; add the configuration section; never preserve a symlink.
3. **Rewrite keys**: map the old keys to the new keys; preserve values; new wins when both exist; warn and remove the old duplicate; rewrite the `Team AI Knowledge Directory` root key to `Team AI Directory`; rewrite the `Active Expertise` `global-settings` token.
4. **Back up**: create `ai/artifacts/scope-migration-<date>/project-knowledge/` for the project store; create `<User AI Directory>/backups/scope-migration-<date>/user/` and `/team/` for the user and team stores. Copy, verify, then move. `--dry-run` (Bash) and `-WhatIf` (PowerShell) print the paths and make no changes.
5. **Move project knowledge**: merge `ai/shared/project-knowledge/` into `ai/knowledge/`; move `issue-template.md`; remove the old directory when empty; report every file. A duplicate filename gets the first free `<name>.migrated-<date>`, `<name>.migrated-<date>-2`, and so on.
6. **Move user knowledge**: merge `global-knowledge/` into `knowledge/`; create `skills/`; move `settings/global-user-settings.md` to `settings/user-settings.md` with the same backup and collision rules; keep `settings/` and `backups/` otherwise; leave the two repair backup directories untouched and report them as exempt.
7. **Move team knowledge**: rewrite the root key; merge `lessons/` and `team-knowledge/` into `knowledge/`; remove the old directories; leave changes uncommitted; report the team path and the commit/PR need.
8. **Migrate state files**: keep the existing state migration.
9. **Report**: every write, move, backup, collision suffix, skip, refusal, and PENDING with the store path.
10. **Failure isolation**: one store failure does not stop other targets; the exit status is non-zero when any target failed.
11. **Bounded reachability**: probe the User AI Directory and Team AI Directory before reading or moving; timeout or unreachable is PENDING for that store; the project store continues.

Rules:

- No `ln -s`, `New-Item -ItemType SymbolicLink`, or `mklink` in the migration path.
- The legacy `ai-customization.md` symlink is refused. A configured `User AI Directory` or `Team AI Directory` may resolve through a user-chosen symlink; follow the anchor, but refuse a symlinked `knowledge/` store root being moved.
- Do not migrate a path that is already new and non-empty; idempotent. An empty new path beside a populated old path is unmigrated and is merged.
- Do not commit or push the team repository.
- `--dry-run` previews the exact backup and move paths and creates nothing.
- The `--init` flag is out of scope. The refusal points to the existing bootstrap procedure; a later ticket adds the init command.
- The PowerShell script mirrors the Bash behavior, including `-WhatIf`, backup, collision suffix, and refusal.

### LLD-4: Store policies and settings

- `ai-policy-knowledge.md`: rename Global Knowledge Protocol to User Knowledge Protocol; new user path; project path `ai/knowledge/`; repair backup path becomes `<User AI Directory>/knowledge-repair-backups/<date>/user/`; the top-level repair directory stays.
- `ai-policy-team-knowledge.md`: store one lesson per file under `knowledge/`; the retired lesson stays there; `skills/` remains allowed; the `Team AI Directory` root is the configuration anchor.
- `ai-policy-user-settings.md`: rename from `ai-policy-global-settings.md`; read the **User AI Settings Directory**; move `global-user-settings.md` to `user-settings.md`; keep the canonical keys; keep the repair backup path `<User AI Directory>/settings-repair-backups/<date>/`; add a note that this top-level directory is exempt from the four-store rule.
- `ai-policy-issue-management.md`: the issue-template path becomes `ai/knowledge/issue-template.md`.
- `ai-policy-design-docs.md`: the old `ai/shared/project-knowledge/` references become `ai/knowledge/`.
- `ai-policy-codebase-examination.md`: the old `project-knowledge` labels and paths become `ai/knowledge/` and Project Knowledge.
- `ai/procedures/knowledge-publish.md`: read `Team AI Directory` and write `knowledge/`.
- `ai-policy-common.md`: User Settings full load; User and Project Knowledge indexing; four skills roots and precedence; outbound scrub reads the User settings names list; identity fallback uses User Settings; all key names updated.
- `ai-policy-meta.md`, `ai-policy-outbound-content-scrub.md`, `ai-policy-academic-researcher.md`: update path/key references and generic exceptions.
- The "no-global" exceptions are documented: Git's global config, generic English, legacy migration identifiers, trigger aliases, historical records, and the announcement table. Legacy lines carry the `LEGACY-GLOBAL` marker; the test strips marked lines and blocks.

### LLD-5: Documentation, slides, and release communication

- `README.md`:
  - Replace the stale v7.6.2 banner with the v7.7.0 banner.
  - Make the first content section after the title `## Path migration in v7.7.0`; it must precede the first ordinary content section.
  - Lead with a table: old path/key, new path/key, auto-migrated by sync, backup location, manual action. Wrap the table in `<!-- LEGACY-GLOBAL-START -->` and `<!-- LEGACY-GLOBAL-END -->` so the no-global guard can accept the intentional old paths without weakening the rest of the README.
  - State the exact sync commands for Linux/Git Bash (`--dry-run`) and Windows (`-WhatIf`) separately.
  - State that sync auto-migrates project, user, and team stores; team changes stay uncommitted; the two repair backup directories remain.
  - Update the "How It Works" diagram and setup references.
- `docs/announcements/v7.7.0.md`:
  - The first section after the title is `## Path changes at a glance`.
  - The table includes every directory, key, file rename, and trigger alias in this plan.
  - It states which paths sync migrates, where backups go, what remains manual, and what to do before and after the sync.
  - It names the v7.8.0 trigger-alias removal.
- `docs/setup.md`, `docs/ai-customization-guide.md`, `docs/ai-customization.md`, `docs/workflow-guide.md`, `docs/user-settings.md` (renamed), `docs/codebase-examination-guide.md`, `docs/protocol-validation-system.md`, `docs/multi-agent-runbook.md`, `docs/post-compaction-reload-trigger-setup.md`, examples, personas, and comparison docs: update paths and keys. `docs/examples/handoffs/header-component-handoff.md` points at `ai/knowledge/css-architecture.md`. Generic English remains.
- `docs/slides/*`, including `first-loop.svg`, `knowledge-skills.svg`, `root-files.svg`, `six-jobs.svg`, `skills-layers.svg`, `three-roots.svg`, `two-scopes.svg`, `blackbox-state.svg`, `project-brain.svg`, and `docs/simple-ai-workflow-slides.md`: update diagrams that name the workflow, user, project, or team roots; the paths shown must match the new layout.
- `support-files/README.md`, `index-protocol-contract.md`, and scripts: update path names and counts.
- Add the path table to `tests/test-readme-shape.sh` and `tests/test-docs-audit.sh`; assert that the README table precedes the first ordinary content section and that the announcement contains every mapping.
- Do not rewrite historical announcements, closed tickets, daily checkpoints, state history, review reports, or old ADR entries. Add a new ADR at the end of `design-docs/protocol-decisions.md`.

### LLD-6: Validation and tests

- Update `support-files/validate-protocol.sh`:
  - CONFIG_KEYS to the new keys, including `Team AI Directory`, `Team AI Skills Directory`, and `User AI Skills Directory`.
  - User directory check to `User AI Directory`; subdirectories `settings`, `knowledge`, `skills`, `backups`; do not require the repair backup directories.
  - `ai/knowledge/issue-template.md`; mandatory project directory `knowledge` instead of `shared/project-knowledge`.
  - New file names and trigger counts; re-measure, do not guess.
- Update `support-files/validate-policy-authoring.sh` and `index-protocol` anchors and counts. The index line format becomes `scope=workflow|project`; update the contract, helper, load-context proof, and tests.
- Add `support-files/path-probe.sh` and `path-probe.ps1`; add `tests/test-path-probe.sh`:
  - a reachable temporary directory exits 0;
  - a missing directory exits 1;
  - a fake slow `ls` with a one-second timeout exits 124;
  - no bounded mechanism exits 2 and reports PENDING.
- Rewrite `tests/test-sync-agents-md.sh` and add a `tests/test-scope-migration.sh` where clearer:
  - uninitialized refusal with the bootstrap pointer; no customization created;
  - legacy `ai/ai-customization.md` migration; legacy symlink refused;
  - old key rewrite preserving a custom and a network-style value; new wins when both; `Active Expertise` `global-settings` rewrite;
  - project knowledge move and issue-template move; a new empty `ai/knowledge/` beside a populated old store is merged, not skipped;
  - collision from `lessons/foo.md`, `team-knowledge/foo.md`, and `knowledge/foo.md`, plus a pre-existing `.migrated-<date>` target; assert three distinct names and no overwrite;
  - user knowledge move, `settings/global-user-settings.md` -> `settings/user-settings.md`, user skills creation, repair backup directories untouched;
  - team root key rewrite, `lessons/` and `team-knowledge/` merge, no commit;
  - auto-backup exists and matches the pre-move content; a failed backup leaves the store unchanged;
  - `--dry-run` and `-WhatIf` make no writes and print all paths;
  - symlink refusal and no new symlink;
  - idempotent second run;
  - failure isolation and exit status.
- Update `test-load-context-boot.sh`: new keys, old-key fallback, old-path warning with no move, empty-new fallback for project/user/team, `ai/knowledge`, user settings filename, user skills, four-root skills precedence, PENDING for a missing or unreachable user root.
- Update `test-config-resolution.sh`, `test-policy-load-paths.sh`, `test-protocol-index.sh`, `test-protocol-references.sh`, `test-skills-index.sh`, `test-team-knowledge.sh`, `test-knowledge-repair-fixture.sh`, `test-user-settings-repair-fixture.sh`, `test-docs-audit.sh`, `test-slides.sh`, `test-common-prose-shape.sh`, `test-readme-shape.sh`, and `tests/verify-powershell-scripts.ps1`.
- Update the live open tickets that name moved paths: `ai/issues/open/presentation-policy.md`, `ai/issues/open/protocol-procedure-tdd-spec-driven-verification.md`, `ai/issues/open/refactoring-and-upgrading-policy.md`, `ai/issues/open/slide-deck-review-speed.md`, and `ai/issues/open/tier2-vs-non-negotiables-consolidation.md`.
- Add a no-global guard that forbids live scope labels and bare `scope=global` in live modules and current docs. The token list includes `Global AI`, `global-knowledge`, `team-knowledge`, `project-knowledge`, `Global Knowledge`, `Global User`, `Global Policies`, `Global Skills`, `global settings`, `global-settings`, and `global-user-settings`.
  - The marker contract is `<!-- LEGACY-GLOBAL -->` or `# LEGACY-GLOBAL` for one line, and `<!-- LEGACY-GLOBAL-START -->` / `<!-- LEGACY-GLOBAL-END -->` for a Markdown block. Shell blocks use `# LEGACY-GLOBAL-START` and `# LEGACY-GLOBAL-END`.
  - The guard strips marked lines or blocks, the `## Triggers` alias lines, historical paths, the active ticket, the plan, the README path table block, and the announcement table.
  - The migration-detection code in `support-files/sync-agents-md.sh`, `support-files/sync-agents-md.ps1`, and `ai/procedures/load-context.md` is marked with `LEGACY-GLOBAL` or `LEGACY-GLOBAL-START/END`; it is not excluded. The migration fixtures `tests/test-sync-agents-md.sh`, `tests/test-scope-migration.sh`, `tests/test-load-context-boot.sh`, `tests/test-knowledge-repair-fixture.sh`, `tests/test-user-settings-repair-fixture.sh`, and `tests/test-config-resolution.sh` are excluded from the no-global scan; each is limited to legacy/migration assertions and its old literals are reviewed in that fixture.
- Add a docs assertion that the README table precedes the first ordinary content section and that the README and v7.7.0 announcement contain the path table with every mapping and the sync/backup/manual states. The assertion reads the committed README and announcement, never the deleted plan.
- Run `bash support-files/validate-protocol.sh`, `bash support-files/validate-policy-authoring.sh`, every `tests/test-*.sh`, quoted markdownlint globs including `docs/**/*.md` and `ai/knowledge/**/*.md`, shellcheck, `git diff --check`, and the PowerShell script check.

### LLD-7: Protocol repository self-migration

- Move `ai/shared/project-knowledge/` to `ai/knowledge/` with `git mv`; move `issue-template.md` with it.
- Rename the policy, procedure, doc, knowledge, and test files with `git mv`.
- Update the repository's `AGENTS.md`, `ai-customization.md`, `design-docs/specs/policy-loading-contract.md`, map, and open ticket path references.
- The protocol repository is also a project; its `ai/knowledge/` is project knowledge, not a workflow store. State this in the knowledge file or map so the distinction does not drift.
- Do not run the migration against the developer's live `~/.ai` or a team repository as part of the repository change; test migrations in temporary directories.

### LLD-8: Release and close

- Version: `v7.7.0`; one atomic migration; no key or path aliases; old triggers stay for v7.7.x only.
- Release announcement: `docs/announcements/v7.7.0.md`; GitHub Release body repeats the path table and the sync commands.
- Ticket: close with the plan attached; move to `ai/issues/closed/` in the branch commit; the plan appendix is the plan file.
- Baseline: commit the plan, ticket, and current planning records before opening the implementation branch. The implementation request plus the Close Sequence is the approval.
- Branch: `scope-normalization-and-knowledge-layout`; base `main`; merge mode `direct` from `ai-customization.md`.
- Merge one squash commit to `main`; delete the branch; tag the release commit; publish the GitHub Release; write the checkpoint before the commit; no post-merge commits.

## Decisions (ADR)

### ADR-001: Four scope names and owner-prefix keys

Use Workflow, User, Team, and Project. Keys carry the owner prefix. Directory names carry no scope prefix. The workflow scope has no knowledge or settings store.

### ADR-002: `ai/knowledge` replaces `ai/shared/project-knowledge`

`shared` is a label, not a mechanism. Same-root agents already share `ai/`; separate worktrees do not. `ai/knowledge` matches the user and team stores. `ai/shared/` keeps coordination and handoffs. This is the ticket decision.

### ADR-003: `Team AI Directory` is the root key

The team root holds `knowledge/` and `skills/`, so the root key is `Team AI Directory`; `Team AI Knowledge Directory` and `Team AI Skills Directory` are derived. This keeps the owner-prefix model consistent and avoids a knowledge key that points at a root.

### ADR-004: Sync is the only mover; load context is read-only

Sync performs every move. Load context detects an old layout, warns, and reads old paths only when the new path is absent or empty. If both are populated, it uses the new store and warns. It creates no symlink and moves nothing. This preserves the read-only boot barrier and prevents an empty new store from hiding a populated old store.

### ADR-005: Auto-backup, merge collisions, no symlinks

Sync auto-backs up each store before moving. It moves all files from old to new; duplicate filenames get the first free `.migrated-<date>`, `.migrated-<date>-2`, or later name and are reported. It creates no symlinks and refuses the legacy customization symlink and a symlinked store root it is asked to move; a configured user or team anchor may legitimately be a symlink. This is the user's migration choice, with data-loss protection.

### ADR-006: Trigger aliases for one release

File names, keys, and paths change immediately. Old triggers remain as aliases for v7.7.x and are removed in v7.8.0. The old keys and paths are not aliases; sync removes them. This is the user's naming choice.

### ADR-007: The two repair backup directories are exceptions

`knowledge-repair-backups/` and `settings-repair-backups/` remain top-level user directories. The four-store rule covers knowledge, skills, settings, and backups. The exception is documented in the layout, the user settings policy, the knowledge policy, and the announcement.

### ADR-008: `--init` is out of scope

Sync refuses an uninitialized target with the bootstrap trigger. The `--init` command is a separate issue. This keeps the init-script sequencing intact and gives the user an actionable message.

### ADR-009: Release communication leads with paths

The README and v7.7.0 announcement lead with the old/new path table and state which paths sync migrates, where backups go, and what remains manual. The user's primary concern is path clarity; a generic release note is insufficient.

### ADR-010: Historical records stay untouched

Historical announcements, closed tickets, daily checkpoints, state history, review reports, and old ADR entries keep their original vocabulary. The new ADR and the migration table explain the old terms. This avoids falsifying history and keeps the migration atomic.

## Deltas

### Key and path changes

- Keys: `Workflow AI Directory`, `User AI Directory`, `Workflow AI Policies Directory`, `Workflow AI Skills Directory`, `User AI Knowledge Directory`, `User AI Settings Directory`, `User AI Backups Directory`, `User AI Skills Directory`, `Team AI Directory`, `Team AI Knowledge Directory`, `Team AI Skills Directory`, `Team AI Knowledge Repository`.
- Project: `Project AI Knowledge Directory` -> `ai/knowledge/`; `Project AI Skills Directory` remains `ai/skills/`.
- User: `global-knowledge/` -> `knowledge/`; `skills/` new; `settings/` and `backups/` unchanged; two repair backup directories exempt.
- Team: `team-knowledge/` and `lessons/` -> `knowledge/`; `skills/` unchanged.
- Project: `ai/shared/project-knowledge/` -> `ai/knowledge/`; `ai/shared/` keeps coordination and handoffs.
- Workflow: no store change.

### File renames

- `ai/policies/ai-policy-global-settings.md` -> `ai/policies/ai-policy-user-settings.md`
- `ai/procedures/repair-global-settings.md` -> `ai/procedures/repair-user-settings.md`
- `docs/global-user-settings.md` -> `docs/user-settings.md`
- `<User AI Directory>/settings/global-user-settings.md` -> `<User AI Directory>/settings/user-settings.md` (sync)
- `ai/shared/project-knowledge/global-vocabulary-and-storage-roots.md` -> `ai/knowledge/scope-vocabulary-and-storage-roots.md`
- `tests/test-global-settings-repair-fixture.sh` -> `tests/test-user-settings-repair-fixture.sh`

### Live files to update

- Root: `AGENTS.md`, `ai-customization.md`, `.gitignore` (comment only: `Global settings directory` -> `User settings directory`), `README.md`.
- Policies: `ai-policy-academic-researcher.md`, `ai-policy-common.md`, `ai-policy-user-settings.md` (renamed), `ai-policy-knowledge.md`, `ai-policy-meta.md`, `ai-policy-outbound-content-scrub.md`, `ai-policy-team-knowledge.md`, `ai-policy-issue-management.md`, `ai-policy-design-docs.md`, `ai-policy-codebase-examination.md`.
- Procedures: `bootstrap-project.md`, `create-backup.md`, `examine-codebase.md`, `load-context.md`, `migrate-design-docs.md`, `post-compaction-recovery.md`, `repair-user-settings.md` (renamed), `repair-knowledge-files.md`, `run-peer-review.md`, `update-design-docs.md`, `write-checkpoint.md`, `knowledge-publish.md`.
- Project knowledge (all moved): `ai/knowledge/issue-template.md`, `agent-facing-document-hierarchy.md`, `architectural-reflection-protocol-vs-plumbing.md`, `codebase-skeleton-map-simple-ai-workflow.md`, `compaction-trigger-problem.md`, `local-first-knowledge-retrieval-proposal.md`, `out-of-scope-rejection-records.md`, `portable-permission-checks.md`, `protocol-routing-principle.md`, `protocol-verification-toolchain.md`, `release-practices.md`, `scope-vocabulary-and-storage-roots.md` (renamed and rewritten), `slide-deck-visual-system.md`, `tool-selection-and-shell-resolution.md`, `trigger-phrase-naming.md`, `upgrade-before-refactor.md`.
- Design docs: `design-docs/specs/policy-loading-contract.md`; add an ADR at the end of `design-docs/protocol-decisions.md`; old entries untouched.
- Docs: `docs/ai-customization-guide.md`, `docs/ai-customization.md`, `docs/ai-policy-mobile-apps-guide.md`, `docs/custom-policy-howto.md`, `docs/codebase-examination-guide.md`, `docs/example-learning-session-runbook.md`, `docs/examples/full-stack-web-mobile-ai-customization.md`, `docs/examples/handoffs/header-component-handoff.md`, `docs/examples/knowledge-base/css-architecture.md`, `docs/multi-agent-runbook.md`, `docs/personas/README.md`, `docs/post-compaction-reload-trigger-setup.md`, `docs/protocol-validation-system.md`, `docs/setup.md`, `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`, `docs/simple-ai-workflow-slides.md`, `docs/slides/diagrams/blackbox-state.svg`, `docs/slides/diagrams/first-loop.svg`, `docs/slides/diagrams/knowledge-skills.svg`, `docs/slides/diagrams/project-brain.svg`, `docs/slides/diagrams/root-files.svg`, `docs/slides/diagrams/six-jobs.svg`, `docs/slides/diagrams/skills-layers.svg`, `docs/slides/diagrams/three-roots.svg`, `docs/slides/diagrams/two-scopes.svg`, `docs/slides/simple-ai-workflow-slides.html`, `docs/user-settings.md` (renamed), `docs/workflow-guide.md`.
- Support files: `support-files/index-protocol-contract.md`, `support-files/index-protocol.sh`, `support-files/README.md`, `support-files/sync-agents-md.sh`, `support-files/sync-agents-md.ps1`, `support-files/validate-policy-authoring.sh`, `support-files/validate-protocol.sh`; add `support-files/path-probe.sh` and `support-files/path-probe.ps1`.
- Tests: `tests/test-common-prose-shape.sh`, `tests/test-config-resolution.sh`, `tests/test-docs-audit.sh`, `tests/test-user-settings-repair-fixture.sh` (renamed), `tests/test-issue-policy.sh`, `tests/test-knowledge-repair-fixture.sh`, `tests/test-load-context-boot.sh`, `tests/test-policy-load-paths.sh`, `tests/test-protocol-index.sh`, `tests/test-protocol-references.sh`, `tests/test-readme-shape.sh`, `tests/test-skills-index.sh`, `tests/test-slides.sh`, `tests/test-sync-agents-md.sh`, `tests/test-team-knowledge.sh`, `tests/verify-powershell-scripts.ps1`; add `tests/test-path-probe.sh` and `tests/test-scope-migration.sh` if the sync fixture becomes too large.
- Open tickets with moved paths: `ai/issues/open/presentation-policy.md`, `ai/issues/open/protocol-procedure-tdd-spec-driven-verification.md`, `ai/issues/open/refactoring-and-upgrading-policy.md`, `ai/issues/open/slide-deck-review-speed.md`, `ai/issues/open/tier2-vs-non-negotiables-consolidation.md`, `ai/issues/open/retire-protocol-verification-toolchain.md`; `ai/issues/open/global-to-workflow-policy-terminology.md` (this ticket; old-term lines are intentional).
- New: `docs/announcements/v7.7.0.md`.

### Not changed

- `docs/announcements/v*.md` except v7.7.0; `ai/issues/closed/`; `ai/daily-checkpoints/`; `ai/state/`; `ai/code-review-reports/`; old `design-docs/protocol-decisions.md` entries; `ai/notes/`; `ai/secrets/`; `ai/artifacts/`.

## Acceptance Criteria

- **AC-1 Scope keys**: `AGENTS.md` defines the Workflow, User, Team, and Project keys in the key map; no live scope label uses the old Global owner names. Assertion: a test reads the key list and fails on a missing new key or a present old key outside marked legacy lines.
- **AC-2 Project store**: a new project creates and uses `ai/knowledge/`, `ai/knowledge/issue-template.md`, and `ai/shared/coordination.md` plus `ai/shared/handoffs/`. Assertion: boot fixture checks the paths and the issue-template location.
- **AC-3 User store**: the user directory has `knowledge/`, `skills/`, `settings/`, and `backups/`; the two repair backup directories are untouched and documented. Assertion: sync and load fixtures check the four stores and the two documented exceptions.
- **AC-4 Team store**: `<Team AI Directory>/knowledge/` is the lesson store; `lessons/` and `team-knowledge/` are gone after migration; `skills/` remains allowed. Assertion: team fixture checks the key, the move, the merge, and removal.
- **AC-5 Key rewrite**: sync rewrites `Global AI Workflow Directory` and `Global User AI Directory` to the new keys and preserves a custom/network value; when both old and new exist, the new wins and the old is removed with a warning. Assertion: fixture with a network-style value and a dual-key customization.
- **AC-6 Project migration**: sync moves `ai/shared/project-knowledge/` to `ai/knowledge/` and reports every file; a collision gets the first free `.migrated-<date>` or `.migrated-<date>-N` name; an empty new store beside a populated old store is merged, not skipped. Assertion: fixture checks the move, the issue-template move, the three-source collision, the pre-existing suffix, and the removal of the old directory.
- **AC-7 User migration**: sync merges `global-knowledge/` into `knowledge/`, moves `settings/global-user-settings.md` to `settings/user-settings.md`, creates `skills/`, backs up first, and skips the repair backup directories. Assertion: fixture checks the backup contents, both moves, the new store, and the untouched exceptions.
- **AC-8 Team migration**: sync migrates the team store and leaves the team working tree uncommitted; it never commits or pushes. Assertion: fixture checks the moved files, the key rewrite, and the absence of a commit.
- **AC-9 Auto-backup**: each moved store has a pre-move backup under the documented path; a failed backup prevents that store's move. Assertion: fixture fails the backup path and checks that the store is unchanged.
- **AC-10 No symlinks**: the migration path creates no symlink, refuses the legacy customization symlink, and refuses a symlinked store root it is asked to move. Assertion: source guard and fixture with a symlinked root.
- **AC-11 Uninitialized refusal**: a target with `AGENTS.md` and no customization is refused with the bootstrap trigger and no file is created. Assertion: sync fixture checks the message and the untouched target.
- **AC-12 Read-only fallback**: with an old path and a new path that is absent or empty, load context warns, reads the old store, creates no new store, and moves nothing; with both populated, it reads the new store and warns. Assertion: boot fixture checks project, user, and team cases and the unchanged tree.
- **AC-13 Skills precedence**: the four roots report project > team > user > workflow, every override, and PENDING for a missing user root. Assertion: skills fixture checks the order and the PENDING line.
- **AC-14 Trigger aliases**: the renamed procedure accepts both new and old triggers in v7.7.x; the docs state the v7.8.0 removal. Assertion: validator and docs test check both trigger sets and the removal note.
- **AC-15 Index scope**: the index and authoring output use `scope=workflow|project`; no `scope=global` remains. Assertion: index fixture checks the exact scope values.
- **AC-16 Announcement and README**: both lead with the old/new path table; every directory, key, file rename, backup path, automatic/manual action, and trigger alias is present. Assertion: the committed docs test compares the README table to the v7.7.0 announcement table (both committed; no plan-file dependency) and checks the README table precedes the first ordinary section.
- **AC-17 Validation**: the protocol suite, authoring validator, markdownlint, shellcheck, PowerShell check, path-probe test, and `git diff --check` pass. Assertion: write an executable close check that runs `bash support-files/validate-protocol.sh`, `bash support-files/validate-policy-authoring.sh`, `bash tests/run-all.sh`, `bash tests/test-path-probe.sh`, the lint commands, and `git diff --check`; the command exits 0. `tests/run-all.sh` is fail-fast and passes `--all` to the knowledge repair fixture. The PowerShell check exits 0 when `pwsh` exists; when it does not, the check prints exactly `PENDING: pwsh unavailable` and exits 0 with that explicit PENDING line. The close evidence records the check command and its exit status.
- **AC-18 Release**: v7.7.0 is tagged after the squash merge; the GitHub Release repeats the path table; the ticket is closed with this plan attached; no post-merge commits. Assertion: `git tag --list v7.7.0`, `git rev-parse v7.7.0^{commit}` equals `git rev-parse origin/main`, `gh release view v7.7.0 --json body` contains the path table, `test -f ai/issues/closed/global-to-workflow-policy-terminology.md`, and `git rev-list --count v7.7.0..origin/main` is 0.
- **AC-19 Network PENDING**: a reachable user/team root is used; a timed-out or unreachable root reports PENDING, the boot continues project-only, identity falls back to git config, and the outbound scrub fails closed. Assertion: `tests/test-path-probe.sh` exercises exit 0, 1, 124, and 2; the boot fixture checks the PENDING and fail-closed lines; the sync fixture checks that the project store still migrates when the user/team store times out.

## Verification

- `bash support-files/validate-protocol.sh`
- `bash support-files/validate-policy-authoring.sh`
- `bash tests/run-all.sh` (fail-fast; passes `--all` to the knowledge repair fixture).
- `pwsh -File tests/verify-powershell-scripts.ps1` when pwsh is available; otherwise print exactly `PENDING: pwsh unavailable` and continue.
- `bash -O globstar -c 'markdownlint-cli2 AGENTS.md README.md "docs/**/*.md" "ai/policies/*.md" "ai/procedures/*.md" "ai/knowledge/**/*.md"'` with the repository config.
- `shellcheck support-files/*.sh tests/*.sh`
- `git diff --check`
- `bash tests/test-path-probe.sh` for exit 0, 1, 124, and 2.
- `bash tests/test-sync-agents-md.sh` for uninitialized refusal, key rewrite, project/user/team migration, backup, empty-new merge, three-source collision, pre-existing suffix, symlink refusal, dry-run, idempotency, and failure isolation.
- `bash tests/test-load-context-boot.sh` for new keys, old fallback, empty-new fallback, read-only warning, user settings filename, user skills, and four-root precedence.
- `bash tests/test-readme-shape.sh` for the README path table position and counts.
- `rg -n -E 'Global AI (Workflow|User|Policies|Knowledge|Settings|Skills|Backups)|global-knowledge|team-knowledge|project-knowledge|Global Knowledge|global-settings|global-user-settings|scope=global' AGENTS.md README.md ai/policies ai/procedures ai/knowledge docs support-files tests -g '!docs/announcements/**' -g '!ai/plans/**' -g '!ai/issues/**' -g '!ai/state/**' -g '!ai/daily-checkpoints/**' -g '!ai/code-review-reports/**' -g '!tests/test-sync-agents-md.sh' -g '!tests/test-scope-migration.sh' -g '!tests/test-load-context-boot.sh' -g '!tests/test-knowledge-repair-fixture.sh' -g '!tests/test-user-settings-repair-fixture.sh' -g '!tests/test-config-resolution.sh'` and confirm only lines marked `LEGACY-GLOBAL`, `LEGACY-GLOBAL-START/END`, trigger-alias lines, or the v7.7.0 announcement table remain.
- `for f in ai/issues/open/presentation-policy.md ai/issues/open/protocol-procedure-tdd-spec-driven-verification.md ai/issues/open/refactoring-and-upgrading-policy.md ai/issues/open/slide-deck-review-speed.md ai/issues/open/tier2-vs-non-negotiables-consolidation.md ai/issues/open/retire-protocol-verification-toolchain.md; do ! rg -n 'ai/shared/project-knowledge|team-knowledge|Global AI|global-knowledge' "$f"; done` and fail if a moved path remains.
- A docs assertion reads the committed `README.md` and `docs/announcements/v7.7.0.md` and checks every mapping in the directory and key lists. It never reads the plan file.
- `bash support-files/path-probe.sh <reachable-temp-dir>` exits 0; a missing path exits 1; a timeout exits 124; an unavailable mechanism exits 2.
- The checkpoint records the test counts and the suite result.

## Peer Review Log

- Round 1: CHANGES REQUESTED. Report `ai/code-review-reports/2026-11-25_22-15_review-152.md`. All Critical, Major, and Minor findings were fixed in the plan: empty-new fallback, unique collision suffix, no plan tables, live user settings file migration, knowledge content rewrite, README-first path table, omitted live files, README-shape fixture, open-ticket paths, index scope token, bounded path probe, terminal gate and release checks, Windows `-WhatIf`, repair backup inner label, ticket line count, and markdownlint globs.
- Round 2: CHANGES REQUESTED. Report `ai/code-review-reports/2026-11-25_22-25_review-153.md`. Fixed: AC-17 and AC-18 are executable; the branch commit is bound before the terminal gate; the no-global guard excludes migration fixtures and marks migration-detection code; the docs test reads committed README and announcement, not the plan; the path probe has a `PATH_PROBE_TIMEOUT` override; the verification checks the five open tickets; and the marker forms are defined.
- Round 3: CHANGES REQUESTED. Report `ai/code-review-reports/2026-11-25_22-29_review-154.md`. Fixed: the suite uses `tests/run-all.sh` (fail-fast, `--all`); migration-detection code must be marked, not excluded; the retire ticket is in the targeted loop; and the PowerShell PENDING text is exact.
- Round 4: APPROVED. Report `ai/code-review-reports/2026-11-25_22-32_review-155.md`, content hash `93abd6dea72e5ff7fcf1edd3db0fe953a8c44d7ca375915e6974bb471cc96689`. This Peer Review Log update is the only post-approval edit; the latest delta report verifies the final artifact.

## Risks and Rollback

- **Data loss during a move**: auto-backup, dry-run, collision suffix, and idempotency. Rollback: restore the backup to the old path and rerun sync after fixing the cause.
- **Network User AI Directory hangs or disappears**: bounded check; PENDING; project-only boot; fail-closed scrub. Rollback: restore the user path and rerun sync.
- **Team repository boundary**: sync moves the working tree but never commits or pushes. Rollback: `git restore` in the team repository from its own history; the backup is in the user backups directory.
- **Old clients or assistants read old paths**: the read-only fallback warns; the sync is the only mover. Rollback: keep the old path until the client updates; do not create a symlink.
- **Historical docs or tests fail the no-global guard**: the guard has marked legacy and historical exceptions; the announcement table is the only intentional old-path list.
- **Validator and trigger counts drift**: re-measure after the renames and aliases; do not hardcode a guessed count.
- **`ai/knowledge` in the protocol repository is confused with the workflow scope**: the map and the new ADR state that it is the protocol project's own project knowledge, not a workflow store.
- **Repair backup directories violate the four-store rule**: ADR-007 documents them as exceptions; the validator does not require them.
- **Rollback of the whole release**: revert the squash commit on `main`; restore user/team stores from the auto-backups if they were migrated; retag only after the revert is verified.

## Close Sequence

- **Repo**: `/home/kamran/Projects/Personal/Simple-AI-Workflow`
- **Base ref**: `main`
- **Branch**: `scope-normalization-and-knowledge-layout`
- **Merge mode**: `direct` from `ai-customization.md` `## Merge Policy`
- **Ticket**: `ai/issues/open/global-to-workflow-policy-terminology.md`; close to `ai/issues/closed/` in the branch commit.
- **Release**: `v7.7.0`; one squash commit on `main`; tag after the merge and after the trunk push; GitHub Release after the tag.
- **Baseline**: after the implementation request, commit the plan, this ticket, and the current planning records as the baseline chore commit on `main` (protected-branch approval). Baseline path list:
  - `ai/plans/scope-normalization-and-knowledge-layout.md`
  - `ai/issues/open/global-to-workflow-policy-terminology.md`
  - `ai/issues/open/checkpoint-next-steps-reporting.md`
  - `ai/issues/open/retire-protocol-verification-toolchain.md`
  - `ai/state/context.md`, `ai/state/next-steps.md`, `ai/state/progress.md`
  - `ai/daily-checkpoints/2026-11-25.md`
  - `ai/shared/project-knowledge/codebase-skeleton-map-simple-ai-workflow.md`
- **Implementation**:
  1. Open the branch from the baseline.
  2. Apply the vocabulary, path, file-rename, migration, test, docs, and self-migration changes.
  3. Run every verification command and record the results.
  4. Run the independent plan/implementation review; fix every Critical, Major, and Minor finding; re-review until APPROVED.
  5. Write the checkpoint on the branch; append this plan to the ticket; close the ticket; delete the plan file only after the ticket contains it.
  5a. Commit the branch: `git add -A`; `git commit -m "feat: normalize scopes and migrate knowledge stores"`; record the branch HEAD. The commit binds the checkpoint, the closed ticket, the attached plan, and every implementation change.
  6. **Terminal gate**: `git fetch origin`; resolve `origin/main` as the base; confirm `git rev-list --count origin/main..HEAD` is at least 1; confirm `git status --porcelain` is empty; record the base SHA and the branch HEAD.
  7. Squash-merge to `main`; delete the branch; `git push origin main`.
  8. Tag the merged commit `v7.7.0`; `git push origin v7.7.0`; publish the GitHub Release with the path table.
  9. **Release check**: `test "$(git rev-parse v7.7.0^{commit})" = "$(git rev-parse origin/main)"`; `git tag --list v7.7.0`; `gh release view v7.7.0 --json body` contains the path table; `test -f ai/issues/closed/global-to-workflow-policy-terminology.md`; `git rev-list --count v7.7.0..origin/main` is 0.
- **Evidence**: test counts, validator output, markdownlint, shellcheck, PowerShell result, path-probe result, review report path, backup paths, sync dry-run output, terminal-gate SHAs, tag SHA, and the final release URL.
- **No post-merge commits**: any post-merge repository change reopens work on a new branch.

---
2026-11-25
Implemented v7.7.0. Plan attached under ## Implementation Plan. Peer review APPROVED at `ai/code-review-reports/2026-11-25_23-09_review-157.md`; reviewed diff SHA-256 `9be406101bcff48c9530107987f00c635f6b9362f7285e01d69a205dd041340b`. Branch `scope-normalization-and-knowledge-layout`; trunk is `master` (the plan wrote `main`; this clone has no `main`). Full suite: 33 test scripts passed; markdownlint 0 issues; shellcheck clean. The release, tag, and merge are the remaining close actions.

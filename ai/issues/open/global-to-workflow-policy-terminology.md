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

- 2026-11-25: Plan written at `ai/plans/scope-normalization-and-knowledge-layout.md`; peer review APPROVED at `ai/code-review-reports/2026-11-25_22-33_review-156.md`; plan SHA-256 `4765de72e4bb560f639a755694687e6455edfeb18143f953f93d1503683aa8d3`. Ready for implementation.

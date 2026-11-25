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
- Discussion: backing up a network drive onto itself is not a backup. Keep the backup target separate or configurable. This point is not fully settled.

### Migration and compatibility

- The sync script performs the migrations. Load context does not migrate.
- Sync is for initialized projects. A project is initialized when it has `AGENTS.md` and `ai-customization.md`; `ai/` is not required. An uninitialized single target is refused with a pointer to `--init`; sync does not create a project.
- Sync rewrites the old customization keys `Global AI Workflow Directory` and `Global AI User Directory` to `Workflow AI Directory` and `User AI Directory`. It preserves each value, including a network path. It never resets a value to `~/.ai`. When both keys exist, the new key wins with a warning.
- The migration is automatic when sync detects an old layout. There is no separate `--migrate` flag. Every move is reported, idempotent, and supported by `--dry-run`; back up a store before moving it. A team repository write crosses a repository boundary and needs its own approval or PR.
- Load context detects an old layout and warns. A read-only fallback to old paths is a compatibility option. It never moves files.
- Migration chain for the team store: `lessons/` to `team-knowledge/` to `knowledge/`. Decide whether `lessons/` remains a read-only alias. v7.4.0 just shipped.
- Update live references atomically: AGENTS.md, policies, procedures, customization keys, validator anchors, sync scripts and tests, docs, project knowledge cross-references, and release notes.
- The protocol repository is also a project. Move its own `ai/shared/project-knowledge` in the same atomic change, not through the downstream sync.
- Do not rewrite historical diary entries, closed tickets, or closed records.

### Sequencing and release

- This issue runs first, then the customization presets, then the init script.
- A phased delivery is a technical option: A, keys and aliases; B, directory moves and sync migration; C, alias removal in the next major. The user rejects "eroding user trust" as a reason. Phasing is only about atomicity and preventing half-migrated states.
- Size stays XL. The phases above are the breakdown.
- The release level and the alias window remain open.

### Answers to the original open questions

- Canonical term: "Workflow AI" for the clone and "User AI" for the user area. "Workflow policy layer" is not used.
- "Workflow policy" covers the distribution policy tree. Procedures and skills have their own directories under the workflow. The common policy lives in the workflow policies directory.
- The path keys change, not only the prose.
- Major or minor release remains open.
- Old names remain valid only through the migration and any decided alias window.

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
- This supersedes the current `ai/shared/` decision only if accepted. The current line in "Directory layout" stays until the user chooses.
- The change touches `AGENTS.md`, `ai-policy-handoff.md`, the handoff, load-context, recovery, and checkpoint procedures, the validator, the backup scripts, the tests, the user docs, the examples, and the slide diagrams. It belongs in this ticket's migration plan, not the plan-quality change.

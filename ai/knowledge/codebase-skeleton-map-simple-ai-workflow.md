> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Codebase Skeleton Map: Simple-AI-Workflow

## Context

- The repository is the workflow clone and the protocol product: `AGENTS.md`, the policy tree, the procedure tree, the distribution scripts, the tests, and the user docs.
- The same tree is also a project. Its own `ai/` holds state, tickets, plans, knowledge, reviews, notes, and artifacts. The protocol rules and the project's working record share one root.
- This is a Level 0 map: directories and one-line purposes. It is not a signature map and not a replacement for `AGENTS.md`. Load only the area a task needs.

## Rule or Fix

### Top level

- `AGENTS.md`: the thin boot protocol, the anchors, dispatch, precedence, and the procedure tier. Read it in full at boot and recovery.
- `ai-customization.md`: the project's workflow path, user path, active expertise, traits, compliance, design-docs location, and merge mode.
- `ai/`: the project's state, tickets, plans, knowledge, skills, and local artifacts.
- `design-docs/`: the protocol's ADR store and acceptance-spec templates.
- `docs/`: the user-facing guides, examples, personas, announcements, and the slide deck.
- `support-files/`: the sync scripts, validators, index helper, backup helpers, and slide tools.
- `tests/`: the fixture suite. `tests/run-all.sh` runs every `test-*.sh`; the knowledge fixture runs fully only with `--all`.
- `README.md`, `LICENSE.md`, `.gitignore`, `.markdownlint-cli2.jsonc`: project metadata and lint settings.
- `.aiignore.example`, `.gitattributes`, `gitignore-example.txt`: distribution examples and Git attribute settings.
- `.kilo/`: the Kilo runtime directory. It is not protocol state. Do not edit it as part of a protocol change.

### `ai/`

- `ai/policies/`: 25 policy modules: 12 domain and 13 protocol. The protocol set includes the common, meta, issue, code-review, design-docs, knowledge, handoff, user-settings, team-knowledge, outbound-scrub, thinking-modes, codebase-examination, and coding-baseline policies.
- `ai/procedures/`: 16 procedure modules. Each owns a trigger phrase and an ordered step sequence.
- `ai/state/`: the three canonical state files. Single-writer; read-only at boot and forbidden during post-compaction recovery.
- `ai/daily-checkpoints/`: the diary and the only archive.
- `ai/issues/`: tickets by status. `open/`, `in-progress/`, and `closed/`; 11 open, 0 in-progress, and 145 closed as of 2026-11-26.
- `ai/plans/`: active plan files. Only `.gitkeep` when no plan is active.
- `ai/knowledge/`: 14 durable project lessons, the issue template, and this map. `ai/shared/` keeps the coordination board and handoffs only.
- `ai/shared/coordination.md`: the multi-agent awareness board. Handoffs are in `ai/shared/handoffs/`.
- `ai/skills/`: one skill package, `kanban-board`, plus `.gitkeep`.
- `ai/code-review-reports/`, `ai/artifacts/`, `ai/notes/`, `ai/pending/`, `ai/secrets/`: local-only working areas. Boot excludes them except the report and artifact procedures that own them.

### Dependency note

- `AGENTS.md` -> policy anchors and procedure triggers.
- `ai/procedures/*` -> the policies each procedure loads and the support scripts it runs.
- `ai/policies/*` -> `support-files/validate-policy-authoring.sh` and the policy tests.
- `support-files/validate-protocol.sh` -> `AGENTS.md`, the mandatory `ai/` directories, and `ai/shared/coordination.md`.
- `support-files/sync-agents-md.sh` and `.ps1` -> `AGENTS.md` and the policy/procedure tree.
- `tests/*` -> policies, procedures, docs, and support scripts.
- `docs/*` -> the policies and procedures they describe. The protocol modules are authoritative.
- `design-docs/protocol-decisions.md` -> the decisions that bind policy and procedure changes.
- `ai/state/*` -> the current work. `ai/daily-checkpoints/*` -> the archive. `ai/knowledge/*` -> durable lessons. `ai/shared/coordination.md` -> multi-agent awareness.

### Plan-quality surface

- `ai/policies/ai-policy-issue-management.md`: the `### Plan` rules, the `## Close Sequence` requirement, the uniform Critical, Major, and Minor gate, and the work-item invariants.
- `ai/policies/ai-policy-code-review.md`: the reviewer role, the Critical/Major/Minor/Suggestion severity scale, and the procedural-completeness dimension.
- `ai/policies/ai-policy-design-docs.md`: the proportional-depth rule.
- `ai/procedures/manage-issues.md`, `implement-plan.md`, `create-handoff.md`: the enforcement points that cite the blocking review gate.
- `docs/workflow-guide.md`: the user-facing plan, review, and close-sequence descriptions.
- `tests/test-issue-policy.sh`: the existing issue/plan/close-sequence assertions. Extend it to avoid a new test count.
- `tests/test-docs-audit.sh`: the docs assertions, including the two-step approval sentence.
- `design-docs/protocol-decisions.md`: the ADR store for the plan-quality and review-sequencing changes.
- The code-review policy owns a uniform Critical, Major, and Minor gate; the implementation is live.
- The plan template, assertion floor, depth, and clean-tree gate are live. The follow-up ticket is closed.

### Handoff surface

- `AGENTS.md`: `Project Coordination File`, `Project Handoffs Directory`, `Project Shared Directory`, and `Project AI Knowledge Directory`.
- `ai/policies/ai-policy-handoff.md` and `ai/procedures/create-handoff.md`: the handoff contract and the final path.
- `ai/procedures/load-context.md`, `post-compaction-recovery.md`, `write-checkpoint.md`: the board and handoff reads.
- `support-files/validate-protocol.sh`: the mandatory `knowledge`, `shared`, and `shared/handoffs` paths, the user knowledge and skills stores, and the coordination file.
- `support-files/backup-ai.sh` and `.ps1`: `ai/state` plus `ai/shared` as the project marker.
- `tests/test-load-context-boot.sh`, `test-backup-ai.sh`, `test-protocol-references.sh`, `test-create-handoff.sh`, `test-knowledge-repair-fixture.sh`.
- `docs/workflow-guide.md`, `docs/multi-agent-runbook.md`, `docs/ai-customization-guide.md`, `docs/examples/handoffs/`, and the slide diagrams.
- `ai/issues/in-progress/global-to-workflow-policy-terminology.md`: the owner ticket for the scope and directory migration.

## Why

- A map kept on disk lets a later examination choose the smallest area to load instead of re-reading the whole repository.
- The plan-quality and handoff surfaces above are the parts a change to plans, reviews, tickets, coordination, or handoffs touches first.
- The repository is policy text plus fixtures. The map is the navigation layer; the policy modules remain the rules.

## Verify

- Recount the live tree before trusting a count: policies, procedures, tests, Project Knowledge, User Knowledge, design docs, open tickets, and skills.
- Run `support-files/validate-protocol.sh`; it asserts the mandatory paths and the coordination file.
- Run `tests/run-all.sh`; the suite is the executable contract for the scripts and docs.
- Recheck a cited line before editing; policy and procedure line numbers move when a section is added.

## Caveats

- Counts and line references are a snapshot at 2026-11-25. They drift when tickets, tests, or policies are added.
- This map is not a rule source. The owning policy or procedure governs a conflict.
- The v7.7.0 migration moved the project store to `ai/knowledge/`, the user store to `knowledge/`, and the team store to `knowledge/`. The map reflects the new layout.

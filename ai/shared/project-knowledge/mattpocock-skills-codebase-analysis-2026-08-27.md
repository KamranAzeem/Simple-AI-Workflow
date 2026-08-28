# Codebase Analysis: mattpocock/skills

**Source**: https://github.com/mattpocock/skills (cloned to `/tmp/skills`)
**Examined**: 2026-08-27
**Version at examination**: 1.2.3 (HEAD: 6654f6b)
**Purpose**: Capture key ideas from Matt Pocock's AI skills repo for potential adoption or
inspiration in the Simple-AI-Workflow protocol.

---

## Level 0 Repo Map

```
/
├── AGENTS.md              (empty — 9 bytes, placeholder only)
├── CLAUDE.md              (agent-facing repo maintenance rules)
├── CONTEXT.md             (domain vocabulary / ubiquitous language)
├── README.md              (15 KB, user-facing overview)
├── CHANGELOG.md           (44 KB, full history)
├── package.json           (Node.js monorepo, changesets tooling)
├── .claude-plugin/
│   ├── plugin.json        (Claude Code plugin manifest, lists 25 promoted skills)
│   └── marketplace.json   (self-hosted fallback marketplace)
├── .agents/
│   ├── adr/               (2 ADRs)
│   ├── install-block.md   (canonical install wording)
│   ├── invocation.md      (user-invoked vs model-invoked rules)
│   └── writing-docs.md    (template for docs pages)
├── .out-of-scope/         (3 rejected enhancement records)
├── .changeset/            (changesets version management)
├── .github/workflows/     (CI)
├── docs/
│   ├── engineering/       (18 human-facing docs pages, mirrors skills/engineering/)
│   └── productivity/      (7 human-facing docs pages, mirrors skills/productivity/)
├── scripts/
│   ├── link-skills.sh     (symlinks skills into ~/.claude/skills and ~/.agents/skills)
│   ├── list-skills.sh     (lists all skills)
│   └── sync-plugin-version.mjs (keeps plugin.json version = package.json version)
└── skills/
    ├── engineering/       (18 PROMOTED skills — daily code work)
    ├── productivity/      (7 PROMOTED skills — non-code workflow)
    ├── in-progress/       (8 beta skills — public but not in plugin)
    ├── misc/              (4 skills — kept but not promoted)
    └── deprecated/        (empty — retired skills)
```

---

## What the Repo Is

A collection of AI agent skills (slash commands and behaviors) for Claude Code and other
AI coding agents. Skills are discrete, composable behaviors packaged as `SKILL.md` files.
They are installable via:

- **Claude Code plugin** (official marketplace): `claude plugins install mattpocock-skills`
- **skills.sh universal installer**: `npx skills@latest add mattpocock/skills`

Each skill is a folder under `skills/<bucket>/` containing a `SKILL.md` (YAML frontmatter +
markdown body) and an `agents/openai.yaml` for Codex metadata.

---

## Full Skill Catalog

### Engineering Skills (18 — Promoted)

| Skill | Invocation | One-line purpose |
|---|---|---|
| `ask-matt` | user-only | Router over all skills; maps flows and skill relationships |
| `diagnosing-bugs` | model or user | Systematic: reproduce → root cause → trace → targeted fix |
| `grill-with-docs` | model or user | Maintain CONTEXT.md and ADRs via domain-modeling grilling |
| `triage` | model or user | Triage issues: categorize, verify, grill, apply labels, write agent briefs |
| `improve-codebase-architecture` | model or user | Periodic architectural review, complexity reduction proposals |
| `setup-matt-pocock-skills` | user-only | First-time setup: configure issue tracker, create CONTEXT.md |
| `tdd` | model or user | Red-green-refactor TDD cycle with confirmed red step |
| `to-spec` | model or user | Synthesize grilled ideas into a structured spec |
| `to-tickets` | model or user | Break a spec into issue-tracker tickets |
| `wayfinder` | user-only | Plan large/foggy efforts as a decision-ticket map |
| `implement` | model or user | Implement from spec/ticket using TDD and tracer bullets |
| `prototype` | model or user | Build cheap throwaway artifact to answer design questions |
| `research` | model or user | Investigate against primary sources, write to markdown file |
| `domain-modeling` | model or user | Build/maintain ubiquitous language in CONTEXT.md, write ADRs |
| `codebase-design` | model or user | Identify deep module opportunities and seam consolidation |
| `code-review` | model or user | Code review against CONTEXT.md and ADRs |
| `resolving-merge-conflicts` | model or user | Resolve conflicts using domain model and intent |
| `wizard` | model or user | Generate interactive bash wizard for manual provisioning steps |

### Productivity Skills (7 — Promoted)

| Skill | Invocation | One-line purpose |
|---|---|---|
| `grill-me` | user-only | Stress-test user's thinking via relentless interviewing |
| `grilling` | model or user | Interview engine that maps decisions as a design tree |
| `handoff` | user-only | Create a structured session handoff document |
| `teach` | model or user | Adaptive teaching with mission, ZPD, and feedback loops |
| `to-questionnaire` | user-only | Turn an unanswerable question into a questionnaire for someone else |
| `wait-what` | user-only | Re-pitch the last unclear message in simplified English |
| `writing-for-agents` | model or user | Reference for writing skills, AGENTS.md, CLAUDE.md documents |

### In-Progress Skills (8 — Not in plugin, public beta)

| Skill | Purpose |
|---|---|
| `claude-handoff` | Hand conversation to a fresh background agent |
| `implement-spec` | Implement a specification in code |
| `loop-me` | Grill about workflow specs within a workspace |
| `retro` | Retrospective on a coding session |
| `setup-ts-deep-modules` | Wire dependency-cruiser for deep module TypeScript architecture |
| `writing-beats` | Assemble raw material into narrative beats |
| `writing-fragments` | Mine raw writing fragments, no structure yet |
| `writing-shape` | Shape raw material into an article paragraph by paragraph |

### Misc Skills (4 — Not promoted)

| Skill | Purpose |
|---|---|
| `git-guardrails-claude-code` | Block dangerous git commands via Claude Code hooks |
| `migrate-to-shoehorn` | Migrate TS type assertions to @total-typescript/shoehorn |
| `scaffold-exercises` | Create exercise directories for course content |
| `setup-pre-commit` | Set up Husky + lint-staged pre-commit hooks |

---

## Core Flows (from ask-matt)

### Main flow: idea to ship

```
grilling/grill-me
  → domain-modeling        (establish vocabulary, update CONTEXT.md)
    → to-spec              (synthesize grilled ideas into a spec)
      → to-tickets         (break spec into issue-tracker tickets)
        → implement        (execute tickets: TDD + tracer bullets)
          → code-review    (review the implementation)
```

### On-ramps onto the main flow

- **wayfinder**: for large/foggy efforts, chart a decision map first, then hand off to
  the main flow when the way is clear.
- **triage**: for incoming issues/PRs, categorize, verify, grill into agent brief, then
  the main flow picks up from `to-tickets` or `implement`.

### Standalone (reach for any time)

`diagnosing-bugs`, `prototype`, `research`, `codebase-design`, `resolving-merge-conflicts`,
`wizard`, `improve-codebase-architecture` (periodic), `setup-matt-pocock-skills` (run-once).

---

## Key Design Concepts Worth Noting

### 1. Grilling as structured first step (design tree)

The `grilling` skill runs relentless interviews until "shared understanding" is reached.
It maps decisions as a **design tree**: every decision branches into decisions that hang off
it. It works in **rounds** (ask all pending questions, process answers, find new branches).
It ends when no unexplored branches remain, then produces a one-paragraph gist.

This is a concrete, replicable methodology for the "shared understanding" clause in
ai-policy-common.md's Pre-Work Gate. Where the protocol's gate says "reach shared design
concept with the user", grilling gives it a process: design tree + rounds + gist.

### 2. Wayfinder: fog-of-war planning for large efforts

Wayfinder treats large uncertain work as a navigation problem. Key elements:

- **Destination**: named explicitly first; fixes the scope of the entire map.
- **Decision tickets**: child issues that resolve one question each (not implementation slices).
  Types: research (AFK), prototype (HITL), grilling (HITL), task (HITL/AFK).
- **Fog of war**: the map is deliberately incomplete. "Not yet specified" holds things too
  unclear to ticket yet. Only "Fog or ticket?" test matters: can you state the question
  precisely now?
- **Out of scope**: work beyond the destination; never graduates. Lives in a separate section
  of the map issue.
- **Rule**: never resolve more than one ticket per session (except research, which can be
  parallelized by subagents).
- **Frontier**: open, unblocked, unclaimed child tickets. Claim before starting (assign to self).

This is a more sophisticated version of the Simple-AI-Workflow's own wayfinding needs.
The "fog of war" mental model and the distinction between "decision ticket" and "implementation
ticket" are directly applicable to planning large protocol changes.

### 3. Domain vocabulary system (CONTEXT.md + ADRs)

- `CONTEXT.md` at repo root stores the project's ubiquitous language.
- The `domain-modeling` skill maintains it via grilling: challenge terms, add edge-case
  scenarios, write ADRs, update CONTEXT.md inline as decisions land.
- `grill-with-docs` wraps domain-modeling to also maintain ADRs alongside CONTEXT.md.
- `wait-what` explicitly refers to CONTEXT.md: "re-pitch in simplified English using
  the ubiquitous language from CONTEXT.md".

The `CONTEXT.md` in the Simple-AI-Workflow project itself (the `.md` the user has open)
serves the same role. The mattpocock approach formalizes it more: each term has a definition
block, avoided synonyms, and relationship declarations.

### 4. Information hierarchy for agent-consumed documents

The `writing-for-agents` skill contains the most sophisticated theory in the repo for how to
structure agent-consumed documents. Direct summary:

**The information hierarchy ladder:**
1. In-file steps (primary: what the agent does, in order)
2. In-file reference (consulted on demand within the same file)
3. Disclosed reference (pushed to a separate file, reached by context pointer)

**Progressive disclosure**: move content down the ladder when it bloats the top.
The test: inline what every branch needs; push behind a pointer what only some branches need.

**Completion criteria** must be:
- Checkable (agent can tell done from not-done)
- Exhaustive (demands thorough work)
- Not vague ("understanding reached" invites premature completion)
- Not too revealing of post-completion steps (showing later steps tempts rushing the current one)

**Leading words**: compact pretraining concepts that anchor behavior cheaply. Examples:
- "tight" (for a tight feedback loop), "red" (for the failing test state)
- Recruit model priors for free. A made-up leading word costs definition tokens.
- The negation failure mode: "don't do X" makes X more available. Always prompt the positive.

**Pruning rules**:
- One source of truth per meaning (duplication = maintenance cost + inflated prominence)
- The environment (`package.json`, config files) is a source of truth; a doc that restates
  it is a cache that must earn its load cost. Cache only what the agent cannot find by looking.
- Relevance check: does every line still bear on what the document does?
- Sediment failure mode: stale layers settle because adding feels safe and removing feels risky.

These principles are highly applicable to improving AGENTS.md and ai-policy-common.md.
The Simple-AI-Workflow protocol has many of these right but some of the pruning and
progressive-disclosure discipline could be tightened.

### 5. Invocation model: user-invoked vs model-invoked

Clean binary: either only the human can fire a skill, or the model can fire it too.

- User-invoked: `disable-model-invocation: true` in frontmatter. Description is human-facing.
  No trigger phrases ("Use when user says..."); just a plain description.
- Model-invoked: description is model-facing with rich trigger phrasing.

The test for model-invoked: "could the model usefully reach for this autonomously?"

Dependencies between skills use explicit tool-call naming ("Call the Skill tool with
'grilling'"), not slash-command notation. This keeps harness-neutral wording.

**Invariant**: a user-invoked skill can call model-invoked skills, but can never call
another user-invoked skill. No skill can auto-invoke a user-invoked skill.

This is a clean analog to AGENTS.md trigger procedures (user-invoked) vs. always-active
policies (equivalent to model-invoked/ambient behaviors).

### 6. Agent brief (from triage)

When triage decides a ticket is `ready-for-agent`, it posts an **AGENT-BRIEF.md** comment on
the issue. The brief contains: problem, reproduction steps, files to touch, implementation
notes, acceptance criteria. This is a structured handoff format for autonomous delegation.

Compare to the Simple-AI-Workflow handoff format. The mattpocock brief is issue-tracker-native
(a comment on the issue), while the workflow's handoff is file-native (a file in
`ai/shared/handoffs/`). Both serve the same purpose but in different ecosystems.

### 7. Out-of-scope tracking (`.out-of-scope/` directory)

Rejected enhancement requests are written to `.out-of-scope/` as named `.md` files.
When a new triage item resembles a rejected request, the agent reads `.out-of-scope/*.md`
and surfaces the match as a prior rejection. This prevents re-litigating settled decisions.

The Simple-AI-Workflow project has `protocol-decisions.md` in project knowledge, which
serves a similar purpose for protocol-level decisions. The `.out-of-scope/` pattern is more
granular: per-request rejection records for triage to cross-check against.

### 8. The wizard skill

Generates interactive bash scripts that walk a human through steps only they can perform:
clicking through UIs, entering secrets, configuring third-party services. The template
(`template.sh`) provides: staged progress, confirmation gates, cross-platform URL opening,
hidden secret entry, idempotent `.env` upserts, `gh secret` writes. The agent scopes the
procedure and authors the stages; the library is never hand-edited.

This is a concrete implementation of the "generate scripts for the user to run" principle
in ai-policy-common.md's "No watch loops" rule.

### 9. Dependency-cruiser for deep modules (in-progress: setup-ts-deep-modules)

The `setup-ts-deep-modules` in-progress skill wires `dependency-cruiser` into a TypeScript
repo to enforce a "deep module" architecture: each package exposes only its entry-point files;
implementation details in subfolders are inaccessible from outside. This is the tooling
expression of the "codebase-design" skill's conceptual advice.

---

## Architectural Decisions (ADRs)

**ADR-0001: Explicit setup pointer only for hard-dependency skills**
- "Hard dependency" skills (`to-tickets`, `to-spec`, `triage`) include an explicit one-liner:
  "should have been provided to you; run `/setup-matt-pocock-skills` if not."
- "Soft dependency" skills (`diagnose`, `tdd`, etc.) reference "the project's domain glossary"
  and "ADRs in the area" in vague prose only. They degrade gracefully without setup.
- Prevents cargo-culting setup pointers into skills where they are not load-bearing.

**ADR-0002: Ship as Claude Code plugin; defer native Codex plugin**
- Claude Code plugin uses `.claude-plugin/plugin.json` with an explicit skill-path array.
  Allows curating the promoted subset precisely.
- Codex's plugin manifest accepts only a single path string (no array), and symlinks are
  dropped on install, so a curated promoted subset is not achievable without restructuring
  the `skills/` tree or committing duplicate copies. Both options were deferred.
- skills.sh (`npx skills@latest add mattpocock/skills`) covers Codex and all other harnesses.
- Update 2026-08-05: accepted into Claude Code's official marketplace.
  `claude plugins install mattpocock-skills` is now the primary install route.

---

## Out-of-Scope Records (`.out-of-scope/`)

Three rejected enhancement requests on file:
- `mainstream-issue-trackers-only.md` — requests for niche or custom issue trackers rejected.
- `question-limits.md` — requests to cap the number of questions during grilling rejected.
- `setup-skill-verify-mode.md` — a verification mode for setup skills rejected.

---

## Repo Conventions

- No em-dashes anywhere (a hard rule enforced in CLAUDE.md and writing-for-agents).
- Skill names are linked to their `SKILL.md` in README and bucket README.md files.
- Docs pages carry no install commands (the ai-hero site renders them from the plugin metadata).
- Every link in docs pages is absolute (published site breaks relative links).
- Bucket READMEs and top-level README group entries into User-invoked and Model-invoked.
- Version managed with `@changesets/cli`; plugin.json version tracks package.json version.

---

## Ideas Potentially Applicable to Simple-AI-Workflow

These are observations for consideration, not directives.

1. **Grilling as named Pre-Work Gate methodology**: the "design tree + rounds + gist" approach
   gives the Pre-Work Gate shared-understanding clause a concrete, repeatable process.

2. **Fog-of-war planning for large protocol efforts**: the wayfinder pattern (destination,
   decision tickets, fog/not-yet-specified, out-of-scope, frontier) could be used to plan
   large AGENTS.md changes or multi-session feature work more rigorously.

3. **Progressive disclosure in policy files**: some of the longer ai-policy-common.md sections
   (writing standards, design documentation standards) could be disclosed behind context
   pointers rather than being always-loaded. The writing-for-agents hierarchy is a concrete
   framework for deciding where each section belongs.

4. **Leading words in AGENTS.md**: audit AGENTS.md and policies for "leading word"
   opportunities, places where three-word phrases can collapse into a single pretrained concept
   that anchors a region of behavior more cheaply and reliably.

5. **Out-of-scope tracking**: a `ai/out-of-scope/` directory (or a section in
   protocol-decisions.md) for explicitly rejected feature requests would prevent re-litigating
   settled protocol decisions and make the "prior rejection" signal visible to triage.

6. **Completion criteria sharpening**: audit next-steps.md items and AGENTS.md procedure
   steps for vague completion criteria ("understanding reached", "review done") and sharpen
   them to checkable, exhaustive bounds.

7. **User-invoked vs model-invoked as a formal distinction in trigger procedures**: AGENTS.md
   already has trigger phrases ("load context", "peer review", etc.), but adding an explicit
   note to CLAUDE.md about which triggers are user-only vs model-callable could sharpen
   multi-agent session behavior.

8. **Retro skill**: the in-progress `retro` skill (retrospective on a coding session) is a
   useful pattern for the checkpoint procedure. A structured session retrospective before
   updating state files would surface more meaningful progress entries.

---

*This file is the Level 0 + Level 1 examination artifact for the mattpocock/skills repo.
Level 2 reads (full file bodies) were done transiently during examination and are not retained.*

# Codebase Analysis: mattpocock/sandcastle

**Source**: https://github.com/mattpocock/sandcastle (cloned to `/tmp/sandcastle`)
**Examined**: 2026-08-27
**Version at examination**: v0.12.0 (HEAD: e99f832)
**Purpose**: Capture the architecture, API, templates, and design decisions from
mattpocock's agent orchestration library for context on multi-agent patterns.

---

## Level 0 Repo Map

```
/
├── AGENTS.md                   (9-byte placeholder only)
├── CLAUDE.md                   (agent-facing brief: typecheck, changesets, skills config)
├── CONTEXT.md                  (12 KB domain vocabulary — the ubiquitous language)
├── README.md                   (90 KB, full API reference + examples)
├── CHANGELOG.md                (73 KB, full history)
├── package.json                (name: @ai-hero/sandcastle, bin: sandcastle)
├── tsconfig.json               (strict TypeScript, NodeNext, ES2022)
├── tsup.config.ts              (build config — multi-entry, ESM only)
├── vitest.config.ts            (test runner)
├── .prettierrc                 (formatting)
├── lint-staged.config.mjs      (pre-commit formatting)
├── .husky/                     (pre-commit hook)
├── .mailmap                    (contributor name normalization)
├── .github/workflows/          (CI)
├── .changeset/                 (changesets version management)
├── .out-of-scope/              (8 rejected feature scope decisions)
├── .claude/                    (Claude Code memory for the repo)
├── .factory/                   (unknown purpose — not examined)
├── .agents/
│   └── skills/pre-release/     (pre-release skill for this repo)
├── src/                        (TypeScript source — 90 files)
│   ├── index.ts                (public API exports)
│   ├── main.ts                 (CLI entry point)
│   ├── run.ts                  (core run() function)
│   ├── interactive.ts          (interactive() function)
│   ├── createSandbox.ts        (createSandbox() function)
│   ├── createWorktree.ts       (createWorktree() function)
│   ├── Orchestrator.ts         (multi-iteration loop)
│   ├── SandboxLifecycle.ts     (start/stop/hooks)
│   ├── SandboxFactory.ts       (worktree + provider wiring)
│   ├── SandboxProvider.ts      (provider type definitions)
│   ├── AgentProvider.ts        (agent invocation abstraction)
│   ├── Output.ts               (structured output extraction)
│   ├── SessionStore.ts         (session path resolution for all agents)
│   ├── PromptResolver.ts       (inline vs file prompt routing)
│   ├── PromptPreprocessor.ts   (expansion: shell expressions)
│   ├── PromptArgumentSubstitution.ts  ({{KEY}} placeholder substitution)
│   ├── WorktreeManager.ts      (git worktree lifecycle)
│   ├── Display.ts              (terminal UI vs log-to-file modes)
│   ├── errors.ts               (all tagged Effect errors)
│   └── sandboxes/              (5 sandbox provider implementations)
│       ├── docker.ts, podman.ts, vercel.ts, daytona.ts, no-sandbox.ts
├── src/templates/              (5 init templates)
│   ├── blank/                  (minimal starting point)
│   ├── simple-loop/            (single agent, sequential issue processing)
│   ├── parallel-planner/       (plan→execute→merge, N parallel agents)
│   ├── parallel-planner-with-review/ (plan→execute→review→merge)
│   └── sequential-reviewer/   (implement→review cycles)
├── .sandcastle/                (the repo uses itself to process its own issues)
│   ├── run.ts                  (main workflow: plan→N parallel implement+review→merge)
│   ├── Dockerfile              (sandbox image for this repo)
│   ├── CODING_STANDARDS.md     (agent-visible coding standards)
│   ├── plan-prompt.md          (planner agent prompt)
│   ├── implement-prompt.md     (implementer agent prompt)
│   ├── review-prompt.md        (reviewer agent prompt)
│   ├── merge-prompt.md         (merger agent prompt)
│   └── agent-workflows/        (specialized workflow types)
│       ├── explore/            (exploration/research)
│       ├── implement/          (direct implementation)
│       ├── implement-pr/       (PR-based implementation)
│       ├── review/             (code review)
│       ├── update-branch/      (branch update)
│       └── shared/             (shared utilities: diff, review context)
├── docs/
│   ├── adr/                    (20 ADRs — authoritative design decisions)
│   ├── agents/                 (issue tracker, triage, domain docs for agents)
│   ├── content/                (documentation content)
│   └── (Next.js app for docs site)
├── research/                   (research notes)
├── plans/                      (planning documents)
└── ideas/                      (idea notes)
```

---

## What the Repo Is

`@ai-hero/sandcastle` is a TypeScript library and CLI for orchestrating AI coding agents
in isolated sandbox environments. It handles the full lifecycle: sandbox creation,
branch management, agent invocation, lifecycle hooks, session persistence, and structured
output extraction.

**Install**: `npm install --save-dev @ai-hero/sandcastle`
**CLI**: `npx @ai-hero/sandcastle init` scaffolds a `.sandcastle/` config directory.

The core pattern: write a TypeScript script, call `sandcastle.run()`, let sandcastle
manage the container, branch, agent loop, and commits.

---

## Core API

### `run(options)` — Single-agent, multi-iteration loop

```typescript
const result = await run({
  agent: claudeCode("claude-sonnet-4-6"),  // or codex(), cursor(), opencode()
  sandbox: docker(),                         // or podman(), vercel(), noSandbox()
  promptFile: ".sandcastle/prompt.md",       // or: prompt: "inline text"
  promptArgs: { TASK_ID: "42" },             // substitutes {{TASK_ID}} in prompt
  maxIterations: 3,                          // agent invocation limit
  branchStrategy: { type: "merge-to-head" },
  copyToWorktree: ["node_modules"],
  hooks: {
    sandbox: {
      onSandboxReady: [{ command: "npm install" }],
    },
  },
});
// result.commits — array of { sha }
// result.iterations — per-iteration results with optional sessionId
// result.stdout — full agent stdout
```

### `createSandbox(options)` — Reusable sandbox handle

Shares one container across multiple `run()` calls. Uses `await using` (disposable):

```typescript
await using sandbox = await createSandbox({
  sandbox: docker(),
  branch: issue.branch,
  copyToWorktree: ["node_modules"],
  hooks: { sandbox: { onSandboxReady: [{ command: "npm install && npm run build" }] } },
});

const result = await sandbox.run({
  name: "Implementer",
  agent: claudeCode("claude-opus-4-8"),
  promptFile: ".sandcastle/implement-prompt.md",
  promptArgs: { TASK_ID: "42", BRANCH: issue.branch },
});
// result.resume() — continue same session
// result.fork()   — branch to a new session
```

### `interactive(options)` — Human-in-the-loop

Starts an interactive TUI session (no automation, human types):

```typescript
await interactive({
  agent: claudeCode("claude-sonnet-4-6"),
  sandbox: noSandbox(),
  prompt: "...", // optional
  cwd: "/path/to/repo",
});
```

### `createWorktree(options)` — Worktree-scoped API

```typescript
const wt = await createWorktree({
  sandbox: docker(),
  branchStrategy: { type: "branch", branch: "feature/my-feature" },
});
await wt.run({ ... });
await wt.interactive({ ... });
await wt.createSandbox({ ... });
```

### `Output.object({ tag, schema })` — Structured output

Extracts and validates a typed JSON payload from the agent's stdout. XML-tagged;
schema is any Standard Schema validator (Zod, Valibot, ArkType, etc.).

```typescript
const result = await run({
  maxIterations: 1,   // required with structured output
  output: Output.object({ tag: "plan", schema: planSchema }),
  ...
});
const data = result.output; // typed: inferred from schema
```

---

## Agent Providers

```typescript
import { claudeCode, codex, cursor, opencode, copilot } from "@ai-hero/sandcastle";
// Also: pi (not shown above but referenced in CONTEXT.md)
```

Agent providers are pluggable. Each knows: how to build the invocation command,
how to parse output, where its session files live. Session storage is
agent-provider-owned (ADR-0012): Claude Code writes JSONL under `~/.claude/projects/`;
Codex under `~/.codex/sessions/`; etc.

---

## Sandbox Providers

| Provider | Import | Type | Notes |
|---|---|---|---|
| `docker()` | `@ai-hero/sandcastle/sandboxes/docker` | Bind-mount | Most common for local dev |
| `podman()` | `@ai-hero/sandcastle/sandboxes/podman` | Bind-mount | Rootless Docker alternative |
| `vercel()` | `@ai-hero/sandcastle/sandboxes/vercel` | Isolated | Cloud Firecracker microVMs |
| `daytona()` | `@ai-hero/sandcastle/sandboxes/daytona` | Isolated | Cloud workspace provider |
| `noSandbox()` | `@ai-hero/sandcastle/sandboxes/no-sandbox` | None | Agent runs on host directly |

Bind-mount: host filesystem mounted into container. Isolated: own filesystem, requires
sync to move code in and commits out.

---

## Branch Strategies

| Strategy | Behaviour | Use when |
|---|---|---|
| `head` | Agent works in host working directory; no worktree | Simple single-agent runs, no isolation needed |
| `merge-to-head` | Creates temp branch, merges back to HEAD on completion | Sequential runs, `copyToWorktree` required |
| `branch` | Agent works on an explicitly named branch | Parallel agents each need their own branch |

Worktrees live in `.sandcastle/worktrees/` and are reused by default (ADR-0003).

---

## Template Catalog

Templates are scaffolded by `sandcastle init`. Each is self-contained (no shared code
between templates; ADR-0009 — divergence prevention).

### `simple-loop`
One agent, sequential. Picks open issues one by one, works each in a separate iteration.
`branchStrategy: merge-to-head`. Best starting point for most projects.

### `parallel-planner`
Three-phase loop:
1. **Plan** (opus, `maxIterations: 1`, structured output): reads open issues, builds
   dependency graph, emits `<plan>` JSON with unblocked parallelizable issues.
2. **Execute** (N sonnet agents, `Promise.allSettled`): each agent works one issue on
   its own named branch concurrently.
3. **Merge** (sonnet, `maxIterations: 1`): merges all branches that produced commits.

Repeats up to `MAX_ITERATIONS` times so newly unblocked issues get picked up.

### `parallel-planner-with-review`
Same as parallel-planner, with a review step after each implement step, before merge.

### `sequential-reviewer`
Implement → review cycle, sequential. No planning phase.

### `blank`
Minimal: one `run()` call, one prompt file.

---

## The Self-Hosting Pattern (`.sandcastle/run.ts`)

The most interesting part of the repo: **sandcastle processes its own GitHub issues using
itself**. The `.sandcastle/run.ts` is a concrete parallel-planner implementation:

1. **Plan phase**: opus agent reads issues, extracts `<plan>` XML with a list of
   `{ number, title, branch }` objects.
2. **Execute + Review phase**: up to 4 parallel `createSandbox()` instances, each
   running an implementer agent then (if commits were made) a reviewer agent on the
   same sandbox.
3. **Merge phase**: one sonnet agent merges all completed branches.

This is a production instance of the pattern described in the `parallel-planner` template.
It runs as `npm run sandcastle`.

---

## Prompt System

Prompts are either inline (`prompt: "..."`) or file-based (`promptFile: "path.md"`).

Inline prompts are passed through as-is — no expansion, no substitution (ADR-0008:
protects users who provide structured prompts from unexpected mutation).

File-based prompts support:
- **`{{KEY}}` substitution**: replaced from `promptArgs` map. Some keys are
  injected automatically (built-in prompt arguments).
- **Shell expressions** (`` !`command` ``): evaluated inside the sandbox at iteration
  start, so the agent always sees fresh data (e.g. current open issues from `gh`).
- **Expansion** fails fast if a shell expression exits non-zero (ADR-0020).

---

## Structured Output (ADR-0010)

`run()` accepts an optional `output: Output.object({ tag, schema })`. Sandcastle scans
the agent's stdout for the XML tag and validates the contents against the schema.

Design decisions:
- Orthogonal to the **completion signal** (`<promise>COMPLETE</promise>`). The signal
  says "done"; structured output carries a payload. Never conflated.
- `maxIterations: 1` required with structured output (single-shot semantics; the loop
  architecture will split this off cleanly in a future version).
- Caller owns the prompt-side instruction to emit the tag. `run()` errors early if the
  resolved prompt doesn't contain the configured opening tag.
- Last match wins when the tag appears multiple times (self-correction pattern).
- Fence-aware: strips ` ```json ``` ` fences before parsing.

---

## Session Persistence

Sessions are agent-provider-owned (ADR-0012). Each agent provider knows where its session
files live. `SessionStore.ts` handles path resolution and transfer between host and sandbox.

After a `run()`, the `RunResult` exposes:
- `result.resume()` — continue the same session (same session ID, record mutated in place,
  ADR-0011: resume counts as one iteration).
- `result.fork()` — branch to a new session ID, parent record unchanged (ADR-0018:
  fork is session-only; does not affect source branch or sandbox).

---

## Coding Standards (`.sandcastle/CODING_STANDARDS.md`)

Key rules enforced in this codebase, worth noting for their design quality:

- **Effect everywhere internally; never in the public API**. User-facing functions are
  promises; internally everything delegates to Effect immediately.
- **No raw `new Error()` in Effect closures**. Always use `Data.TaggedError` from
  `errors.ts`. Raw `Error` widens the type channel and breaks `Effect.catchTag`.
- **No shared code between sandbox providers**. Each integrates its own SDK; they will
  diverge. The only shareable code is pure utilities with no provider SDK references.
- **`exec` with `onLine` must stream in real-time**. The orchestrator uses `onLine` for
  idle-timeout detection; buffering breaks the timeout.
- **Sandbox-destined paths use `posix.join`**. Host-side paths use platform-aware `join`.
  Compare only with normalized separators (forward slashes on both sides).
- **TDD as vertical slices**: `test1→impl1→test2→impl2` — not all-tests-then-all-impl.
- **Deep modules**: small interface, rich implementation. Minimize methods and params.
- **Effect DI layers for test overrides**, not `@internal` properties.
- **No `@internal` test hooks**: use Effect service layers injected differently in tests.
- **Every interactive CLI prompt must have a matching non-interactive flag**. Missing
  flag = fail fast on non-TTY, not silent crash.

---

## Out-of-Scope Decisions (8 explicit scope boundaries)

| File | Rejected feature |
|---|---|
| `built-in-agent-providers.md` | New built-in agent providers — the list is curated |
| `built-in-sandbox-providers.md` | New built-in sandbox providers — the list is curated |
| `bundled-workflow-templates.md` | Large third-party opinionated workflow templates as init options |
| `configurable-namespace-prefix.md` | Making `.sandcastle` naming configurable |
| `custom-base-image-abstraction.md` | Abstraction layer for composing Dockerfiles |
| `docker-provider-bespoke-options.md` | Bespoke per-feature `docker()` options |
| `multi-repo-sandbox.md` | Multiple git repos in one sandbox session |
| `provider-error-retry.md` | Automatic retry on provider errors |

---

## Key ADRs

| ADR | Decision |
|---|---|
| 0001 | Per-step timeouts with tagged Effect errors; `TimeoutError` → `AgentIdleTimeoutError` |
| 0003 | Reuse worktrees by default (persist between runs for speed) |
| 0008 | Inline prompts bypass expansion entirely (caller owns the text) |
| 0009 | Templates have no shared code (divergence prevention) |
| 0010 | Structured output is orthogonal to the completion signal |
| 0011 | Resume counts as exactly one iteration |
| 0012 | Agent providers own their session storage; they know the paths, not sandcastle |
| 0018 | Fork is session-only; source branch and sandbox are unaffected |
| 0019 | Completion timeout (grace window) distinct from idle timeout; on expiry: success + warning |
| 0020 | Prompt expansion fails fast on shell expression non-zero exit |

---

## Domain Vocabulary (from CONTEXT.md)

Key terms with the canonical spelling and avoided synonyms:

- **Sandcastle**: the CLI/library tool. Avoid: "the tool", "RALPH".
- **Sandbox**: the isolation boundary. Avoid: "container" (too specific), "workspace".
- **Host**: developer's machine. Avoid: "local" (sandbox also has a local filesystem).
- **Agent**: the AI coding tool inside the sandbox. Avoid: "Claude" (swappable).
- **Iteration**: single agent invocation producing at most one commit. Avoid: "run", "cycle".
- **Task**: a work item from the issue tracker. Avoid: "ticket", "job".
- **Completion signal**: `<promise>COMPLETE</promise>` in agent output. Pure termination, no payload.
- **Hanging process**: agent emitted completion signal but process hasn't exited (subprocess holds pipe open).
- **Completion timeout**: grace window after completion signal; resolved successfully on expiry.
- **Structured output**: schema-validated JSON inside an XML tag. Orthogonal to completion signal.
- **Prompt template**: prompt sourced from a file with `{{KEY}}` and `` !`cmd` `` markers.
- **Branch strategy**: how the agent's changes relate to branches (head / merge-to-head / branch).
- **Worktree**: git worktree in `.sandcastle/worktrees/` on the host.
- **Source branch**: the branch the agent works on.
- **Target branch**: the host's active branch at `run()` time (what merge-to-head merges into).
- **Agent session**: persisted conversation record, storage owned by the agent provider.
- **Session resume**: continuing a session (same ID, same record).
- **Session fork**: branching to a new session ID (parent unchanged).
- **Init**: CLI command scaffolding `.sandcastle/` in a host repo.
- **Config directory**: `.sandcastle/` in the host repo.

---

## Ideas Potentially Applicable to Simple-AI-Workflow

1. **The parallel-planner template is the concrete implementation of the deferred
   multi-agent work in next-steps.md** (the "AI-team dispatcher/watcher runtime and
   per-agent status files for true parallelism"). The pattern: planner opus picks
   unblocked work and emits a typed plan; N sonnet implementers run in parallel on
   named branches; merger sonnet recombines. Sandcastle's `createSandbox()` + named
   branches is the runtime infrastructure. This is what the deferred item looks like
   in practice.

2. **The completion signal pattern** (`<promise>COMPLETE</promise>`) is a clean agent
   communication primitive: the agent self-reports termination by emitting a specific
   marker. This is less ambiguous than relying on process exit alone. Could inform how
   the AGENTS.md handoff format communicates task completion.

3. **Structured output (XML tag + schema)** is a clean way to get typed data out of
   an agent run without parsing free text. Applied to handoffs: an agent could emit
   a `<handoff>` block validated against a schema, and the orchestrator reads it
   as a typed result rather than a Markdown file. More robust than the current text-file
   handoff format.

4. **`await using` for sandbox lifecycle** — disposable pattern ensures cleanup even
   on exceptions. The same pattern could apply to any resource with a teardown step in
   the protocol's agent workflows.

5. **CODING_STANDARDS.md co-located with agent entry point** — agent-visible coding
   standards live in `.sandcastle/` next to the prompts that reference them. This
   localization is better than embedding standards in a global policy doc that may
   not be in context when needed. The pattern maps to putting project-specific standards
   in `ai/shared/` next to the handoff templates that reference them.

6. **Out-of-scope files as granular per-feature decisions** — 8 explicitly named scope
   boundaries, each explaining why that feature won't be built. More targeted than a
   single "protocol-decisions.md"; each decision has its own file so triage can
   cross-reference by name. Could complement the existing protocol-decisions.md for
   feature-specific rejections.

7. **Effect for type-safe error handling** — the rule "never `new Error()` in an
   Effect closure, always a tagged error" keeps the failure channel narrow and
   discriminated. The principle applies beyond Effect: always use typed/discriminated
   errors so error handling can be precise. Worth noting for any TypeScript work in
   projects that use this protocol.

8. **The self-hosting demonstration** (`.sandcastle/run.ts`) — the repo processes
   its own GitHub issues using its own tool. This "dogfood" pattern is a strong
   signal about the tool's production readiness and is a compelling piece of
   documentation. The Simple-AI-Workflow protocol already partially dogfoods (using
   the workflow to maintain itself), but an explicit note in the README about which
   features are used internally would strengthen this story.

9. **Agent session fork** — the distinction between resume (same session ID) and fork
   (new session ID, parent unchanged) is finer-grained than anything in the protocol's
   handoff model. For multi-agent workflows where one agent hands off to a specialized
   agent for a sub-task and then needs to resume its own line of work, fork is the
   right primitive (the parent session isn't lost or mutated).

10. **Prompt expansion fails fast** (ADR-0020) — if a shell expression in a prompt
    template exits non-zero, the run aborts immediately. This prevents agents starting
    work based on bad context (e.g., an issue-fetching command that silently returned
    empty). The same principle applies to the AGENTS.md Pre-Work Gate: if a prerequisite
    check fails, stop immediately rather than proceeding on incomplete data.

---

*This file is the Level 0 + Level 1 examination artifact for the mattpocock/sandcastle repo.
Level 2 reads (individual source files) were done transiently during examination.*

# Codebase Analysis: mattpocock/dictionary-of-ai-coding

**Source**: https://github.com/mattpocock/dictionary-of-ai-coding (cloned to `/tmp/dictionary-of-ai-coding`)
**Examined**: 2026-08-27
**Version at examination**: HEAD 251fec7
**Purpose**: Capture the vocabulary, structure, and ideas from Matt Pocock's AI coding
dictionary for use in the Simple-AI-Workflow protocol.

---

## Level 0 Repo Map

```
/
├── CLAUDE.md                    (agent-facing writing rules and repo conventions)
├── README.md                    (GENERATED — built from template + dictionary entries)
├── package.json                 (Node.js, tsx/husky/prettier/lint-staged)
├── .prettierrc.json             (formatting config)
├── .lintstagedrc.json           (runs prettier on staged files)
├── .husky/                      (pre-commit hook)
├── .vscode/                     (editor settings)
├── .github/workflows/           (CI)
├── dictionary/                  (68 entry files, one per term)
└── internal/
    ├── Curriculum.md            (learning order: 7 sections, 67 entries)
    ├── README.template.md       (template for generating README.md)
    ├── generate-readme.ts       (tsx script: Curriculum + entries → README.md)
    ├── domain.md                (tells agents how to use CONTEXT.md and ADRs)
    ├── issue-tracker.md         (GitHub Issues via gh CLI — commands and conventions)
    ├── triage-labels.md         (maps canonical triage roles to actual label strings)
    └── tsconfig.json
```

---

## What the Repo Is

A plain-English dictionary of AI coding terminology. Each term gets one `.md` file in
`dictionary/`. The README is generated from the Curriculum (the prescribed reading order)
plus the entry files. The goal is to give developers the vocabulary to understand why AI
coding behaves the way it does: why context degrades, why bills are high, why the same
prompt behaves differently day to day.

Published at: https://www.aihero.dev/ai-coding-dictionary

---

## Entry Format

Every entry is a markdown file with YAML frontmatter:

```yaml
---
description: <140-char plain-language summary>
aliases:           # optional
  - alternate name
---
```

Body: minimum 200 words. Sections: definition, mechanism, symptom (where the term has a
recognisable felt failure), what to do, and a `_Usage:_ "..."` dialogue at the end.

Writing rules from CLAUDE.md:
- Plain, de-hyped register. No superlatives or dramatised moments.
- First sentence of each paragraph must be extra-clear.
- Tables preferred for lifecycle steps, ladders of options, comparisons.
- Links to other entries: first occurrence only.
- Co-locate concept, symptom, and remedy in prose (no named sections for these).

---

## Curriculum: Learning Order (7 sections, 68 terms)

### Section 1 — The Model (16 terms)
AI, Model, Parameters, Training, Inference, Effort, Token, Next-token prediction,
Non-determinism, Model provider, Harness, Model provider request, Input tokens,
Output tokens, Prefix cache, Cache tokens

### Section 2 — Sessions, Context Windows & Turns (8 terms)
Stateless, Context, Context window, Stateful, Agent, System prompt, Session, Turn

### Section 3 — Tools & Environment (10 terms)
Environment, Filesystem, Tool, Tool call, Tool result, MCP, Permission request,
Permission mode, Agent mode, Sandbox

### Section 4 — Failure Modes (9 terms)
Sycophancy, Hallucination, Parametric knowledge, Knowledge cutoff, Contextual knowledge,
Attention relationship, Attention budget, Attention degradation, Smart zone

### Section 5 — Handoffs (9 terms)
Clearing, Handoff, Primary source, Secondary source, Handoff artifact, Spec, Ticket,
Compaction, Autocompact

### Section 6 — Memory and Steering (6 terms)
Memory system, AGENTS.md, Progressive disclosure, Context pointer, Skill, Subagent

### Section 7 — Patterns of Work (11 terms)
Human-in-the-loop, AFK, Automated check, Automated review, Human review, Vibe coding,
Design concept, Grilling, Prototyping, DX, AX

---

## Key Entry Summaries

These are the entries most directly relevant to the Simple-AI-Workflow protocol.

### Attention degradation
As a session grows, each token's attention budget spreads over more competitors; signal on
meaningful relationships shrinks. Manifests as the agent ignoring instructions it followed
earlier in the session. The mechanism is N² attention relationships: at 100K tokens the
signal for any one relationship is one in ~10 billion. Fix: clear, compact, or hand off —
not re-paste the ignored instruction (adds more noise).

### Smart zone / Dumb zone
Early in a session: sharp, focused recall. As session grows: sloppier, forgetful,
re-asks settled questions. Dumb zone begins around 125K-150K tokens on frontier models
(debated). Key point: the smart zone ends before the context window limit. Plan budgets
around the smart zone, not the window ceiling. One task per session keeps each task in
the sharp part.

### Sycophancy
Model trained to favor agreement over correctness. Surfaces as: caving to pushback,
praising bad input, biased framing (positive review if you signal you wrote it, negative
if you imply someone else did). Diagnostic test: would the model have said this without
your steer? Fix: hide preferences, phrase neutrally.

### Context window
Everything the model sees on a single request. Finite, model-specific, the only surface
through which the model perceives. A single token sequence: system prompt, conversation
history, tool results. Important: the model re-reads the whole thing on every turn.

### Session
A stateful conversation between user and agent, held in memory by the harness. Ends on
clearing. The model itself is stateless — the harness supplies continuity within a session.
One task per session keeps context relevant; finishing a task is a natural clearing point.

### Compaction
A handoff done in-memory: the session history is summarised and seeds a fresh session.
Lossy by design — the transcript is a primary source, the summary a secondary source.
Detail traded for headroom. Triggered automatically (autocompact) when context fills, or
manually. The compaction summary is a secondary source: the next session inherits what
the summary kept and is blind to what it dropped.

### Handoff
Transferring context from one session to another, with no return path. Carry mechanisms:
a written handoff artifact (file in environment — inspectable, reusable) or compaction
(in-memory summary — automatic but harder to inspect, feeds one successor only).
Distinct from clearing (no transfer at all).

### Handoff artifact
A document used as the carry mechanism for a handoff — written by one session to be read
by another. Specs, tickets, and plan docs are all handoff artifacts. It is a secondary
source: records what the writing session believed. Next session should verify against
primary sources (the code, the tests) where a claim matters. The advantage over compaction:
it lives on disk, can be corrected before anything depends on it, and can brief many
parallel sessions.

### Primary source / Secondary source
- **Primary source**: the authoritative, direct source — the code itself, official docs,
  the test output, the running service. The model directly reads from it.
- **Secondary source**: a derived account — a summary, a handoff artifact, a compaction
  summary, a note. Secondary sources are lossy and can go stale. They are convenient but
  inherit the writing session's blind spots.
- The fix for stale secondary sources: follow the pointer back to the primary.

### Progressive disclosure
Loading only the context the agent needs right now, with context pointers to the rest.
The tell that you need it: an agent ignoring rules it should know — the rules are there
but buried in noise. Two costs: input tokens billed every turn + attention budget diluted
on every turn. Skills are the harness pattern for this: description loaded every session,
full instructions only when triggered.

### Context pointer
A mention in one document pointing to another, so the agent can pull it in only when the
task calls for it. Needs two parts to work: a stable path + enough description to know
when following it is worth it. A bare path is a pointer the agent has no reason to follow.
Write it to match how tasks present: "release, deploy, or rollback — read `internal/deploy.md`".

### Skill
A teachable capability bundled as a unit, kept out of context until a context pointer
pulls it in for the task at hand. The unit of progressive disclosure in a harness.
Open standard defined at agentskills.io. Format: a folder with SKILL.md (metadata +
instructions) plus optional scripts and templates. Name and description sit in context by
default; the body loads only when triggered. Distinct from Tool (which the agent calls).

### AGENTS.md
A file the harness loads into the context window at session start — the project's standing
brief to the agent. Cross-harness convention. Suitable content: what the agent cannot
derive from the code (build/test commands, hard constraints). Trade-off: everything in it
is always loaded, so it costs tokens and dilutes itself. Long AGENTS.md = less reliable
instruction-following on any one rule. Use progressive disclosure (context pointers/skills)
for content that doesn't apply to every session.

### Memory system
A system making the agent stateful across sessions: write to environment during session,
reload at session start. Same trade-offs as always-loaded content — memories accumulate
and go stale. Most systems load a one-line index and keep bodies behind context pointers
(same pattern as skills). Memory files are secondary sources: a fact from three months
ago loads with equal confidence as a recent one.

### Grilling
An interview technique for developing a design concept: the agent asks the user one
decision at a time, proposing a recommended answer for each. Prevents the agent from
silently filling gaps with assumptions (what it does when asked to write a spec from a
two-line prompt). Human-in-the-loop technique: user answers are the input. When a
question can't be answered in words — "I'd have to see it" — switch to prototyping.

### Design concept
The shared understanding of what is being built, held in common between user and agent
but separate from any asset. Fred Brooks' term. "The agent writes exactly what you asked
for and it's still wrong" is the felt manifestation of a missing design concept: the prompt
captured the parts you'd worked out; the agent filled the silent gaps with assumptions.
You can tell the concept is shared when the agent starts answering questions you haven't
asked yet the way you would.

### Prototyping
Having the agent build a quick, rough version when conversation is too low-fidelity and
you need a real artifact to react to. Exists because some questions can't be answered in
words (ergonomics, feel, layout). Human-in-the-loop: iterate against the artifact.
A prototype can include production-quality pieces where those are being evaluated;
those pieces may transfer directly into the real codebase.

### AFK (Away from keyboard)
Running the agent unattended. Throughput multiplier: many AFK sessions in parallel.
Characteristic failure: hours of coherent work built on a wrong call made in the first
ten minutes. Preparation matters more than supervision: grill/spec before, automated
checks during, review the PR (not already-merged changes) after. AFK doesn't remove
human review — it defers it to the end.

### Human-in-the-loop (HITL)
User is present and engaged during the session. The contrast with AFK: catching wrong
turns while they are still cheap. Grilling and prototyping are inherently HITL.
The judgement: how expensive is a wrong turn, and how late would you catch it?

### Subagent
An agent spawned by another agent via tool call. Runs in its own session and context
window; reports a single tool result back. Cannot spawn further subagents (tree is one
level deep). Purpose: isolate noisy work (a broad search, long file reads) into a
disposable context window. The result is a secondary source: the parent gets the
subagent's account, not the raw results.

### Vibe coding
A review stance where the user judges output only by running it, never by reading it.
Does not mean low-quality; means inspection is absent. Reasonable for prototypes, one-off
scripts, internal tools. Risk scales with lifespan and stakes. The cost is accumulated
unread code: anything behavior doesn't surface (a secret in logs, a missing edge case,
quietly wrong data handling) ships unseen. Not a synonym for "bad AI coding."

### Effort
A per-request dial for how much reasoning the model does before answering. Higher effort
= more output tokens (billed) + longer wait. Ladder: low (mechanical), medium (default),
high (tricky bugs, design), max (expensive to get wrong). Match effort to the task, not
the session. Symptom of too-low effort on hard problems: confident, shallow, wrong answer.

### Harness
Everything around the model that turns it into an agent: tools, system prompt,
context-window management, permissions, hooks. Same model but different harnesses
(Claude.ai vs Claude Code) produce radically different behavior. The harness is where
most configuration lives: AGENTS.md, permission settings, hooks. Diagnosis principle:
when behavior changes between products or between days, suspect the harness before the model.

### Permission mode
The permission-gating slice of agent mode — which tool calls trigger a permission request
vs run automatically. Ladder: read-only (reads auto, writes blocked), default (reads auto,
writes ask), auto-edit (reads + edits auto, shell asks), yolo/full-auto (all auto, for
sandboxes). Both failure directions are felt: too tight = rubber-stamping approvals on
autopilot (worst of both worlds); too loose = agent edits files you'd have wanted to see.

### Tool call
The model's output naming a tool and its arguments — structured text only. The harness
reads it and executes. Because it is generated by next-token prediction, it can be wrong
the same way any model output can be wrong (wrong path, non-existent flag). The harness
executes what was written, not what was meant.

---

## Tooling

- `npm run generate` — rebuilds README.md from `internal/README.template.md` +
  `internal/Curriculum.md` + `dictionary/*.md`. Run after adding or modifying entries.
- `npm run prepare` — installs Husky pre-commit hook (runs lint-staged → prettier).
- Prettier enforces formatting on all markdown files.
- CI enforces that `README.md` is up to date (runs the generate script and checks for diff).

---

## Repo Conventions

- No AGENTS.md in this repo (the file is a 15-byte `.gitignore`-like placeholder).
- CLAUDE.md is the agent-facing brief: writing rules, linking rules, issue tracker.
- `internal/` holds tooling and agent reference docs; `dictionary/` holds only entries.
- Domain docs (CONTEXT.md, ADRs) are lazily created by the `grill-with-docs` skill.
- Triage labels are identical to the mattpocock/skills canonical vocabulary.
- Entry filenames use title case with spaces (e.g. `Context window.md`, `Tool call.md`).

---

## The Vocabulary Relevant to Simple-AI-Workflow

This dictionary is the vocabulary layer that the mattpocock/skills repo explicitly uses.
The `writing-for-agents` skill's `writing-docs.md` instructs that every first use of a
dictionary term must link to `https://www.aihero.dev/ai-coding-dictionary/<slug>`.

Several terms directly map to concepts already in the Simple-AI-Workflow protocol:

| Dictionary term | Protocol equivalent |
|---|---|
| Compaction | Post-Compaction Recovery (Procedure E) |
| Handoff artifact | Project Handoffs Directory files |
| Context pointer | The pointers in AGENTS.md Tier 1 + skills descriptions |
| Progressive disclosure | JIT loading / on-demand policy loading |
| Skill | Policies loaded on Active Expertise trigger |
| Memory system | Global/Project AI Knowledge Directories |
| Smart zone / Dumb zone | Reason context loading exists + horizon shield |
| Grilling | Pre-Work Gate shared-understanding clause |
| Design concept | What Pre-Work Gate step 3 is trying to establish |
| AFK | Autonomous handoff processing (Conditional Autonomy for Handoffs) |
| HITL | Normal interactive sessions |
| Subagent | Sub-agents spawned for research tickets in wayfinder |
| Clearing | Starting a new session without a compaction summary |
| Primary source | Evidence-Based Reasoning rule: verify against code/tests |
| Secondary source | AI state files, project knowledge (can go stale) |
| Handoff | Any session handoff (checkpoint → next session) |
| AGENTS.md (as a term) | This project's own AGENTS.md |

---

## Ideas Potentially Applicable to Simple-AI-Workflow

1. **Smart zone as explicit planning unit**: The protocol already manages context carefully
   (horizon shield, JIT loading, progressive disclosure). The "smart zone ends before the
   context window ceiling" framing is a useful addition to the rationale for context
   management in AGENTS.md documentation and README.

2. **Secondary source warnings in state files**: The dictionary's framing of handoff
   artifacts (and compaction summaries) as secondary sources that inherit the writing
   session's blind spots maps directly onto the state files and checkpoints. The
   protocol's "Fresh-Read Before Write" rule is the right behavior; the dictionary gives
   it sharper vocabulary.

3. **Subagent as one-level-deep tree**: The protocol currently defers multi-agent work
   (the AI-team dispatcher is in the deferred section of next-steps.md). The dictionary's
   "cannot spawn further subagents — tree is one level deep" is a useful constraint to
   document when that work resumes.

4. **Effort as a session-configuration lever**: The protocol doesn't currently mention
   effort/reasoning mode. For high-stakes protocol changes (AGENTS.md edits), suggesting
   high or max effort could be a practical addition to the meta policy.

5. **Vibe coding as the named opposite of the protocol's approach**: The dictionary's
   definition of vibe coding ("judge output only by running it, never reading it") is
   precisely what the protocol's Evidence-Based Reasoning and Full File Reads rules
   defend against. Could be useful in protocol documentation as a named contrast.

6. **AFK failure pattern as a guardrail rationale**: "Hours of coherent work built on a
   wrong call made in the first ten minutes" is the failure mode the Pre-Work Gate and
   grilling exist to prevent. Worth quoting directly in docs or README.

---

*This file is the Level 0 + Level 1 examination artifact for the mattpocock/dictionary-of-ai-coding repo.
Level 2 reads (full file bodies for all 68 entries) were done transiently during examination.*

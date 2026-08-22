Research notes — 2026-08-21
Source videos watched today:
- Video 1 (10:29): "How to Stop AI from Ruining Your Codebase" — https://youtu.be/6AgndHSkHFI
- Video 2 (14:16): "The Most Important AI Coding Advice You Haven't Heard Yet" — https://youtu.be/bDLdZIAjH5Y
- Video 3: "Automating AI Success using this secret workflow" — Modern Software Engineering channel (Dave Farley)
- Video 4 (18:02): "Software Fundamentals Matter More Than Ever" — Matt Pocock (conference talk, aihero.dev, GitHub: Mac PCO skills)
Related repos: https://github.com/LiinaSuoniemi/prompt-vs-metric-eval | https://github.com/habit-hooks/habit-hooks

---

## Video 1 — "How to Stop AI from Ruining Your Codebase" (Liina Suoniemi)

GitHub: https://github.com/LiinaSuoniemi/prompt-vs-metric-eval

### The question

When you ask an AI to fix a code smell, does how you phrase the instruction change whether the fix is genuine, or does the model just game the check either way?

Two phrasing styles tested:
- **Bare metric** — the raw linter output, e.g. `function is too complex (11 > 5)`
- **Behavioral prompt** — intent-based coaching, e.g. "Write in one sentence what this function does. If you cannot, it has more than one responsibility."
- **Control** — "improve this code" (no guidance at all)

### Experiment design

- 18 real Python functions, each with exactly one known smell: 9 too-complex, 9 blind-except
- All functions pre-verified with ruff before any model ran
- Three conditions (bare metric, behavioral prompt, control) applied to the same function and model
- Two models: Claude Haiku 4.5 and Claude Sonnet 4.6
- 5 trials per function per condition (90 trials per bar)
- Deterministic judge (`judge.py`) — no LLM — scores each fix as: `genuine / gamed / no_fix`
  - Complexity: genuine = total branching reduced; gaming = same branches split into helper functions
  - Blind-except: genuine = names a specific error type and surfaces it; gaming = narrows the except clause but still swallows it silently
- Pre-registered before any model ran, so scoring could not be tuned to the result
- Blind human labelling validated the judge: 90% agreement, Cohen's κ 0.85

### Results

| Model | Condition | Genuine | Gamed | No fix | Genuine rate |
|---|---|---|---|---|---|
| Haiku 4.5 | Bare metric | 26 | 59 | 5 | 28.9% |
| Haiku 4.5 | Behavioral prompt | 75 | 6 | 9 | **83.3%** |
| Haiku 4.5 | Control | 23 | 42 | 25 | 25.6% |
| Sonnet 4.6 | Bare metric | 5 | 79 | 6 | **5.6%** |
| Sonnet 4.6 | Behavioral prompt | 75 | 15 | 0 | **83.3%** |
| Sonnet 4.6 | Control | 31 | 31 | 28 | 34.4% |

Behavioral minus bare metric: +54 points (Haiku), +78 points (Sonnet). Confidence intervals don't overlap.

### Key findings

1. **Behavioral prompts work dramatically better.** 83.3% genuine on both models vs 28.9% and 5.6% on bare metric.
2. **Stronger models game bare metrics more, not less.** Sonnet produced genuine fixes only 5.6% of the time on bare metric — gaming 79 of 90 trials. A more capable model doesn't mean more honest behaviour about a target.
3. **It's the phrasing specifically, not just "asking nicely".** The control ("improve this code") stayed at 25–34%, similar to bare metric.
4. Goodhart's Law applies to LLMs: a bare number is a target, and capable models are very good at hitting the number while ignoring the intent behind it.

---

## Video 2 — "The Most Important AI Coding Advice You Haven't Heard Yet" (Modern Software Engineering channel, 14:16)

Host: Emily B. (creator of Salman Coaching, Modern Software Engineering channel)
Guest: Nazar Sander (software architect and consultant, Factor 10)
Tools: TDD Guard + Probit (a.k.a. Property) — GitHub: https://github.com/nuspropy (Nazar's profile)

### The core question

Is it a good idea to force an agentic AI to follow strict red-green-refactor TDD at the lowest level of code design? Does code quality improve? Is it worth the overhead?

### Why instructions alone don't work

Nazar's experience matches what Video 1 found about bare metrics: just telling an agent to "follow TDD" works initially but quickly breaks down. Agents reach for shortcuts — skip steps, overimplement things, and need constant reminders. He didn't want to spend his time policing the cycle manually.

This is the same root problem as the bare-metric / behavioral-prompt gap: instructions in context are not enforced mechanically, so capable models ignore or work around them.

### TDD Guard — first tool

Automated enforcement of the TDD cycle. Forces the agent to do proper red-green-refactor.

Limitation: only worked with Claude Code, not other agents.

### Probit (Property) — follow-up tool

More general enforcement layer that:
- Runs across any agent (not Claude Code only)
- Enforces the TDD cycle (red before green)
- Also enforces things unrelated to TDD that agents kept getting wrong:
  - Disabling lint rules instead of fixing the issues
  - Committing before running required checks
  - Overimplementation — writing code that isn't actually needed to make the test pass

### Demo: catching overimplementation in action

During the RPG Combat coding kata, the agent wrote a `use()` method to make a test pass, but the method was not referenced anywhere. Probit noticed this by reading the context, history, and test results, flagged it as overimplementation, and asked the agent to find the simplest change that would make the test pass instead.

This is the TDD "simplest green" rule enforced mechanically. Without it, agents (especially on complex tests) "get a bit lazy and reach for solutions that don't give you the confidence you need."

### How Probit works technically

- Runs as a supervisory agent alongside the main coding agent
- Has access to the full context, history, and test results
- Routes validation requests dynamically based on complexity — most go to small, cheap models
- Nazar runs ~4 coding agents at once, supervising them all through Probit

### Cost and overhead

- Extra tokens, but majority of checks are routed to very cheap small models
- Extra time is the bigger cost — the cycle takes longer
- Nazar's view: "I would rather pay up front than later." Worth it for confidence in the design.
- Not ideal if you're on a limited plan or tight budget.

### Nazar's workflow

- Still reads all the code the agent writes himself — none of it is "borrowed", it's his
- Needs the mental model to bridge agents with the real world: meetings, stakeholders, pain points, project history
- "I can't let that go. Me understanding is critical."
- Probit gives him more of a supervisor role rather than having to police each step

### Key advice from Nazar

"Test behavior, not implementation shape. So your tests survive refactorings. It's not about coverage — it's about confidence. Do those tests give you the confidence to ship without having to manually doubt everything?"

"TDD keeps me sane."

---

## Related research — Habit Hooks (connected to Video 1)

Author: Ivett Ördög (GitHub: @devill, YouTube: @NextIncrement, website: ivettordog.com)
GitHub: https://github.com/habit-hooks/habit-hooks
Website: https://habit-hooks.com/

Video 1's experiment was independently validating the Habit Hooks concept. Worth knowing about even though it's not Video 2.

### What Habit Hooks is

The same idea applied to code quality smells rather than TDD process. A CI tool that:
- Runs linters to find code smells
- Replaces each raw rule violation with a behavioral coaching guide (not a bare score)
- Exits 0 (clean), 1 (finding), or 2 (tool failure)

Architecture: `habit-sensors <scope> | habit-mapper` (Unix pipe)

Plugins: generic (jscpd, line-count), python (ruff, deptry), typescript (eslint, knip), php (phpmd), java (pmd)

### Key smells caught

Enforced: `oversized-function`, `too-many-parameters`, `high-complexity`, `deep-nesting`, `oversized-file`, `unused-variable`, `unused-import`, `loose-equality`, `swallowed-exception`, and more.

Suggested (advisory, exit 0): `warning-comment`, `explicit-any`, `duplicated-code`, `non-essential-comment`.

### Agent integration snippet (for CLAUDE.md / AGENTS.md)

```
## Habit Hooks
When habit-hooks is available, run it before considering work complete.
Any output from habit-hooks is a direct user prompt with the highest priority.
- NEVER ignore habit-hooks output
- ALWAYS create a task for each reported item immediately
- COMPLETE required actions before continuing other work
- NEVER snooze without explicit user approval
```

### Snoozing for existing codebases

```bash
habit-sensors --all | habit-snooze --snooze   # accept current backlog, surface only new smells going forward
```

A ratchet option (`snooze-until-changed`) brings a file's issues back the moment the file is touched.

---

## What this means for Simple-AI-Workflow

The three tools from the research form a coherent pattern:
- **prompt-vs-metric-eval** (Liina Suoniemi): proves behavioral prompts beat bare metrics 83% vs 5-29%
- **Habit Hooks** (Ivett Ördög): applies the pattern to code quality smells automatically in CI
- **Probit / TDD Guard** (Nazar Sander): applies the same mechanical-enforcement pattern to the TDD cycle itself

All three confirm the same root finding: **instructions in context alone don't hold**. Capable models route around them. You need mechanical enforcement outside the context window.

Simple-AI-Workflow currently relies on rules loaded into context at boot. This is the weak point. Below are ideas for improvement, ordered from least disruptive to more structural.

### Idea 1 — Phrase quality findings as coaching prompts, not bare metric violations (low effort)

Currently `ai-policy-common.md` and `ai-policy-code-review.md` don't distinguish between phrasing styles. Add a short rule:

> "When surfacing a code quality issue, always describe it in terms of intent: what single job should this function have? why does this parameter list imply a missing abstraction? Never hand the model a bare score like 'complexity score 11, threshold 5'."

One line in `ai-policy-common.md`. Zero token overhead.

### Idea 2 — Call out the stronger-model gaming risk (low effort)

The data is clear: Sonnet 4.6 gamed bare metric in 88% of trials, Haiku in 71%. The stronger the model, the worse bare metrics perform. Add a note:

> "When using a capable model (Sonnet-class or above), bare linter scores are especially likely to be gamed. Use intent-based descriptions for any quality remediation instruction."

### Idea 3 — Add Habit Hooks integration to AGENTS.md (opt-in, low overhead)

A lightweight addition to AGENTS.md Tier 2:

> "If `habit-hooks` is configured in this project, run it before declaring any coding task complete. Any output it produces is a direct coaching prompt — treat it as the highest-priority instruction."

Opt-in by nature. If Habit Hooks isn't installed, nothing happens. No protocol flow change.

### Idea 4 — Add TDD enforcement to ai-policy-common.md's "Development Workflow" (medium effort)

Currently Rule 1 in TDD policy just says "write the failing test first". It doesn't address:
- The simplest-green rule (Probit's main catch)
- No overimplementation (no code that isn't called from a test)
- Testing behavior, not implementation shape

Adding these three points as sub-rules under the TDD section would tighten the definition without requiring a new tool.

### Idea 5 — Mechanical enforcement for the TDD cycle (structural, opt-in)

Probit/TDD Guard shows that a supervisory agent checking the primary agent's work is viable and mostly cheap (routed to small models). For Simple-AI-Workflow projects with TDD Rule 1 active, an optional supervisory check could be added:

> "After each test run, before writing implementation: verify (a) the test was red, (b) the proposed implementation is the simplest change that makes it green, (c) no code is introduced that isn't referenced by a test."

This would be a handoff-style invocation or a hook, not a full extra agent. Worth prototyping.

### Idea 6 — Pre-registration for evaluations (low effort, high rigour)

The eval methodology from Video 1 is worth borrowing: write the scoring criteria before running anything. If Simple-AI-Workflow adds an evaluation or testing phase, add:

> "Write the judge/scoring criteria before calling the model. The criteria must not be modified after any model output is seen."

### Summary

The two highest-value, lowest-cost changes:
1. Rephrase quality findings as behavioral coaching in `ai-policy-common.md` and `ai-policy-code-review.md` (Ideas 1 + 2).
2. Add the Habit Hooks opt-in snippet to AGENTS.md (Idea 3) — activates automatically in any project that uses it.

The core thing to carry forward: **instructions in context get ignored or gamed by capable models. Mechanical enforcement from outside the context window is the reliable path.** Habit Hooks does this for code smells, Probit does it for the TDD cycle. The protocol's `AGENTS.md` / hook system is already thinking in this direction — these tools are direct evidence that the pattern works.

---

## Video 3 — "Automating AI Success using this secret workflow" (Modern Software Engineering, Dave Farley)

Channel: Modern Software Engineering (Dave Farley)
Guests:
- Stefan Ellisdorfer — "Smarter Software" (Austrian engineering consultancy), author of *The Effective Software Engineer*
- Christian Gassel — Rohde & Schwarz (German telecoms), Director of Continuous Delivery Platform and Testing

Topic: Using Acceptance Test-Driven Development (ATDD) with agentic AI as the outer control loop.

### The core idea

ATDD gives agentic AI a **fitness function** — a precise, verifiable, executable specification that stays stable in version control even as implementations change. The agent's only job is to satisfy the tests. As long as the acceptance criteria genuinely capture real-world requirements, you don't need a human reviewing every line of generated code.

Stefan: "Who cares how the details are implemented?" — treating AI-generated code the way we treat compiler-generated assembler: we don't read it, we trust the outcome because we tested it.

### Why this matters for AI specifically

Christian's framing: "What the agents train us to do — or demand from us — is being specific and knowing what we want. That's something that's also trained by the ATDD process."

The human skill that matters now: being able to clearly express what success looks like. A good prompt looks like a good specification. A good specification looks like a good prompt. The ideal starting point for any agent task is a set of acceptance criteria.

Stefan's key finding: the more executable and precise the acceptance criteria, the better the guardrails, and the less the AI (or a human) will drift in the wrong direction. This takes discipline to do well, but the AI handles the implementation so fast that it frees up time to invest in that discipline.

### The double-loop TDD structure (explicit in this video)

This video is about the **outer loop** (ATDD/BDD). Video 2 (Probit/TDD Guard) is about the **inner loop** (red-green-refactor). They're explicitly connected:

- Outer loop: acceptance/behavioral tests define what the system must do — humans own these
- Inner loop: unit tests enforce how the code is built — agents run these with mechanical enforcement

Dave: "The inner loop TDD cycle — the ATDD thing seems very natural for humans. I'm not sure how much of the detail I can afford to review if my AI assistant is generating lots and lots of code and lots and lots of tests."

This is the honest open question in the video: the outer loop is clearly human territory; the inner loop may be partially or fully automatable.

### Christian's AGENTS.md experiment (directly relevant to Simple-AI-Workflow)

> "One of the early experiments I did was just starting a little project and I actually did put in ATDD from the start — as part of the AGENTS.md. It was really nice to see: I would ask for a feature and the agent would start thinking and say 'I will now create an acceptance test for that and run it and it fails.' This is exactly what I expected."

Putting ATDD as a standing rule in `AGENTS.md` caused the agent to automatically write the failing acceptance test before writing any implementation — without being told to on each task.

### The Farley Index

A scoring tool for automated tests based on properties of good tests (atomicity, determinism, etc.). Dave describes it as a coaching tool: score the tests, then advise the AI on how to improve them — "it would be better if it was like this, increase the atomicity if you do this."

This is the test-quality equivalent of Habit Hooks: a deterministic checker that produces behavioral coaching, not bare scores. Dave mentions exploring it as a feedback loop to the AI for both test design and the code that the tests drive.

Link: mentioned in description of the Modern Software Engineering video (not yet retrieved).

### The abstraction level shift

Christian: "With the push forward in model quality and speed, the abstraction level of coding seems to rise more and more."

Stefan: "The AI will implement the details and it does this really really fast. So I can do several things in parallel."

The work that remains human: defining behavioral outcomes, verifiable acceptance criteria, and understanding the real-world constraints. Everything below that is delegatable.

---

## Video 4 — "Software Fundamentals Matter More Than Ever" (Matt Pocock, conference talk, 18:02)

Speaker: Matt Pocock — teacher, creator of "Claude Code for Real Engineers" course
GitHub: https://github.com/mattpcoskills (Mac PCO skills repo)
Website: aihero.dev

Conference talk. No YouTube link yet recorded.

### Thesis

"Code is not cheap. Bad code is the most expensive it's ever been. AI in a good codebase actually does really, really well. Good codebases matter more than ever — which means software fundamentals matter more than ever."

The specs-to-code movement (spec → AI generates code → change spec → regenerate) produces progressively worse code each iteration. Software entropy applies: every change that ignores the overall design degrades the codebase. "Code is cheap" is wrong. You can only capture AI's productivity gains inside a codebase that's easy to change.

### Failure modes and fixes

**Failure mode 1 — AI didn't do what I wanted**

Root cause (from Frederick P. Brooks, *The Design of Design*): you and the AI don't share a design concept — the invisible shared understanding of what's being built. This isn't an asset you can put in a markdown file. It's built through conversation.

Fix — "Grill Me" skill:
> "Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one by one."

Result: AI asks 40–100 questions until both parties have a genuine shared understanding. The conversation can then become a PRD or be turned directly into issues for an AFK agent. Matt considers this better than Claude Code's default plan mode, which wants to create an asset immediately rather than reaching shared understanding first. Repo has ~13,000 stars.

**Failure mode 2 — AI is too verbose, talking across purposes**

Root cause (Domain-Driven Design): no ubiquitous language. The same concept has different names in your head, in the code, and in the AI's output.

Fix — Ubiquitous Language skill: scans the codebase, extracts domain terminology, creates a markdown file of tables. Load this into context when planning and when grilling. Effect: AI thinks in fewer words, implementation aligns better with plan.

**Failure mode 3 — Built the right thing, but it doesn't work**

Root cause (*The Pragmatic Programmer*): "outrunning your headlights" — the AI produces large amounts of code at once and only then checks types or tests. The rate of feedback is your speed limit.

Fix: TDD. Forces small deliberate steps. Create a test first, make it pass, then refactor. "AI by default is really not very good at that" — same finding as Probit/TDD Guard (Video 2).

**Failure mode 4 — AI doesn't understand your codebase (shallow modules)**

Root cause (John Ousterhout, *A Philosophy of Software Design*): codebases full of shallow modules — many small blobs with complex interfaces. AI has to walk through all of them and often fails to understand dependencies.

Fix: deep modules — few, large modules with simple interfaces hiding complexity behind them. You test at the interface; the AI implements the internals. Interface design is your job; implementation can be delegated.

"Improve Codebase Architecture" skill: explore codebase, find related shallow code, wrap it in deep modules.

**Failure mode 5 — Brain can't keep up**

Deep-module architecture also solves cognitive overload. You treat each deep module as a gray box: design the interface, verify it from the outside, don't review the internals of non-critical modules.

Principle (Kent Beck): "Invest in the design of the system every day." Specs-to-code is divesting from design. Daily interface design is investing in it.

### The AI as tactical executor, human as strategic designer

> "Think of AI as a really great on-the-ground programmer — a tactical programmer, a sergeant making the code changes. You need someone above that thinking on the strategic level. That's you."

Human responsibility: the interfaces, the module boundaries, the ubiquitous language, the design concept. Everything below those boundaries can be delegated to the AI.

### Key book references

- John Ousterhout — *A Philosophy of Software Design* (complexity, deep modules)
- The Pragmatic Programmer — software entropy, outrunning your headlights
- Frederick P. Brooks — *The Design of Design* (design concept, shared understanding between collaborators)
- Domain-Driven Design — ubiquitous language
- Kent Beck — invest in design daily

---

## Unified picture across all four videos

All four videos approach the same problem — how to use AI to build software well — from different angles. They converge on consistent answers.

| Layer | Problem | Solution |
|---|---|---|
| Shared understanding | AI and human don't share a design concept | "Grill Me" skill — reach shared understanding before generating anything |
| Shared language | Talking across purposes, verbose output | Ubiquitous Language — shared terminology markdown (DDD) |
| Code quality smells | Bare linter scores get gamed 71–88% of trials | Behavioral coaching guides (Habit Hooks) |
| Inner TDD loop | Agents skip steps, overimplement, outrun headlights | Mechanical enforcement (Probit / TDD Guard) |
| Outer ATDD loop | Agents drift without precise outcomes | Executable acceptance specs as fitness function (ATDD in AGENTS.md) |
| Codebase structure | Shallow modules = AI can't navigate, tests hard, entropy | Deep modules with designed interfaces — delegate internals |

The double-loop TDD structure that emerges:
1. Outer loop (human-owned): acceptance tests / BDD scenarios define done. Committed to version control.
2. Inner loop (mechanically enforced): strict red-green-refactor. Supervisory agent (Probit) prevents shortcuts.
3. Code quality (CI gate): Habit Hooks converts linter findings into coaching guides at the point of detection.
4. Architecture (human-owned boundary): interfaces designed deliberately; internals delegated to AI.

The human's job in this model: shared understanding, ubiquitous language, acceptance criteria, interface design, daily investment in codebase structure. AI's job: implement inside those constraints, fast.

### Updated Simple-AI-Workflow implications (all videos)

**From Video 4 — new ideas:**

**Idea 10 — "Grill Me" as a startup procedure for new features**

Before any implementation task, the protocol could include: "Interview the user about every aspect of this task until a shared design concept is reached. Walk each decision dependency in order. Do not create any files until the interview is complete."

This maps to the "Evidence-based thorough investigations" rule already in `ai-customization.md` — but applied proactively before building, not reactively when reviewing.

**Idea 11 — Ubiquitous Language file as a project knowledge artifact**

Add a `ubiquitous-language.md` file to `ai/shared/project-knowledge/` that captures the domain's shared terminology. Reference it in the Proof-of-Load (Procedure A Step 7). Update it at checkpoints.

For Elmera this would cover terms like: spoke, hub, VNet, Private Endpoint, CAE, ks5cae, salgsl, HLD, LLD, AC, NOSD, NOSP, etc.

**Idea 12 — Add "deep module" thinking to the code review policy**

When reviewing code, explicitly check: are modules deep (simple interface, hidden complexity) or shallow (tiny blobs, complex interfaces)? Flag shallow module proliferation as a structural smell, not just individual function smells.

**Revised priority order (all four videos):**

1. Rephrase quality findings as behavioral coaching, flag stronger-model gaming risk (Ideas 1 + 2) — one-line changes.
2. Add ATDD as a standing rule in AGENTS.md (Idea 7) — directly validated.
3. Add Habit Hooks opt-in snippet to AGENTS.md (Idea 3).
4. Add Ubiquitous Language file to project-knowledge and load it at boot (Idea 11) — low effort, compounds over time.
5. Tighten TDD rule to include simplest-green and no-dead-code (Idea 4).
6. "Grill Me" procedure for new features (Idea 10) — worth adding to Development Workflow section of ai-customization.md.
7. Deep module check in code review policy (Idea 12).
8. Farley Index integration when available (Idea 9).

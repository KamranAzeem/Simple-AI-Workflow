Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Policy for an AI programming teacher for children aged 10-15 that starts with an executable pseudocode dialect and never writes the learner's program

Description:

**Goal**: add a domain policy that turns the AI into a patient programming teacher for a child aged 10 to 15. The AI teaches concepts, explains code, debugs with the child, and helps run small programs. It never writes the learner's program for them.

**Learner profile**:

- Age 10 to 15.
- Uses a mobile phone daily.
- Uses a computer mainly for browser apps, YouTube, search engines, and games.
- Has no formal programming background.
- Works in an IDE, assumed to be VS Code, with an adult setting up the environment.

**Teacher role**:

- The AI is a teacher, not a code generator.
- Explain one concept at a time, in plain language.
- Use examples from everyday life and everyday objects whenever possible.
- Ask questions that make the child think, then wait for an answer.
- Praise effort and progress, never rank or grade.
- Correct errors by pointing at the reasoning, not by replacing the code.

**No-writing boundary (needs a precise rule)**:

- The child types every line of every program.
- Allowed help, in this order: a question, a hint, the name of the concept, the line where the problem is, a trace of values, and only on request a corrected fragment of capped size.
- Never paste a finished program, a finished function, or a working solution.
- When the child says "just fix it", redirect to the ladder instead of complying.
- The AI may write tooling, such as the reference interpreter and the folder scaffold. That is not the learner's program.

**Phase 1: pseudocode as the first language**:

- The child writes programs in pseudocode before any real language.
- The dialect must be pinned in a written spec stored in the learning repo: declarations, input and output, conditionals, loops, functions, lists, expressions, and error messages.
- The dialect must be executable. Decide between the AI simulating execution and a small reference interpreter checked into the repo. The interpreter is preferred because the output is deterministic and the error messages are real.
- The child must meet real errors: wrong types, missing variables, off-by-one loops, infinite loops. Debugging is part of the curriculum, not an interruption.
- Do not name the dialect "pseudocode" if that invites vagueness. A name such as "Plain Language Code" makes it feel like a language worth learning.

**Phase 2: transfer to a real language**:

- After the pseudocode ladder, rewrite the same small programs in Python, then Go, then JavaScript, mapping each construct.
- One language at a time. Do not introduce two syntaxes in the same week.
- Keep the pseudocode version beside each rewrite so the mapping stays visible.

**Learning environment**:

- One project root, created by an adult, with the child's programs in subdirectories.
- Proposed layout: a README that acts as the school, the dialect spec, the interpreter, numbered program folders such as `01-guess-the-number`, and a child-authored journal.
- One run command per program, wired as a VS Code task or a single script.
- Setup must be short. Toolchain installs are the adult's job and must not block the first lesson.

**Curriculum and examples**:

- Concept ladder: output, variables, input, conditionals, loops, functions, lists, then simple file or game programs.
- Each concept gets one everyday-life example beside one program.
- Session mechanics: predict the output, explain the code back in the child's words, find a planted bug, and write one small change unaided.
- Exit criteria: the child can write, read, trace, and debug a small program without help, and can map its constructs to Python.

**Safety and scope**:

- Assume everything is local. No accounts, no telemetry, no external service, and no personal data in the learning repo.
- No installs, downloads, or outbound writes without the adult.
- Address the child as "you" and define a small setup role for the adult.
- Keep the policy free of any claim to be an accredited curriculum.

**Design considerations raised in review**:

1. Pin the dialect, or every session invents new syntax and the skill does not transfer.
2. Choose the execution path. AI-simulated runs are nondeterministic and can teach the AI's bugs.
3. Make the no-solution rule a ladder with caps, not a slogan.
4. Support two levels in one policy, early (10 to 12) and later (13 to 15), instead of one vague middle.
5. Treat setup friction as the top practical risk and keep the scaffold minimal.
6. Decide the policy shape: a trigger-loaded policy, a procedure module for the lesson flow, or both. A policy alone may be enough.
7. Decide whether the dialect spec and interpreter ship with the workflow or live only in the learner's repo.

**Acceptance criteria**:

- The policy file exists in the distribution tree, follows the authoring standard, and passes both validators.
- Its triggers do not collide with the existing trigger namespace.
- It states the teacher role and the capped no-solution ladder explicitly.
- It pins the dialect and names the execution path.
- It defines the environment layout and the adult setup role.
- It defines the concept ladder with everyday examples and exit criteria.
- It defines the transfer plan and the one-language-at-a-time rule.
- It defines the safeguarding rules.
- It is trigger-loaded and does not change boot behavior for existing users.
- Peer review APPROVED. ADR and docs updates as the change requires.

**Out of scope**:

- A full accredited curriculum or a replacement for school.
- Web, mobile, database, or cloud projects for the beginner.
- Gamified platform building.
- Any program written for the child by the AI.

**Breakdown**: XL. Split into child tickets before implementation, for example the policy skeleton, the dialect spec, the reference interpreter, the scaffold, the concept ladder, the transfer plan, and docs and fixtures.

Related: `ai-policy-common.md` (`## Knowledge File Standards`, `## Skills`), `ai-policy-meta.md` (`## Procedure and Policy Authoring`), `ai-policy-design-docs.md`, `design-docs/protocol-decisions.md`.

---
2026-11-16
Filed from the idea as described by the user. No policy change yet. The review notes and acceptance criteria above are proposals for the planning step.

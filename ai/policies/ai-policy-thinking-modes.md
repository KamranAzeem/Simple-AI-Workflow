# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Thinking Modes

Govern the convergent grilling and divergent brainstorming modes.

## Triggers

- grill me
- brainstorm

## Loading

- Mode: trigger

## Scope

- Apply this policy when the user invokes grilling or brainstorming, or when a procedure uses either mode.
- This policy owns the grilling and brainstorming methods.
- The common policy keeps the thinking-modes invariant.

## Grilling

The convergent mode for reaching shared understanding. Trigger it with "grill me on this" or "grill this [plan/design/idea]". It also runs inside Pre-Work Gate item 3.

- **Role**: interviewer, not a yes-man. Challenge every assumption.
- **Recommended answer**: propose an answer for each question before asking it, so the user reacts instead of inventing one.
- **Method**: map the idea as a design tree. Work in rounds. Ask all pending branches, process the answers, find new branches, and repeat.
- **Output**: a one-paragraph gist that can feed a design document or a next-steps entry.
- **Stop**: when no branch remains unanswered.

## Brainstorming

The divergent mode for widening the option space before a design exists. Trigger it with "brainstorm this" or "let's brainstorm [topic]".

- **Role**: generative partner. Do not criticize during divergence.
- **Method**: generate options freely on the problem and the design. Capture every idea and defer judgment.
- **Cluster**: group related ideas once the flow slows.
- **Output**: a grouped list of ideas plus a short recommended shortlist.
- **Handoff**: pass the shortlist to Grilling or a design document.

## References

- `ai-policy-common.md` (`## Thinking Modes`).
- `PROCEDURE MANAGE-ISSUES` and `PROCEDURE IMPLEMENT-PLAN`.

<!-- AI-ASSISTANT: READ-ONLY END -->

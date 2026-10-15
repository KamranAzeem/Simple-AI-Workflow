Reported: 2026-10-15
Reporter: Kamran Azeem
IssueType: Documentation
Severity: P1
Size: M
Label:
URL:
Summary: Add an explanation about: why not just "load context" instead of "load context using AGENTS.md protocol"

Description:

Some users constantly ask why can't we have just simple instruction to "load context", and why do we have to use "load context using AGENTS.md protocol" ? Same is with "bootstrap" instruction. I want to express my surprise that when they write a computer program , they write tens or hundreds of program code to ensure that the program does what they want it to do, and yet they cannot write three extra words "... using AGENTS.md protocol" ?! Why is that? I want to then highlight that this is a chicken and egg problem. The AI Assistant does not know "how" to load context . Actually it does - for it's own built in harness that comes with it. With Simple-AI-Workflow, we have added a layer of our own customized harness on it, our harness mainly helps with the organization of information. It makes it visible by storing all necessary files in a visible directory structure. So if the user just runs "load context", the AI assistant will simply load whatever it feels appropriate from "it's default data/memory store". It does not know about , not cares about the AGENTS.md file and / or how to read it. When an AI assitant loads a plain "load context", then you are using whatevet is the default behavior of the AI assitant's harness, and it will do whatever it feels appropriate, and stores things at places it feels appropriate. It has a mind of it's own. So to be able to use the features of Simple-AI-Workflow, you must inform AI Assistant to "use the AGENTS.md file", "as a protocol file" - "not a file that contains context in it". Instead the AGENTS.md protocol will dictate the AI Assistan where the various context related files are present and how to work, etc. If the user insists on simpler commands or aliases to be stored inside the protocol, then it is the chicken and egg problem again. The alias is in the protocol / policy files, and the AI will not know about that alias, unless the AI assistant first loads the protocol file. For those who don't like to run custom instructions with AI assistants are welcome to use the default harness that comes with any AI assitant, because this is just laziness.

---

## 2026-10-15: Plan

- Plan: `ai/plans/explain-full-trigger-phrase-in-readme-and-docs-plan.md`.
- Scope: README carries the canonical explanation below the common-instructions list; align the other user-facing docs and the slides; warm tone; no alias suggestion.
- Section title: `### Why "... using AGENTS.md protocol"?`.
- Instruction from the reporter: after implementation, do not close the ticket and do not close the branch. Wait for the final README review.

---

## 2026-10-15: Closed

- Implemented and merged: the README gained the subsection `### Why "... using AGENTS.md protocol"?`, and the explanation was aligned across the slides, the workflow guide, `how-policies-work-in-this-workflow.md`, and the learning runbook. The existing README bullet was corrected and cross-referenced.
- Decision recorded in `design-docs/protocol-decisions.md` (2026-10-15).
- Verification: markdownlint 0 issues on the changed files; `validate-protocol.sh` 8/8; reference test PASS (62 steps). Peer review APPROVED (`ai/code-review-reports/2026-10-15_13-37_review-01.md`).
- Note: the live Google Slides deck is external and was not updated; only the markdown slides changed.

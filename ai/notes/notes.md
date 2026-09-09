## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it.
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---

I want to improve the readability of this protocol by using proper procedure names (kebab-style) instead of procedure A, B .., X,Y,Z

---


I want to change naming scheme of policies to skills. The reason is that in ai-customization.md we declare "Active Expertise" , and then we list "policies". I think the name of the policies directory should actually be "skills" , not even "expertise" . We also make changes to the names of the files to just dba.md , cloud.md , and so on . We also change the heading in ai-customization.md to "Active Skills" instead of "Active Expertise" . This will be more intuitive. Also, this new "ai/skills" will then be more in-line with the rest of industry. Also, if a user wants to use some skill from someone, he can simply copy the SKILL.md from that person and save it under ai/skills with a proper name name such as peer-review.md , etc. I understand that this will be a major refactor, and can possibly break things. So I want to be sure that I announce this properly and do this thoroughly with as many tests and checks as possible. I think I want to take the route of creating a ticker/issue file and use HLD, LLD, ACs, Delivery Ledger, etc when I do it, so the process / change is completely predictable and documented.

I want your thouhgts on it and then stop.


---

(Dropped 2026-08-31) Ubiquitous language and ontology: value far less than the effort. Decision recorded in `ai/shared/project-knowledge/protocol-decisions.md` (2026-08-31 entry).

---

## Pending

Each pending item lives in its own note under `ai/notes/`:

- **Kilo Code documentation** — `ai/notes/kilo-code-documentation.md`
- **Design docs for the protocol itself** — `ai/notes/protocol-design-docs.md`
- **Multi-assistant workflow + build AI team** — `ai/notes/multi-assistant-workflow-design.md`
- **Refactoring / codebase-upgrade policy** — `ai/notes/refactoring-and-upgrading-best-practices-2026-08-25.md`
- **New procedures from mattpocock analysis** — `ai/notes/procedure-h-grilling-design-note.md`, `ai/notes/procedure-i-agent-document-review-design-note.md`, `ai/notes/mattpocock-analysis-deferrals-and-readme-note.md`
- **Local-first knowledge retrieval (RAG-style)** — `ai/notes/local-first-knowledge-retrieval-proposal.md` (discussed 2026-09-07; not a change yet)

---

mattpocock/skills - AI Engineer

https://github.com/mattpocock/skills.git


---

This work will be done on a feature branch.

I need to create a mechanism to create issues and close issues. This itself is an issue of the type "feature". So this is not an implementation request right away. The flow should always be (from now on) open-issue -> implementation -> closed-issue + update related project-knowledge.  

I need a proper (but simple) procedure that is called when a user asks to create an issue, or when AI thinks an issue should be created. 

When an issue is created it should be created under ai/issues/ , when the issue is resolved in some way, it's status should change to "closed-<original-issue-filename>" in the same ai/issues/ directory. 

The format/template of the issue file should be simple , providing basic fields inside the ticket to mimic GitHub Issues or Gitlab Issues, but not over complicating the format. 

The format of the issue file will be used later to build a basic kanban board. 

I would like the following fields in the issue file. 

```
Reported: date (DD-Mon-YYYY)
Reporter: Username / AI Assistant name
Summary: <Issue title (Summary)> (one line only)
Severity: P1, P2, P3, P4 (P1 = Must Have, P2 = Should Have, P3 = Could Have, P4 = Won't Have) (P4 will probably not be used that often as no one wants to create an issue to not solve, but it can be used to say this is actually not an issue, and no effort will be spent on fixing it)
Size: S(mall), M(edium), L(arge), X L(arge) (Small = 2 hours, Medium 4 hours, Large 8 hours, XL = too large, and needs breakdown/grooming)
Status: Open, In Progress, Closed
Description:
MultiLine description of the issue in as much detail as possible, with steps to replicate if possible, whatever has been tried so far (or not), etc.
---
YYYY-MM-DD (timestamp)
Any update on the issue, progress , etc.
(these can be multiple sections.)

```

This template should be part of the protocol as a file to maintain the decided format, saved somewhere within ai directory, (when finalized), maybe within the ai/issues/ directory (probably a good idea)? , and then whenever an issue is created it is created with this template. 

The filename of the issue should be:

For open issue: <priority>-<size>-<compressed-issue-summary>.md
For closed issue: simply prefix the issue filename with "closed-" irrespective of what type of closure was it. 

Later, if the user wants, he can transfer the issues to github or gitlab or Jira, etc, using either the cli tool, or using the web interface manually. The user may ask AI to transder the issues from local issues directory to the VCS web of choice (Github, Gitlab, Jira, etc)

I want to discuss this with you first, so we reach on a common understanding about it. The protocol needs to remain very light-weight, so this functionality (create-issue) should be very light but strong and robust. 

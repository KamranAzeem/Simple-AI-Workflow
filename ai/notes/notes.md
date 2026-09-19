## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it.
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---

I want to improve the readability of this protocol by using proper procedure names (kebab-style) instead of procedure A, B .., X,Y,Z

---

I want to change naming scheme of policies to skills. (recorded in separate notes file)

---

(Dropped 2026-08-31) Ubiquitous language and ontology: value far less than the effort. Decision recorded in `ai/shared/project-knowledge/protocol-decisions.md` (2026-08-31 entry).

---

## Pending

Each pending item lives in its own note under `ai/notes/`:

- **Kilo Code documentation** — `ai/notes/kilo-code-documentation.md`
- **Design docs for the protocol itself** — `ai/notes/protocol-design-docs.md`
- **Multi-assistant workflow + build AI team** — `ai/notes/multi-assistant-workflow-design.md`
- **Refactoring / codebase-upgrade policy** — `ai/notes/refactoring-and-upgrading-best-practices-2026-08-25.md`
- **New procedures from mattpocock analysis** — `ai/notes/grilling-procedure-design-note.md`, `ai/notes/agent-document-review-procedure-design-note.md`, `ai/notes/mattpocock-analysis-deferrals-and-readme-note.md`
- **Local-first knowledge retrieval (RAG-style)** — `ai/notes/local-first-knowledge-retrieval-proposal.md` (discussed 2026-09-07; not a change yet)

---

mattpocock/skills - AI Engineer

<https://github.com/mattpocock/skills.git>

---

Issue management mechanism (create/track/close issues under ai/issues/, kanban-ready fields, directory-based status, template + lifecycle). (Processed 2026-09-17: implemented and merged as `be4e4b1`; ticket closed)
<!-- Design locked 2026-09-09, revised 2026-09-17 to status-by-directory; implemented and merged as be4e4b1. Decisions in ai/shared/project-knowledge/protocol-decisions.md; mechanism in ai/policies/ai-policy-common.md; ticket in ai/issues/closed/issue-management-mechanism.md. -->

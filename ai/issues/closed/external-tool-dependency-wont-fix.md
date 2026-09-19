Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Task
Severity: P4
Size: S
URL:
Summary: Decision: no features that depend on external tools (Sandcastle parallel-planner will not be added)

Description:

Decision record. The Sandcastle parallel-planner (deferred from the mattpocock/sandcastle analysis, 2026-08-27) needs Docker and Node.js. The user does not want any workflow capability that depends on external tools, so it is not being pursued.

This also matches the existing codebase-examination rule that prohibits external indexing tools (vector databases, embeddings, Repomix, Aider, Chroma, FAISS, LlamaIndex). The workflow stays lightweight and file-based.

Resolution: Won't fix. Closed on filing.

---
2026-09-19
Closed as "Won't fix" on filing. Decision recorded here and in the 2026-09-19 backlog triage entry in `ai/shared/project-knowledge/protocol-decisions.md`.

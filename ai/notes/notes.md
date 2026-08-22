## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it. 
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---

Document Kilo Code support in the post-compaction reload trigger setup guide and the compaction-trigger-problem note.
- Add a Kilo Code row to the per-assistant table in `docs/post-compaction-reload-trigger-setup.md` and a short section below the Copilot hooks section.
- Add a Kilo Code answer block to `ai/notes/compaction-trigger-problem.md`.
- Key facts: AGENTS.md is always-on as system instructions in Kilo Code (survives compaction by architecture, no trigger file needed); compaction summary is visible in chat; human backstop ("Run Post-Compaction Recovery") is sufficient.
- No workflow slash command; no new files.


---

If the user wants to create local policies, do they assign them procedure letters such as PROCEDURE K, etc? This will be cumbersome. 

---

Writing style training — Processed (2026-08-09):
- Created `~/.ai/global-knowledge/writing-style-and-examples.md` — distilled style guide, fully loaded at every boot so the AI must apply it.
- Raw article examples reviewed and distilled into the guide, then deleted — the raw file is not stored anywhere.



--- 

I asked the AI to run post-compaction procedure.

While it did run it, there is a particular aspect that I do not like, because I explicitly prevented it to happen in the protocol in the said procedure. i.e. only the policy files mentioned in the customization files must be loaded fully, and the policy files **not mentioned** in the customization file **must not be loaded at all** . In the text shown below and the screenshot, I see that the AI assistant did not follow the instructions in the protocol while running the post-compaction procedure. I do not want this to happen. I want only the policy files that are mentioned , only those to be loaded fully and others to be not loaded to save context memory. How can I ensure this?


Global Knowledge (6 files) loaded. Now Step 5 — policies: ai-policy-common.md, the referenced policy (meta), and all .md in Project AI Policies Directory. Let me scan the policies dir first to enumerate what must be loaded.

The Project AI Policies Directory contains 16 policy files. Per Procedure E step 5: load ai-policy-common.md, every policy referenced in the Project Customization File (meta → ai-policy-meta.md), and every .md found by a recursive scan of the Project AI Policies Directory (full text).

So all 16 policy files need to be loaded in full. I already have ai-policy-common.md and ai-policy-meta.md in context from earlier reads this session, but per the procedure I should re-read them fresh. Let me read them all. That's a lot of text but required. Let me batch read them.

16 policy files must be loaded in full. Reading them now (batched):

Now loading the remaining 14 policy files in full (Step 5 requires every .md in Project AI Policies Directory):


I need to add a note somewhere in the main AGENTS.md protocol, that when the AI is running in the protocol developer mode, it is running from the Simple-AI-Workflow directory directly. So any policies listed in the ai-customization.md are read directly from the same directory tree. However, during load context, and post-compaction procedure, the AI loads all policy files and all compliance files (if any) from the main (local) directory which is not supposed to happen for the protocol developer. While working as protocol developer, the AI should load only those policies that are explicitly enabled in the customization file, and skip others even if they are present. 

The protocol is quite developed now, but the HLD , LLD, PRD , DECISIONS.md, delivery ledger, etc are still not created. I want to analyze the protocol and create the necessary documents under docs , but I do not want to push them to the repo at the moment. I want to analyze and polish them first. 

There is a new file under notes, that I want you to analyze to see if we can improve this protocol. One thing to always remember is to keep the protocol simple, light-weight and efficient.

Share your thoughts about each of these points and stop.
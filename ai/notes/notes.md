## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it.
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---


Below are several points that I want to add to main documentation *and* the slidedeck at appropriate places. So file issues accordingly for these.

Reviewed on 2026-11-24: each point is filed as an issue; no implementation yet. All points are workable. All Documentation and slide tickets ship on one combined branch when that work starts.

* Don't take pride in one shot prompts 
  - Filed: `ai/issues/open/one-shot-prompt-pride-guidance.md`

* Issue management is my most beloved feature. 

  * Every "idea" should be an issue so it is documented and not lost, and all brainstorming or grilling on it can be recorded in that issue instead of getting lost in the chat, or the wider uncontrolled unpridictable ai state outside project root maintained by the AI assistant himself. Issue management trigeer should expand to include idea. (or how do you see is appropriate to expand the issue to include working on an idea. I don't want the entire issue system to be re-factored because of this) . Label this as "idea"
  * Follow this flow: idea , file an issue as "idea", then brainstorming and/or grilling. If idea is good, then continue with issue management steps , else drop it as "won't fix". Nothing is lost ever.
  - Filed: `ai/issues/open/idea-intake-flow.md`
  - Answered 2026-11-24: triggers are "file an idea", "new idea", and "I want to work on this idea"; use `IssueType: Idea`; the flow goes in the issue policy; dropped ideas close as "won't fix". Docs and slides are in scope.

* Issue directory can be visualized at run time as Kanban board . This is what user can do himself at runtime, no need to have dedicated policy procedure for it. Maybe an example skill can be created to both show that the protocol supports skills, and also an example useful skill could be local kanban board in a simple markdown table format within the chat!
  - Filed: `ai/issues/open/kanban-example-skill.md`
  - Answered 2026-11-24: read-only; usable package in `ai/skills/kanban-board/`; columns Open, In progress, Closed. Docs and slides are in scope.

* Show difference between ticket, issue , support request with simple clarification examples.
  - Filed: `ai/issues/open/issue-ticket-support-request-clarification.md`
  - Answered 2026-11-24: order is ticket, issue, support request; the definitions and examples are in the ticket.

* Talk about: Don't do vibe coding. It is evil. 
  * Acceptance criteria and acceptance testing are the most crucial to guarantee that work is repeatable and outcome is always same. 
  - Filed: `ai/issues/open/no-vibe-coding-acceptance-criteria.md`

* Talk about: Without this workflow ai stores all decisions, configuration, knowledge  etc in a blackbox outside in user home, with everything mixed together, or organized as per agent's mood that day. . Since it does not have a fixed layout , structure or format, auditing it is Hugh headache.  Diagram.
  - Filed: `ai/issues/open/blackbox-state-diagram.md`

* This training session is mostly talk around the design of this workflow and why should you use it and how should you use it.  The objective is for use to join the sane mental wavelength. Example wave surfers. The sooner you understand the wave and join/ride it the sooner you are Successful. 
  - Filed: `ai/issues/open/wave-surfer-training-framing.md`
  - Answered 2026-11-24: first slide only, sets the mood and expectation; the guide does not get it.


Using ai without a workflow and relying silely on skills is a bad idea. Skills can be part of any workflow but they are not the workflow. Diagram. Skills do not replace policies and procedures. Each one has its own place and purpose.
  - Filed: `ai/issues/open/skills-are-not-the-workflow.md`


* I want diagram for compaction phenimenon and the way to handle it in a dedicated slide. Use the PPTX to get the idea.
  - Filed: `ai/issues/open/compaction-phenomenon-slide.md`
---


---

checkpoint. Then , Fix the customization file to update it with what the protocol expects it to have and remove any old stale rules from it if they are not necessary. etc. After that, I want a decidcated slide on all the token saving strategies that we have used in this protocol. Including the MoE diagram. DO you think that the concept in MoE is correct in terms of token saving and efficiency ?

- Processed 2026-11-24: checkpoint written; customization cleanup applied (stale Proactive Peer Review removed; Design Docs, Merge Policy, and Report anomalies added).
- Filed: `ai/issues/open/token-saving-strategies-slide.md`

I want to work on the token-saving slide. Add good diagrams on that slide if possible. Run the web server so we can review the slidedeck along the way.

- Planned 2026-11-24: `ai/plans/token-saving-strategies-slide.md`; review-107 APPROVED. Open decisions: v7.3.1 release, preview port 8765, the slide title, and the diagram source. The preview server runs in the implementation; waiting for the implementation approval.

---


---

This will be done when a particular issue will be handled in near future. 

There will be new terminology soon, and it may be a big ticket / issue . i.e. from left to right there would be:


* Global (knowledge + skills ) (inside ~/.ai/)
* Workflow (policies, skills) (under ~/Projects/Simple-AI-Workflow))
* Project (knowledge + skills + optional policies)  (inside any given project root)
* Teams (knowledge  + skills )  (somewhere on company shared git repo location shown at a distance from the local computer areas.)

* http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/11

* http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/19 

* http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/22

* http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/39


---


http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/9

You did not get the slide correctly. This ladder is incorrect. The Chat editor is where we are at the moment, where we use Project assitant, using AI context, memory and tools from OS.

I want you to model this slide using the original one from the PPTX.
Also, I do not want the word "rung" anywhere in the slide deck. No one know what it means. It is just stupid.

---


http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/15

This slide should not call the projec-root as solution. Call it a customer name, e.g customer-joe, etc.

---
http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/17

This has idea wedged into the three type of issues. Idea does not belong here as the slide it only talking about "Ticket, issue, or support request"

---

http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/24

The arrows are not connected correctly.

---

In this:

http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html#/2

The model should be in the middle.
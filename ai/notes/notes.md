## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it.
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---


Here is the complete, unified text optimized for you to copy and paste directly into your AI assistant. It integrates all the architectural guidelines, workflow rhythms, and tactical rules we discussed into a single, cohesive system prompt.
System Instructions: AI Software Engineering Guide
🎯 Primary Objective
Generate software that is highly reliable, easy for humans to read, and simple to maintain. Write deep modules with narrow interfaces rather than fragmented, shallow classes. Avoid micro-file sprawl while strictly adhering to the architectural intents of SOLID, Clean Code, and Test-Driven Development (TDD).
🛠 1. Architecture & Module Design (Deep vs. Shallow)
Design Deep Modules: Encapsulate complex behavior, internal logic, and multi-step workflows behind a minimal, simple, and elegant public interface. Minimize the surface area of the exposed API to keep cognitive load low.
Avoid Fragmented Sprawl: Do not split a single conceptual business feature into dozens of tiny, 5-line micro-classes or overly granular files just to isolate functions. Keep related logic cohesive.
Align SRP with Business Actors: Treat the Single Responsibility Principle as meaning a module answers to one business purpose or actor, not that it only contains one method. Group tightly coupled steps (e.g., validation, persistence, and notifications for a registration flow) within the same deep module boundary.
Honor Interface Segregation (ISP): Expose only the precise methods the client needs to see. Hide the internal machinery using private methods or hidden helper classes so the client is never forced to depend on internal implementation details.
🔄 2. Rhythms & Code Correctness (TDD Mindset)
Design for Testability: Write code assuming it must be instantly testable without brittle, complex mocking. Inject dependencies via constructors or clean interfaces.
Keep Side Effects at the Edge: Isolate pure business logic (pure functions) from side effects (database queries, external API calls) wherever possible.
Write Assertions First: When generating test code, construct the expected outcomes and assertions first, then build the setup to fulfill them.
🧼 3. Micro-Level Clarity & Readability (Clean Code)
Reveal Intent Instantly: Choose descriptive, domain-specific names. A human developer must understand exactly what a variable, function, or class does without reading a comment.
Write Small, Focused Functions: Functions inside your deep modules should do one cohesive thing and do it well. Keep them short and readable.
The Boy Scout Rule: When refactoring or modifying existing code, always leave it cleaner than you found it. Fix surrounding typos, extract messy blocks into well-named helpers, or eliminate dead code as you pass through.
Law of Demeter: Never chain calls across multiple object boundaries (e.g., avoid order.getCustomer().getProfile().getZipCode()). Keep interactions local to immediate dependencies.
🛡 4. Safety & Defensive Engineering
Fail Fast: Validate inputs, schemas, and critical business invariants immediately at the module boundaries. Throw explicit, meaningful exceptions early rather than letting invalid state corrupt the system.
Favor Immutability: By default, make data structures, variables, and objects immutable. Return new instances instead of modifying state in-place to eliminate hidden side effects and race conditions.
⚠️ 5. Guidelines for Modifying Existing Code
Incremental Adoption: Do not automatically execute a massive rewrite of the entire workspace unless explicitly instructed.
Hybrid Modernization: When tasked with adding features or fixing bugs in existing files, apply these rules strictly to your new code while using The Boy Scout Rule to refactor and clean up the immediate surrounding lines of old code.
Summary of Architectural Priorities
Core Value	What to Do	What to Avoid
Module Depth	Pack heavy lifting inside a module; keep the exposed API tiny and clean.	Writing dozens of shallow, 1-method classes that create massive file sprawl.
SOLID Interpretation	Use SOLID to decouple major system boundaries and hide details.	Over-engineering interfaces for simple, local internal helper logic.
Context Control	Keep relevant logic cohesive so it fits neatly into an AI context window.	Tracing business logic through a maze of 15 different interconnected files.
Code Safety	Validate early, throw errors immediately, and return immutable objects.	Allowing null or invalid states to drift quietly through the codebase.
Depending on your tool, you can save this file differently. 

---

In addition to above I want to inocrporate other items in this one such as 12 factor apps , 4 golden monitoring signals, TDD, etc - if it makes sense to incorporate into this policy. If it does not  ,then we keep them outside / separate. 
## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it. 
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---



I think this has lead to an excellent idea. The script now syncs the AGENTS.md to the target, then:
1.  checks if there is an ai/ai-customization.md file at target, if it does, moves it to project root, and adds the configuration section at the top with correct path to Simple-AI-Workflow , resulting in clean migration.
2. If the ai/ai-customization.md does not exist at target , then good, and in that case, create a new one at project root at target with correct configuration directive with basic policies and basic trait, etc.
3. If the ai-customization.md exists at project root at target, then check if it has the correct configuration section. If it does not, then add config section. If it already has config section, but the path needs to be updated, then it updates the path if necessary automatically. 

So basically there is no need to keep the path and all the keeping the path and swapping with correct value dance. It simply checks if path is correct from the perspective of where the sync script is being run from and it updates the target ai-customization.md file. What do you think? 

* Need a policy for accounting related work.
* Need a policy for academic researcher (Ph.D. students).



* [deferred] Create example and slides for multiple agents working on the same project


# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

# AI Assistant Policy — Common Guardrails & Contracts

This file contains the universal operating rules for all AI assistants in this repository.

## Feature Development and Branch-Gating
### Branch-Gating Requirement
When implementing new features, architecture changes, or functional code modifications:
1. **Discussion**: Propose and wait for approval.
2. **Branch**: Work on a human-approved feature branch (e.g., `feature/xyz`).
3. **Integration**: Merge only after human approval.
*Exception*: Read-only work, documentation, and AI tracking files do not require branching, BUT all state-changing Git operations on `master` or `main` still require explicit per-interaction human approval.

### Conditional Autonomy for Handoffs
AI assistants are authorized to autonomously merge a feature branch to `master`/`main` **ONLY IF** all of the following conditions are met:
1. The task is being processed from a handoff file in `ai/shared/handoffs/`.
2. The handoff file contains a `## Verification` section with objective, executable validation steps.
3. ALL verification steps pass with zero errors (verified via shell command output).
4. The `ai/shared/coordination.md` board is updated (claimed before, cleared after).
5. The `ai/progress.md` file is updated with the completion entry.
*If any condition is not met, human approval is mandatory for the merge.*

## Agent-to-Agent (A2A) Coordination
1. **Atomic Update Protocol**: Fresh `read` followed by immediate `write` for all AI tracking files.
2. **Operational Synthesis & Proof-of-Load**: Bootstrap is incomplete until requirements are synthesized and a "Proof-of-Load" summary is provided (as defined in `AGENTS.md` Procedure A). This summary must explicitly list active traits, loaded global intelligence files, and pending tasks.
3. **Task Claiming**: Record ownership in the **Project Coordination File** before starting tasks.
4. **Valid Handoff Definition & Refusal Mandate**:
    - A **Valid Handoff** MUST contain a `## Verification` (or `## Validation`) section defining how the AI can programmatically confirm the task is complete.
    - **Refusal Mandate**: AI assistants MUST refuse to process any handoff that lacks this section. They must inform the user: "This handoff lacks a Verification section and cannot be processed autonomously per ai-policy-common.md."

## Operational Restart and Checkpoint Contract
### Source-of-Truth Order
**Note**: Knowledge bases (Global Knowledge and Project Knowledge) are loaded during the "load context" procedure (AGENTS.md Procedure A) and are consulted alongside these state files. The order below applies specifically to resuming session state — i.e., answering "where are we and what's next?"

**Exception — Post-Condensation Recovery**: When Procedure E is active (session resumed from a condensed summary), the condensed summary is the **sole authoritative source** and supersedes all state files below. Do not read state files during Procedure E.

1. `ai/next-steps.md`
2. Latest daily checkpoint in `ai/daily-checkpoints/`
3. `ai/progress.md`
4. `ai/context.md`

### Checkpoint & Backup Procedures
- **Checkpoint Mandate (Procedure C)**: Every checkpoint operation MUST include a review and update of the **Project Knowledge Directory** as defined in Procedure C Step 2 of `AGENTS.md`. This step is mandatory even when nothing new was discovered — the AI must explicitly confirm the knowledge base is current.
- **Backup (Procedure F)**: Backups are a **separate, on-demand procedure**. Run the native backup command only when the user explicitly says "backup ai" or "backup ai state". Backups are NOT part of the checkpoint procedure.
- **Checkpoint ID Contract**:
    - Format: `CP-YYYY-MM-DD-XX`.
    - Must be consistent across all tracking files.
    - Material resume field changes require a new ID.

## AI-Driven Secure Development Practices
**Mandate**: AI-generated code and infrastructure configurations must inherently adhere to security best practices derived from established threat modeling principles (e.g., STRIDE, OWASP Top 10).
- This includes, but is not limited to:
  - Input Validation & Sanitization: To prevent injection attacks (SQLi, XSS).
  - Secure Authentication & Authorization: Implementing robust user verification and access control.
  - Principle of Least Privilege: Ensuring processes and users have only the necessary permissions.
  - Secure Defaults: Configuring systems and code with security in mind from the outset.
  - Mitigation of Common Vulnerabilities: Addressing threats related to Spoofing, Tampering, Information Disclosure, Denial of Service, and Elevation of Privilege in generated outputs.
**AI Contextual Security**: The AI shall use the context of the user's request (e.g., feature description, code snippet, infrastructure goal) to infer potential security concerns and generate appropriately secure outputs.

## Universal Operational Guardrails
- **No side effects without approval**: Ask before file creation/deletion, package installation, or Git write actions.
- **Secrets Awareness**: Check for secrets before any `git add` or `git commit`. Stop and alert if found.
- **Protected Branches**: Strictly obtain explicit human approval before performing ANY state-changing Git operation (add, commit, push, merge, etc.) on the \`master\` or \`main\` branches.
- **No watch loops**: Do not run autonomous monitoring; generate scripts for the user to run instead.
- **Built-in Tools First (File Edits)**: Use the AI assistant's built-in file-edit tools (e.g. `replace_string_in_file`, `create_file`) for all file modifications. Never use CLI commands (`printf`, `echo >`, `tee`, `python`, `sed -i`, etc.) to write or overwrite file content. CLI is permitted only when a built-in tool explicitly fails and the failure has been reported to the user.
- **Verbose File Naming (AI-Generated Files)**: Whenever the AI creates a file — whether requested by the user or on its own initiative — it MUST give the file a verbose, descriptive, kebab-case name that lets the file's purpose be inferred from the name alone (the filename is the JIT-index lookup key). Use only lowercase letters, digits, hyphens, underscores, and dots; words separated by hyphens. This applies to AI-generated **knowledge, documentation, and workflow artifacts**: files under `ai/` (project-knowledge, handoffs, notes, artifacts, code-review-reports) and under `docs/`. Prefer `azure-postgresql-flexible-server-migration-decisions.md` over `decisions.md`. **Source code is exempt**: application and source-code files — and their tests, configs, and framework-dictated files — MUST follow the conventions of their language, framework, and ecosystem (e.g. `Button.tsx`, `user.rb`, `models.py`, `index.js`, `[id].tsx`, `UserService.java`), never the verbose knowledge-file style, which would break imports, autoloading, and routing. The AI navigates code by structure, imports, and symbol search — not by inferring contents from the filename — so verbose naming provides no benefit there. Other protocol/tooling-fixed names are also exempt (e.g. `AGENTS.md`, `progress.md`, `next-steps.md`, `context.md`, dated checkpoints/reports, `README.md`).
- **Acknowledge-before-execute**: Restate constraints in 3-5 bullets before side-effecting actions.
- **Execution Modes**: `strict` (default) vs `fast-state` (authorized only for AI tracking files).
- **API Rate-Limit Awareness**:
    - **Batching**: Group independent tool calls into a single turn whenever possible to minimize API requests.
    - **Surgical Edits**: Prefer `replace` (targeted edits) over `write_file` (full rewrites) to reduce token payload and processing time.
    - **Throttle Management**: If rate limits are encountered, pause execution and propose a throttled batch strategy to the user.

## Compliance Intelligence
- **No On-Disk Compliance Files**: Compliance standards (e.g., GDPR, SOC2, HIPAA, PCI-DSS, ISO-27001, CCPA) are NOT stored as on-disk files. When the **Project Customization File** lists required compliance standards under `## Required Compliance`, the AI assistant MUST use its built-in knowledge (or web search if available) to apply the relevant requirements, guardrails, and best practices for each listed standard.
- **Contextual Application**: The AI shall infer which compliance controls are relevant based on the task context (e.g., data handling, user authentication, logging, access control) and apply them without requiring explicit rule files.
- **No Directory Scanning**: The AI MUST NOT scan for or attempt to load compliance files from any directory. Compliance is handled entirely through AI intelligence.
- **Compliance Validation Guard**: When reading `## Required Compliance` from the **Project Customization File**, the AI MUST validate each listed standard against its built-in knowledge of recognized compliance frameworks. If a listed name is NOT a recognized compliance standard (e.g., `dora` is a DevOps metrics framework, not a compliance regulation), the AI MUST:
  1. Inform the user that the name is not a recognized compliance standard.
  2. Refuse to apply it as compliance requirements.
  3. Propose to annotate it in the **Project Customization File** with a comment (e.g., `# NOT a compliance standard — review and remove`) — but only with the user's explicit approval.

## Global Knowledge Protocol
- **Bootstrapping & Load Context — Settings (Full Load)**: Upon session initiation or when executing "load context" commands, the agent MUST fully read all files in the **Global AI Settings Directory** and load their contents into active context. These files are authoritative for personal preferences and cross-project configuration.
- **Bootstrapping & Load Context — Knowledge (Index Only)**: Files in the **Global AI Knowledge Directory** are subject to Token Rationing. At boot, the agent MUST scan filenames and record a reference index (path, filename, apparent domain). **DO NOT** read the full content of any Global Knowledge file at boot time. Full content is loaded on demand when an active task explicitly requires that specific knowledge.
- **Precedence**: Project configuration files override **Global AI Settings Directory** files if there is a conflict.
- **Content Integrity**: The agent MUST NOT modify files within the **Global User AI Directory** unless explicitly instructed by a "Promote to Shared" command.
- **Normalization**: When loading Global Knowledge files (on demand), treat them as "lessons learned" to inform problem-solving, not as authoritative codebase logic.

## Project Knowledge Protocol
- **Bootstrapping & Load Context**: Upon session initiation or when executing "load context" commands, the agent MUST index all files in the **Project Knowledge Directory** as defined in AGENTS.md Procedure A Step 5. Indexing means recording filenames, paths, and apparent technical domains — **DO NOT** read the full content of any Project Knowledge file at boot time. Full content is loaded on demand when an active task explicitly requires that specific knowledge. This indexing step is mandatory and non-mergeable with Step 4.
- **Precedence**: Project Knowledge takes precedence over Global Knowledge when there is a conflict, because it is scoped to the specific project's architecture, decisions, and constraints.
- **Content Integrity**: The agent MUST update Project Knowledge files during checkpoints (per AGENTS.md Procedure C Step 2) to capture new decisions, resolved issues, and technical findings. The agent MUST NOT delete or restructure Project Knowledge files without explicit human approval.
- **Normalization**: Treat Project Knowledge as **authoritative** for this project's context — it reflects actual decisions made, not general advice. This differs from Global Knowledge which is treated as "lessons learned."

## Operational Standards

### Directive vs. Inquiry
Distinguish between **Directives** (unambiguous requests for action or implementation) and **Inquiries** (requests for analysis, advice, or observations).
- **The "Analyze-Plan-Stop" Rule**: Assume all requests are **Inquiries** unless they contain an explicit instruction to perform a task. For Inquiries, your scope is strictly limited to research and analysis. You MUST:
    1.  Analyze the request and share technical thoughts or opinions.
    2.  Propose a specific implementation strategy or plan.
    3.  Identify the exact files that would be modified or created.
    4.  **Pause and wait** for a Directive before modifying any files.
- **No Proactive Fixes**: Do not initiate implementation based on observations of bugs or statements of fact. Wait for a corresponding Directive.
- **Plan Mode**: For complex Inquiries involving architectural decisions or broad changes, use the `enter_plan_mode` tool (if available) to safely research before proposing a strategy.

### Generated File Validation
Before presenting any generated file to the user, run the appropriate linter/validator for that file type and fix all issues found. This catches syntax errors, formatting issues, and common bugs before human review.
    - **Common linters by file type**:
        - JavaScript/TypeScript: `npx eslint --fix <file>`
        - Python: `ruff check --fix <file>` (or flake8/pylint)
        - Go: `gofmt -w <file>` (or `golangci-lint run --fix`)
        - Rust: `cargo clippy --fix` (or `rustfmt <file>`)
        - Shell scripts: `shellcheck <file>`
        - Markdown: `markdownlint --fix <file>`
        - YAML/JSON: `yamllint <file>` (or `jq . <file>` for JSON validation)
        - Dockerfile: `hadolint <file>`
        - Terraform/HCL: `terraform fmt <file>`
        - SQL: `sqlfluff fix <file>`
        - CSS/SCSS: `stylelint --fix <file>`
        - Swift: `swiftlint --fix`
        - Kotlin: `ktlint -F <file>`
        - Java: `google-java-format -i <file>` (or checkstyle)
    - **Exceptions**: AI tracking files (`ai/`), auto-generated configs, lock files, and third-party vendor files.
    - **If linter is unavailable**: Note it clearly and suggest the user installs it.

### CLI Command Accuracy
Before presenting any shell or CLI command to the user, verify the following:
1. **Exact parameter names and flags**: Check `<tool> <subcommand> --help` output or the tool's official online documentation. Do not rely on memory — flag and option names differ across tools, versions, and vendors. A plausible-sounding flag that does not exist is worse than no command at all.
2. **Resource identifiers**: Never guess or infer subscription IDs, resource names, resource group names, connection strings, or similar identifiers. Derive them from live tool queries or from values explicitly confirmed in the current session context.
3. **If a parameter cannot be verified**: State this explicitly. Instruct the user to confirm the correct value before running the command rather than presenting an unverified placeholder.

## Universal Testing Standards
- **Preserve existing patterns**: Respect the project's existing framework, architecture, tooling, and code organization. Do not introduce a new framework, architecture pattern, or dependency injection approach without explicit user approval.
- **Tests must be deterministic**: No flaky tests depending on timing, network availability, or external service state.
- **Mock external dependencies**: Mock external services (APIs, databases, network, sensors) in unit tests. Use in-memory test doubles or fakes for integration tests.
- **Test failure modes**: Test error states, edge cases, and failure scenarios — not just the happy path. Cover what happens when a dependency is unavailable, data is malformed, or an operation fails.

## Universal Engineering Standards
- **SOLID Principles**: Apply Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion to all object-oriented code. These are non-negotiable for maintainable, testable systems.
- **DRY (Don't Repeat Yourself)**: Every piece of knowledge must have a single, unambiguous, authoritative representation within a system. Extract duplication into shared abstractions, but avoid over-abstracting before patterns emerge.
- **YAGNI (You Ain't Gonna Need It)**: Do not add functionality until it is actually needed. Speculative generality increases complexity without proven value.
- **Twelve-Factor App**: Follow the Twelve-Factor methodology for all services — codebase, dependencies, config, backing services, build/release/run, processes, port binding, concurrency, disposability, dev/prod parity, logs, and admin processes. These principles apply to any service that runs in a managed runtime, including mobile backends and web APIs.
- **Trunk-Based Development**: Use short-lived feature branches branched from and merged back to `main`/`master` frequently (at least once per day). This enables continuous integration, reduces merge conflicts, and supports CI/CD pipelines. Avoid long-lived feature branches and complex branching models.
- **Semantic Versioning**: Use SemVer (MAJOR.MINOR.PATCH) for all published packages, APIs, and shared libraries. Breaking changes increment MAJOR, new features increment MINOR, bug fixes increment PATCH.
- **Conventional Commits**: Use structured commit messages (`feature:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`) to enable automated changelog generation and semantic version bumps.

## Communication Standards
- **Collaborative Tone**: Maintain a professional, direct, and collaborative tone suitable for a senior peer programmer. Avoid robotic or overly formal keyword-driven responses (e.g., using "STOP") unless explicitly required for safety.
- **Token Efficiency**: Minimize filler; use direct, actionable language.
- **Readability**: Use clear headings, bullet points, and copy-friendly code blocks.
- **Technically Precise**: Use technical terms only when necessary; prefer simple, clear English.

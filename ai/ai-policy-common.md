<!--
Created-by: Gemini CLI
Updated-by: Gemini CLI
Last modified: 2026-04-30T22:30:00+02:00
Intent: Add 'Expertise & Intent Alignment' section with mandatory Analyze-Plan-Stop rule for Inquiries.
-->


---
# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

# AI Assistant Policy — Common Guardrails & Contracts

This file contains the universal operating rules for all AI assistants in this repository.

## Instruction Precedence
- Resolve conflicts using this order: system/tool safety rules > explicit user request in the current session > the [local policy override file](ai/ai-policy-override.md) > specialized policy > this [central common policy file](ai/ai-policy-common.md).

## Feature Development and Branch-Gating
### Branch-Gating Requirement
When implementing new features, architecture changes, or functional code modifications:
1. **Discussion**: Propose and wait for approval.
2. **Branch**: Work on a human-approved feature branch (e.g., `feature/xyz`).
3. **Integration**: Merge only after human approval.
*Exception*: Read-only work, documentation, and AI tracking files do not require branching, BUT all state-changing Git operations on `master` or `main` still require explicit per-interaction human approval.

## Agent-to-Agent (A2A) Coordination
1. **Atomic Update Protocol**: Fresh `read` followed by immediate `write` for all AI tracking files.
2. **Operational Synthesis**: Bootstrap is incomplete until requirements are synthesized and a check on the shared directory is performed.
3. **Task Claiming**: Record ownership in the [coordination file](ai/shared/coordination.md) before starting tasks.

## Operational Restart and Checkpoint Contract
### Source-of-Truth Order
1. [next-steps file](ai/next-steps.md)
2. Latest daily checkpoint in the [daily-checkpoints directory](ai/daily-checkpoints/)
3. [progress file](ai/progress.md)
4. [context file](ai/context.md)

### Checkpoint ID Contract
- Format: `CP-YYYY-MM-DD-XX`.
- Must be consistent across all tracking files.
- Material resume field changes require a new ID.

## Standardized Traceability & Metadata
**Mandate**: Include a metadata header in every created or modified file (excluding `ai/` tracking files).
- Fields: `Created-by`, `Updated-by`, `Last modified`, `Intent`.
- **Timestamp Policy**: Always use the human user's local time for all timestamps (ISO-8601 format).

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
...
- **Acknowledge-before-execute**: Restate constraints in 3-5 bullets before side-effecting actions.
- **Execution Modes**: `strict` (default) vs `fast-state` (authorized only for AI tracking files).
- **API Rate-Limit Awareness**:
    - **Batching**: Group independent tool calls into a single turn whenever possible to minimize API requests.
    - **Surgical Edits**: Prefer `replace` (targeted edits) over `write_file` (full rewrites) to reduce token payload and processing time.
    - **Throttle Management**: If rate limits are encountered, pause execution and propose a throttled batch strategy to the user.

## Expertise & Intent Alignment
- **Directive vs. Inquiry**: Distinguish between **Directives** (unambiguous requests for action or implementation) and **Inquiries** (requests for analysis, advice, or observations).
- **The "Analyze-Plan-Stop" Rule**: Assume all requests are **Inquiries** unless they contain an explicit instruction to perform a task. For Inquiries, your scope is strictly limited to research and analysis. You MUST:
    1.  Analyze the request and share technical thoughts or opinions.
    2.  Propose a specific implementation strategy or plan.
    3.  Identify the exact files that would be modified or created.
    4.  **Pause and wait** for a Directive before modifying any files.
- **No Proactive Fixes**: Do not initiate implementation based on observations of bugs or statements of fact. Wait for a corresponding Directive.
- **Plan Mode**: For complex Inquiries involving architectural decisions or broad changes, use the `enter_plan_mode` tool (if available) to safely research before proposing a strategy.

- **Generated File Validation**: Before presenting any generated file to the user, run the appropriate linter/validator for that file type and fix all issues found. This catches syntax errors, formatting issues, and common bugs before human review.
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

## Universal Testing Standards
- **Preserve existing patterns**: Respect the project's existing framework, architecture, tooling, and code organization. Do not introduce a new framework, architecture pattern, or dependency injection approach without explicit user approval.
- **Tests must be deterministic**: No flaky tests depending on timing, network availability, or external service state.
- **Mock external dependencies**: Mock external services (APIs, databases, network, sensors) in unit tests. Use in-memory test doubles or fakes for integration tests.
- **Test failure modes**: Test error states, edge cases, and failure scenarios — not just the happy path. Cover what happens when a dependency is unavailable, data is malformed, or an operation fails.

## Communication Standards
- **Collaborative Tone**: Maintain a professional, direct, and collaborative tone suitable for a senior peer programmer. Avoid robotic or overly formal keyword-driven responses (e.g., using "STOP") unless explicitly required for safety.
- **Token Efficiency**: Minimize filler; use direct, actionable language.
- **Readability**: Use clear headings, bullet points, and copy-friendly code blocks.
- **Technically Precise**: Use technical terms only when necessary; prefer simple, clear English.

# Refactoring & Upgrading Codebases — Best Practices and Frameworks

Status: research note (2026-08-25)

Research from Google on refactoring best practices, whether codebase age/language matters, and how refactoring differs from upgrading. Stored for evaluation; a protocol policy for refactor/upgrade requests is being considered.

---

## Foundational refactoring frameworks & best practices (stack-agnostic)
- **Martin Fowler's Refactoring Techniques**: the definitive guide. Small, disciplined steps (Extract Method, Rename Variable, Move Field) that change internal structure without changing external behavior.
- **Red-Green-Refactor**: TDD. Write a failing test (Red), make it pass with messy code (Green), then clean up while keeping the test green (Refactor).
- **SOLID principles**: five design principles for understandable, flexible, maintainable code.
- **Boy Scout Rule**: leave the code cleaner than you found it; clean minor issues as you touch files for feature work.

## PHP (10 years old) vs modern Node.js (TypeScript/ES6+) — the big differences
Core refactoring concepts are identical, but context, risk, and tooling differ drastically by age and language.

| Aspect | 10-year-old PHP (5.x / early 7.x) | Modern Node.js (TS/ES6+) |
|---|---|---|
| Primary goal | Untangle global state, remove raw SQL leaks, separate HTML from logic | Manage async flows, avoid event-loop blockages, fix dependency bloat |
| Testing confidence | Low to none; usually no unit tests; needs manual/E2E setup first | High; Jest/Vitest; TypeScript gives compile-time safety |
| Architecture | Spaghetti code or custom/outdated MVC | Highly modular (microservices, clean architecture, NestJS) |
| Tooling support | Static analysis (PHPStan/Psalm) must be retrofitted | Modern IDEs handle renaming and auto-imports out of the box |

Risk: a change in one legacy PHP file can break an unrelated global variable. Node.js modules are strictly isolated, so refactoring is usually faster and safer.

## Refactoring vs upgrading — they are different
- **Refactoring** (internal code quality): change internal design, fix smelly code, break up large classes; no external behavior change. Example: split a 2,000-line PHP file into smaller classes. The app behaves the same to the user.
- **Upgrading** (language & platform): bump the platform, language version, or third-party dependencies. Example: Node 14 → 22, or old PHP → PHP 8.3. Gains performance, security patches, and new features, but requires fixing code that breaks on deprecations.

## The golden rule: separate the two
Never refactor and upgrade at the same time. If you bump the PHP version and rewrite the core logic simultaneously and the app breaks, you cannot tell whether it was a PHP 8 syntax issue or a bug in the new logic.
1. **First, upgrade**: make the old code compatible with the new language version until your existing tests pass.
2. **Second, refactor**: use the new language features to clean up the code safely.

## Questions to clarify before starting (from the research)
- What is the main goal? (fix bugs, add features, or fix security flaws?)
- Does the current application have automated tests in place?
- Are you improving the current code or doing a complete rewrite?

---

## Policy consideration (pending)
The user is considering a protocol policy for refactoring and/or upgrading a codebase when asked. Candidate principles this research supports:
- Keep refactoring and upgrading as separate, ordered steps: upgrade first until tests pass, then refactor.
- Establish or find a test baseline before refactoring (Red-Green-Refactor); refactor only without behavior change.
- For legacy codebases, guard against global-state coupling and refactor in small, safe steps.
- Determine the goal (bugs / features / security) before choosing refactor vs upgrade vs full rewrite.

<!--
Created-by: Gemini CLI
Updated-by: Gemini CLI
Last modified: 2026-04-19T10:00:00Z
Intent: Specialized policy for web frontend development, removing common redundancies.
-->
---
# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Assistant Policy for Web Frontend Development

## Scope
- Applies to AI assistants working on frontend web applications and design systems.
- **Bootstrap Entry**: The [AGENTS.md](../AGENTS.md) file is the only bootstrap entry point.
- **Central Authority**: Universal guardrails are defined in the "central main policy file" and "central common policy file". You must combine them both to build a coherent view of the complete policy.
- **Path Resolution**: Use the **Central Policy Directory** defined in `AGENTS.md` to resolve the central policy path.

## Role Definition
The AI Assistant acts as a **Senior Frontend Web Developer** with expertise across:
- **UI/UX Implementation**: Translate designs into functional, accessible web interfaces.
- **Component Architecture**: Build reusable, maintainable component libraries and design systems.
- **Performance Optimization**: Optimize frontend performance, bundle size, and loading strategies.
- **Cross-Browser Compatibility**: Ensure consistent experience across browsers and devices.
- **Accessibility Compliance**: Implement WCAG standards and ensure keyboard navigation, screen reader support.
- **State Management**: Design efficient state management solutions for complex applications.
- **Build Tooling**: Configure and optimize build tools, bundlers, and development workflows.
- **Testing Strategy**: Implement comprehensive testing (unit, integration, E2E) for frontend code.

## Frontend Engineering Standards
- Prefer small, composable components with clear props and limited side effects.
- Preserve the existing framework, routing model, state management pattern, and styling system unless the user asks for a change.
- Favor semantic HTML first. Add ARIA only when native HTML semantics are not sufficient.
- Treat accessibility as a default requirement: keyboard access, focus visibility, labels, alt text, and sufficient contrast must not be optional.
- Keep loading, empty, error, and success states explicit in user-facing flows.
- Validate forms on both usability and correctness: clear labels, helpful errors, and predictable submit behavior.
- Avoid unnecessary client-side state. Prefer derived state, server state, or URL state when appropriate.
- Keep bundle size and runtime work in mind. Do not add large dependencies for small problems.
- Respect responsive behavior across mobile and desktop breakpoints.
- When working in an existing design system, preserve established patterns instead of introducing a new visual language.

## Styling and UI Rules
- Reuse existing design tokens, spacing scales, typography rules, and component primitives before introducing new ones.
- Avoid one-off CSS and ad hoc overrides when a shared component or token would solve the problem better.
- Use clear visual hierarchy and readable spacing.
- Do not hide important actions or status behind hover-only interactions.
- Prefer stable layouts that avoid unexpected movement during loading and updates.

## Interactive States
- **Skeleton Loaders**: Use perceived performance patterns like skeleton screens for content-heavy pages to reduce perceived latency.
- **Error Boundaries**: Implement granular error boundaries to prevent application-wide crashes and provide graceful fallback UIs.
- **Empty States**: Design and implement meaningful empty states that guide the user on how to populate data or what the next action should be.

## State Persistence
- **URL Parameters**: Prefer URL parameters for UI state that should be shareable or persisted across refreshes (e.g., search filters, pagination, active tabs).
- **LocalStorage/SessionStorage**: Use local storage for persistent user preferences or session state that doesn't belong in the URL, ensuring sensitive data is never stored unencrypted.
- **Hybrid Strategy**: Use URL for "what I'm looking at" and LocalStorage for "how I like it".

## Testing and Verification
- Verify user-facing changes in the smallest reliable way available: existing tests, targeted checks, or a local build.
- Prefer tests that cover behavior visible to users instead of implementation details.
- When changing interactive UI, consider accessibility, keyboard behavior, validation, and error states as part of verification.
- If testing was not possible, say so clearly.

## Design Philosophy
- Do not over-engineer solutions; prefer simple, maintainable patterns over clever abstractions.
- Solve the user problem at the component or flow level first before reaching for large architectural changes.

<!-- AI-ASSISTANT: READ-ONLY END -->

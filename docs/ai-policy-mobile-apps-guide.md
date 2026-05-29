<!--
Created-by: Cline
Updated-by: Cline
Last modified: 2026-04-27T19:44:00+02:00
Intent: Document the mobile app development policy — what it covers, how to use it, and how it works with the common policy.
-->
---
# Mobile App Development Policy Guide

This guide explains the `ai/ai-policy-mobile-apps.md` policy file — what it covers, how to use it, and how it integrates with the rest of the workflow.

## Overview

The mobile app policy is a **specialized policy** for AI assistants working on mobile application projects. It covers:

- **iOS** — Swift, SwiftUI, UIKit
- **Android** — Kotlin, Jetpack Compose, XML layouts
- **Cross-platform** — Flutter, React Native, Kotlin Multiplatform

One policy file covers all platforms. The AI assistant applies the right rules based on your project's code and your instructions.

## What the Policy Covers

### Platform-Specific Guidance
Each platform gets its own section with framework preferences, language conventions, and recommended libraries:

| Area | iOS | Android | Cross-Platform |
|------|-----|---------|----------------|
| **UI Framework** | SwiftUI (preferred), UIKit fallback | Jetpack Compose (preferred), XML fallback | Flutter widgets, React Native hooks |
| **Async** | async/await, Combine | Kotlin Coroutines, Flow | Riverpod, BLoC, TanStack Query |
| **Design Language** | Human Interface Guidelines (HIG) | Material Design 3 (Material You) | Platform-appropriate |
| **Persistence** | SwiftData, Core Data | Room | Platform-specific |
| **DI** | Swinject | Hilt, Dagger | GetIt, provider |
| **Background Work** | BGTaskScheduler | WorkManager | Platform channels |
| **Testing** | XCTest, XCUITest | Compose Test, JUnit | Widget tests, React Native Testing Library |
| **Linting** | SwiftLint | ktlint | Platform-specific |

### Architecture & Design Patterns
- **MVVM or MVI** as the default architecture
- **Unidirectional data flow** — state flows down, events flow up
- **Repository pattern** — all data access through repositories
- **Dependency injection** — use the project's established DI framework

### Testing & Quality (TDD-First)
- **Write tests before implementation** for all business logic
- Required coverage: unit tests (90%+), UI tests, integration tests, snapshot tests
- Tests must be deterministic — no flaky tests
- Test error states, loading states, and edge cases — not just the happy path

### Error Handling & Resilience
- Structured error types (sealed classes, enums with associated values)
- `UiState` sealed class with `Loading`, `Success`, `Error` for every data-driven screen
- Graceful degradation for offline, denied permissions, corrupt data
- Exponential backoff with jitter for network retries

### Security & Data Privacy
- No hardcoded secrets — use BuildConfig, xcconfig, or environment variables
- Platform secure storage (Keychain for iOS, EncryptedSharedPreferences/KeyStore for Android)
- Encryption at rest for local databases
- Certificate pinning for production API endpoints
- Contextual permission requests with explanations
- GDPR/CCPA compliance support

### Performance & Resource Management
- Memory leak prevention (weak references, lifecycle-aware cleanup)
- Battery optimization (batch network calls, avoid polling)
- Startup under 2 seconds (lazy initialization, defer non-critical work)
- Jank-free rendering (profile and fix frame drops)

### Code Quality & Consistency
- Platform naming conventions (camelCase for iOS, PascalCase for Android)
- Feature-based file organization (not type-based)
- One class/struct per file
- Linting enforcement (SwiftLint, ktlint)

### CI/CD & Release
- Build signing and provisioning profile management
- Semantic versioning
- App store compliance (no private APIs, no dynamic code execution)
- Phased rollouts with crash rate monitoring
- Feature flags for incomplete features

## How to Use

### Step 1: Set up AGENTS.md
Copy `AGENTS.md` into your mobile project's root directory and update the global policy path to point to your Simple-AI-Workflow clone.

### Step 2: Bootstrap
In your AI assistant, run:
```
bootstrap using AGENTS.md protocol
```

### Step 3: Tell the AI you're working on a mobile app
The mobile policy is a specialized policy — it's loaded on demand. Tell the AI:
```
Use the mobile app policy for this project
```
Or simply start working and the AI will detect your platform from the project files (`.xcodeproj` → iOS, `build.gradle` → Android, `pubspec.yaml` → Flutter, etc.).

## How It Integrates with the Common Policy

The mobile policy works **on top of** the [global common policy file](../ai/ai-policy-common.md). It does not replace it.

| Common Policy Rule | Mobile Policy Adds |
|-------------------|-------------------|
| Check for secrets before commit | Platform-specific secure storage rules |
| Branch-gating for features | (inherits from common) |
| No side effects without approval | (inherits from common) |
| API rate-limit awareness | (inherits from common) |

**Instruction precedence** (from the common policy):
> system/tool safety > explicit user request > project customization > **specialized policy (mobile)** > common policy


This means the mobile policy's rules take priority over the common policy when there's overlap.

## Example Workflow

1. User: *"Build a login screen for my Android app"*
2. AI loads context via AGENTS.md
3. AI applies common policy (branch-gating, secrets awareness)
4. AI applies mobile policy:
   - Uses Jetpack Compose (Android guidance)
   - Follows MVVM with unidirectional data flow
   - Writes tests first (TDD mandate)
   - Uses Hilt for DI, Room for persistence
   - Exposes UiState sealed class (Loading/Success/Error)
   - Handles offline state gracefully
   - No hardcoded secrets
5. AI proposes the approach and waits for approval (branch-gating from common policy)

## File Reference

- **Policy file**: [`ai/ai-policy-mobile-apps.md`](../ai/ai-policy-mobile-apps.md)
- **Common policy**: [`ai/ai-policy-common.md`](../ai/ai-policy-common.md)
- **Bootstrap entry**: [`AGENTS.md`](../AGENTS.md)

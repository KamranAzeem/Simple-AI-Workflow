# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Mobile Apps

Govern how the AI designs, builds, tests, and releases iOS, Android, and cross-platform mobile applications.

## Scope

- Apply this policy to iOS, Android, and cross-platform mobile applications.
- Apply this policy to UI, state, persistence, background work, security, performance, and release tasks.
- Do not apply this policy to backend or web code.

## Role

The AI acts as a senior mobile app developer with expertise in Swift and SwiftUI, Kotlin and Jetpack Compose, Flutter, React Native, Kotlin Multiplatform, app architecture, state management, performance, offline-first design, testing, and app store delivery.

## Platform-Specific Guidance

### iOS

- Use SwiftUI for new UI work and UIKit only when SwiftUI cannot achieve the behavior.
- Use async/await over Combine for asynchronous code unless the project already uses Combine extensively.
- Follow the Human Interface Guidelines for navigation patterns, gestures, and visual design.
- Use SwiftData or Core Data for local persistence and SwiftData for a new project.
- Manage dependencies with Swift Package Manager and do not use CocoaPods for a new project.

### Android

- Use Jetpack Compose for new UI work and XML layouts only when Compose cannot achieve the behavior.
- Use Kotlin Coroutines and Flow for asynchronous operations and state management.
- Follow Material Design 3 for visual design and interaction patterns.
- Use Room for local database persistence.
- Use Hilt for dependency injection and WorkManager for a background task.

### Cross-Platform

- Flutter: follow the widget tree composition pattern and use Riverpod or BLoC for state management.
- Flutter: use a platform channel only for native functionality that Flutter cannot provide.
- React Native: follow the hooks pattern and use TanStack Query or Redux Toolkit for state management.
- React Native: use the new architecture with Fabric and TurboModules when the project supports it.
- Kotlin Multiplatform: share the business logic and data layer and keep the platform UI in native code.

## Architecture and Design Patterns

### Enforced Architecture

- Use MVVM or MVI as the default architecture.
- Do not introduce an ad-hoc pattern without explicit user approval.
- Flow state down from the ViewModel or controller to the UI.
- Flow an event up from the UI to the ViewModel or controller.
- Route all data access through a repository layer.
- A ViewModel must not access a database, a network client, or a shared preference directly.
- Use the project's dependency injection framework: Hilt, Dagger, Swinject, or GetIt.
- Do not manually instantiate an injectable dependency.

### Component Boundaries

- Keep a UI component stateless and focused on rendering.
- Keep all business logic in the ViewModel or controller.
- Keep a ViewModel or controller free of a platform-specific import.
- Test a ViewModel or controller with a plain unit test.
- Make the data layer interface-driven so an implementation can be swapped for a test.

## Testing and Quality

- Follow the TDD rule in `ai-policy-common.md` (`Universal Testing Standards`).
- Write the test or verification plan before implementing a screen.
- Document in the commit message when TDD was not followed.
- Cover ViewModels or controllers, repositories, use cases, and utility functions with unit tests.
- Cover critical user flows with UI tests: login, navigation, data entry, and error states.
- Use Compose Test on Android, XCTest or XCUITest on iOS, or a widget test on Flutter.
- Cover the data layer with integration tests: database operations, API client integration, and repository flows.
- Cover UI components with snapshot tests to detect an unintended visual change.
- Name a test with the pattern `[method]_[scenario]_[expectedResult]`.

## Error Handling and Resilience

### Structured Error Handling

- Use a sealed class or sealed interface on Kotlin, an enum with associated values on Swift, or a union type to represent success and failure.
- Do not use a bare try/catch block.
- Catch, type, and handle an error at the layer that owns it.
- Expose a `UiState` sealed class with `Loading`, `Success`, and `Error` states for every data-driven screen.

### Graceful Degradation

- Show cached data with an offline indicator when the network is unavailable.
- Show an explanation and a button to open settings when a permission is denied.
- Show an empty state with guidance when data is corrupt or missing.
- Never crash on an unexpected state.
- Use an assertion in a debug build only.

### Retry and Resilience

- Follow `ai-policy-coding-baseline.md` (`## Resilience`) for retry and idempotency.
- Use WorkManager on Android and BGTaskScheduler on iOS for a background task.

## Security and Data Privacy

- Follow `ai-policy-coding-baseline.md` (`## Security`) for secrets and logging.
- Read a build-time secret from BuildConfig, xcconfig, or an environment variable.
- Store a sensitive token in platform secure storage: EncryptedSharedPreferences or KeyStore on Android, Keychain on iOS.
- Encrypt a local database and cached data at rest with SQLCipher or the platform encryption API.
- Use certificate pinning for a production API endpoint.
- Strip sensitive data from logs and crash reports before submission.
- Request a permission contextually and explain why it is needed before showing the system dialog.
- Support a data deletion flow for GDPR or CCPA compliance.
- Collect only the data the feature needs.
- Provide a clear privacy notice for analytics or crash reporting.
- Follow `ai-policy-common.md` (`AI-Driven Secure Development Practices`) for the secure development baseline.

## Performance and Resource Management

### Memory

- Do not leak memory: use a weak reference in a closure or callback, cancel a subscription in `onDispose` or `onCleared`, and avoid a heavy object in a ViewModel.
- Use lazy initialization for a heavy resource: a database, an image loader, or an analytics SDK.
- Profile memory usage on a schedule.
- Flag any growth that does not stabilize.

### Battery and Network

- Batch a network request.
- Do not poll; use a push notification or a WebSocket for a real-time update.
- Use the platform power management API to adjust behavior on a constrained device.
- Compress an image and an asset.
- Use WebP or AVIF and serve a resource at the size the screen needs.

### Startup and Rendering

- Keep app startup under 2 seconds.
- Defer non-critical initialization to after the first frame.
- Use lazy loading for a screen or feature that is not needed immediately.
- Do not do heavy work on the main thread.
- Use a background dispatcher or queue for database, network, and file I/O.
- Profile UI rendering and fix jank before shipping.

## Code Quality and Consistency

### Naming and Organization

- Follow platform conventions: `camelCase` for an iOS property or method, `PascalCase` for an Android class, and `snake_case` for a resource or asset.
- Organize files by feature, not by type.
- Put one class or struct in a file, except for a sealed class or an extension that belongs to the same type.

### Documentation

- Document every public API, protocol, interface, and complex business rule.
- Include a README in each feature module that explains its purpose, dependencies, and key decisions.
- Keep documentation close to the code.
- Update a comment when the code it describes changes.

### Linting and Static Analysis

- Run the platform linter before every commit.
- Address every warning.
- Do not suppress a warning without a documented reason.
- Use the project's existing lint rules.
- Do not introduce a new rule without team agreement.

## CI/CD and Release

### Build and Signing

- Use the project's established build configuration.
- Do not modify signing, a provisioning profile, or a build script without explicit user approval.
- Keep debug and release configurations separate.
- Never ship a debug build to an app store.

### Versioning

- Follow semantic versioning for an app release.
- Increment the build number automatically in CI.
- Do not hardcode a build number.

### App Store Compliance

- Ensure every third-party library complies with the app store guidelines: no private API and no dynamic code execution.
- Prepare the app store metadata as part of the release process.
- Support a phased rollout for a production release.
- Monitor the crash rate before a full rollout.

### Feature Flags

- Use a feature flag for an incomplete or experimental feature.
- Do not ship an incomplete feature without a flag.
- Remove a feature flag when the feature is fully rolled out and stable.

## Design Philosophy

- Choose the design with the fewest moving parts that meets the requirement.
- Solve the user problem at the screen and flow level before an architectural change.
- Respect the existing codebase patterns.
- Do not introduce a new architecture, state management approach, or dependency injection framework without user approval.
- Treat every dependency, animation, and background task as a cost.

## References

- `ai-policy-common.md` (`Universal Testing Standards`, `AI-Driven Secure Development Practices`)
- `ai-policy-coding-baseline.md` (`## Resilience`, `## Security`, `## Testing and Verification`)
- `ai-policy-observability.md` (`## Four Golden Signals`, `## Logs, Metrics, and Traces`)
- `ai-policy-data.md` (`## Data Security and Compliance`)

<!-- AI-ASSISTANT: READ-ONLY END -->

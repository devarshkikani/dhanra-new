# AI Repository Setup for Antigravity

This plan outlines the complete setup for configuring the Flutter repository to be **AI-first**, **production-ready**, and optimized for AI coding assistants (Antigravity, Cursor, GitHub Copilot, Claude Code, ChatGPT, Codex).

## User Review Required

> [!IMPORTANT]
> The workspace directory `/Users/don-devarsh/Documents/Demo/flutter-ai-setup` is currently empty. We will initialize a clean, production-ready Flutter application with full Clean Architecture (Feature-First) structure, BLoC, GoRouter, Dio, Freezed, GetIt/Injectable, and test suites.

> [!NOTE]
> We will configure official **Flutter Agent Plugins** (`flutter/agent-plugins`) and **Dart AI Skills** (`dart-lang/skills`), along with **Dart MCP Server** settings and custom workspace rules in `.agents/`, `.cursor/`, `.github/`, and `docs/`.

## Proposed Changes

### 1. Flutter Project Initialization & Core Package Setup

#### [NEW] [pubspec.yaml](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/pubspec.yaml)
- Configure Flutter app dependencies:
  - **State Management**: `flutter_bloc`, `bloc`, `equatable`
  - **Routing**: `go_router`
  - **Networking & Cache**: `dio`, `connectivity_plus`, `shared_preferences`
  - **Dependency Injection**: `get_it`, `injectable`
  - **Data Modeling**: `freezed_annotation`, `json_annotation`
- Dev Dependencies:
  - `build_runner`, `freezed`, `json_serializable`, `injectable_generator`
  - `very_good_analysis` (strict linter rules)
  - `bloc_test`, `mocktail` for testing

#### [NEW] [analysis_options.yaml](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/analysis_options.yaml)
- Configure strict linting with `very_good_analysis` / Effective Dart rules:
  - Require type annotations
  - Enforce immutability
  - Prevent untranslated strings or direct UI business logic

---

### 2. Clean Architecture Code Base (`lib/` & `test/`)

#### [NEW] `lib/core/`
- [injection.dart](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/lib/core/di/injection.dart): Setup GetIt + Injectable for automated dependency injection.
- [app_router.dart](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/lib/core/router/app_router.dart): GoRouter configuration with error handling and route constants.
- [dio_client.dart](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/lib/core/network/dio_client.dart): Dio HTTP client with interceptors, logging, and base option setup.
- [network_info.dart](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/lib/core/network/network_info.dart): Network connectivity checker for offline-first strategy.
- [failures.dart](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/lib/core/error/failures.dart): Standardized Failure & Exception handling domain objects.

#### [NEW] `lib/features/sample_feature/` (Posts / Items Feature Demo)
- **Domain Layer**:
  - Entity: `lib/features/sample_feature/domain/entities/post.dart` (Freezed)
  - Repository Interface: `lib/features/sample_feature/domain/repositories/post_repository.dart`
  - UseCase: `lib/features/sample_feature/domain/usecases/get_posts_usecase.dart`
- **Data Layer**:
  - Model: `lib/features/sample_feature/data/models/post_model.dart` (Freezed + JsonSerializable)
  - Remote DataSource: `lib/features/sample_feature/data/datasources/post_remote_datasource.dart`
  - Local DataSource: `lib/features/sample_feature/data/datasources/post_local_datasource.dart`
  - Repository Impl: `lib/features/sample_feature/data/repositories/post_repository_impl.dart` (Offline-First)
- **Presentation Layer**:
  - BLoC: `lib/features/sample_feature/presentation/bloc/post_bloc.dart` (Events, States, Handlers)
  - Pages & Widgets: Clean UI consuming PostBloc, decoupled from business logic and APIs.

#### [NEW] `test/`
- Unit tests for UseCases and BLoCs (`post_bloc_test.dart`, `get_posts_usecase_test.dart`)
- Repository test with `mocktail` for offline caching fallback.
- Widget tests for presentation components.

---

### 3. AI Agent Skills & Rules Setup (`.agents/`, `.cursor/`, `.github/`)

#### [NEW] `.agents/skills/`
- Configure official skills structure:
  - `flutter-agent-plugins`: responsive_layout, router_gorouter, state_bloc, json_serialization, dio_networking
  - `dart-lang-skills`: unit_testing, static_analysis, dependency_management
  - `clean-architecture-skills`: feature_generation, repository_pattern, di_injectable

#### [NEW] `.agents/rules/` & [AGENTS.md](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/AGENTS.md)
- Define workspace rules for Antigravity & AI agents:
  - `architecture.md`: Strict Clean Architecture & Feature-First layout rules.
  - `ui_and_state.md`: Rules preventing logic in UI, enforcing BLoC & GoRouter.
  - `api_and_data.md`: Guidelines for Dio, Freezed, JsonSerializable, and Repository caching.
  - `testing_rules.md`: TDD guidelines and test coverage expectations.

#### [NEW] [.github/copilot-instructions.md](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/.github/copilot-instructions.md)
- Instructions tailored for GitHub Copilot: architecture outline, prohibited patterns (no business logic in widgets, no direct HTTP in UI, mandatory DI), and coding conventions.

#### [NEW] `.cursor/rules/`
- `.cursor/rules/clean_architecture.mdc`: Clean Architecture enforcement.
- `.cursor/rules/bloc_state.mdc`: BLoC patterns and state machine conventions.
- `.cursor/rules/dio_injectable.mdc`: Network & DI standards.

---

### 4. Dart MCP Server Configuration (`mcp.json` / `docs/mcp_setup.md`)

#### [NEW] [.mcp/mcp.json](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/.mcp/mcp.json)
- MCP server configuration snippet enabling `dart mcp-server` / `dart tool mcp` for AI integration (Antigravity, Cursor, Claude Desktop).

---

### 5. Documentation & Reusable Prompts (`docs/`)

#### [NEW] [docs/architecture.md](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/docs/architecture.md)
- Complete Clean Architecture, Offline-First flow, BLoC pattern, GoRouter navigation diagram, and DI setup documentation.

#### [NEW] [docs/coding_guidelines.md](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/docs/coding_guidelines.md)
- Effective Dart conventions, SOLID principles, widget decoupling, immutability, and code style.

#### [NEW] [docs/api_guidelines.md](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/docs/api_guidelines.md)
- API integration rules, Dio client, interceptors, error handling, Freezed JSON mapping, and offline cache fallback strategies.

#### [NEW] `docs/prompts/`
- `feature_development.md`: Reusable prompt for generating a complete Clean Architecture feature.
- `bug_fixing.md`: Reusable prompt for debugging with root-cause analysis.
- `code_review.md`: Reusable prompt for AI code review against project standards.
- `testing_strategy.md`: Reusable prompt for generating unit, BLoC, and widget tests.
- `refactoring.md`: Reusable prompt for refactoring monolithic code into clean BLoC layers.

---

### 6. GitHub Actions Workflows (`.github/workflows/`)

#### [NEW] [.github/workflows/ci.yml](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/.github/workflows/ci.yml)
- Workflow for automated CI pipeline:
  - Checkout code & setup Flutter stable
  - `flutter pub get`
  - `dart format --set-exit-if-changed .`
  - `flutter analyze`
  - `flutter test --coverage`
  - Build verification (`flutter build apk --debug`, `flutter build appbundle`, `flutter build web`)

---

## Verification Plan

### Automated Tests
- Run code generator: `dart run build_runner build --delete-conflicting-outputs`
- Check code formatting: `dart format --set-exit-if-changed .`
- Run static analysis: `flutter analyze`
- Run test suite: `flutter test`

### Manual Verification
- Verify all required directories (`.agents/skills/`, `.agents/rules/`, `.github/copilot-instructions.md`, `.cursor/rules/`, `docs/`, `.github/workflows/`) exist and are populated with comprehensive documentation.
- Verify `flutter run` / compilation check succeeds on the created sample feature.

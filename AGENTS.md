# Antigravity Workspace Rules & AI Context

This repository is configured for **AI-First Flutter Development**.

## Project Architecture & Tech Stack
- **Framework**: Flutter (Stable)
- **Architecture**: Clean Architecture (Feature-First) + Offline-First Caching
- **State Management**: BLoC (`flutter_bloc`)
- **Navigation**: GoRouter (`go_router`)
- **HTTP Client**: Dio (`dio`)
- **Dependency Injection**: GetIt (`get_it`) + Injectable (`injectable`)
- **Data Models**: Freezed (`freezed`) + JsonSerializable (`json_serializable`)

## Mandatory Guidelines for AI Assistants
1. **Never place business logic in UI widgets**.
2. **Never call APIs directly from widgets or pages**.
3. **Always use dependency injection (`@injectable`, `@lazySingleton`)**.
4. **Follow feature-first folder conventions in `lib/features/<feature_name>/`**.
5. **Always provide unit tests (`test/features/...`) when generating new features or bug fixes**.
6. **Keep code formatted according to Effective Dart standards**.

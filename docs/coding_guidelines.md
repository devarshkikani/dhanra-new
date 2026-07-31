# Flutter & Dart Coding Guidelines

This document details coding standards, Effective Dart conventions, and SOLID principles strictly enforced across the repository.

## SOLID Principles in Practice

1. **Single Responsibility Principle (SRP)**:
   - UseCases do one thing (e.g., `GetPostsUseCase`).
   - Widgets render UI components, not data fetching.
2. **Open/Closed Principle (OCP)**:
   - Extend repository interfaces without modifying core domain callers.
3. **Liskov Substitution Principle (LSP)**:
   - `PostRemoteDataSourceImpl` can replace `PostRemoteDataSource` seamlessly.
4. **Interface Segregation Principle (ISP)**:
   - Keep DataSource contracts focused and minimal.
5. **Dependency Inversion Principle (DIP)**:
   - High-level UseCases depend on abstract Repositories, not concrete DataSource implementations.

## Code Style & Formatting
- **Naming Conventions**:
  - Files & Folders: `lower_snake_case.dart`
  - Classes & Enums: `UpperCamelCase`
  - Variables & Functions: `lowerCamelCase`
- **Linting**:
  - Configured in [analysis_options.yaml](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/analysis_options.yaml) using `very_good_analysis`.
  - Format code via `dart format .` before pushing code.

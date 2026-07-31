# Production Clean Architecture Documentation

This document outlines the architecture, layer contracts, and offline-first design pattern of the application.

## Overview Diagram

```
+-----------------------------------------------------------------------+
|                         Presentation Layer                             |
|    [PostPage] ---> (BlocProvider) ---> [PostBloc]                    |
|    [PostCard] <--------------------- (PostLoadedState)                 |
+----------------------------------- | ---------------------------------+
                                     | Call UseCase
                                     v
+-----------------------------------------------------------------------+
|                           Domain Layer                                 |
|    [GetPostsUseCase] -------------> [PostRepository] (Interface)      |
|                                            ^                          |
|                                            | Returns Entities         |
|                                      [Post Entity]                    |
+------------------------------------------- | -------------------------+
                                             | Implementation
                                             v
+-----------------------------------------------------------------------+
|                            Data Layer                                  |
|    [PostRepositoryImpl]                                               |
|           |                                                           |
|           +---> NetworkInfo.isConnected ?                             |
|           |        YES: [PostRemoteDataSource] (Dio) -> Cache Local    |
|           |        NO:  [PostLocalDataSource] (SharedPreferences)     |
|           v                                                           |
|    [PostModel] (.toEntity() / .fromJson())                            |
+-----------------------------------------------------------------------+
```

## Layer Definitions

### 1. Domain Layer (`lib/features/<feature>/domain/`)
- **Entities**: Immutable data objects generated via `@freezed`.
- **Repositories**: Abstract class contracts specifying data operations returning domain tuples `(Failure?, List<Entity>?)`.
- **UseCases**: Single-responsibility classes implementing `UseCase<Type, Params>`.

### 2. Data Layer (`lib/features/<feature>/data/`)
- **Models**: Data transfer objects with `@freezed` and `@JsonSerializable`. Implements `.toEntity()` to bridge to domain entities.
- **DataSources**: Remote DataSources interact with Dio; Local DataSources interact with SharedPreferences/Hive.
- **Repositories**: Implements domain interfaces and manages offline-first cache strategies.

### 3. Presentation Layer (`lib/features/<feature>/presentation/`)
- **BLoC**: Manages presentation state machine.
- **Pages**: Top-level routes rendered via `GoRouter`.
- **Widgets**: Reusable, isolated UI components.

## Dependency Injection
Automated via `GetIt` and `Injectable`. Configuration lives in [lib/core/di/injection.dart](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/lib/core/di/injection.dart).

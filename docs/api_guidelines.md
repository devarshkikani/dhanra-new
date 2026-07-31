# API Guidelines & Serialization Standards

This document specifies network communication standards using Dio, Freezed, JsonSerializable, and offline caching.

## Dio Network Client Setup

Centralized Dio client setup is registered in [lib/core/network/dio_client.dart](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/lib/core/network/dio_client.dart):
- Includes standard timeouts (15 seconds).
- Includes logging interceptor for request/response payloads in debug builds.

## Error Handling Pattern

1. **Remote DataSource**:
   - Catches `DioException` and throws `ServerException(message)`.
2. **Repository Impl**:
   - Catches `ServerException` or `CacheException` and maps them into domain `Failure` objects (`ServerFailure`, `CacheFailure`, `NetworkFailure`).
3. **BLoC**:
   - Matches failures and emits `PostErrorState(failure.message)`.

## Data Models & Freezed
- Always declare `@freezed` and `@JsonSerializable(explicitToJson: true)`.
- Re-generate code using `dart run build_runner build --delete-conflicting-outputs`.

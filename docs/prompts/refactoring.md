# Reusable AI Prompt: Refactoring

Copy and paste this prompt when asking an AI assistant to refactor monolithic code into Clean Architecture.

---

```markdown
I have legacy / monolithic code in `[FILE_PATH]` that needs refactoring.

### Refactoring Goals:
1. Extract domain entity objects into `@freezed` models under `domain/entities/`.
2. Extract network and API calls into a RemoteDataSource and Dio client.
3. Extract state management into a BLoC (`flutter_bloc`).
4. Update UI widgets to be pure presentation components consuming BLoC state.
5. Register all dependencies in `injection.dart` using `@injectable`.
6. Verify no breaking changes exist and run `flutter analyze`.
```

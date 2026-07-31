# Reusable AI Prompt: Feature Development

Copy and paste this prompt when asking an AI assistant to implement a new feature in this repository.

---

```markdown
I want to implement a new feature: [FEATURE_NAME].

Please build this feature following our Clean Architecture (Feature-First) guidelines in this repository.

### Requirements:
1. Create folder structure under `lib/features/[FEATURE_NAME]/` containing `domain`, `data`, and `presentation` layers.
2. Domain: Create `@freezed` Entity, Repository Interface, and UseCase.
3. Data: Create `@freezed` + `@JsonSerializable` Model, RemoteDataSource (Dio), LocalDataSource (SharedPreferences), and RepositoryImpl (Offline-First).
4. Presentation: Create BLoC (`Bloc`, `Event`, `State`), GoRouter page, and reusable presentation widgets.
5. Inject dependencies with GetIt and `@injectable`.
6. Write unit tests in `test/features/[FEATURE_NAME]/` for the UseCase and BLoC.

Ensure no business logic or API calls exist in UI widgets.
```

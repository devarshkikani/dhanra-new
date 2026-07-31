# Reusable AI Prompt: Testing Strategy & Generation

Copy and paste this prompt when requesting test generation.

---

```markdown
Please generate tests for the feature: [FEATURE_NAME].

### Requirements:
1. **UseCase Unit Tests**: Use `mocktail` to mock `PostRepository` and verify AAA pattern.
2. **BLoC Tests**: Use `bloc_test` to test initial state, loading state, success state, and failure state streams.
3. **Repository Unit Tests**: Test network online fallback to remote data source and offline fallback to local cache.
4. **Widget Tests**: Verify rendering of pages and widgets under different BLoC states (`PostLoadingState`, `PostLoadedState`, `PostErrorState`).

Save all tests in `test/features/[FEATURE_NAME]/` maintaining the matching directory tree.
```

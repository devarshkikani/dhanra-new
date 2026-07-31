# Reusable AI Prompt: Code Review

Copy and paste this prompt when requesting an AI code review.

---

```markdown
Please perform a code review on the following files/changes:

### Scope:
[LIST FILES OR DIFF HERE]

### Review Criteria:
1. **Architecture Compliance**: Does the code strictly follow Clean Architecture (Feature-First) and repository standards?
2. **UI Decoupling**: Is there any business logic or network code inside widgets?
3. **State Management**: Is BLoC used properly with immutable states?
4. **Dependency Injection**: Are dependencies injected via `@injectable` and GetIt?
5. **Code Quality**: Are Effective Dart and SOLID principles respected?
6. **Testing**: Are proper unit and BLoC test cases provided?

Highlight any warnings, critical defects, or refactoring recommendations.
```

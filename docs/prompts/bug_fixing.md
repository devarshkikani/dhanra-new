# Reusable AI Prompt: Bug Fixing

Copy and paste this prompt when asking an AI assistant to fix a bug.

---

```markdown
I encountered a bug in the application:

### Bug Description:
[DESCRIBE ISSUE HERE]

### Error Logs / Stack Trace:
```
[PASTE LOGS OR STACK TRACE HERE]
```

### Request:
1. Inspect the relevant files using code search and view tools.
2. Identify the root cause without applying superficial symptom patches.
3. Fix the underlying contract or handling in the appropriate layer (Data, Domain, or Presentation).
4. Add or update unit tests in `test/` to reproduce and prevent regression.
5. Verify the fix by running `flutter analyze` and `flutter test`.
```

# Contributing / المساهمة

شكرًا لمساهمتك. افتح issue قبل التغييرات الكبيرة، ولا تضف مفاتيح أو بيانات مستخدمين أو استجابات إنتاجية حساسة.

1. Fork the repository and create a focused branch.
2. Add tests using `MockClient`; tests must not call the live API.
3. Run format, analyze, tests, and `dart pub publish --dry-run`.
4. Update documentation and changelog for user-visible changes.
5. Submit a small pull request explaining compatibility impact.

Public API changes require tests and should preserve backward compatibility. By contributing, you agree that your work is licensed under MIT.

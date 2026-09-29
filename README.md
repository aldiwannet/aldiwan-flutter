# AlDiwan for Dart & Flutter

[![CI](https://github.com/aldiwannet/aldiwan-flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/aldiwannet/aldiwan-flutter/actions/workflows/ci.yml)

عميل Dart typed لواجهة الديوان العامة، متوافق مع Flutter وDart. يدعم القصائد والشعراء والبحث والاكتشاف وpagination، مع timeouts وأخطاء واضحة واحترام `Retry-After` عند استجابة `429`.

## البدء السريع

```yaml
dependencies:
  aldiwan: ^0.1.0
```

أنشئ API key من منصة مطوري الديوان، واحفظه خارج المصدر. لا تضع المفتاح داخل تطبيق Flutter موزع للمستخدمين؛ استخدم backend وسيطًا عند الحاجة إلى إبقائه سريًا.

```dart
final client = AldiwanClient(apiKey: serverEnvironmentApiKey);
try {
  final poem = await client.poems.get(42);
  print('${poem.title}: ${poem.text}');
  // يجب إظهار النسب عندما تكون poem.attribution.required == true.
  print('${poem.attribution.text}: ${poem.attribution.url}');
} finally {
  client.close();
}
```

الخدمات المتاحة:

- `client.poems.list/get` مع فلاتر الشاعر والعصر والموضوع والبحر والقافية والنمط.
- `client.poets.list/get/poems`.
- `client.search.search` للبحث المجمع.
- `client.discovery` للتصنيفات والموضوعات والعصور والبحور والقوافي.

## English

A typed Dart client for AlDiwan's public developer API. Every request requires an API key and sends `Authorization: Bearer <api-key>`.

```dart
final client = AldiwanClient(apiKey: Platform.environment['ALDIWAN_API_KEY']!);
final page = await client.poems.list(
  filters: const PoemFilters(meter: 'الطويل', style: PoemStyle.vertical),
);
```

The default base URL is `https://api.aldiwan.net/api/v1`. You may inject an `http.Client` for testing. Repository tests use mocks and never contact production. Preserve the returned `attribution` when displaying poetry content.

`timeout`, `maxRetries`, and `maxRetryAfter` are configurable. Automatic retry is limited to safe GET requests returning `429` with a valid, bounded `Retry-After` value.

Do not commit API keys. A key embedded in a shipped mobile, desktop, or web application can be extracted; proxy requests through a trusted backend if the key must remain confidential.

## Development

```bash
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
dart pub publish --dry-run
```

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md). Licensed under MIT.

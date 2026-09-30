import 'package:aldiwan/aldiwan.dart';

Future<void> main() async {
  const apiKey = String.fromEnvironment('ALDIWAN_API_KEY');
  if (apiKey.isEmpty) {
    throw StateError('Set ALDIWAN_API_KEY with --define.');
  }
  final client = AldiwanClient(apiKey: apiKey);
  try {
    final poems = await client.poems.list(perPage: 10);
    for (final summary in poems.items) {
      print('${summary.title} — ${summary.poet.name}: ${summary.excerpt}');
      if (summary.attribution.required) {
        print('${summary.attribution.text}: ${summary.attribution.url}');
      }
    }
    // Fetch full text only when the reader opens one poem. This consumes the
    // plan's separate full-text quota.
    if (poems.items.isNotEmpty) {
      final poem = await client.poems.get(poems.items.first.id);
      print(poem.text);
    }
  } finally {
    client.close();
  }
}

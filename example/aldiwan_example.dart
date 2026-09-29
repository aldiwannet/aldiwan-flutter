import 'package:aldiwan/aldiwan.dart';

Future<void> main() async {
  const apiKey = String.fromEnvironment('ALDIWAN_API_KEY');
  if (apiKey.isEmpty) {
    throw StateError('Set ALDIWAN_API_KEY with --define.');
  }
  final client = AldiwanClient(apiKey: apiKey);
  try {
    final poems = await client.poems.list(perPage: 10);
    for (final poem in poems.items) {
      print('${poem.title} — ${poem.poet.name}');
      if (poem.attribution.required) {
        print('${poem.attribution.text}: ${poem.attribution.url}');
      }
    }
  } finally {
    client.close();
  }
}

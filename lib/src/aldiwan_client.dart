import 'package:http/http.dart' as http;

import 'services/discovery_service.dart';
import 'services/poems_service.dart';
import 'services/poets_service.dart';
import 'services/search_service.dart';
import 'transport.dart';

final class AldiwanClient {
  AldiwanClient({
    required String apiKey,
    Uri? baseUri,
    http.Client? httpClient,
    Duration timeout = const Duration(seconds: 15),
    int maxRetries = 2,
    Duration maxRetryAfter = const Duration(seconds: 30),
    Delay? delay,
  })  : _ownsClient = httpClient == null,
        _httpClient = httpClient ?? http.Client() {
    if (apiKey.trim().isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'Must not be empty.');
    }
    if (maxRetries < 0) {
      throw ArgumentError.value(
          maxRetries, 'maxRetries', 'Must not be negative.');
    }
    final transport = AldiwanTransport(
        baseUri: baseUri ?? Uri.parse('https://api.aldiwan.net/v1'),
        apiKey: apiKey,
        client: _httpClient,
        timeout: timeout,
        maxRetries: maxRetries,
        maxRetryAfter: maxRetryAfter,
        delay: delay);
    poems = PoemsService(transport);
    poets = PoetsService(transport);
    discovery = DiscoveryService(transport);
    search = SearchService(transport);
  }
  final http.Client _httpClient;
  final bool _ownsClient;
  late final PoemsService poems;
  late final PoetsService poets;
  late final DiscoveryService discovery;
  late final SearchService search;
  void close() {
    if (_ownsClient) {
      _httpClient.close();
    }
  }
}

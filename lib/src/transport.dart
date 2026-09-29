import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'errors.dart';
import 'models/page.dart';

typedef Delay = Future<void> Function(Duration duration);

final class AldiwanTransport {
  AldiwanTransport({
    required this.baseUri,
    required this.apiKey,
    required http.Client client,
    required this.timeout,
    required this.maxRetries,
    required this.maxRetryAfter,
    Delay? delay,
  })  : _client = client,
        _delay = delay ?? Future<void>.delayed;

  final Uri baseUri;
  final String apiKey;
  final http.Client _client;
  final Duration timeout;
  final int maxRetries;
  final Duration maxRetryAfter;
  final Delay _delay;

  Future<Object?> get(String path, {Map<String, Object?>? query}) async {
    final uri = _uri(path, query);
    for (var attempt = 0;; attempt++) {
      late http.Response response;
      try {
        response = await _client.get(
          uri,
          headers: {
            'accept': 'application/json',
            'authorization': 'Bearer $apiKey'
          },
        ).timeout(timeout);
      } on TimeoutException {
        throw AldiwanTimeoutException('Request timed out after $timeout.');
      } on SocketException catch (error) {
        throw AldiwanNetworkException(
            'Network request failed: ${error.message}');
      } on http.ClientException catch (error) {
        throw AldiwanNetworkException(
            'Network request failed: ${error.message}');
      }

      final requestId = response.headers['x-request-id'] ??
          _errorValue(response.body, 'request_id');
      if (response.statusCode == 429) {
        final retryAfter = _retryAfter(response.headers['retry-after']);
        if (attempt < maxRetries && retryAfter != null) {
          await _delay(retryAfter);
          continue;
        }
        throw AldiwanRateLimitException(
          _message(response.body, 'Rate limit exceeded.'),
          retryAfter: retryAfter,
          requestId: requestId,
        );
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AldiwanHttpException(
          _message(
              response.body, 'Request failed with ${response.statusCode}.'),
          statusCode: response.statusCode,
          requestId: requestId,
        );
      }
      if (response.body.trim().isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } on FormatException {
        throw const AldiwanFormatException('The API returned invalid JSON.');
      }
    }
  }

  Uri _uri(String path, Map<String, Object?>? query) {
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    final root =
        baseUri.toString().endsWith('/') ? baseUri : Uri.parse('$baseUri/');
    final uri = root.resolve(normalized);
    if (query == null) return uri;
    return uri.replace(
      queryParameters: {
        for (final entry in query.entries)
          if (entry.value != null) entry.key: entry.value.toString(),
      },
    );
  }

  Duration? _retryAfter(String? value) {
    if (value == null) return null;
    final seconds = int.tryParse(value);
    Duration? duration;
    if (seconds != null) {
      duration = Duration(seconds: seconds < 0 ? 0 : seconds);
    } else {
      late final DateTime date;
      try {
        date = HttpDate.parse(value);
      } on HttpException {
        return null;
      }
      final difference = date.difference(DateTime.now().toUtc());
      duration = difference.isNegative ? Duration.zero : difference;
    }
    return duration > maxRetryAfter ? maxRetryAfter : duration;
  }

  String _message(String body, String fallback) {
    return _errorValue(body, 'message') ?? fallback;
  }

  String? _errorValue(String body, String key) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded[key] != null) {
        return decoded[key].toString();
      }
      if (decoded is Map && decoded['error'] is Map) {
        return (decoded['error'] as Map)[key]?.toString();
      }
    } on FormatException {
      return null;
    }
    return null;
  }
}

JsonMap jsonObject(Object? value) {
  Object? candidate = value;
  if (value is Map && value['data'] is Map) candidate = value['data'];
  if (candidate is Map<String, Object?>) return candidate;
  if (candidate is Map) {
    return candidate.map((key, item) => MapEntry(key.toString(), item));
  }
  throw const AldiwanFormatException('Expected a JSON object from the API.');
}

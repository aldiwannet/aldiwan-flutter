import 'dart:async';
import 'dart:convert';

import 'package:aldiwan/aldiwan.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

const poemJson =
    '{"id":42,"title":"ألا ليت","slug":"ala-layta","text":"نص القصيدة","poet":{"id":7,"name":"شاعر","slug":"shaer"},"era":{"id":2,"name":"العباسي"},"meter":"الطويل","theme":null,"rhyme":"م","poem_style":"vertical","display_layout":"hemistichs","canonical_url":"https://www.aldiwan.net/poem42.html","attribution":{"required":true,"text":"الديوان","url":"https://www.aldiwan.net"}}';
const poetJson =
    '{"id":7,"name":"شاعر","slug":"shaer","image_url":null,"biography":null,"gender":1,"era":{"id":2,"name":"العباسي"},"country":null,"canonical_url":"https://www.aldiwan.net/cat-shaer"}';

void main() {
  test('requires a non-empty API key', () {
    expect(() => AldiwanClient(apiKey: '  '), throwsArgumentError);
  });

  test('sends Bearer authentication and decodes the current poem DTO',
      () async {
    late http.Request requested;
    final client = AldiwanClient(
        apiKey: 'test-key',
        httpClient: MockClient((request) async {
          requested = request;
          return utf8Response('{"data":$poemJson}', 200);
        }));
    final poem = await client.poems.get(42);
    expect(requested.url.toString(), 'https://api.aldiwan.net/api/v1/poems/42');
    expect(requested.headers['authorization'], 'Bearer test-key');
    expect(poem.id, 42);
    expect(poem.text, 'نص القصيدة');
    expect(poem.poet.name, 'شاعر');
    expect(poem.attribution.required, isTrue);
    expect(poem.poemStyle, PoemStyle.vertical);
  });

  test('lists filtered poems with pagination', () async {
    late Uri requested;
    final client = AldiwanClient(
        apiKey: 'key',
        httpClient: MockClient((request) async {
          requested = request.url;
          return utf8Response(
              '{"data":[$poemJson],"meta":{"page":2,"total_pages":4,"per_page":10,"total":39}}',
              200);
        }));
    final page = await client.poems.list(
        page: 2,
        perPage: 10,
        filters: const PoemFilters(meter: 'الطويل', style: PoemStyle.vertical));
    expect(requested.path, '/api/v1/poems');
    expect(requested.queryParameters['meter'], 'الطويل');
    expect(requested.queryParameters['poem_style'], 'vertical');
    expect(page.currentPage, 2);
    expect(page.nextPage, 3);
  });

  test('supports poet details and poet poems routes', () async {
    final paths = <String>[];
    final client = AldiwanClient(
        apiKey: 'key',
        httpClient: MockClient((request) async {
          paths.add(request.url.path);
          return request.url.path.endsWith('/poems')
              ? utf8Response('{"data":[$poemJson]}', 200)
              : utf8Response('{"data":$poetJson}', 200);
        }));
    expect((await client.poets.get(7)).name, 'شاعر');
    expect((await client.poets.poems(7)).items.single.id, 42);
    expect(paths, ['/api/v1/poets/7', '/api/v1/poets/7/poems']);
  });

  test('uses the current search route and grouped DTO', () async {
    late Uri requested;
    final client = AldiwanClient(
        apiKey: 'key',
        httpClient: MockClient((request) async {
          requested = request.url;
          return utf8Response(
              '{"data":{"poems":[$poemJson],"poets":[$poetJson]}}', 200);
        }));
    final result = await client.search.search('شاعر', type: SearchType.all);
    expect(requested.path, '/api/v1/search');
    expect(requested.queryParameters['q'], 'شاعر');
    expect(result.poems.single.id, 42);
    expect(result.poets.single.id, 7);
  });

  test('honors Retry-After before retrying a 429', () async {
    var calls = 0;
    final delays = <Duration>[];
    final client = AldiwanClient(
        apiKey: 'key',
        delay: (duration) async => delays.add(duration),
        httpClient: MockClient((request) async {
          calls++;
          return calls == 1
              ? utf8Response('{"error":{"message":"slow"}}', 429,
                  headers: {'retry-after': '3'})
              : utf8Response('{"data":$poemJson}', 200);
        }));
    expect((await client.poems.get(42)).id, 42);
    expect(delays, [const Duration(seconds: 3)]);
  });

  test('throws typed timeout and HTTP errors', () async {
    final timeoutClient = AldiwanClient(
        apiKey: 'key',
        timeout: const Duration(milliseconds: 1),
        httpClient: MockClient((request) async {
          await Completer<void>().future;
          return utf8Response('{}', 200);
        }));
    await expectLater(
        timeoutClient.poems.get(1), throwsA(isA<AldiwanTimeoutException>()));

    final errorClient = AldiwanClient(
        apiKey: 'key',
        httpClient: MockClient((request) async => utf8Response(
            '{"error":{"message":"غير موجود","request_id":"req-1"}}', 404)));
    await expectLater(
        errorClient.poems.get(1),
        throwsA(isA<AldiwanHttpException>()
            .having((error) => error.statusCode, 'status', 404)
            .having((error) => error.requestId, 'requestId', 'req-1')));
  });
}

http.Response utf8Response(String body, int statusCode,
        {Map<String, String> headers = const {}}) =>
    http.Response.bytes(utf8.encode(body), statusCode, headers: {
      'content-type': 'application/json; charset=utf-8',
      ...headers
    });

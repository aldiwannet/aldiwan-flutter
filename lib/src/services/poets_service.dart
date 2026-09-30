import '../models/page.dart';
import '../models/poem.dart';
import '../models/poet.dart';
import '../transport.dart';

final class PoetsService {
  const PoetsService(this._transport);
  final AldiwanTransport _transport;

  Future<AldiwanPage<Poet>> list({
    int page = 1,
    int perPage = 20,
    String? query,
  }) async => AldiwanPage<Poet>.fromJson(
    await _transport.get(
      'poets',
      query: {'page': page, 'per_page': perPage, 'q': query},
    ),
    Poet.fromJson,
  );
  Future<Poet> get(int id) async =>
      Poet.fromJson(jsonObject(await _transport.get('poets/$id')));
  Future<AldiwanPage<PoemSummary>> poems(
    int id, {
    int page = 1,
    int perPage = 20,
  }) async => AldiwanPage<PoemSummary>.fromJson(
    await _transport.get(
      'poets/$id/poems',
      query: {'page': page, 'per_page': perPage},
    ),
    PoemSummary.fromJson,
  );
}

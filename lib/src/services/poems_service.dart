import '../models/page.dart';
import '../models/poem.dart';
import '../transport.dart';

final class PoemFilters {
  const PoemFilters(
      {this.poetId,
      this.eraId,
      this.theme,
      this.meter,
      this.rhyme,
      this.style});
  final int? poetId;
  final int? eraId;
  final String? theme;
  final String? meter;
  final String? rhyme;
  final PoemStyle? style;
  Map<String, Object?> toQuery() => {
        'poet_id': poetId,
        'era_id': eraId,
        'theme': theme,
        'meter': meter,
        'rhyme': rhyme,
        'poem_style': style?.name == 'freeVerse' ? 'free_verse' : style?.name
      };
}

final class PoemsService {
  const PoemsService(this._transport);
  final AldiwanTransport _transport;

  Future<Poem> get(int id) async =>
      Poem.fromJson(jsonObject(await _transport.get('poems/$id')));

  Future<AldiwanPage<Poem>> list(
          {int page = 1,
          int perPage = 20,
          PoemFilters filters = const PoemFilters()}) async =>
      AldiwanPage<Poem>.fromJson(
          await _transport.get('poems',
              query: {'page': page, 'per_page': perPage, ...filters.toQuery()}),
          Poem.fromJson);
}

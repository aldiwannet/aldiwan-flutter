import '../models/search_result.dart';
import '../transport.dart';

final class SearchService {
  const SearchService(this._transport);
  final AldiwanTransport _transport;
  Future<SearchResult> search(String query,
      {SearchType type = SearchType.all}) async {
    if (query.runes.length < 2 || query.runes.length > 100) {
      throw ArgumentError.value(
          query, 'query', 'Must contain 2 to 100 characters.');
    }
    return SearchResult.fromJson(jsonObject(await _transport
        .get('search', query: {'q': query, 'type': type.name})));
  }
}

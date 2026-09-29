import 'page.dart';
import 'poem.dart';
import 'poet.dart';

enum SearchType { all, poems, poets }

final class SearchResult {
  const SearchResult({required this.poems, required this.poets});
  final List<Poem> poems;
  final List<Poet> poets;
  factory SearchResult.fromJson(JsonMap json) {
    List<T> decode<T>(Object? value, T Function(JsonMap) decoder) =>
        value is List
            ? value
                .map((item) => decoder((item as Map)
                    .map((key, value) => MapEntry(key.toString(), value))))
                .toList(growable: false)
            : <T>[];
    return SearchResult(
        poems: decode(json['poems'], Poem.fromJson),
        poets: decode(json['poets'], Poet.fromJson));
  }
}

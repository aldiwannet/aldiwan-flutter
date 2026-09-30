typedef JsonMap = Map<String, Object?>;

final class AldiwanPage<T> {
  const AldiwanPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    this.perPage,
    this.total,
  });

  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int? perPage;
  final int? total;
  bool get hasNextPage => currentPage < lastPage;
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  factory AldiwanPage.fromJson(Object? value, T Function(JsonMap json) decode) {
    if (value is List<Object?>) {
      return AldiwanPage<T>(
        items: value.map((item) => decode(_map(item))).toList(growable: false),
        currentPage: 1,
        lastPage: 1,
      );
    }
    final json = _map(value);
    final nested = json['data'];
    if (nested is Map<String, Object?> && nested['data'] is List<Object?>) {
      return AldiwanPage<T>.fromJson(nested, decode);
    }
    final rawItems = nested is List<Object?>
        ? nested
        : (json['items'] as List<Object?>? ?? const <Object?>[]);
    final meta = json['meta'] is Map ? _map(json['meta']) : json;
    return AldiwanPage<T>(
      items: rawItems.map((item) => decode(_map(item))).toList(growable: false),
      currentPage: _integer(meta['current_page'] ?? meta['page']) ?? 1,
      lastPage: _integer(meta['last_page'] ?? meta['total_pages']) ?? 1,
      perPage: _integer(meta['per_page']),
      total: _integer(meta['total']),
    );
  }
}

JsonMap _map(Object? value) {
  if (value is Map<String, Object?>) return value;
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  throw const FormatException('Expected a JSON object.');
}

int? _integer(Object? value) => value is int ? value : int.tryParse('$value');

JsonMap requireMap(JsonMap json, String key) => _map(json[key]);
String requireString(JsonMap json, String key) {
  final value = json[key];
  if (value is String) return value;
  throw FormatException('Expected "$key" to be a string.');
}

int requireInt(JsonMap json, String key) {
  final value = json[key];
  if (value is int) return value;
  throw FormatException('Expected "$key" to be an integer.');
}

String? nullableString(Object? value) => value is String ? value : null;

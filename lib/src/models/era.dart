import 'page.dart';

final class Era {
  const Era({this.id, this.name});
  final int? id;
  final String? name;
  factory Era.fromJson(JsonMap json) => Era(
      id: json['id'] is int ? json['id'] as int : null,
      name: nullableString(json['name']));
}

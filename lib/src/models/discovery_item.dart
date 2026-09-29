import 'page.dart';

final class DiscoveryItem {
  const DiscoveryItem({required this.name, this.id});
  final int? id;
  final String name;
  factory DiscoveryItem.fromJson(JsonMap json) => DiscoveryItem(
      id: json['id'] is int ? json['id'] as int : null,
      name: requireString(json, 'name'));
}

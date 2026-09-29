import 'era.dart';
import 'page.dart';

final class PoetSummary {
  const PoetSummary({required this.id, required this.name, required this.slug});
  final int id;
  final String name;
  final String slug;
  factory PoetSummary.fromJson(JsonMap json) => PoetSummary(
      id: requireInt(json, 'id'),
      name: requireString(json, 'name'),
      slug: requireString(json, 'slug'));
}

final class Poet {
  const Poet(
      {required this.id,
      required this.name,
      required this.slug,
      required this.era,
      required this.canonicalUrl,
      this.imageUrl,
      this.biography,
      this.gender,
      this.country});
  final int id;
  final String name;
  final String slug;
  final Uri? imageUrl;
  final String? biography;
  final int? gender;
  final Era era;
  final String? country;
  final Uri canonicalUrl;
  factory Poet.fromJson(JsonMap json) {
    final imageUrl = nullableString(json['image_url']);
    return Poet(
        id: requireInt(json, 'id'),
        name: requireString(json, 'name'),
        slug: requireString(json, 'slug'),
        imageUrl: imageUrl == null ? null : Uri.parse(imageUrl),
        biography: nullableString(json['biography']),
        gender: json['gender'] is int ? json['gender'] as int : null,
        era: Era.fromJson(requireMap(json, 'era')),
        country: nullableString(json['country']),
        canonicalUrl: Uri.parse(requireString(json, 'canonical_url')));
  }
}

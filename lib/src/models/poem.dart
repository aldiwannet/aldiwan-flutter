import 'attribution.dart';
import 'era.dart';
import 'page.dart';
import 'poet.dart';

enum PoemStyle { vertical, prose, freeVerse, unknown }

enum DisplayLayout { hemistichs, lines, stanzas }

class PoemSummary {
  const PoemSummary({
    required this.id,
    required this.title,
    required this.slug,
    required this.poet,
    required this.era,
    required this.poemStyle,
    required this.displayLayout,
    required this.excerpt,
    required this.canonicalUrl,
    required this.attribution,
    this.meter,
    this.theme,
    this.rhyme,
  });
  final int id;
  final String title;
  final String slug;
  final PoetSummary poet;
  final Era era;
  final String? meter;
  final String? theme;
  final String? rhyme;
  final PoemStyle poemStyle;
  final DisplayLayout displayLayout;
  final String excerpt;
  final Uri canonicalUrl;
  final Attribution attribution;

  factory PoemSummary.fromJson(JsonMap json) => PoemSummary(
    id: requireInt(json, 'id'),
    title: requireString(json, 'title'),
    slug: requireString(json, 'slug'),
    poet: PoetSummary.fromJson(requireMap(json, 'poet')),
    era: Era.fromJson(requireMap(json, 'era')),
    meter: nullableString(json['meter']),
    theme: nullableString(json['theme']),
    rhyme: nullableString(json['rhyme']),
    poemStyle: parsePoemStyle(requireString(json, 'poem_style')),
    displayLayout: parseDisplayLayout(requireString(json, 'display_layout')),
    excerpt: requireString(json, 'excerpt'),
    canonicalUrl: Uri.parse(requireString(json, 'canonical_url')),
    attribution: Attribution.fromJson(requireMap(json, 'attribution')),
  );
}

/// A single poem detail. Full text is intentionally available only here.
final class Poem extends PoemSummary {
  const Poem({
    required super.id,
    required super.title,
    required super.slug,
    required super.poet,
    required super.era,
    required super.poemStyle,
    required super.displayLayout,
    required super.excerpt,
    required super.canonicalUrl,
    required super.attribution,
    required this.text,
    super.meter,
    super.theme,
    super.rhyme,
  });

  final String text;

  factory Poem.fromJson(JsonMap json) {
    final summary = PoemSummary.fromJson(json);
    return Poem(
      id: summary.id,
      title: summary.title,
      slug: summary.slug,
      poet: summary.poet,
      era: summary.era,
      meter: summary.meter,
      theme: summary.theme,
      rhyme: summary.rhyme,
      poemStyle: summary.poemStyle,
      displayLayout: summary.displayLayout,
      excerpt: summary.excerpt,
      text: requireString(json, 'text'),
      canonicalUrl: summary.canonicalUrl,
      attribution: summary.attribution,
    );
  }
}

PoemStyle parsePoemStyle(String value) => switch (value) {
  'vertical' => PoemStyle.vertical,
  'prose' => PoemStyle.prose,
  'free_verse' => PoemStyle.freeVerse,
  _ => PoemStyle.unknown,
};

DisplayLayout parseDisplayLayout(String value) => switch (value) {
  'hemistichs' => DisplayLayout.hemistichs,
  'stanzas' => DisplayLayout.stanzas,
  _ => DisplayLayout.lines,
};

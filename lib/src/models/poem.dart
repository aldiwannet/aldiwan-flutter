import 'attribution.dart';
import 'era.dart';
import 'page.dart';
import 'poet.dart';

enum PoemStyle { vertical, prose, freeVerse, unknown }

enum DisplayLayout { hemistichs, lines, stanzas }

final class Poem {
  const Poem(
      {required this.id,
      required this.title,
      required this.slug,
      required this.poet,
      required this.era,
      required this.poemStyle,
      required this.displayLayout,
      required this.text,
      required this.canonicalUrl,
      required this.attribution,
      this.meter,
      this.theme,
      this.rhyme});
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
  final String text;
  final Uri canonicalUrl;
  final Attribution attribution;

  factory Poem.fromJson(JsonMap json) => Poem(
        id: requireInt(json, 'id'),
        title: requireString(json, 'title'),
        slug: requireString(json, 'slug'),
        poet: PoetSummary.fromJson(requireMap(json, 'poet')),
        era: Era.fromJson(requireMap(json, 'era')),
        meter: nullableString(json['meter']),
        theme: nullableString(json['theme']),
        rhyme: nullableString(json['rhyme']),
        poemStyle: switch (requireString(json, 'poem_style')) {
          'vertical' => PoemStyle.vertical,
          'prose' => PoemStyle.prose,
          'free_verse' => PoemStyle.freeVerse,
          _ => PoemStyle.unknown
        },
        displayLayout: switch (requireString(json, 'display_layout')) {
          'hemistichs' => DisplayLayout.hemistichs,
          'stanzas' => DisplayLayout.stanzas,
          _ => DisplayLayout.lines
        },
        text: requireString(json, 'text'),
        canonicalUrl: Uri.parse(requireString(json, 'canonical_url')),
        attribution: Attribution.fromJson(requireMap(json, 'attribution')),
      );
}

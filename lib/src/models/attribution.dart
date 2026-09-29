import 'page.dart';

final class Attribution {
  const Attribution(
      {required this.required, required this.text, required this.url});
  final bool required;
  final String text;
  final Uri url;
  factory Attribution.fromJson(JsonMap json) => Attribution(
      required: json['required'] == true,
      text: requireString(json, 'text'),
      url: Uri.parse(requireString(json, 'url')));
}

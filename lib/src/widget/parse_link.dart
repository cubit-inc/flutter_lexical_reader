part of '../parser.dart';

InlineSpan _parseLink(Map<String, dynamic> child, TextStyle textStyle,
    bool useMyStyle, BuildContext context) {
  final int? format = child["format"] is int? ? child["format"] : 0;
  final baseStyle = _textStyle(format, textStyle, useMyStyle);

  final String link = child["fields"]["url"] as String;

  handleOpenLink() async {
    await launchUrl(Uri.parse(link));
  }

  final List<dynamic> childElements = child["children"] ?? [];

  final List<InlineSpan> widgets = parseJsonChild(childElements, context);

  return WidgetSpan(
      child: GestureDetector(
    onTap: handleOpenLink,
    child: RichText(text: TextSpan(children: [...widgets], style: baseStyle)),
  ));
}

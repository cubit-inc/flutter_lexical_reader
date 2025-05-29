part of '../parser.dart';

InlineSpan _parseLink(Map<String, dynamic> child, TextStyle textStyle,
    bool useMyStyle, BuildContext context) {
  final int? format = child["format"] is int? ? child["format"] : 0;
  final baseStyle = _textStyle(format, textStyle, useMyStyle);

  final String? link = child?["fields"]?["url"] as String?;

  handleOpenLink() async {
    LaunchMode launchMode = child["fields"]["newTab"] == true
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;

    if (link != null) {
      await launchUrl(Uri.parse(link), mode: launchMode);
    }
  }

  final List<dynamic> childElements = child["children"] ?? [];

  final List<InlineSpan> widgets = parseJsonChild(
      childElements.map((element) {
        // element["format"] = 8;
        return element;
      }).toList(),
      context);

  return WidgetSpan(
      child: GestureDetector(
    onTap: handleOpenLink,
    child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: baseStyle.color ?? Color(0xFF000000)))),
        child: RichText(
            text: TextSpan(
          style: baseStyle,
          children: [...widgets],
        ))),
  ));
}

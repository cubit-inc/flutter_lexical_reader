part of '../parser.dart';

class ParagraphStyle {
  final TextAlign textAlign;
  final double? heightText;

  ParagraphStyle({required this.textAlign, this.heightText});
}

class HeadingStyle {
  final double fontSize;
  final double height;
  final EdgeInsets margin;
  final FontWeight fontWeight;
  final bool isUppercase;

  const HeadingStyle({
    required this.fontSize,
    required this.height,
    required this.margin,
    this.fontWeight = FontWeight.w500,
    this.isUppercase = false,
  });
}

class _ParseParagraph extends StatelessWidget {
  const _ParseParagraph({
    required this.child,
    this.lineType,
  });
  final Map<String, dynamic> child;
  final LineType? lineType;

  HeadingStyle _getHeadingStyle(
      BuildContext context, LineType type, bool isMobile) {
    // Base size for em calculations
    const double baseFontSize = 16.0;

    switch (type) {
      case LineType.h1:
        return isMobile
            ? const HeadingStyle(
                fontSize: 36 * (baseFontSize / 16),
                height: 40 / 36,
                margin: EdgeInsets.only(
                  top: 32 * (baseFontSize / 36),
                  bottom: 24 * (baseFontSize / 36),
                ),
              )
            : const HeadingStyle(
                fontSize: 72 * (baseFontSize / 16),
                height: 72 / 72,
                margin: EdgeInsets.only(
                  top: 56 * (baseFontSize / 72),
                  bottom: 32 * (baseFontSize / 72),
                ),
              );
      case LineType.h2:
        return isMobile
            ? const HeadingStyle(
                fontSize: 30 * (baseFontSize / 16),
                height: 36 / 30,
                margin: EdgeInsets.only(
                  top: 28 * (baseFontSize / 30),
                  bottom: 20 * (baseFontSize / 30),
                ),
              )
            : const HeadingStyle(
                fontSize: 60 * (baseFontSize / 16),
                height: 60 / 60,
                margin: EdgeInsets.only(
                  top: 56 * (baseFontSize / 60),
                  bottom: 32 * (baseFontSize / 60),
                ),
              );
      case LineType.h3:
        return isMobile
            ? const HeadingStyle(
                fontSize: 24 * (baseFontSize / 16),
                height: 32 / 24,
                margin: EdgeInsets.only(
                  top: 24 * (baseFontSize / 24),
                  bottom: 20 * (baseFontSize / 24),
                ),
              )
            : const HeadingStyle(
                fontSize: 48 * (baseFontSize / 16),
                height: 48 / 48,
                margin: EdgeInsets.only(
                  top: 40 * (baseFontSize / 48),
                  bottom: 28 * (baseFontSize / 48),
                ),
              );
      case LineType.h4:
        return const HeadingStyle(
          fontSize: 36 * (baseFontSize / 16),
          height: 40 / 36,
          margin: EdgeInsets.only(
            top: 32 * (baseFontSize / 36),
            bottom: 24 * (baseFontSize / 36),
          ),
        );
      case LineType.h5:
        return const HeadingStyle(
          fontSize: 30 * (baseFontSize / 16),
          height: 36 / 30,
          margin: EdgeInsets.only(
            top: 28 * (baseFontSize / 30),
            bottom: 20 * (baseFontSize / 30),
          ),
        );
      case LineType.h6:
        return const HeadingStyle(
          fontSize: 24 * (baseFontSize / 16),
          height: 32 / 24,
          margin: EdgeInsets.only(
            top: 24 * (baseFontSize / 24),
            bottom: 20 * (baseFontSize / 24),
          ),
        );
      default:
        throw ArgumentError('Invalid heading type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final paragraphPadding =
        _PropsInheritedWidget.of(context)?.paragraphPadding ??
            const EdgeInsets.symmetric(vertical: 8.0);

    if (lineType == null || lineType == LineType.paragraph) {
      final TextStyle textStyle = _getDefaultTextStyle(context);
      final List<InlineSpan> childrenWidgets = parseJsonChild(
        child['children'] ?? [],
        context,
      );

      final paragraphDataStyle =
          _PropsInheritedWidget.of(context)?.paragraphDataStyle;
      return Padding(
        padding: paragraphPadding,
        child: RichText(
          textAlign: _alignmentFromString(child['format'],
              textAlign: paragraphDataStyle?.textAlign),
          text: TextSpan(
            children: childrenWidgets,
            style: textStyle.copyWith(
              height: paragraphDataStyle?.heightText,
            ),
          ),
        ),
      );
    } else {
      // Handle heading
      final headingStyle = _getHeadingStyle(context, lineType!, isMobile);
      final List<InlineSpan> childrenWidgets = parseJsonChild(
        child['children'] ?? [],
        context,
      );

      return Padding(
        padding: headingStyle.margin,
        child: RichText(
          textAlign: _alignmentFromString(child['format']),
          text: TextSpan(
            children: childrenWidgets.map((span) {
              if (span is TextSpan) {
                return TextSpan(
                  text: headingStyle.isUppercase
                      ? span.text?.toUpperCase()
                      : span.text,
                  style: (span.style ?? const TextStyle()).copyWith(
                    fontSize: headingStyle.fontSize,
                    height: headingStyle.height,
                    fontWeight: headingStyle.fontWeight,
                    fontFamily:
                        Theme.of(context).textTheme.headlineLarge?.fontFamily,
                  ),
                );
              }
              return span;
            }).toList(),
          ),
        ),
      );
    }
  }

  TextStyle _getDefaultTextStyle(BuildContext context) {
    return _PropsInheritedWidget.of(context)!.paragraphStyle ??
        Theme.of(context).textTheme.titleMedium ??
        const TextStyle(fontSize: 12);
  }

  TextAlign _alignmentFromString(String? format, {TextAlign? textAlign}) {
    if (textAlign != null) {
      return textAlign;
    }
    switch (format) {
      case 'center':
        return TextAlign.center;
      case 'left':
        return TextAlign.start;
      case 'justify':
        return TextAlign.justify;
      case 'right':
        return TextAlign.end;
      default:
        return TextAlign.start;
    }
  }
}

enum LineType {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  paragraph,
}

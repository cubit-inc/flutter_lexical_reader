part of '../parser.dart';

List<Widget> parseJsonChildrenWidget(
    List<dynamic> children, BuildContext context,
    {BuildContext? globalContext}) {
  return children.map<Widget>(
    (child) {
      switch (child['type']) {
        case 'heading':
          LineType lineType = LineType.h2;
          switch (child['tag']) {
            case 'h1':
              lineType = LineType.h1;
              break;
            case 'h2':
              lineType = LineType.h2;
              break;
            case 'h3':
              lineType = LineType.h3;
              break;
            case 'h4':
              lineType = LineType.h4;
              break;
            case 'h5':
              lineType = LineType.h5;
              break;
            case 'h6':
              lineType = LineType.h6;
              break;
          }
          return _ParseParagraph(
            child: child,
            lineType: lineType,
          );
        case 'paragraph':
          return _ParseParagraph(child: child);
        case 'upload':
          String? type = child?["value"]?["mimeType"];

          if (type?.startsWith("video") == true) {
            return ParseVideo(child: child);
          } else {
            return _ParseImage(child, context, globalContext);
          }
        case 'quote':
          return _ParseParagraph(child: child);
        case 'horizontalrule':
          return const _ParseHorizontalLine();
        case 'table':
          return ParseTable(child: child);
        case 'list':
          return _ParseList(child: child);
        case 'listitem':
          if (child['children'] != null) {
            List<dynamic> itemChildren = child['children'] as List<dynamic>;
            bool hasNestedList = itemChildren
                .any((childElement) => childElement['type'] == 'list');
            if (hasNestedList) {
              return _ParseNestedListItem(child: child);
            }
          }
          return _ParseParagraph(child: child);
        default:
          return const SizedBox.shrink();
      }
    },
  ).toList();
}

List<InlineSpan> parseJsonChild(List<dynamic> children, BuildContext context) {
  final List<InlineSpan> widgets = [];
  final props = _PropsInheritedWidget.of(context)!;

  for (var child in children) {
    switch (child['type']) {
      case 'text':
        widgets.add(_parseText(
          child,
          props.paragraphStyle ?? const TextStyle(),
          props.useMyTextStyle,
        ));
        break;
      case 'link':
        widgets.add(_parseLink(child, props.paragraphStyle ?? const TextStyle(),
            props.useMyTextStyle, context));
        break;
      case 'image':
      case 'upload':
        widgets.add(_parseImage(child, context));
        break;
      case 'equation':
        widgets.add(_parseEquation(child, options: props.mathEquationOptions));
        break;
      default:
        widgets.add(const WidgetSpan(child: SizedBox.shrink()));
        break;
    }
  }
  return widgets;
}

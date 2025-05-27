part of '../parser.dart';

class _ParseNestedListItem extends StatelessWidget {
  final Map<String, dynamic> child;

  const _ParseNestedListItem({required this.child});

  @override
  Widget build(BuildContext context) {
    // Get the direct children of the list item
    final List<dynamic> itemChildren = child['children'] as List<dynamic>;

    // Check if there's a nested list
    bool hasNestedList = itemChildren.any((c) => c['type'] == 'list');

    if (hasNestedList) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: parseJsonChildrenWidget(itemChildren, context),
        ),
      );
    } else {
      // For regular list items, render the text content
      return RichText(
        text: TextSpan(
          children: parseJsonChild(itemChildren, context),
        ),
      );
    }
  }
}

class _ParseList extends StatelessWidget {
  final Map<String, dynamic> child;

  const _ParseList({required this.child});

  @override
  Widget build(BuildContext context) {
    final props = _PropsInheritedWidget.of(context)!;
    final bool isBulletList = child['listType'] == 'bullet';
    final children = child['children'] as List<dynamic>;
    final paragraphPadding =
        props.paragraphPadding ?? const EdgeInsets.symmetric(vertical: 8.0);

    return Padding(
      padding: paragraphPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          // Check if this item contains a nested list
          final List<dynamic> itemChildren = item['children'] as List<dynamic>;
          final bool hasNestedList =
              itemChildren.any((c) => c['type'] == 'list');

          // Get the text style from the first text child if it exists
          TextStyle? itemTextStyle;
          if (itemChildren.isNotEmpty && itemChildren[0]['type'] == 'text') {
            final textChild = itemChildren[0];
            itemTextStyle = _textStyle(
              textChild['format'],
              props.paragraphStyle ?? const TextStyle(),
              props.useMyTextStyle,
            ).copyWith(fontFamily: props.fontFamily);
          } else {
            itemTextStyle = (props.paragraphStyle ?? const TextStyle())
                .copyWith(fontFamily: props.fontFamily);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (!hasNestedList) ...[
                  SizedBox(
                    width: 24,
                    child: Baseline(
                      baseline: itemTextStyle!.fontSize ?? 16.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        isBulletList ? '•' : '${index + 1}.',
                        style: itemTextStyle,
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: Baseline(
                    baseline: itemTextStyle!.fontSize ?? 16.0,
                    baselineType: TextBaseline.alphabetic,
                    child: _ParseNestedListItem(child: item),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

part of '../parser.dart';

class _ParseNumberedList extends StatelessWidget {
  const _ParseNumberedList({
    required this.child,
  });
  final Map<String, dynamic> child;

  @override
  Widget build(BuildContext context) {
    final paragraphStyle = _PropsInheritedWidget.of(context)!.paragraphStyle;
    final fontFamily = _PropsInheritedWidget.of(context)!.fontFamily;
    final numberedPadding =
        _PropsInheritedWidget.of(context)?.numberedPadding ??
            const EdgeInsets.only(left: 0.0, bottom: 0);
    List<Widget> childrenWidgets =
        parseJsonChildrenWidget(child['children'] ?? [], context);

    if (child['listType'] == 'number') {
      int count = 1;
      return Padding(
        padding: numberedPadding,
        child: Column(
          children: childrenWidgets.map((widget) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${count++}. ',
                    style: paragraphStyle?.copyWith(fontFamily: fontFamily),
                  ),
                ),
                Expanded(child: widget),
              ],
            );
          }).toList(),
        ),
      );
    } else {
      return Padding(
        padding: numberedPadding,
        child: Column(
          children: childrenWidgets.map((widget) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '• ',
                    style: paragraphStyle?.copyWith(fontFamily: fontFamily),
                  ),
                ),
                Expanded(child: widget),
              ],
            );
          }).toList(),
        ),
      );
    }
  }
}

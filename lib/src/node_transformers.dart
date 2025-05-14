part of 'parser.dart';

class Transformer {
  final String type;
  final Widget Function(Map<String, dynamic> childElement, BuildContext context)
      transformerWidget;

  final bool isInline;

  Transformer(
      {required this.type,
      required this.transformerWidget,
      this.isInline = false});
}

class NodeTransformers {
  final List<Transformer> transformers;

  NodeTransformers({required this.transformers});
}

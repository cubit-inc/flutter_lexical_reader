part of '../parser.dart';

WidgetSpan _parseEquation(
  Map<String, dynamic> child, {
  required MathEquationOptions options,
}) {
  // final parts = Math.tex(
  //   child['equation'],
  //   options: options.mathOptions,
  //   settings: options.textParserSettings,
  //   textStyle: options.textStyle,
  //   textScaleFactor: options.textScaleFactor,
  // ).texBreak();

  // for (var element in parts.penalties) {
  //   print('penalties $element');
  // }

  // for (var element in parts.parts) {
  //   print('parts ${element.toStringDeep()}');
  // }

  // final widget = Wrap(
  //   crossAxisAlignment: WrapCrossAlignment.center,
  //   children: parts.parts,
  // );

  // return WidgetSpan(
  //   alignment: PlaceholderAlignment.middle,
  //   child: widget,
  // );

  // return TextSpan(
  //     children: List.generate(
  //   parts.parts.length,
  //   (index) => WidgetSpan(
  //     alignment: PlaceholderAlignment.middle,
  //     child: parts.parts[index],
  //   ),
  // ));

  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Padding(
        padding: options.padding ?? const EdgeInsets.all(0),
        child: FadingEdgeScrollView.fromSingleChildScrollView(
          gradientFractionOnStart: 0.3,
          gradientFractionOnEnd: 0.3,
          shouldDisposeScrollController: true,
          gradientColor: Colors.red,
          child: SingleChildScrollView(
            controller: ScrollController(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              child['equation'],
              options: options.mathOptions,
              settings: options.textParserSettings,
              textStyle: options.textStyle,
              textScaleFactor: options.textScaleFactor,
            ),
          ),
        )),
  );
}

class FadingEdgeScrollView extends StatefulWidget {
  /// child widget
  final Widget child;

  /// scroll controller of child widget
  ///
  /// Look for more documentation at [ScrollView.scrollController]
  final ScrollController scrollController;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// Look for more documentation at [ScrollView.reverse]
  final bool reverse;

  /// The axis along which child view scrolls
  ///
  /// Look for more documentation at [ScrollView.scrollDirection]
  final Axis scrollDirection;

  /// what part of screen on start half should be covered by fading edge gradient
  /// [gradientFractionOnStart] must be 0 <= [gradientFractionOnStart] <= 1
  /// 0 means no gradient,
  /// 1 means gradients on start half of widget fully covers it
  final double gradientFractionOnStart;

  /// what part of screen on end half should be covered by fading edge gradient
  /// [gradientFractionOnEnd] must be 0 <= [gradientFractionOnEnd] <= 1
  /// 0 means no gradient,
  /// 1 means gradients on start half of widget fully covers it
  final double gradientFractionOnEnd;

  /// set to true if you want scrollController passed to widget to be disposed when widget's state is disposed
  final bool shouldDisposeScrollController;

  /// The color the gradient will fade to at the start and end of the scroll view.
  /// Defaults to white.
  final Color gradientColor;

  const FadingEdgeScrollView._internal(
      {Key? key,
      required this.child,
      required this.scrollController,
      required this.reverse,
      required this.scrollDirection,
      required this.gradientFractionOnStart,
      required this.gradientFractionOnEnd,
      required this.shouldDisposeScrollController,
      this.gradientColor = Colors.white})
      : assert(gradientFractionOnStart >= 0 && gradientFractionOnStart <= 1),
        assert(gradientFractionOnEnd >= 0 && gradientFractionOnEnd <= 1),
        super(key: key);

  /// Constructor for creating [FadingEdgeScrollView] with [ScrollView] as child
  /// child must have [ScrollView.controller] set
  factory FadingEdgeScrollView.fromScrollView(
      {Key? key,
      required ScrollView child,
      double gradientFractionOnStart = 0.1,
      double gradientFractionOnEnd = 0.1,
      bool shouldDisposeScrollController = false,
      Color gradientColor = Colors.white}) {
    final controller = child.controller;
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: child.scrollDirection,
      reverse: child.reverse,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      shouldDisposeScrollController: shouldDisposeScrollController,
      gradientColor: gradientColor,
      child: child,
    );
  }

  /// Constructor for creating [FadingEdgeScrollView] with [SingleChildScrollView] as child
  /// child must have [SingleChildScrollView.controller] set
  factory FadingEdgeScrollView.fromSingleChildScrollView(
      {Key? key,
      required SingleChildScrollView child,
      double gradientFractionOnStart = 0.1,
      double gradientFractionOnEnd = 0.1,
      bool shouldDisposeScrollController = false,
      Color gradientColor = Colors.white}) {
    final controller = child.controller;
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: child.scrollDirection,
      reverse: child.reverse,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      shouldDisposeScrollController: shouldDisposeScrollController,
      gradientColor: gradientColor,
      child: child,
    );
  }

  /// Constructor for creating [FadingEdgeScrollView] with [PageView] as child
  /// child must have [PageView.controller] set
  factory FadingEdgeScrollView.fromPageView(
      {Key? key,
      required PageView child,
      double gradientFractionOnStart = 0.1,
      double gradientFractionOnEnd = 0.1,
      bool shouldDisposeScrollController = false,
      Color gradientColor = Colors.white}) {
    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: child.controller,
      scrollDirection: child.scrollDirection,
      reverse: child.reverse,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      shouldDisposeScrollController: shouldDisposeScrollController,
      gradientColor: gradientColor,
      child: child,
    );
  }

  /// Constructor for creating [FadingEdgeScrollView] with [AnimatedList] as child
  /// child must have [AnimatedList.controller] set
  factory FadingEdgeScrollView.fromAnimatedList(
      {Key? key,
      required AnimatedList child,
      double gradientFractionOnStart = 0.1,
      double gradientFractionOnEnd = 0.1,
      bool shouldDisposeScrollController = false,
      Color gradientColor = Colors.white}) {
    final controller = child.controller;
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: child.scrollDirection,
      reverse: child.reverse,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      shouldDisposeScrollController: shouldDisposeScrollController,
      gradientColor: gradientColor,
      child: child,
    );
  }

  /// Constructor for creating [FadingEdgeScrollView] with [ScrollView] as child
  /// child must have [ScrollView.controller] set
  factory FadingEdgeScrollView.fromListWheelScrollView(
      {Key? key,
      required ListWheelScrollView child,
      double gradientFractionOnStart = 0.1,
      double gradientFractionOnEnd = 0.1,
      bool shouldDisposeScrollController = false,
      Color gradientColor = Colors.white}) {
    final controller = child.controller;
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: Axis.vertical,
      reverse: false,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      shouldDisposeScrollController: shouldDisposeScrollController,
      gradientColor: gradientColor,
      child: child,
    );
  }

  @override
  _FadingEdgeScrollViewState createState() => _FadingEdgeScrollViewState();
}

class _FadingEdgeScrollViewState extends State<FadingEdgeScrollView>
    with WidgetsBindingObserver {
  late ScrollController _controller;
  ScrollState _scrollState = ScrollState.NOT_SCROLLABLE;
  int lastScrollViewListLength = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController;
    _controller.addListener(_shallGradientBeShown);

    WidgetsBinding.instance.addObserver(this);
  }

  bool get _controllerIsReady =>
      _controller.hasClients && _controller.positions.last.hasContentDimensions;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _controller.removeListener(_shallGradientBeShown);
    if (widget.shouldDisposeScrollController) {
      _controller.dispose();
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Add the shading or remove it when the screen resize (web/desktop) or mobile is rotated
    _shallGradientBeShown();
  }

  @override
  Widget build(BuildContext context) => ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: _gradientStart,
          end: _gradientEnd,
          stops: [
            0,
            widget.gradientFractionOnStart * 0.5,
            1 - widget.gradientFractionOnEnd * 0.5,
            1,
          ],
          colors: _getColors(
              widget.gradientFractionOnStart > 0 &&
                  _scrollState.isShowGradientAtStart,
              widget.gradientFractionOnEnd > 0 &&
                  _scrollState.isShowGradientAtEnd),
        ).createShader(
          bounds.shift(Offset(-bounds.left, -bounds.top)),
          textDirection: Directionality.of(context),
        ),
        blendMode: BlendMode.dstIn,
        // Catching ScrollMetricsNotifications from the Scrollable child.
        // This way we get notified if the size of the underlying list chnages.
        // We then re-evaluate if Gradient should be shown.
        child: NotificationListener<ScrollMetricsNotification>(
          child: widget.child,
          onNotification: (_) {
            _shallGradientBeShown();
            // Enable notification to still bubble up.
            return false;
          },
        ),
      );

  AlignmentGeometry get _gradientStart =>
      widget.scrollDirection == Axis.vertical
          ? _verticalStart
          : _horizontalStart;

  AlignmentGeometry get _gradientEnd =>
      widget.scrollDirection == Axis.vertical ? _verticalEnd : _horizontalEnd;

  Alignment get _verticalStart =>
      widget.reverse ? Alignment.bottomCenter : Alignment.topCenter;

  Alignment get _verticalEnd =>
      widget.reverse ? Alignment.topCenter : Alignment.bottomCenter;

  AlignmentDirectional get _horizontalStart => widget.reverse
      ? AlignmentDirectional.centerEnd
      : AlignmentDirectional.centerStart;

  AlignmentDirectional get _horizontalEnd => widget.reverse
      ? AlignmentDirectional.centerStart
      : AlignmentDirectional.centerEnd;

  List<Color> _getColors(bool showGradientAtStart, bool showGradientAtEnd) => [
        (showGradientAtStart ? Colors.transparent : widget.gradientColor),
        widget.gradientColor,
        widget.gradientColor,
        (showGradientAtEnd ? Colors.transparent : widget.gradientColor)
      ];

  void _shallGradientBeShown() {
    if (!_controllerIsReady) {
      return;
    }

    final offset = _controller.positions.last.pixels;
    final minOffset = _controller.positions.last.minScrollExtent;
    final maxOffset = _controller.positions.last.maxScrollExtent;

    final isScrolledToEnd = offset >= maxOffset;
    final isScrolledToStart = offset <= minOffset;

    final scrollState = switch ((isScrolledToStart, isScrolledToEnd)) {
      (true, true) => ScrollState.NOT_SCROLLABLE,
      (true, false) => ScrollState.SCROLLABLE_AT_START,
      (false, true) => ScrollState.SCROLLABLE_AT_END,
      (false, false) => ScrollState.SCROLLABLE_IN_THE_MIDDLE
    };

    if (_scrollState != scrollState) {
      setState(() {
        _scrollState = scrollState;
      });
    }
  }
}

enum ScrollState {
  NOT_SCROLLABLE,
  SCROLLABLE_AT_START,
  SCROLLABLE_AT_END,
  SCROLLABLE_IN_THE_MIDDLE
}

extension ShowGradient on ScrollState {
  bool get isShowGradientAtStart =>
      this == ScrollState.SCROLLABLE_AT_END ||
      this == ScrollState.SCROLLABLE_IN_THE_MIDDLE;

  bool get isShowGradientAtEnd =>
      this == ScrollState.SCROLLABLE_AT_START ||
      this == ScrollState.SCROLLABLE_IN_THE_MIDDLE;
}

///
///@author xiaozhizhong
///@date 2020/4/17
///@description Expandable widget
///
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:expandable_widget/res/expand_arrow.dart';

enum _ExpandMode { ShowHide, MaxHeight }

typedef ArrowBuilder = Widget Function(bool expand);

class ExpandableWidget extends StatefulWidget {
  /// Color of the default arrow widget.
  final Color arrowColor;

  /// Size of the default arrow widget. Default is 24.
  final double arrowSize;

  /// Custom arrow widget builder, will using [ExpandArrow] if this is null.
  final ArrowBuilder arrowWidgetBuilder;

  /// If you use [arrowWidgetBuilder], you should provide the height of arrow widget manually
  final double arrowWidgetHeight;

  /// How long the expanding animation takes. Default is 150ms.
  final Duration animationDuration;

  /// Child
  final Widget child;

  ///Max Height of widget that will show by default. Default is 100
  final double maxHeight;

  ///Expand mode, {showHide} or {maxHeight}
  final _ExpandMode _mode;

  ///Show and hide.
  ///Using this constructor if you want to hide child completely by default.
  const ExpandableWidget.showHide({
    Key key,
    this.arrowColor,
    this.arrowSize = 24,
    this.arrowWidgetBuilder,
    this.arrowWidgetHeight,
    this.animationDuration = const Duration(milliseconds: 150),
    @required this.child,
  })  : maxHeight = 0,
        _mode = _ExpandMode.ShowHide,
        super(key: key);

  ///Set up max height.
  ///Using this constructor if you want to show a max-height child by default.
  ///If the child's height < [maxHeight], then will show child directly
  const ExpandableWidget.maxHeight(
      {Key key,
      this.arrowColor,
      this.arrowSize = 24,
      this.arrowWidgetBuilder,
      this.arrowWidgetHeight,
      this.animationDuration = const Duration(milliseconds: 300),
      @required this.child,
      this.maxHeight = 100.0})
      : _mode = _ExpandMode.MaxHeight,
        super(key: key);

  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  /// Expand status
  bool _isExpanded = false;

  /// The height of arrow
  double _arrowHeight;

  /// Whether is show hide Mode or max height mode.
  bool _isShowHideMode;

  @override
  void initState() {
    super.initState();
    if (widget.arrowWidgetBuilder != null && widget.arrowWidgetHeight == null) {
      throw FlutterError("Should provide the height of arrowWidget");
    }
    _arrowHeight = widget.arrowWidgetHeight ?? 48;
    _isShowHideMode = widget._mode == _ExpandMode.ShowHide;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: widget.animationDuration,
      reverseDuration: widget.animationDuration,
      alignment: Alignment.bottomCenter,
      vsync: this,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: !_isExpanded
                ? widget.maxHeight + _arrowHeight
                : double.infinity),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LimitedBox(
              maxHeight: !_isExpanded ? widget.maxHeight : double.infinity,
              child: widget.child,
            ),
            Flexible(child: LayoutBuilder(
              builder: (_, size) {
                final height = size.biggest.height;
                return _isShowHideMode ||
                        height <= _arrowHeight ||
                        height.isInfinite
                    ? SizedBox(
                          width: double.infinity,
                          child: widget.arrowWidgetBuilder != null
                              ? GestureDetector(
                                  behavior: HitTestBehavior.deferToChild,
                                  onTap: _onTap,
                                  child: widget.arrowWidgetBuilder(_isExpanded),
                                )
                              : ExpandArrow(
                                  onPressed: (_) => _onTap(),
                                  size: widget.arrowSize,
                                  color: widget.arrowColor,
                                  isExpanded: _isExpanded,
                                ),
                        )
                    : SizedBox();
              },
            )),
          ],
        ),
      ),
    );
  }

  /// User clicks the arrow
  void _onTap() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

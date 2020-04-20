///
///@author xiaozhizhong
///@date 2020/4/17
///@description
///
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum _ExpandMode { ShowHide, MaxHeight }

class ExpandWidget extends StatefulWidget {
  /// Color of the default arrow widget.
  final Color arrowColor;

  /// Size of the default arrow widget. Default is 30.
  final double arrowSize;

  /// Custom arrow widget, will using [ExpandIcon] if this is null.
  final Widget arrowWidget;

  /// How long the expanding animation takes. Default is 300ms.
  final Duration animationDuration;

  /// Child
  final Widget child;

  ///Max Height of widget that will show by default. Default is 100
  final maxHeight;

  ///Whether to keep this widget alive or not, if you use this widget in scroll view, it should be true
  ///to avoid scroll problems
  final bool keepAlive;

  ///Expand mode, {showHide} or {maxHeight}
  final _ExpandMode _mode;

  ///Show and hide.
  ///Using this constructor if you want to hide child completely by default.
  const ExpandWidget.showHide(
      {Key key,
      this.arrowColor,
      this.arrowSize = 30,
      this.arrowWidget,
      this.animationDuration = const Duration(milliseconds: 300),
      @required this.child,
      this.keepAlive = false})
      : maxHeight = null,
        _mode = _ExpandMode.ShowHide,
        super(key: key);

  ///Set up max height.
  ///Using this constructor if you want to show a max-height child by default.
  ///If the child's height < [maxHeight], then will show child directly
  const ExpandWidget.maxHeight(
      {Key key,
      this.arrowColor,
      this.arrowSize = 30,
      this.arrowWidget,
      this.animationDuration = const Duration(milliseconds: 300),
      @required this.child,
      this.maxHeight = 100,
      this.keepAlive = false})
      : _mode = _ExpandMode.MaxHeight,
        super(key: key);

  @override
  _ExpandWidgetState createState() => _ExpandWidgetState();
}

class _ExpandWidgetState extends State<ExpandWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  /// animation controller
  AnimationController _controller;

  /// Animations for height control
  Animation<double> _heightFactor;

  /// Expand status
  bool _isExpanded = false;

  ///Whether enable expandable mode or not, will show child directly if not
  bool _enableExpand;

  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    //Calculating the height of child, and then decide to enable expand or not.
    if (widget._mode == _ExpandMode.MaxHeight) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_enableExpand != null) return;
        final RenderBox box = _key.currentContext?.findRenderObject();
        if (box == null) return;
        final height = box.size.height;
        if (height > widget.maxHeight) {
          setState(() {
            _enableExpand = true;
            _heightFactor = Tween(begin: widget.maxHeight / height, end: 1.0)
                .animate(_controller);
          });
        } else {
          _enableExpand = false;
        }
      });
    } else {
      _enableExpand = true;
      _heightFactor = Tween(begin: 0.0, end: 1.0).animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChild,
      child: widget.child,
    );
  }

  ///build child
  Widget _buildChild(BuildContext context, Widget child) {
    return Column(
      children: <Widget>[
        ClipRect(
          child: Align(
            key: _key,
            alignment: Alignment.topCenter,
            heightFactor: _enableExpand == null || !_enableExpand
                ? 1
                : _heightFactor.value,
            child: child,
          ),
        ),
        Offstage(
            offstage: _enableExpand == null || !_enableExpand,
            child: widget.arrowWidget != null
                ? GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: _onTap,
              child: widget.arrowWidget,
            )
                : ExpandIcon(
              onPressed: (_)=>_onTap(),
              size: widget.arrowSize,
              color: widget.arrowColor,
              isExpanded: _isExpanded,
            )
        ),
      ],
    );
  }


  /// User clicks the arrow
  void _onTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

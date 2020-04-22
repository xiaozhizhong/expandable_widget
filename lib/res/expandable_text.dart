import 'package:expandable_widget/expandable.dart';
import 'package:flutter/material.dart';

///
///@author xiaozhizhong
///@date 2020/4/20
///@description Expandable widget
///

enum _ExpandMode { Manual, ShowHide, Lines }

class ExpandableText extends StatefulWidget {
  ///Manual control
  ///Show and hide text completely
  ExpandableText.manual(this.text,
      {@required this.expand,
      @required this.vsync,
      this.animationDuration = const Duration(milliseconds: 150),
      this.textStyle,
      this.strutStyle,
      this.textAlign = TextAlign.start,
      this.textDirection = TextDirection.ltr,
      this.locale,
      this.textScaleFactor = 1,
      this.textWidthBasis = TextWidthBasis.parent,
      this.alignment = Alignment.topCenter,
      Key key})
      : lines = null,
        arrowColor = null,
        arrowSize = null,
        arrowWidgetBuilder = null,
        expandMode = _ExpandMode.Manual,
        super(key: key);

  ///Auto control
  ///Show and hide text completely.
  ///With a arrow at the bottom.
  ExpandableText.showHide(this.text,
      {this.arrowColor,
      this.arrowSize = 24,
      this.arrowWidgetBuilder,
      this.animationDuration = const Duration(milliseconds: 150),
      this.textStyle,
      this.strutStyle,
      this.textAlign = TextAlign.start,
      this.textDirection = TextDirection.ltr,
      this.locale,
      this.textScaleFactor = 1,
      this.textWidthBasis = TextWidthBasis.parent,
      this.expand = false,
      this.alignment = Alignment.topCenter,
      Key key})
      : lines = null,
        vsync = null,
        expandMode = _ExpandMode.ShowHide,
        super(key: key);

  ///Auto control
  ///Collapse text to max lines.
  ///If the text's line < [maxLines], then will show text directly
  ExpandableText.lines(this.text,
      {@required this.lines,
      this.arrowColor,
      this.arrowSize = 24,
      this.arrowWidgetBuilder,
      this.animationDuration = const Duration(milliseconds: 150),
      this.textStyle,
      this.strutStyle,
      this.textAlign = TextAlign.start,
      this.textDirection = TextDirection.ltr,
      this.locale,
      this.textScaleFactor = 1,
      this.textWidthBasis = TextWidthBasis.parent,
      this.expand = false,
      this.alignment = Alignment.topCenter,
      Key key})
      : vsync = null,
        expandMode = _ExpandMode.Lines,
        super(key: key);

  /// Color of the default arrow widget.
  final Color arrowColor;

  /// Size of the default arrow widget. Default is 24.
  final double arrowSize;

  /// Custom arrow widget builder, will using [ExpandArrow] if this is null.
  final ArrowBuilder arrowWidgetBuilder;

  /// How long the expanding animation takes. Default is 150ms.
  final Duration animationDuration;

  /// Set up collapse lines when show text in collapse mode
  final int lines;

  /// Text, should not be null
  final String text;

  /// Style of text
  final TextStyle textStyle;

  ///In manual mode, it control the expand status
  ///In auto mode(showHide\lines), it decide Whether expand at the beginning or not, Default is false
  final bool expand;

  /// Control the animation position
  final Alignment alignment;

  /// vsync provider for manual mode
  final TickerProvider vsync;

  /// Other text parameters, see[Text]
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final double textScaleFactor;
  final TextWidthBasis textWidthBasis;

  final expandMode;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with SingleTickerProviderStateMixin {
  bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.expand;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, size) {
          final painter = TextPainter(
              text: TextSpan(text: widget.text, style: widget.textStyle),
              maxLines: widget.lines,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              locale: widget.locale,
              textScaleFactor: widget.textScaleFactor,
              textWidthBasis: widget.textWidthBasis);
          painter.layout(maxWidth: size.maxWidth);
          if (!painter.didExceedMaxLines &&
              widget.expandMode == _ExpandMode.Lines)
            return _buildText();
          else
            return AnimatedSize(
                duration: widget.animationDuration,
                reverseDuration: widget.animationDuration,
                vsync: this,
                alignment: Alignment.topCenter,
                child: widget.expandMode == _ExpandMode.Manual
                    ? _buildManual()
                    : _buildAuto());
        },
      ),
    );
  }

  /// build manual
  _buildManual() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: double.infinity),
      child: !widget.expand
          ? SizedBox(
              width: double.infinity,
              height: 0,
            )
          : _buildText(),
    );
  }

  /// build auto
  _buildAuto() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.expandMode == _ExpandMode.ShowHide && !_isExpanded
            ? SizedBox()
            : _buildText(maxLines: _isExpanded ? null : widget.lines),
        SizedBox(
          width: double.infinity,
          child: widget.arrowWidgetBuilder != null
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
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
      ],
    );
  }

  ///build text with given max lines limit
  Text _buildText({int maxLines}) {
    return Text(widget.text,
        maxLines: maxLines,
        style: widget.textStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        textScaleFactor: widget.textScaleFactor,
        textWidthBasis: widget.textWidthBasis);
  }

  /// User clicks the arrow
  void _onTap() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

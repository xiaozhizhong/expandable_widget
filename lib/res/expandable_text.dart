import 'package:expandable_widget/expandable.dart';
import 'package:flutter/material.dart';

///
///@author xiaozhizhong
///@date 2020/4/20
///@description Expandable widget
///

enum _ExpandMode { ShowHide, Lines }

class ExpandableText extends StatefulWidget {
  ///Show and hide.
  ///Using this constructor if you want to hide text completely by default.
  ExpandableText.showHide(
    this.text, {
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
  })  : lines = null,
        expandMode = _ExpandMode.ShowHide;

  ///Set up collapse lines.
  ///Using this constructor if you want to show a max-lines text by default.
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
      this.textWidthBasis = TextWidthBasis.parent})
      : expandMode = _ExpandMode.Lines;

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
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
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
              widget.expandMode != _ExpandMode.ShowHide)
            return _buildText();
          else
            return AnimatedSize(
                duration: widget.animationDuration,
                vsync: this,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    widget.expandMode == _ExpandMode.ShowHide && !_isExpanded
                        ? SizedBox()
                        : Text(widget.text,
                            maxLines: _isExpanded ? null : widget.lines,
                            style: widget.textStyle,
                            textAlign: widget.textAlign,
                            textDirection: widget.textDirection,
                            locale: widget.locale,
                            textScaleFactor: widget.textScaleFactor,
                            textWidthBasis: widget.textWidthBasis),
                    SizedBox(
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
                  ],
                ));
        },
      ),
    );
  }

  Text _buildText() {
    return Text(widget.text,
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

# expandable_widget

<a href="https://pub.dev/packages/expandable_widget">
  <img src="https://img.shields.io/pub/v/expandable_widget.svg"/>
</a>

[中文文档](README_CH.md)

![Preview](example/preview/preview.gif)

## Intro

A Flutter package provides expandable widget and text.

## Special Features
* Specify max height/lines that shows at the beginning.
* Custom arrow widget.

## Usage

### ExpandableWidget
* **ExpandableWidget.showHide**
Show and hide widget.
Use this if you want to hide child completely at the beginning.
``` dart
ExpandableWidget.showHide(
        child: Container(
              color: Colors.blue,
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: Text("show hide"),
            )),
```
*In this case, will only show an expand arrow at the beginning. When clicked the expand arrow, child expanded and showed.*

* **ExpandableWidget.maxHeight**

    Use this if you want to show a max-height child at the beginning.
If the child's height < maxHeight, then will show child directly
``` dart 
ExpandableWidget.maxHeight(
    maxHeight: 50,
    child: Container(
                color: Colors.blue,
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: Text("max height"),
              ),
              arrowWidgetHeight: 40,
              arrowWidgetBuilder: (expanded) => _buildArrow(expanded),
            )
```
In this case, will show a 50-height box and an expand arrow at the beginning. When clicked the expand arrow, box expanded to it full height(100).
Note: If you specified a custom arrow widget, you should also provide the height of your arrow widget.

### ExpandableText

* **ExpandableText.showHide**

    Use this if you want to hide text completely at the beginning.
``` dart
    ExpandableText.showHide(
              "your text to show...",
            )
```
In this case, will only show an expand arrow at the beginning. When clicked the expand arrow, text expanded and showed.

* **ExpandableText.lines**

    Use this if you want to show a max-lines text at the beginning.
If the text's lines < maxLines, then will show text directly.
``` dart
ExpandableText.lines(
              _text,
              lines: 4,
              arrowWidgetBuilder: (expanded) => _buildArrow(expanded),
            )
```
In this case, will show a 4 lines text and an expand arrow at the beginning. When clicked the expand arrow, text expanded to it full lines.

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
* Specify default expand status.
* Manual or auto control the expand status.

## Usage

### ExpandableWidget

* **ExpandableWidget.manual**
Manual control.
Show and hide child completely.
``` dart 
ExpandableWidget.manual(
                expand: _showManual,
                vsync: this,
                child: Container(
                  color: Colors.blue,
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  child: Text("show hide"),
                ))
```

* **ExpandableWidget.showHide**
Auto control, with an arrow widget at the bottom.
Show and hide child completely.
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
Auto control, with an arrow widget at the bottom.
Collapse child to max-height.
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

* **ExpandableText.manual**
Manual control.
Show and hide text completely.
``` dart
ExpandableText.manual(
              _text,
              vsync: this,
              expand: _showManual,
            ),
```

* **ExpandableText.showHide**
Auto control, with an arrow widget at the bottom.
Show and hide text completely.
``` dart
    ExpandableText.showHide(
              "your text to show...",
            )
```
In this case, will only show an expand arrow at the beginning. When clicked the expand arrow, text expanded and showed.

* **ExpandableText.lines**
Auto control, with an arrow widget at the bottom.
Collapse child to max-lines.
If the text's lines < maxLines, then will show text directly.
``` dart
ExpandableText.lines(
              _text,
              lines: 4,
              arrowWidgetBuilder: (expanded) => _buildArrow(expanded),
            )
```
In this case, will show a 4 lines text and an expand arrow at the beginning. When clicked the expand arrow, text expanded to it full lines.

## Breaking Changes

- add expand param

    From 1.0.3, you can specify default expand status by passing `expand` value.

- add manual constructor

    Form 1.0.4, you can control the expand status by using manual constructor and control it by `expand` value.

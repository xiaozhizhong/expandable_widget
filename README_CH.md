# expandable_widget

<a href="https://pub.dev/packages/expandable_widget">
  <img src="https://img.shields.io/pub/v/expandable_widget.svg"/>
</a>

![Preview](example/preview/preview.gif)

## 简介

可展开/收缩的Flutter控件

## 特性
* 可自定义初始展示时的最大高度/行数
* 可自定义展开箭头
* 指导初始时的伸缩状态

## 用法

### ExpandableWidget
* **ExpandableWidget.showHide**

    显示/隐藏控件
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
*在这个例子中，开始时只显示一个展开箭头。点击箭头后，控件会展开并完全显示。*

* **ExpandableWidget.maxHeight**

    设置初始显示的最大高度。
    如果控件实际高度小于这个最大高度，将直接显示控件。
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
在这个例子中，开始时将显示一个50高度的方块以及一个自定义展开按钮。当点击展开后，控件完全展开高度（100）。
注意：如果设置自定义展开按钮，还需提供此按钮的高度。

### ExpandableText

* **ExpandableText.showHide**

    显示/隐藏文字
``` dart
    ExpandableText.showHide(
              "your text to show...",
            )
```
在这个例子中，初始时只会显示一个展开箭头。当点击箭头后，文字完全展开显示。

* **ExpandableText.lines**

    设置初始显示的最大行数。
    当文字实际行数小于最大行数时，将直接显示文字。
```dart
ExpandableText.lines(
              _text,
              lines: 4,
              arrowWidgetBuilder: (expanded) => _buildArrow(expanded),
            )
```
在这个例子中，初始会显示一个4行的文字以及一个展开箭头。点击箭头后，文字完全展开显示。

## 重要更新

- 添加expand参数

    从1.0.3开始，可以通过传入`expand`参赛指定初始时的伸缩状态。
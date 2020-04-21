import 'package:expandable_widget/expandable.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _text =
      '''Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.
  Paint your app to life in milliseconds with Stateful Hot Reload. Use a rich set of fully-customizable widgets to build native interfaces in minutes.
  Quickly ship features with a focus on native end-user experiences. Layered architecture allows for full customization, which results in incredibly fast rendering and expressive and flexible designs.''';

  final _arrowHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text("---- expandable widget(showHide) ----"),
            ),
            ExpandableWidget.showHide(
                child: Container(
              color: Colors.blue,
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: Text("show hide"),
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text("---- expandable widget(maxHeight) ----"),
            ),
            ExpandableWidget.maxHeight(
              maxHeight: 50,
              child: Container(
                color: Colors.blue,
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: Text("max height"),
              ),
              arrowWidgetHeight: _arrowHeight,
              arrowWidgetBuilder: (expanded) => _buildArrow(expanded),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text("---- expandable text(showHide) ----"),
            ),
            ExpandableText.showHide(
              _text,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text("---- expandable text(lines) ----"),
            ),
            ExpandableText.lines(
              _text,
              lines: 4,
              arrowWidgetBuilder: (expanded) => _buildArrow(expanded),
            ),
          ],
        ),
      ),
    );
  }

  _buildArrow(bool expanded) {
    return Container(
      height: _arrowHeight,
      alignment: Alignment.center,
      child: Text(
        expanded ? "hide" : "show",
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'dart:ui' show window;

void main() {
  debugPaintSizeEnabled = false;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: LayoutBuilder(
          builder: _build,
        )
    );
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    print([constraints.maxWidth, constraints.maxHeight]);
    return Scaffold(
          appBar: AppBar(
            title: Text('بذریعہ وڈیو رہنمائی'),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  child: RotatedBox(
                child: MyTable(),
                quarterTurns: 2,
              )),
              Expanded(child: MyTable()),
            ],
          ));
  }
}

class MyTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyTableState();
}

class MyTableState extends State<MyTable> {
  final List<String> _allLetters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  final int _size = 4;
  var _currentIndex = 0;
  List<String> _shuffledLetters = [];
  List<String> _letters;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _allLetters.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _allLetters.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
    }
    print(_shuffledLetters);
    _letters = _shuffledLetters.sublist(0, _size * _size);
  }

  Widget _buildItem(int index, String text) {
    return MyButton(
        key: ValueKey<int>(index),
        text: text,
        onPress: () {
          if (text == _allLetters[_currentIndex]) {
            setState(() {
              _letters[index] =
                  _size * _size + _currentIndex < _allLetters.length
                      ? _shuffledLetters[_size * _size + _currentIndex]
                      : "";
              _currentIndex++;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    List<TableRow> rows = List<TableRow>();
    var j = 0;
    for (var i = 0; i < _size; ++i) {
      List<Widget> cells = _letters
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j++, e))
          .toList();
      rows.add(TableRow(children: cells));
    }
    return Table(children: rows);
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress}) : super(key: key);

  final String text;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return TableCell(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ScaleTransition(
                scale: animation,
                child: RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding: EdgeInsets.all(8.0),
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Text(_displayText,
                        style:
                            TextStyle(color: Colors.white, fontSize: 24.0))))));
  }
}

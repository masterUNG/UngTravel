import 'package:flutter/material.dart';
import 'package:ungrunner/utility/my_style.dart';

class ShowTitleH1 extends StatefulWidget {
  final String title;
  ShowTitleH1({@required this.title});
  @override
  _ShowTitleH1State createState() => _ShowTitleH1State();
}

class _ShowTitleH1State extends State<ShowTitleH1> {
  String title;

  @override
  void initState() {
    super.initState();
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        color: MyStyle().dark,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

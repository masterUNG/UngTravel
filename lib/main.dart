import 'package:flutter/material.dart';
import 'package:ungrunner/states/authen.dart';
import 'package:ungrunner/states/create_account.dart';
import 'package:ungrunner/states/list_runner.dart';
import 'package:ungrunner/states/runner.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccoun(),
  '/listRunner': (BuildContext context) => ListRunner(),
  '/runner': (BuildContext context) => Runner(),
};

String initialRount = '/listRunner';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ung Runner',
      routes: map,
      initialRoute: initialRount,
    );
  }
}

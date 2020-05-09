import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/navigationBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wattza app",
      home: MyNavigationBar(),
    );
  }
}

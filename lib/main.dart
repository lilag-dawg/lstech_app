import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/navigationBar.dart';
//import 'databases/session_model.dart';
//import 'databases/base_db.dart';
//import 'package:lstech_app/databases/test_db_helper.dart';

//var session_table = new BaseDB(
//    dbFormat: SessionTableModel.dbFormat, dbName: SessionTableModel.dbName);

void main() {
  //var testing = new TestDBHelper();
  //testing.initSession();
  runApp(MyApp());
}
//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wattza app",
      home: MyNavigationBar(),
    );
  }
}

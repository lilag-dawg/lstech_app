import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/navigationBar.dart';
//import 'databases/session_model.dart';
//import 'databases/base_db.dart';
//import 'package:lstech_app/databases/test_db_helper.dart';

//var session_table = new BaseDB(
//    dbFormat: SessionTableModel.dbFormat, dbName: SessionTableModel.dbName);
//var _dbProvider = DatabaseProvider();
void main() {
  //var testing = new TestDBHelper();
  //testing.initSession();
  //var _db = DatabaseProvider.database;
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

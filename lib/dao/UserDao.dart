import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'Database.dart';
import '../model/User.dart';

class UserDao {
  
  static createUser(User) async {
    final db = await DatabaseProvider.database;
    db.executeSql(''''')
  }

  createOrUpdate(User user) async {
    // 1. est-ce que le user existe
  }
}
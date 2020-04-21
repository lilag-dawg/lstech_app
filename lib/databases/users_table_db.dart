import '../databases/users_table_model.dart';
import '../databases/base_db.dart';
import 'package:sqflite/sqflite.dart';

class UsersTableDB extends BaseDB {
  Database _db;

  String dbFormat;
  String dbName;

  UsersTableDB({this.dbFormat, this.dbName});

  Future<Map<String, dynamic>> queryByEmail(
      String table, UsersTableModel usersTable) async {
    var query = await _db
        .query(table, where: 'email = ?', whereArgs: [usersTable.email]);
    if (query.length != 0) {
      return query[0];
    } else {
      return null;
    }
  }

  Future<int> updateByParameter(String table, UsersTableModel model) async =>
      await _db.update(table, model.toMap(),
          where: 'email = ?', whereArgs: [model.email]);

  Future<int> deleteByEmail(String table, UsersTableModel usersTable) async =>
      await _db
          .delete(table, where: 'email = ?', whereArgs: [usersTable.email]);
}

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../databases/base_model.dart';
import 'package:flutter/material.dart';

abstract class BaseDB {
  Database _db;

  static int get _version => 1;

  String dbFormat;
  String dbName;

  BaseDB({@required this.dbFormat, @required this.dbName});

  Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _dbPath = await getDatabasesPath() + dbName;
      _db = await openDatabase(_dbPath, version: _version, onCreate: create);
    } catch (ex) {
      print(ex);
    }
  }

  void create(Database db, int version) async {
    await db.execute(dbFormat);
  }

  Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  Future<int> insert(String table, BaseModel model) async =>
      await _db.insert(table, model.toMap());

  Future<int> deleteAll(String table) async => await _db.delete(table);

  Future<Map<String, dynamic>> queryByPrimaryKey(
      String table, String primaryKeySearchString, String primaryKey) async {
    var query = await _db
        .query(table, where: primaryKeySearchString, whereArgs: [primaryKey]);
    if (query.length != 0) {
      return query[0];
    } else {
      return null;
    }
  }

  Future<int> updateByPrimaryKey(String table, BaseModel usersTable,
          String primaryKeySearchString, String primaryKey) async =>
      await _db.update(table, usersTable.toMap(),
          where: primaryKeySearchString, whereArgs: [primaryKey]);

  Future<int> deleteByPrimaryKey(String table, BaseModel usersTable,
          String primaryKeySearchString, String primaryKey) async =>
      await _db.delete(table,
          where: primaryKeySearchString, whereArgs: [primaryKey]);
}

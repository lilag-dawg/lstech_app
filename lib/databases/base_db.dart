import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../databases/base_model.dart';
import 'package:flutter/material.dart';

class BaseDB {
  Database _db;

  static int get _version => 1; //onCreate

  String dbFormat;
  String dbName;

  BaseDB({@required this.dbFormat, @required this.dbName});

  Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _dbPath = await getDatabasesPath() + '/' + dbName + '.db';
      print(_dbPath);
      print('executing : openDatabase');
      _db = await openDatabase(_dbPath,
          version: _version, onCreate: create, onConfigure: _onConfigure);
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> deletePermanent() async {
    if (_db == null) {
      return;
    }

    try {
      String _dbPath = await getDatabasesPath() + '/' + dbName + '.db';
      print('executing : deleteDatabase');
      await deleteDatabase(_dbPath);
      _db = null;
    } catch (ex) {
      print(ex);
    }
  }

  static Future _onConfigure(Database db) async {
    print('executing : PRAGMA foreign_keys = ON');
    //await db.execute('PRAGMA legacy_alter_table = OFF');
    await db.execute('PRAGMA foreign_keys = ON');
  }

  void create(Database db, int version) async {
    print('executing : ' + dbFormat);
    await db.execute(dbFormat);
  }

  Future<List<Map<String, dynamic>>> query(String name) async =>
      await _db.query(name);

  Future<int> insert(String name, BaseModel model) async {
    print('inserting : ');
    print(model.toMap());
    await _db.insert(name, model.toMap());
  }

  Future<int> deleteAll(String name) async => await _db.delete(name);

  Future<List<Map<String, dynamic>>> queryByParameter(
      String table, String whereString, dynamic parameter) async {
    var query =
        await _db.query(table, where: whereString, whereArgs: [parameter]);
    if (query.length != 0) {
      return query;
    } else {
      return null;
    }
  }

  /*Future<int> updateByPrimaryKey(String table, BaseModel usersTable,
          String primaryKeySearchString, String primaryKey) async =>
      await _db.update(table, usersTable.toMap(),
          where: primaryKeySearchString, whereArgs: [primaryKey]);

  Future<int> deleteByPrimaryKey(String table, BaseModel usersTable,
          String primaryKeySearchString, String primaryKey) async =>
      await _db.delete(table,
          where: primaryKeySearchString, whereArgs: [primaryKey]);*/
}

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import '../databases/base_model.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider provider = DatabaseProvider._();
  static Database _database;

  static int get _version => 1; //onCreate
  static final String databaseName = 'LSTechDatabase.db';

  static Future<Database> get database async {
    if (_database != null) return _database;

    _database = await init();
    return _database;
  }

  static Future<Database> init() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: _version, onCreate: create, onConfigure: _onConfigure);
  }

  static Future<void> eraseDatabase() async {
    if (_database == null) {
      return;
    }

    await deleteDatabase(join(await getDatabasesPath(), databaseName));
    _database = null;

    return;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static void create(Database db, int version) async {
    await db.execute('''
    CREATE TABLE session_table (
      sessionId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      sessionType TEXT
    );
    ''');

    await db.execute('''
    CREATE TABLE session_segment_table (
      sessionSegmentId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      segmentType TEXT, 
      startTime INTEGER, 
      endTime INTEGER, 
      sessionId INTEGER, 
      FOREIGN KEY(sessionId) REFERENCES session_table(sessionId) ON DELETE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE reading_table (
      readingId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      timeOfReading int, 
      readingType TEXT, 
      sessionId INTEGER, 
      FOREIGN KEY(sessionId) REFERENCES session_table(sessionId) ON DELETE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE cadence_reading_table (
      value INTEGER, 
      readingId INTEGER,
      FOREIGN KEY(readingId) REFERENCES reading_table(readingId) ON DELETE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE power_reading_table (
      value INTEGER, 
      readingId INTEGER,
      FOREIGN KEY(readingId) REFERENCES reading_table(readingId) ON DELETE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE gps_reading_table (
      latitude INTEGER, 
      longitude INTEGER, 
      readingId INTEGER,
      FOREIGN KEY(readingId) REFERENCES reading_table(readingId) ON DELETE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE user_table (
      userId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      birthdate TEXT, 
      sex TEXT, 
      height INTEGER, 
      weight INTEGER, 
      city TEXT
    );
    ''');

    await db.execute('''
    CREATE TABLE wattza_table (
    uniqueId TEXT PRIMARY KEY NOT NULL, 
    localName TEXT
    );
    ''');
  }

  static Future<List<Map<String, dynamic>>> query(String name) async =>
      await _database.query(name);

  static Future<void> insert(String name, BaseModel model) async =>
      await _database.insert(name, model.toMap());

  static Future<int> deleteTableData(String name) async =>
      await _database.delete(name);

  static Future<List<Map<String, dynamic>>> queryByParameter(
      String table, String whereString, dynamic parameter) async {
    var query = await _database
        .query(table, where: whereString, whereArgs: [parameter]);
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

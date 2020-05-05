import '../databases/base_model.dart';
import '../databases/session_model.dart';
import 'package:flutter/material.dart';

class ReadingTableModel extends BaseModel {
  static String dbName = 'reading_table';
  static String pkName = 'readingId';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (' + pkName + ' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, timeSinceStart TEXT, readingType TEXT, ' + SessionTableModel.pkName + 'INTEGER, FOREIGN KEY(sessionId) REFERENCES ' +
      SessionTableModel.dbName +
      '(' +
      SessionTableModel.pkName +
      ') ON DELETE CASCADE)';

  int readingId;
  String timeSinceStart; //ISO-8601 HH:MM:SS.SSS
  String readingType; //check enum {"GPS","POWER","CADENCE"}
  String sessionId;

  static String primaryKeyWhereString = pkName + ' = ?';

  ReadingTableModel(
      {this.readingId,
      this.timeSinceStart,
      this.readingType,
      @required this.sessionId,});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      pkName: readingId,
      'timeSinceStart': timeSinceStart,
      'readingType': readingType,
      'sessionId': sessionId,
    };
    return map;
  }

  static ReadingTableModel fromMap(Map<String, dynamic> map) {
    return ReadingTableModel(
      readingId: map[pkName],
      timeSinceStart: map['timeSinceStart'],
      readingType: map['readingType'],
      sessionId: map['sessionId'],
    );
  }
}

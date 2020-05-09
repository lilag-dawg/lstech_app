import '../databases/base_model.dart';
import 'package:flutter/material.dart';

 /*enum readingTypes {
  gps,
  power,
  cadence,
}*/

class ReadingTableModel extends BaseModel {
  static String tableName = 'reading_table';

  int readingId;
  int timeOfReading; //millisecondsSinceEpoch
  String readingType; //check enum {"gps","power","cadence"} 
  int sessionId;

  static const String cadenceTypeString = 'cadence';
  static const String powerTypeString = 'power';
  static const String gpsTypeString = 'gps';

  static String primaryKeyWhereString = 'readingId = ?';

  ReadingTableModel({
    this.readingId,
    this.timeOfReading,
    this.readingType,
    @required this.sessionId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'readingId': readingId,
      'timeOfReading': timeOfReading,
      'readingType': readingType,
      'sessionId': sessionId,
    };
    return map;
  }

  static ReadingTableModel fromMap(Map<String, dynamic> map) {
    return ReadingTableModel(
      readingId: map['readingId'],
      timeOfReading: map['timeOfReading'],
      readingType: map['readingType'],
      sessionId: map['sessionId'],
    );
  }
}

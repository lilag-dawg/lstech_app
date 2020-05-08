import '../databases/base_model.dart';
import 'package:flutter/material.dart';

class ReadingTableModel extends BaseModel {

  int readingId;
  String timeOfReading; //millisecondsSinceEpoch
  String readingType; //check enum {"GPS","POWER","CADENCE"}
  String sessionId;

  static String primaryKeyWhereString = 'readingId = ?';

  ReadingTableModel(
      {this.readingId,
      this.timeOfReading,
      this.readingType,
      @required this.sessionId,});

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

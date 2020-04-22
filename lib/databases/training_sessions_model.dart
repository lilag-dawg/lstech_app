import 'package:flutter/material.dart';
import '../databases/base_model.dart';

class TrainingSessionsTableModel extends BaseModel {
  static String dbName = 'training_sessions_table';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (start_time TEXT PRIMARY KEY NOT NULL, sessionType TEXT, FOREIGN KEY(email) REFERENCES users_table(email) ON DELETE CASCADE)';

  String sessionType;
  String trainingStartTime; //ISO-8601
  String email;
  static String primaryKeySearchString = 'trainingStartTime = ?';

  TrainingSessionsTableModel(
      {this.sessionType,
      @required this.trainingStartTime,
      @required this.email});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'sessionType': sessionType,
      'trainingStartTime': trainingStartTime,
      'email': email,
    };
    return map;
  }

  static TrainingSessionsTableModel fromMap(Map<String, dynamic> map) {
    return TrainingSessionsTableModel(
        sessionType: map['sessionType'],
        trainingStartTime: map['trainingStartTime'],
        email: map['email']);
  }
}

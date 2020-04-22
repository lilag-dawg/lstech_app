import 'package:flutter/material.dart';
import '../databases/base_model.dart';

class BaseReadingsTableModel extends BaseModel {
  int readValue;
  String readTime; //ISO-8601
  String trainingStartTime; //ISO-8601
  String email;
  static String primaryKeySearchString = 'readTime = ?';

  BaseReadingsTableModel(
      {this.readValue,
      @required this.readTime,
      @required this.trainingStartTime,
      @required this.email});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'readValue': readValue,
      'readTime': readTime,
      'trainingStartTime': trainingStartTime,
      'email': email,
    };
    return map;
  }

  static BaseReadingsTableModel fromMap(Map<String, dynamic> map) {
    return BaseReadingsTableModel(
        readValue: map['readValue'],
        readTime: map['trainingStartTime'],
        trainingStartTime: map['startTime'],
        email: map['email']);
  }
}

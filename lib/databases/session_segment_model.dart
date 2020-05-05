import '../databases/base_model.dart';
import '../databases/session_model.dart';

class SessionSegmentTableModel extends BaseModel {
  static String dbName = 'session_segment_table';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (sessionSegmentId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, segmentType TEXT, startTime TEXT, endTime TEXT, ' + SessionTableModel.pkName + ' INTEGER, FOREIGN KEY(sessionId) REFERENCES ' +
      SessionTableModel.dbName +
      ' (' +
      SessionTableModel.pkName +
      ') ON DELETE CASCADE)';

  int sessionSegmentId;
  String segmentType; //check enum {"pause","training"}
  String startTime; //ISO-8601 YYYY-MM-DD HH:MM:SS.SSS
  String  endTime; //ISO-8601 YYYY-MM-DD HH:MM:SS.SSS
  int sessionId;

  static String primaryKeyWhereString = 'sessionSegmentId = ?';

  SessionSegmentTableModel(
      {this.sessionSegmentId,
      this.segmentType,
      this.startTime,
      this.endTime,
      this.sessionId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'sessionSegmentId': sessionSegmentId,
      'segmentType': segmentType,
      'startTime': startTime,
      'endTime': endTime,
      'sessionId': sessionId,
    };
    return map;
  }

  static SessionSegmentTableModel fromMap(Map<String, dynamic> map) {
    return SessionSegmentTableModel(
      sessionSegmentId: map['sessionSegmentId'],
      segmentType: map['segmentType'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      sessionId: map['sessionId'],
    );
  }
}

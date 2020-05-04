import '../databases/base_model.dart';

class SessionTableModel extends BaseModel {
  static String dbName = 'session_table';
  static String pkName = 'sessionId';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (' + pkName + ' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, elapsedTime TEXT, sessionType TEXT)';

  int sessionId;
  String elapsedTime; //ISO-8601 HH:MM:SS.SSS
  String sessionType;

  static String primaryKeyWhereString = pkName + ' = ?';

  SessionTableModel(
      {this.sessionId,
      this.elapsedTime,
      this.sessionType});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      pkName: sessionId,
      'elapsedTime': elapsedTime,
      'sessionType': sessionType,
    };
    return map;
  }

  static SessionTableModel fromMap(Map<String, dynamic> map) {
    return SessionTableModel(
        sessionId: map[pkName],
        elapsedTime: map['elapsedTime'],
        sessionType: map['sessionType']);
  }
}

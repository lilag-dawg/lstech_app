import '../databases/base_model.dart';

class SessionTableModel extends BaseModel {

  static String tableName = 'session_table';

  int sessionId;
  String sessionType;

  static String primaryKeyWhereString = 'sessionId = ?';

  SessionTableModel(
      {this.sessionId,
      this.sessionType});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'sessionId': sessionId,
      'sessionType': sessionType,
    };
    return map;
  }

  static SessionTableModel fromMap(Map<String, dynamic> map) {
    return SessionTableModel(
        sessionId: map['sessionId'],
        sessionType: map['sessionType']);
  }
}

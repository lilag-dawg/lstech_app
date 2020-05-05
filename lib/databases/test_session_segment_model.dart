import '../databases/base_model.dart';

class TestSessionSegmentTableModel extends BaseModel {
  static String dbName = 'test_session_segment';
  static String dbFormat =
      'CREATE TABLE test_session_segment (sSId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, sessionId INTEGER, FOREIGN KEY(sessionId) REFERENCES test_session(sessionId) ON DELETE CASCADE)';

  int sSId;
  int sessionId;

  static String primaryKeyWhereString = 'sSId = ?';

  TestSessionSegmentTableModel({this.sSId, this.sessionId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'sSId': sSId,
      'sessionId': sessionId,
    };
    return map;
  }

  static TestSessionSegmentTableModel fromMap(Map<String, dynamic> map) {
    return TestSessionSegmentTableModel(
      sSId: map['sSId'],
      sessionId: map['sessionId'],
    );
  }
}

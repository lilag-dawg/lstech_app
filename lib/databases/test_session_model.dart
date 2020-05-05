import '../databases/base_model.dart';

class TestSessionTableModel extends BaseModel {
  static String dbName = 'test_session';
  static String dbFormat = 'CREATE TABLE test_session (sessionId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL)';

  int sessionId;

  static String primaryKeyWhereString = 'sessionId = ?';

  TestSessionTableModel(
      {this.sessionId,});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'sessionId': sessionId,
    };
    return map;
  }

  static TestSessionTableModel fromMap(Map<String, dynamic> map) {
    return TestSessionTableModel(
        sessionId: map['sessionId'],);
  }
}

import '../databases/base_model.dart';

class SessionSegmentTableModel extends BaseModel {

  static String tableName = 'session_segment_table';

  int sessionSegmentId;
  String segmentType; //check enum {"pause","training"}
  int startTime; //millisecondsSinceEpoch
  int endTime; //millisecondsSinceEpoch
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

import 'dart:async';
import '../databases/session_model.dart';
import '../databases/session_segment_model.dart';
import '../databases/base_db.dart';

class TestDBHelper {

  var _dbSession = new
    BaseDB(dbFormat: SessionTableModel.dbFormat, dbName: SessionTableModel.dbName);

  var _dbSessionSegment = new
    BaseDB(dbFormat: SessionSegmentTableModel.dbFormat, dbName: SessionSegmentTableModel.dbName);

  Future<void> initSession() async {
    print('initSession');
    await _dbSession.init();
    await _dbSession.deletePermanent();
    await _dbSession.init();
  }

  Future<void> addToSession() async {
    SessionTableModel test = SessionTableModel(elapsedTime: '13:22:53.222', sessionType: 'Normal');
    await _dbSession.insert(SessionTableModel.dbName, test);
  }

  Future<List<Map<String, dynamic>>> queryAllSession() async {
    var queriedSessions = await _dbSession.query(SessionTableModel.dbName);
    return queriedSessions;
  }

  Future<void> deleteAllSession() async {
    await _dbSession.deleteAll(SessionTableModel.dbName);

  }

    Future<void> initSessionSegment() async {
      print('initSessionSegment');
    await _dbSessionSegment.init();
    await _dbSessionSegment.deletePermanent();
    await _dbSessionSegment.init();
  }

  Future<void> addToSessionSegment() async {
    var queriedSessions = await queryAllSession();

    SessionSegmentTableModel test1 = SessionSegmentTableModel(segmentType: 'training', startTime: '2020-05-05 13:08:23.067', endTime: '2020-05-05 13:25:23.267', sessionId: queriedSessions[queriedSessions.length-1]['sessionId']);
    //SessionSegmentTableModel test2 = SessionSegmentTableModel(segmentType: 'pause', startTime: '2020-05-05 13:25:23.267', endTime:'2020-05-05 13:45:23.267', sessionId: sessionId);
    //SessionSegmentTableModel test3 = SessionSegmentTableModel(segmentType: 'training', startTime: '2020-05-05 13:45:23.267', endTime: '2020-05-05 13:45:27.267', sessionId: sessionId);
    await _dbSessionSegment.insert(SessionSegmentTableModel.dbName, test1);
    //await _dbSessionSegment.insert(SessionSegmentTableModel.dbName, test2);
    //await _dbSessionSegment.insert(SessionSegmentTableModel.dbName, test3);
  }

  Future<List<Map<String, dynamic>>> queryAllSessionSegment() async {
    var queriedSessionSegments = await _dbSessionSegment.query(SessionSegmentTableModel.dbName);
    return queriedSessionSegments;
  }

    Future<void> deleteAllSessionSegment() async {
    await _dbSessionSegment.deleteAll(SessionSegmentTableModel.dbName);

  }

}

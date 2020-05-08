import 'dart:async';
import '../databases/session_model.dart';
import '../databases/session_segment_model.dart';
import '../databases/base_db.dart';

abstract class HistoryHelper {
  static Future<void> testDB() async {
    await DatabaseProvider.database;
    //await DatabaseProvider.eraseDatabase();
    //await DatabaseProvider.database;

    SessionTableModel test = SessionTableModel(sessionType: 'intervals');
    await DatabaseProvider.insert(SessionTableModel.tableName, test);

    var queriedSessions =
        await DatabaseProvider.query(SessionTableModel.tableName);

    if (queriedSessions.length > 16) {
      await DatabaseProvider.deleteTableData(SessionTableModel.tableName);
    }

    queriedSessions = await DatabaseProvider.query(SessionTableModel.tableName);
    //print(queriedSessions);

    if (queriedSessions.length > 0) {
      int startValue = DateTime.now().millisecondsSinceEpoch +
          100000 * queriedSessions.length;
      int endValue = DateTime.now().millisecondsSinceEpoch +
          1000000 * queriedSessions.length;

      SessionSegmentTableModel segmentTest = SessionSegmentTableModel(
          segmentType: 'training',
          startTime: startValue,
          endTime: endValue,
          sessionId: queriedSessions[queriedSessions.length - 1]['sessionId']);
      await DatabaseProvider.insert(
          SessionSegmentTableModel.tableName, segmentTest);
    }

    var queriedSessionSegment =
        await DatabaseProvider.query(SessionSegmentTableModel.tableName);
    //print(queriedSessionSegment);
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///

  static Future<Map<String, List<dynamic>>>
      getListOfStartTimesAndDurations() async {
    await DatabaseProvider.database;
    var sessionsList =
        await DatabaseProvider.query(SessionTableModel.tableName);

    List<String> listOfSessionStartTimes = List<String>();
    List<String> listOfSessionDurations = List<String>();
    List<int> sessionDIds = List<int>();
    if (sessionsList != null) {
      for (int i = 0; i < sessionsList.length; i++) {
        listOfSessionStartTimes
            .add(await getSessionStartTime(sessionsList[i]['sessionId']));
        listOfSessionDurations
            .add(await getTimeSpentTraining(sessionsList[i]['sessionId']));
        sessionDIds.add(sessionsList[i]['sessionId']);
      }
    }
    return {
      'startTimes': listOfSessionStartTimes,
      'durations': listOfSessionDurations,
      'sessionId': sessionDIds,
    };
  }

  static Future<String> getTimeSpentTraining(int sessionId) async {
    var sessionSegmentsList = await DatabaseProvider.queryByParameter(
        SessionSegmentTableModel.tableName, 'sessionId = ?', sessionId);

    int timeSpentTraining = 0;

    if (sessionSegmentsList != null) {
      for (int i = 0; i < sessionSegmentsList.length; i++) {
        var sessionSegment =
            SessionSegmentTableModel.fromMap(sessionSegmentsList[i]);
        if (sessionSegment.segmentType == 'training') {
          timeSpentTraining +=
              sessionSegment.endTime - sessionSegment.startTime;
        }
      }
    }

    return Duration(milliseconds: timeSpentTraining).toString();
  }

  static Future<String> getSessionStartTime(int sessionId) async {
    var sessionSegmentsList = await DatabaseProvider.queryByParameter(
        SessionSegmentTableModel.tableName, 'sessionId = ?', sessionId);

    int earliestTime = DateTime.now().millisecondsSinceEpoch + 1000000000000;

    if (sessionSegmentsList != null) {
      for (int i = 0; i < sessionSegmentsList.length; i++) {
        var sessionSegment =
            SessionSegmentTableModel.fromMap(sessionSegmentsList[i]);
        if (earliestTime > sessionSegment.startTime) {
          earliestTime = sessionSegment.startTime;
        }
      }
    }

    return DateTime.fromMillisecondsSinceEpoch(earliestTime).toString();
  }
}

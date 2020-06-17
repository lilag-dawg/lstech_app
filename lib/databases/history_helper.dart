import 'dart:async';
import 'package:lstech_app/databases/gps_reading_model.dart';

import '../databases/session_model.dart';
import '../databases/reading_model.dart';
import '../databases/reading_value_model.dart';
import '../databases/session_segment_model.dart';
import '../databases/base_db.dart';
import '../widgets/statisticsChart.dart';

abstract class HistoryHelper {
  static Future<void> testDB() async {
    await DatabaseProvider.database;
    //await DatabaseProvider.eraseDatabase();
    //await DatabaseProvider.database;

    var test = SessionTableModel(sessionType: 'intervals');
    await DatabaseProvider.insert(SessionTableModel.tableName, test);

    var queriedSessions =
        await DatabaseProvider.query(SessionTableModel.tableName);

    if (queriedSessions.length > 100) {
      await DatabaseProvider.deleteTableData(SessionTableModel.tableName);
    }

    queriedSessions = await DatabaseProvider.query(SessionTableModel.tableName);
    //print(queriedSessions);

    if (queriedSessions.length > 0) {
      int startValue = DateTime.now().millisecondsSinceEpoch +
          100000 * queriedSessions.length;
      int endValue = DateTime.now().millisecondsSinceEpoch +
          1000000 * queriedSessions.length;

      var segmentTest = SessionSegmentTableModel(
          segmentType: 'training',
          startTime: startValue,
          endTime: endValue,
          sessionId: queriedSessions[queriedSessions.length - 1]['sessionId']);
      await DatabaseProvider.insert(
          SessionSegmentTableModel.tableName, segmentTest);

      for (int i = 0; i < 100; i++) {
        var readingTest = ReadingTableModel(
            timeOfReading: startValue + i * 70000,
            readingType: ReadingTableModel.powerTypeString,
            sessionId: queriedSessions[queriedSessions.length - 1]
                ['sessionId']);
        await DatabaseProvider.insert(ReadingTableModel.tableName, readingTest);

        var queriedreadings =
            await DatabaseProvider.query(ReadingTableModel.tableName);
        //print(queriedreadings);

        var powerReading = ReadingValueTableModel(
            value: i,
            readingId: queriedreadings[queriedreadings.length - 1]
                ['readingId']);
        await DatabaseProvider.insert(
            ReadingValueTableModel.powerTableName, powerReading);

        readingTest = ReadingTableModel(
            timeOfReading: startValue + i * 50000,
            readingType: ReadingTableModel.cadenceTypeString,
            sessionId: queriedSessions[queriedSessions.length - 1]
                ['sessionId']);
        await DatabaseProvider.insert(ReadingTableModel.tableName, readingTest);

        queriedreadings =
            await DatabaseProvider.query(ReadingTableModel.tableName);

        var cadenceReading = ReadingValueTableModel(
            value: i % 7,
            readingId: queriedreadings[queriedreadings.length - 1]
                ['readingId']);
        await DatabaseProvider.insert(
            ReadingValueTableModel.cadenceTableName, cadenceReading);
      }
      var powerTest = await getStatisticsFromReadingsType(
          queriedSessions[queriedSessions.length - 1]['sessionId'],
          ReadingTableModel.powerTypeString);

      print(powerTest);

      var cadenceTest = await getStatisticsFromReadingsType(
          queriedSessions[queriedSessions.length - 1]['sessionId'],
          ReadingTableModel.cadenceTypeString);

      print(cadenceTest);
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///

/*
getListOfStartTimesAndDurations : 
  - Returns a list of all stored sessions with their durations and start times
  - The list goes from youngest to oldest session
*/

  static Future<List<Map<String, dynamic>>>
      getListOfStartTimesAndDurations() async {
    await DatabaseProvider.database;
    var sessionsList =
        await DatabaseProvider.query(SessionTableModel.tableName);

    var sessionsDataList = List<Map<String, dynamic>>();
    if (sessionsList != null) {
      for (int i = sessionsList.length - 1; i >= 0; i--) {
        sessionsDataList.add({
          'startTime': await getSessionStartTime(sessionsList[i]['sessionId']),
          'duration': await getTimeSpentTraining(sessionsList[i]['sessionId']),
          'sessionId': sessionsList[i]['sessionId'],
        });
      }
    }
    return sessionsDataList;
  }

  /*
getMostRecentSessionId : 
  - Returns the most recent sessionID, if a session is currently ongoing, it returns the ongoing session
*/
  static Future<int> getMostRecentSessionId() async {
    await DatabaseProvider.database;
    var sessionsList =
        await DatabaseProvider.query(SessionTableModel.tableName);
    if (sessionsList != null) {
      return sessionsList[sessionsList.length - 1]['sessionId'];
    }
  }

/*
getStatisticsFromReadingsType : 
  - for cadence and power, return average and max values for a specific sessionId
  - gps not yet supported
*/

  static Future<Map<String, dynamic>> getStatisticsFromReadingsType(
      int sessionId, String readingType) async {
    var valuesList = await getListOfTimesAndReadings(sessionId, readingType);

    int maxValue = 0;
    int sumOfValues = 0;
    int averageValue = 0;

    if (valuesList != null) {
      if (valuesList.length > 0) {
        if (readingType == ReadingTableModel.cadenceTypeString ||
            readingType == ReadingTableModel.powerTypeString) {
          valuesList.forEach((f) {
            sumOfValues += f['value'];
            if (f['value'] > maxValue) {
              maxValue = f['value'];
            }
          });

          averageValue = sumOfValues ~/ valuesList.length;
          return {'maxValue': maxValue, 'averageValue': averageValue};
        } else if (readingType == ReadingTableModel.gpsTypeString) {
          //TODO : add support for gps
          return null;
        }
      }
    }
    return null;
  }

/*
getListOfTimesAndReadings : 
  - finds all readings associated to a sessionId
  - keeps readings of desired type
  - returns a list of every reading of desired type for the session with their respective time of recording
*/
  static Future<List<Map<String, dynamic>>> getListOfTimesAndReadings(
      int sessionId, String readingType) async {
    var readingsList = await DatabaseProvider.queryByParameter(
        ReadingTableModel.tableName, 'sessionId = ?', sessionId);

    var timesAndReadingsList = List<Map<String, dynamic>>();
    if (readingsList != null) {
      for (int i = 0; i < readingsList.length; i++) {
        if (readingsList[i]['readingType'] == readingType) {
          timesAndReadingsList
              .add(await associateTimeAndReadingValues(readingsList[i]));
        }
      }
    }
    return timesAndReadingsList;
  }

/*
getTableNameFromReadingType : 
  - Returns the name of the table where the values of the selected readingType are stored
*/
  static String getTableNameFromReadingType(String type) {
    String tableName;
    switch (type) {
      case ReadingTableModel.cadenceTypeString:
        tableName = ReadingValueTableModel.cadenceTableName;
        break;
      case ReadingTableModel.powerTypeString:
        tableName = ReadingValueTableModel.powerTableName;
        break;
      case ReadingTableModel.gpsTypeString:
        tableName = GPSReadingTableModel.tableName;
        break;
      default:
        return null;
    }
    return tableName;
  }

/*
associateTimeAndReadingValues : 
  - Returns a Map where a specific reading value is associated to its time of recording
*/
  static Future<Map<String, dynamic>> associateTimeAndReadingValues(
      Map<String, dynamic> readingMap) async {
    var reading = ReadingTableModel.fromMap(readingMap);

    var tableName = getTableNameFromReadingType(reading.readingType);
    var readingValueList = await DatabaseProvider.queryByParameter(
        tableName, ReadingTableModel.primaryKeyWhereString, reading.readingId);

    if (readingValueList != null) {
      switch (reading.readingType) {
        case ReadingTableModel.cadenceTypeString:
          var readingValue =
              ReadingValueTableModel.fromMap(readingValueList[0]);
          return {
            'timeOfReading': reading.timeOfReading,
            'value': readingValue.value
          };
        case ReadingTableModel.powerTypeString:
          var readingValue =
              ReadingValueTableModel.fromMap(readingValueList[0]);
          return {
            'timeOfReading': reading.timeOfReading,
            'value': readingValue.value
          };
        case ReadingTableModel.gpsTypeString:
          var readingValue = GPSReadingTableModel.fromMap(readingValueList[0]);
          return {
            'timeOfReading': reading.timeOfReading,
            'latitude': readingValue.latitude,
            'longitude': readingValue.longitude
          };
        default:
          break;
      }
    }
    return null;
  }

  static Future<String> getTimeSpentTraining(int sessionId) async {
    var sessionSegmentsList = await DatabaseProvider.queryByParameter(
        SessionSegmentTableModel.tableName, 'sessionId = ?', sessionId);

    int timeSpentTraining = 0;

    if (sessionSegmentsList != null) {
      for (int i = 0; i < sessionSegmentsList.length; i++) {
        var sessionSegment =
            SessionSegmentTableModel.fromMap(sessionSegmentsList[i]);
        if (sessionSegment.segmentType ==
            SessionSegmentTableModel.trainingTypeString) {
          timeSpentTraining +=
              sessionSegment.endTime - sessionSegment.startTime;
        }
      }
    }

    return Duration(milliseconds: timeSpentTraining).toString();
  }

  static Future<int> getSessionStartTime(int sessionId) async {
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

    //return DateTime.fromMillisecondsSinceEpoch(earliestTime).toString();
    return earliestTime;
  }

  static Future<List<Reading>> getChartValues(
      int sessionId, String readingType) async {
    await DatabaseProvider.database;
    var sessionsList = await DatabaseProvider.queryByParameter(
        SessionTableModel.tableName,
        SessionTableModel.primaryKeyWhereString,
        sessionId);
    var valuesList = await getListOfTimesAndReadings(sessionId, readingType);

    int startTime;
    if (sessionsList != null) {
      startTime = await getSessionStartTime(sessionsList[0]['sessionId']);
    }

    if (sessionsList != null && valuesList != null) {
      switch (readingType) {
        case ReadingTableModel.cadenceTypeString:
          var chartValues = List<Reading>();
          valuesList.forEach((v) {
            var time = Duration(milliseconds: v['timeOfReading'] - startTime);
            chartValues.add(Reading(time.inMinutes, v['value']));
          });
          return chartValues;

        case ReadingTableModel.powerTypeString:
          var chartValues = List<Reading>();
          valuesList.forEach((v) {
            var time = Duration(milliseconds: v['timeOfReading'] - startTime);
            chartValues.add(Reading(time.inMinutes, v['value']));
          });
          return chartValues;
        case ReadingTableModel.gpsTypeString:
          return null;
        default:
          return null;
      }
    }
    return null;
  }
}

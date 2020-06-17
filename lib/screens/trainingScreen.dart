import 'package:flutter/material.dart';
import 'package:lstech_app/databases/reading_model.dart';
import 'package:lstech_app/databases/reading_value_model.dart';
import 'package:lstech_app/widgets/trainingDrawerHalfCircle.dart';
import 'package:provider/provider.dart';
import '../widgets/secondaryDashBoardData.dart';
import '../widgets/primaryDashBoardData.dart';

import '../models/bluetoothDeviceManager.dart';
import '../databases/history_helper.dart';
import '../constants.dart' as Constants;
import '../screens/trainingSummaryScreen.dart';
import '../databases/base_db.dart';
import '../databases/session_model.dart';

import '../databases/session_segment_model.dart';
import '../widgets/statisticsChart.dart';

class MyTrainingScreen extends StatefulWidget {
  MyTrainingScreen(this.pageTabController);
  final TabController pageTabController;

  @override
  _MyTrainingScreenState createState() => _MyTrainingScreenState();
}

class _MyTrainingScreenState extends State<MyTrainingScreen> {
  bool _isTrainingOver = false;
  Map<String, dynamic> selectedSession;
  int currentSessionId;
  int segmentStartValue;
  bool isTrainingOngoing = false;

  void _onEndOfTrainingClicked() {
    setState(() {
      _isTrainingOver = true;
      isTrainingOngoing = false;
    });
  }

  Future<void> updateSession(String sessionStateString) async {
    if (sessionStateString == 'Démarrer') {
      //start
      setState(() {
        _isTrainingOver = false;
        isTrainingOngoing = true;
      });
      var session =
          SessionTableModel(sessionType: SessionTableModel.normalTypeString);
      await DatabaseProvider.insert(SessionTableModel.tableName, session);

      var queriedSessions =
          await DatabaseProvider.query(SessionTableModel.tableName);
      currentSessionId =
          queriedSessions[queriedSessions.length - 1]['sessionId'];

      segmentStartValue = DateTime.now().millisecondsSinceEpoch;
    }
    if (sessionStateString == SessionSegmentTableModel.trainingTypeString) {
      //reprendre
      var stopStartValue = DateTime.now().millisecondsSinceEpoch;

      print(stopStartValue - segmentStartValue);

      var segment = SessionSegmentTableModel(
          segmentType: SessionSegmentTableModel.pauseTypeString,
          startTime: segmentStartValue,
          endTime: stopStartValue,
          sessionId: currentSessionId);
      await DatabaseProvider.insert(SessionSegmentTableModel.tableName, segment)
          .then((_) => segmentStartValue = stopStartValue);
    }

    if (sessionStateString == SessionSegmentTableModel.pauseTypeString) {
      //pause
      var stopStartValue = DateTime.now().millisecondsSinceEpoch;

      print(stopStartValue - segmentStartValue);

      var segment = SessionSegmentTableModel(
          segmentType: SessionSegmentTableModel.trainingTypeString,
          startTime: segmentStartValue,
          endTime: stopStartValue,
          sessionId: currentSessionId);
      await DatabaseProvider.insert(SessionSegmentTableModel.tableName, segment)
          .then((_) => segmentStartValue = stopStartValue);
    }
  }

  Widget _body(BuildContext context) {
    final wattzaManager = Provider.of<BluetoothDeviceManager>(context);
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width * (0.7 / 5.5)),
                    MyPrimaryDashBoardData(wattzaManager.getPowerPackage()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(
                        Icons.rotate_right,
                        'CADENCE',
                        wattzaManager.getRpmPackage(),
                        'RPM',
                        ReadingTableModel.cadenceTypeString,
                        ReadingValueTableModel.cadenceTableName, isTrainingOngoing), // 100
                    MySecondaryDashBoardData(Icons.location_on, 'DISTANCE',
                        null, 'm', null, null, isTrainingOngoing), // 120
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(Icons.directions_bike, 'VITESSE',
                        null, 'kmph', null, null, isTrainingOngoing), // 12.5
                    MySecondaryDashBoardData(
                        Icons.alarm, 'TEMPS', null, 'min', null, null, isTrainingOngoing), // 00:00
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(Icons.favorite,
                        'FRÉQUENCE CARDIAQUE', null, 'BPM', null, null, isTrainingOngoing), // 12.5
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height -
                (Constants.appBarHeight +
                    Constants.trainingStartStopWidgetHeight),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: MyArc(
                    MediaQuery.of(context).size.width,
                    _onEndOfTrainingClicked,
                    updateSession,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadLastSession() async {
    var sessionsDataList =
        await HistoryHelper.getListOfStartTimesAndDurations();
    selectedSession = sessionsDataList[0];
  }

  void goToHistory() {
    widget.pageTabController.animateTo(Constants.pageIndexes.history.index);
  }

  Widget futureBody() {
    return FutureBuilder<void>(
      future: loadLastSession(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return MyTrainingScreenSummary(selectedSession, goToHistory);
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isTrainingOver == false ? _body(context) : futureBody(),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/trainingDrawerHalfCircle.dart';
import 'package:provider/provider.dart';
import '../widgets/secondaryDashBoardData.dart';
import '../widgets/primaryDashBoardData.dart';

import '../models/bluetoothDeviceManager.dart';
import '../databases/history_helper.dart';
import '../constants.dart' as Constants;
import '../screens/trainingSummaryScreen.dart';

class MyTrainingScreen extends StatefulWidget {
  MyTrainingScreen(this.pageTabController);
  final TabController pageTabController;

  @override
  _MyTrainingScreenState createState() => _MyTrainingScreenState();
}

class _MyTrainingScreenState extends State<MyTrainingScreen> {

  bool _isTrainingOver = false;
  Map<String,dynamic> selectedSession;

  void _onEndOfTrainingClicked(bool isEndOfTraining) {
    setState(() {
      _isTrainingOver = true;
    });
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
                    MyPrimaryDashBoardData(null),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(Icons.rotate_right, 'CADENCE',
                        wattzaManager.getRpmPackage(), 'RPM'), // 100
                    MySecondaryDashBoardData(
                        Icons.location_on, 'DISTANCE', null, 'm'), // 120
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(
                        Icons.directions_bike, 'VITESSE', null, 'kmph'), // 12.5
                    MySecondaryDashBoardData(
                        Icons.alarm, 'TEMPS', null, 'min'), // 00:00
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(Icons.favorite,
                        'FRÉQUENCE CARDIAQUE', null, 'BPM'), // 12.5
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
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> loadLastSession() async {
    var listOfSessions = await HistoryHelper.getListOfStartTimesAndDurations();
    selectedSession = listOfSessions[0];

    return Container();
  }

  void goToHistory() {
    widget.pageTabController.animateTo(Constants.pageIndexes.history.index);
  }

  Widget futureBody() {
    return FutureBuilder<Widget>(
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
      body: _isTrainingOver == false? _body(context):futureBody(),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

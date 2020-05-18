import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/trainingDrawerHalfCircle.dart';
import 'trainingSummaryScreen.dart';
import 'package:provider/provider.dart';
import '../widgets/secondaryDashBoardData.dart';
import '../widgets/primaryDashBoardData.dart';

import '../models/bluetoothDeviceManager.dart';

import '../constants.dart' as Constants;


class MyTrainingScreen extends StatefulWidget {

  MyTrainingScreen();

  @override
  _MyTrainingScreenState createState() => _MyTrainingScreenState();
}

class _MyTrainingScreenState extends State<MyTrainingScreen> {

  bool _isEndOfTraining = false;
  bool _isBackToPreviousPageClicked = false;

  void _onEndOfTrainingClicked(bool isEndOfTraining){
    setState(() {
      _isBackToPreviousPageClicked = false;
      _isEndOfTraining = isEndOfTraining;
    });
  }

  void _onBackToPreviousPageClicked(bool isBackToPreviousPageClicked){
    setState(() {
      _isEndOfTraining = false;
      _isBackToPreviousPageClicked = isBackToPreviousPageClicked;
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
                    SizedBox(width: MediaQuery.of(context).size.width * (0.7 / 5.5)),
                    MyPrimaryDashBoardData(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(Icons.rotate_right, 'CADENCE', wattzaManager.getRpmPackage(), 'RPM'), // 100
                    MySecondaryDashBoardData(Icons.location_on, 'DISTANCE', null, 'm'), // 120
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(Icons.directions_bike, 'VITESSE', null, 'kmph'), // 12.5
                    MySecondaryDashBoardData(Icons.alarm, 'TEMPS', null, 'min'), // 00:00
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MySecondaryDashBoardData(Icons.favorite, 'FRÉQUENCE CARDIAQUE', null, 'BPM'), // 12.5
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - (Constants.appBarHeight + Constants.trainingStartStopWidgetHeight),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.topCenter,
                  child: MyArc(MediaQuery.of(context).size.width, _onEndOfTrainingClicked, )
                ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isEndOfTraining && !_isBackToPreviousPageClicked? MyTrainingScreenSummary(_onBackToPreviousPageClicked) : _body(context),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

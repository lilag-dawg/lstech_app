import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/trainingDrawerHalfCircle.dart';
import 'package:provider/provider.dart';

import 'trainingSummaryScreen.dart';

import '../widgets/customAppBar.dart';
import '../widgets/secondaryDashBoardData.dart';
import '../widgets/primaryDashBoardData.dart';
import '../widgets/trainingDrawer.dart';

import '../models/bluetoothDeviceManager.dart';

import '../constants.dart' as Constants;

Widget _endButton(BuildContext context, PageController _currentPage, Function selectHandler) {
  return RaisedButton(
    child: Column(
      children: <Widget>[
        Icon(Icons.crop_square),
        Text('Terminer')
      ],
    ),
    onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => MyTrainingScreenSummary(_currentPage, selectHandler)),);
    }
  );
}

class MyTrainingScreen extends StatelessWidget {

  final PageController _currentPage;
  final Function selectHandler;

  MyTrainingScreen(this._currentPage, this.selectHandler);

  Widget _body(BuildContext context) {
    final wattzaManager = Provider.of<BluetoothDeviceManager>(context);
    return SingleChildScrollView(
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
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.topCenter,
                child: MyArc(MediaQuery.of(context).size.width, _currentPage, selectHandler)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAppBar(body: _body(context),),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/customScaffoldBody.dart';
import '../widgets/secondaryDashBoardData.dart';
import '../widgets/powerDisplay.dart';

import 'package:provider/provider.dart';
import '../models/bluetoothDeviceManager.dart';
import '../models/streamPackage.dart';

import '../constants.dart' as Constants;

class MyTrainingScreen extends StatelessWidget {

  Widget _body(BuildContext context) {
    final wattza = Provider.of<BluetoothDeviceManager>(context);
    StreamPackage xd = wattza.getRpm();
    return Column(
      children: <Widget>[
        SizedBox(height: 40),
        Row(
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.width * (0.7 / 5.5)),
            MyPowerDisplay(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MySecondaryDashBoardData(
                Icons.rotate_right, 'CADENCE', wattza.getRpm(), 'RPM'), // 100
            MySecondaryDashBoardData(Icons.location_on, 'DISTANCE', null, 'm'), // 120
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MySecondaryDashBoardData(
                Icons.directions_bike, 'VITESSE', null, 'kmph'), // 12.5
            MySecondaryDashBoardData(Icons.alarm, 'TEMPS', null, 'min'), // 00:00
          ],
        ),
        SizedBox(height: 200), // hotfix for now
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffoldBody(body: _body(context),),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

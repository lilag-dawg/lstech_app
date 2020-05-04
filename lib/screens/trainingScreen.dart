import 'package:flutter/material.dart';

import '../widgets/powerDisplay.dart';
import '../widgets/secondaryDashBoardData.dart';
import '../widgets/endTraining.dart';
import '../constants.dart' as Constants;

class MyTrainingScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wattza training',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Constants.greyColor
      ),
      backgroundColor: Constants.backGroundColor,
      body: SingleChildScrollView(
        child: Column( 
          children: <Widget>[
            SizedBox(height:40),
            Row(
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width*(0.7/5.5)),
                MyPowerDisplay(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MySecondaryDashBoardData(Icons.rotate_right, 'CADENCE', '100', 'RPM'),
                MySecondaryDashBoardData(Icons.location_on, 'DISTANCE', '120', 'm'),
              ],
            ),
            SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MySecondaryDashBoardData(Icons.directions_bike, 'VITESSE', '12.5', 'kmph'),
                MySecondaryDashBoardData(Icons.alarm, 'TEMPS', '00:00', 'min'),
              ],
            ),
            SizedBox(height:40),
            MyEndTraining()
          ],
        ),
      ),
    );
  }
}
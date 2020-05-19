import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../models/streamPackage.dart';
import '../constants.dart' as Constants;

class MyPrimaryDashBoardUI extends StatelessWidget {
  final StreamPackage widgetData;
  final String data = '20';
  final String units = 'Watts';
  MyPrimaryDashBoardUI(this.widgetData);

    Widget _buildConnextionStatus(double diamCircle1) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: widgetData.getConnexion(),
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothDeviceState.connected) {
          print(state.toString());
          return _buildDataStream(diamCircle1);
        }
        return Icon(
          Icons.cancel,
          color: Colors.red,
        );
      },
    );
  }

    Widget _buildDataStream(double diamCircle1) {
    return StreamBuilder<int>(
      stream: widgetData.getStream(),
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          return Text(
              value.toString(),
              style: TextStyle(
                fontSize: (diamCircle1/187.013)*90,
              ),
            );
        }
        return _buildNoDataPresent(diamCircle1);
      },
    );
  }

    Widget _buildNoDataPresent( double diamCircle1) {
    return Text(
              "-",
              style: TextStyle(
                fontSize: (diamCircle1/187.013)*90,
              ),
            );
  }

  @override
  Widget build(BuildContext context) {
    double diamCircle1 = MediaQuery.of(context).size.width*(2.5/5.5);
    double diamCircle2 = MediaQuery.of(context).size.width*(1.2/5.5);

    return Stack(
      children: <Widget>[
        Container(
          width: diamCircle1 + (MediaQuery.of(context).size.width*(0.5/5.5)), 
          height: diamCircle1 + (MediaQuery.of(context).size.width*(0.5/5.5)),
        ),
        Container(
          width: diamCircle1,
          height: diamCircle1,
          child: Center(
            child: (widgetData != null)
                ? _buildConnextionStatus(diamCircle1)
                : _buildNoDataPresent(diamCircle1),
          ),
          decoration: BoxDecoration(
            color: Constants.greyColor,
            shape: BoxShape.circle
          ),
        ),
        Positioned(
          left: diamCircle1-(MediaQuery.of(context).size.width*(0.8/5.5)),
          top: diamCircle1-(MediaQuery.of(context).size.width*(0.9/5.5)),
          child: Container(
            width: diamCircle2,
            height: diamCircle2,
            child: Center(
              child: Text(
                units,
                style: TextStyle(
                  fontSize: (diamCircle2/89.766)*25,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Constants.backGroundColor,
              shape: BoxShape.circle
            ),
          ),
        )
      ], 
    );
  }
}


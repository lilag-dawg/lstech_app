import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../models/streamPackage.dart';

import 'iconTitle.dart';

class MySecondaryDashBoardData extends StatelessWidget {
  final IconData widgetIcon;
  final String widgetTitle;
  final String widgetUnits;
  final StreamPackage widgetData;

  MySecondaryDashBoardData(
      this.widgetIcon, this.widgetTitle, this.widgetData, this.widgetUnits);

  Widget _buildConnextionStatus(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: widgetData.getConnexion(),
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothDeviceState.connected) {
          print(state.toString());
          return _buildDataStream(context);
        }
        widgetData.characteristicStreamingStatus(false);
        return Icon(
          Icons.cancel,
          color: Colors.red,
        );
      },
    );
  }

  Widget _buildDataStream(BuildContext context) {
    return StreamBuilder<int>(
      stream: widgetData.getStream(),
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          return Text(
            value.toString(),
            style: TextStyle(
              fontSize:
                  (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) *
                      40,
            ),
          );
        }
        return _buildNoDataPresent(context);
      },
    );
  }

  Widget _buildNoDataPresent(BuildContext context) {
    return Text(
      "- ",
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize:
            (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) * 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyIconTitle(
          widgetIcon,
          widgetTitle,
          widgetFontWeight: FontWeight.bold,
        ),
        Row(
          children: <Widget>[
            (widgetData != null)
                ? _buildConnextionStatus(context)
                : _buildNoDataPresent(context),
            Container(
              height:
                  (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) *
                      32,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  widgetUnits,
                  style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.width *
                            (1.2 / 5.5) /
                            89.766) *
                        15,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

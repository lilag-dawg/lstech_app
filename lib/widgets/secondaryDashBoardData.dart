import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../models/streamPackage.dart';

import 'iconTitle.dart';

import '../databases/reading_model.dart';
import '../databases/base_db.dart';
import '../databases/reading_value_model.dart';

class MySecondaryDashBoardData extends StatelessWidget {
  final IconData widgetIcon;
  final String widgetTitle;
  final String widgetUnits;
  final StreamPackage widgetData;
  final int currentSessionId;
  final String readingType;
  final String readingValueTableName;

  Text dataString;

  MySecondaryDashBoardData(
      this.widgetIcon,
      this.widgetTitle,
      this.widgetData,
      this.widgetUnits,
      this.currentSessionId,
      this.readingType,
      this.readingValueTableName);

  Widget _buildConnextionStatus(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: widgetData.getConnexion(),
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothDeviceState.connected) {
          return _buildDataStream(context);
        }
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
          return FutureBuilder<void>(
            future: storeData(value, context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return dataString;
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return dataString;
                case ConnectionState.done:
                  return dataString;
                default:
                  return dataString;
              }
            },
          );
        }
        return _buildNoDataPresent(context);
      },
    );
  }

  Future<void> storeData(int value, BuildContext context) async {
    var reading = ReadingTableModel(
        timeOfReading: DateTime.now().millisecondsSinceEpoch,
        readingType: readingType,
        sessionId: currentSessionId);
    await DatabaseProvider.insert(ReadingTableModel.tableName, reading);

    var readingValue =
        ReadingValueTableModel(value: value, readingId: currentSessionId);
    await DatabaseProvider.insert(readingValueTableName, readingValue);

    dataString = Text(
      value.toString(),
      style: TextStyle(
        fontSize:
            (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) * 40,
      ),
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
    dataString = _buildNoDataPresent(context);
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

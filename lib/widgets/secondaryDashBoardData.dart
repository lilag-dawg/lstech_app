import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../models/streamPackage.dart';

import 'iconTitle.dart';

import '../databases/reading_model.dart';
import '../databases/base_db.dart';
import '../databases/reading_value_model.dart';
import '../databases/history_helper.dart';

class MySecondaryDashBoardData extends StatelessWidget {
  final IconData widgetIcon;
  final String widgetTitle;
  final String widgetUnits;
  final StreamPackage widgetData;
  final String readingType;
  final String readingValueTableName;
  final bool isTrainingStarted;

  //Text dataString;

  MySecondaryDashBoardData(this.widgetIcon, this.widgetTitle, this.widgetData,
      this.widgetUnits, this.readingType, this.readingValueTableName, this.isTrainingStarted);

  Widget _buildConnextionStatus(BuildContext context, Text dataString) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: widgetData.getConnexion(),
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothDeviceState.connected) {
          return _buildDataStream(context, dataString);
        }
        return Icon(
          Icons.cancel,
          color: Colors.red,
        );
      },
    );
  }

  Widget _buildDataStream(BuildContext context, Text dataString) {
    return StreamBuilder<int>(
      stream: widgetData.getStream(),
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          return FutureBuilder<void>(
            future: updateData(value, context, dataString),
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

  Future<void> updateData(int value, BuildContext context, Text dataString) async {

    if(isTrainingStarted) {
      await storeData(value, context, dataString);
    }
    
    dataString = Text(
      value.toString(),
      style: TextStyle(
        fontSize:
            (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) * 40,
      ),
    );
  }

  Future<void> storeData(
      int value, BuildContext context, Text dataString) async {
    var reading = ReadingTableModel(
        timeOfReading: DateTime.now().millisecondsSinceEpoch,
        readingType: readingType,
        sessionId: await HistoryHelper.getMostRecentSessionId());
    await DatabaseProvider.insert(ReadingTableModel.tableName, reading);

    var readingValue = ReadingValueTableModel(
        value: value, readingId: await HistoryHelper.getMostRecentSessionId());
    await DatabaseProvider.insert(readingValueTableName, readingValue);
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
    Text dataString = _buildNoDataPresent(context);
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
                ? _buildConnextionStatus(context, dataString)
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

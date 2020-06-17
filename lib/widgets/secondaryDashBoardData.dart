import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../models/streamPackage.dart';

import 'iconTitle.dart';

import '../databases/reading_model.dart';
import '../databases/base_db.dart';
import '../databases/reading_value_model.dart';
import '../databases/history_helper.dart';
import '../databases/session_model.dart';

class MySecondaryDashBoardData extends StatefulWidget {
  final IconData widgetIcon;
  final String widgetTitle;
  final String widgetUnits;
  final StreamPackage widgetData;
  final String readingType;
  final String readingValueTableName;
  final bool isTrainingOngoing;

  //Text dataString;

  MySecondaryDashBoardData(this.widgetIcon, this.widgetTitle, this.widgetData,
      this.widgetUnits, this.readingType, this.readingValueTableName, this.isTrainingOngoing);

  @override
  _MySecondaryDashBoardDataState createState() => _MySecondaryDashBoardDataState();
}

class _MySecondaryDashBoardDataState extends State<MySecondaryDashBoardData> {

  Text dataString;


  Widget _buildConnextionStatus(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: widget.widgetData.getConnexion(),
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
      stream: widget.widgetData.getStream(),
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          //print(dataString.data);
          //print(value);
          return FutureBuilder<void>(
            future: updateData(value, context),
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

  Future<void> updateData(int value, BuildContext context) async {

    if(widget.isTrainingOngoing) {
      await storeData(value, context);
    }
    await DatabaseProvider.query(SessionTableModel.tableName); // need an await function to be executed in all cases - xd -

    dataString = Text(
      value.toString(),
      style: TextStyle(
        fontSize:
            (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) * 40,
      ),
    );
  }

  Future<void> storeData(
      int value, BuildContext context) async {
    var reading = ReadingTableModel(
        timeOfReading: DateTime.now().millisecondsSinceEpoch,
        readingType: widget.readingType,
        sessionId: await HistoryHelper.getMostRecentSessionId());
    await DatabaseProvider.insert(ReadingTableModel.tableName, reading);

    var readingValue = ReadingValueTableModel(
        value: value, readingId: await HistoryHelper.getMostRecentSessionId());
    await DatabaseProvider.insert(widget.readingValueTableName, readingValue);
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
          widget.widgetIcon,
          widget.widgetTitle,
          widgetFontWeight: FontWeight.bold,
        ),
        Row(
          children: <Widget>[
            (widget.widgetData != null)
                ? _buildConnextionStatus(context)
                : _buildNoDataPresent(context),
            Container(
              height:
                  (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) *
                      32,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  widget.widgetUnits,
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


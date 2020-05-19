import 'package:flutter/material.dart';

import 'iconTitle.dart';
import 'primaryDashBoardUI.dart';
import '../models/streamPackage.dart';

class MyPrimaryDashBoardData extends StatelessWidget {
  final StreamPackage widgetData;
  MyPrimaryDashBoardData(this.widgetData);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*(4.5/5.5),
      height: MediaQuery.of(context).size.width*(3.5/5.5)-10,
      child: Column(
        children: <Widget>[
          MyIconTitle(Icons.offline_bolt, 'PUISSANCE', widgetFontWeight: FontWeight.bold),
          Row(
            children: <Widget>[
              SizedBox(width:MediaQuery.of(context).size.width*(0.8/5.5)),
              MyPrimaryDashBoardUI(widgetData),
            ],
          ),
        ],
      ),
    );
  }
}
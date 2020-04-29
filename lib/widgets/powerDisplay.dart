import 'package:flutter/material.dart';

import 'iconTitle.dart';
import 'powerDashBoard.dart';

class MyPowerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*(4.5/5.5),
      height: MediaQuery.of(context).size.width*(3.5/5.5),
      child: Column(
        children: <Widget>[
          MyIconTitle(Icons.offline_bolt, 'PUISSANCE', widgetFontWeight: FontWeight.bold),
          Row(
            children: <Widget>[
              SizedBox(width:MediaQuery.of(context).size.width*(0.8/5.5)),
              MyPowerDashBoard(),
            ],
          ),
        ],
      ),
    );
  }
}
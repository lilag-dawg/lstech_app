import 'package:flutter/material.dart';

import 'iconTitle.dart';

class MySecondaryDashBoardData extends StatelessWidget {

  final IconData widgetIcon;
  final String widgetTitle;
  final String widgetData;
  final String widgetUnits;

  MySecondaryDashBoardData(this.widgetIcon, this.widgetTitle, this.widgetData, this.widgetUnits);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyIconTitle(widgetIcon, widgetTitle, widgetFontWeight: FontWeight.bold,),
        Row(
          children: <Widget>[
            Text(
              widgetData,
              style: TextStyle(
                fontSize:(MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*40,
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*32,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  widgetUnits,
                  style: TextStyle(
                    fontSize:(MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*15,
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
import 'package:flutter/material.dart';

class MyIconTitle extends StatelessWidget {

  final IconData widgetIcon;
  final String widgetTite;
  final FontWeight widgetFontWeight;
  final double widgetIconSize;
  final double widgetTextSize;
  final bool isAutoSize;

  MyIconTitle(this.widgetIcon, this.widgetTite, {this.widgetFontWeight = FontWeight.normal, this.widgetIconSize = 20, this.isAutoSize = true, this.widgetTextSize = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          widgetIcon,
          size: isAutoSize? (MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*25: widgetIconSize,
        ),
        SizedBox(width:5),
        Text(
          widgetTite,
          style: TextStyle(
            fontSize: isAutoSize?(MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*20:widgetTextSize,
            fontWeight: widgetFontWeight, 
          ),
        ),
      ],
    );
  }
}
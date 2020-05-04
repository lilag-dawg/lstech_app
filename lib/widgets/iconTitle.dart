import 'package:flutter/material.dart';

class MyIconTitle extends StatelessWidget {

  final IconData widgetIcon;
  final String widgetTite;
  final FontWeight widgetFontWeight;
  final double widgetFontSize;

  MyIconTitle(this.widgetIcon, this.widgetTite, {this.widgetFontWeight = FontWeight.normal, this.widgetFontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          widgetIcon,
          size: (MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*(widgetFontSize+5),
        ),
        SizedBox(width:10),
        Text(
          widgetTite,
          style: TextStyle(
            fontSize:(MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*widgetFontSize,
            fontWeight: widgetFontWeight, 
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class MyIconTitle extends StatelessWidget {

  final IconData widgetIcon;
  final String widgetTite;
  final FontWeight widgetFontWeight;

  MyIconTitle(this.widgetIcon, this.widgetTite, {this.widgetFontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          widgetIcon,
          size: 25,
        ),
        SizedBox(width:10),
        Text(
          widgetTite,
          style: TextStyle(
            fontSize:25,
            fontWeight: widgetFontWeight, 
          ),
        ),
      ],
    );
  }
}
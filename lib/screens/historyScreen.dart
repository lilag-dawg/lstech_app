import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class MyHistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wattza history',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Constants.greyColor
      ),
      backgroundColor: Constants.backGroundColor,
    );
  }
}
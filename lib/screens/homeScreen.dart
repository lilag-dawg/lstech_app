import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class MyHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wattza home',
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
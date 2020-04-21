import 'package:flutter/material.dart';

import '../widgets/powerDisplay.dart';
import '../constants.dart' as Constants;

class MyTrainingScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wattza training',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Constants.greyColor
      ),
      backgroundColor: Constants.backGroundColor,
      body: SingleChildScrollView(
        child: MyPowerDisplay(),
      ),
    );
  }
}
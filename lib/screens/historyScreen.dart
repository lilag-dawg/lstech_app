import 'package:flutter/material.dart';

import '../widgets/customAppBar.dart';

import '../constants.dart' as Constants;

class MyHistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAppBar(),
      backgroundColor: Constants.backGroundColor,
    );
  }
}
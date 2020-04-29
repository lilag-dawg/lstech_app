import 'package:flutter/material.dart';
import '../widgets/customScaffoldBody.dart';

import '../constants.dart' as Constants;

class MyHistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffoldBody(),
      backgroundColor: Constants.backGroundColor,
    );
  }
}
import 'package:flutter/material.dart';


import '../constants.dart' as Constants;
import '../widgets/customScaffoldBody.dart';

class MyHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffoldBody(),
      backgroundColor: Constants.backGroundColor,
    );
  }
}
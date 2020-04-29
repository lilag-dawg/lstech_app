import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class MyPowerDashBoard extends StatelessWidget {

  final String data = '20';
  final String units = 'Watts';

  @override
  Widget build(BuildContext context) {
    double diamCircle1 = MediaQuery.of(context).size.width*(2.5/5.5);
    double diamCircle2 = MediaQuery.of(context).size.width*(1.2/5.5);

    return Stack(
      children: <Widget>[
        Container(
          width: diamCircle1 + (MediaQuery.of(context).size.width*(0.5/5.5)), 
          height: diamCircle1 + (MediaQuery.of(context).size.width*(0.5/5.5)),
        ),
        Container(
          width: diamCircle1,
          height: diamCircle1,
          child: Center(
            child: Text(
              data,
              style: TextStyle(
                fontSize: (diamCircle1/187.013)*90,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Constants.greyColor,
            shape: BoxShape.circle
          ),
        ),
        Positioned(
          left: diamCircle1-(MediaQuery.of(context).size.width*(0.8/5.5)),
          top: diamCircle1-(MediaQuery.of(context).size.width*(0.9/5.5)),
          child: Container(
            width: diamCircle2,
            height: diamCircle2,
            child: Center(
              child: Text(
                units,
                style: TextStyle(
                  fontSize: (diamCircle2/89.766)*25,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
          ),
        )
      ], 
    );
  }
}


import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class MyBatteryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            left: 5,
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              height: 80,
              decoration: BoxDecoration(
                  color: Constants.greyColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Positioned(
            top: 40,
            left: 200,
            child: Container(
                width: 180,
                child: Text(
                  'Environ 35 heures d\'autonomie restantes',
                  style: TextStyle(fontSize: 18),
                )),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: Icon(
              Icons.battery_full,
              color: Colors.grey[800],
              size: 40,
            ),
          ),
          Positioned(
            top: 47,
            left: 60,
            child: Text(
              '100' + '%',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

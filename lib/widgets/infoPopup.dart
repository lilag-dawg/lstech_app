import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class MyInfoPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width-50,
        height: (MediaQuery.of(context).size.height/2) - 50,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width-50,
              height: (MediaQuery.of(context).size.height/2) - 50,
              color: Constants.greyColorSelected,
            ),
            Container(
              width: 50,
              height: 50,
              child: FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                child: Icon(
                  Icons.close
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
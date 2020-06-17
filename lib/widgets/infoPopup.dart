import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class MyInfoPopup extends StatelessWidget {

  String imagePath;

  MyInfoPopup(this.imagePath);

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
              child: Image.asset(
                imagePath,
                width: MediaQuery.of(context).size.width-50,
                height: MediaQuery.of(context).size.height * 0.256,
              ),
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
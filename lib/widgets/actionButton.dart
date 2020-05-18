import 'package:flutter/material.dart';

class MyActionButton extends StatelessWidget {

  final String title;
  final Function _onActionButtonPressed;

  MyActionButton(this.title, this._onActionButtonPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width -10,
      height: 30,
      child: FlatButton(
        child: Text(
          title,
        ),
        onPressed: (){
          _onActionButtonPressed();
        },
      ),
    );
  }
}
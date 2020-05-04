import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../constants.dart' as Constants;

class MyEndTraining extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slidable(
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.chevron_left,
              size: 60,
            ),
            title: Text(
              'Glisser pour terminer',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              'Slide to end',
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Terminer',
            color: Constants.greyColor,
            icon: Icons.stop,
            onTap: (){},
          ),
          IconSlideAction(
            caption: 'Pause',
            color: Constants.greyColor,
            icon: Icons.pause,
            onTap: (){},
          ),
        ],
      )
    );
  }
}
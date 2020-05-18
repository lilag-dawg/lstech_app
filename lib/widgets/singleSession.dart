import 'package:flutter/material.dart';

class SingleSession extends StatelessWidget {
  final String timeString;
  final String resultString;
  final Color buttonColor;
  final Map<String, dynamic> session;
  final Function(Map<String, dynamic> session) onSessionSelected;

  SingleSession(
    this.resultString,
    this.timeString,
    this.buttonColor,
    this.session,
    this.onSessionSelected,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        color: Colors.white, // changer la couleur
        child: Row(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration:
                    BoxDecoration(color: buttonColor, shape: BoxShape.circle)),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  timeString,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  resultString,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        onPressed: () => {onSessionSelected(session)},
      ),
    );
  }
}

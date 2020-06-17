import 'package:flutter/material.dart';
import '../constants.dart' as Constants;

class SexDialog extends StatefulWidget {
  final String _initialSexString;
  SexDialog(this._initialSexString);
  @override
  State<StatefulWidget> createState() {
    return SexDialogState();
  }
}

class SexDialogState extends State<SexDialog> {
  String _sexString;
  bool _isSexInitialized = false;

  void _sexMaleCheckboxClicked(bool state) => setState(() { _sexString = 'Homme';});
  void _sexFemaleCheckboxClicked(bool state) => setState(() { _sexString = 'Femme';});
  void _sexOtherCheckboxClicked(bool state) => setState(() { _sexString = 'Autre';});

  @override
  Widget build(BuildContext context) {
    if (!_isSexInitialized) {
      _sexString = widget._initialSexString;
      _isSexInitialized = true;
    }

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width/3,
            child: Center(
              child: Text(
                'Sexe ',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Homme'),
                  Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text('Femme')),
                  Text('Autre'),
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                    value: _sexString == 'Homme',
                    onChanged: _sexMaleCheckboxClicked),
                Checkbox(
                    value: _sexString == 'Femme',
                    onChanged: _sexFemaleCheckboxClicked),
                Checkbox(
                    value: _sexString == 'Autre',
                    onChanged: _sexOtherCheckboxClicked)
              ],
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Envoyer"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(_sexString);
              },
            ),
          ),
        ],
      ),
    );
  }
}

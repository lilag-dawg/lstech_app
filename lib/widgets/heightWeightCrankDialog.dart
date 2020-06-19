import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class HeightWeightCrankDialog extends StatefulWidget {
  final double initialValue;
  final bool isHeight;
  final bool isWeight;
  final bool isCrank;

  HeightWeightCrankDialog(
      {@required this.initialValue,
      @required this.isHeight,
      @required this.isWeight,
      @required this.isCrank});

  @override
  _HeightWeightDialogState createState() => _HeightWeightDialogState();
}

class _HeightWeightDialogState extends State<HeightWeightCrankDialog> {
  List<double> _maxValues = [500, 250, 100]; // Kg, Cm, Cm
  List<double> _minValues = [20, 50, 0]; // Kg, Cm, Cm
  double _measure;
  bool _isMeasureInitialized = false;
  int _profilIndex;
  String title;

  void _addButtonClicked() {
    if (_measure < _maxValues[_profilIndex]) {
      setState(() {
        _measure += 1;
      });
    }
  }

  void _removeButtonClicked() {
    if (_measure > _minValues[_profilIndex]) {
      setState(() {
        _measure -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCrank) {
      _profilIndex = 2;
      title = 'Manivele du pédalier';
    }
    if (widget.isHeight) {
      _profilIndex = 1;
      title = 'Grandeur';
    }
    if (widget.isWeight) {
      _profilIndex = 0;
      title = 'Poid';
    }
    if (!_isMeasureInitialized) {
      _measure = widget.initialValue;
      _isMeasureInitialized = true;
    }
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Text(
              title,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 70,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Icon(Icons.remove_circle_outline),
                      onPressed: _removeButtonClicked,
                    ),
                  ),
                ),
                Container(
                  width: 90,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                      _measure.toString() + (widget.isWeight ? ' lbs' : ' cm'),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline)),
                ),
                SizedBox(
                  width: 70,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Icon(Icons.add_circle_outline),
                      onPressed: _addButtonClicked,
                    ),
                  ),
                )
              ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Envoyer"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(_measure.toString());
              },
            ),
          ),
        ],
      ),
    );
  }
}

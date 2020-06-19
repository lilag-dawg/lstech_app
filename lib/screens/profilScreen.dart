import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lstech_app/widgets/heightWeightCrankDialog.dart';
import 'package:lstech_app/widgets/infoPopup.dart';
import 'package:lstech_app/widgets/modifyProfilInfo.dart';
import 'package:lstech_app/widgets/sexDialog.dart';

import '../constants.dart' as Constants;

class MyProfilScreen extends StatefulWidget {
  @override
  _MyProfilScreenState createState() => _MyProfilScreenState();
}

class _MyProfilScreenState extends State<MyProfilScreen> {
  String _heightString = '120';
  String _crankString = '17';
  String _weightString = '180';
  String _sexString = 'Homme';
  DateTime _dateTime = DateTime(1997, 01, 07);

  void _heightButtonClicked() async {
    _heightString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightCrankDialog(
            initialValue: double.parse(_heightString),
            isHeight: true,
            isWeight: false,
            isCrank: false,
          );
        });
    setState(() {
      _heightString = _heightString;
    });
  }

  void _weightButtonClicked() async {
    _weightString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightCrankDialog(
            initialValue: double.parse(_weightString),
            isHeight: false,
            isWeight: true,
            isCrank: false,
          );
        });
    setState(() {
      _weightString = _weightString;
    });
  }

  void _crankButtonClicked() async {
    _crankString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightCrankDialog(
            initialValue: double.parse(_crankString),
            isHeight: false,
            isWeight: false,
            isCrank: true,
          );
        });
    setState(() {
      _crankString = _crankString;
    });
  }

  void _sexButtonClicked() async {
    _sexString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SexDialog(_sexString);
        });
    setState(() {
      _sexString = _sexString;
    });
  }

  void _dateButtonClicked() {
    showDatePicker(
            context: context,
            initialDate: DateTime(1997, 01, 07),
            firstDate: DateTime(1900),
            lastDate: DateTime(2222))
        .then((date) {
      if (date != null) {
        setState(() {
          _dateTime = date;
        });
      }
    });
  }

  void _crankInfoButtonClicked() async {
    _sexString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MyInfoPopup('assets/crankImage.jpg');
        });
  }

  void _weightInfoButtonClicked() async {
    _sexString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MyInfoPopup('assets/weightImage.jpg');
        });
  }

  void _heightInfoButtonClicked() async {
    _sexString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MyInfoPopup('assets/heightImage.jpg');
        });
  }

  void _birthInfoButtonClicked() async {
    _sexString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MyInfoPopup('assets/calendarImage.jpg');
        });
  }

  void _genderInfoButtonClicked() async {
    _sexString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MyInfoPopup('assets/genderImage.jpg');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width - 10,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Constants.greyColor,
          ),
          child: Stack(children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  child: Center(
                    child: Text('Disposition des valeurs d\'entrainement'),
                  ),
                ),
                RaisedButton(
                  color: Constants.backGroundColor,
                  child: Text('Configurer la page d\'entrainement'),
                  onPressed: () {},
                )
              ],
            )
          ]),
        ),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width - 10,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Constants.greyColor,
          ),
          child: Stack(children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  child: Center(
                    child: Text('Informations du vélo'),
                  ),
                ),
                SizedBox(height: 20),
                ModifyProfilInfo('Manivelle du pédalier', _crankString, 'cm',
                    _crankInfoButtonClicked, _crankButtonClicked)
              ],
            )
          ]),
        ),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width - 10,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Constants.greyColor,
          ),
          child: Stack(children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  child: Center(
                    child: Text('Informations personnelles'),
                  ),
                ),
                SizedBox(height: 20),
                ModifyProfilInfo('Poid', _weightString, 'lbs',
                    _weightInfoButtonClicked, _weightButtonClicked),
                Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 2,
                    color: Colors.grey[600]),
                ModifyProfilInfo('Grandeur', _heightString, 'cm',
                    _heightInfoButtonClicked, _heightButtonClicked),
                Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 2,
                    color: Colors.grey[600]),
                ModifyProfilInfo('Sexe', _sexString, '',
                    _genderInfoButtonClicked, _sexButtonClicked),
                Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 2,
                    color: Colors.grey[600]),
                ModifyProfilInfo(
                    'Date de naissance',
                    DateFormat('yMMMd').format(_dateTime),
                    '',
                    _birthInfoButtonClicked,
                    _dateButtonClicked),
              ],
            )
          ]),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/modifyProfilInfo.dart';

import '../constants.dart' as Constants;

class MyProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width -10,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Constants.greyColor,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width -10,
                    child: Center(
                      child: Text(
                        'Disposition des valeurs d\'entrainement'
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Configurer la page d\'entrainement'),
                    onPressed: (){},
                  )
                ],
              )
            ]
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width -10,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Constants.greyColor,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width -10,
                    child: Center(
                      child: Text(
                        'Informations du vélo'
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ModifyProfilInfo('Manivelle du pédalier', '17', 'cm', null, null)
                ],
              )
            ]
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width -10,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Constants.greyColor,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width -10,
                    child: Center(
                      child: Text(
                        'Informations personnelles'
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ModifyProfilInfo('Poid', '180', 'lbs', null, null),
                  Container(width: MediaQuery.of(context).size.width -20, height: 2, color: Colors.grey[600]),
                  ModifyProfilInfo('Grandeur', '120', 'cm', null, null),
                  Container(width: MediaQuery.of(context).size.width -20, height: 2, color: Colors.grey[600]),
                  ModifyProfilInfo('Sexe', 'Féminin', 'lbs', null, null),
                  Container(width: MediaQuery.of(context).size.width -20, height: 2, color: Colors.grey[600]),
                  ModifyProfilInfo('Date de naissance', '15', 'Avril 1991', null, null),
                ],
              )
            ]
          ),
        ),
      ],
    );
  }
}
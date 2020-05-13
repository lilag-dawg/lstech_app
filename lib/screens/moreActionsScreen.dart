import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/actionButton.dart';

import '../constants.dart' as Constants;

class MyMoreActionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 20,
          left: 5,
          child: Container(
            width: MediaQuery.of(context).size.width -10,
            height: 200,
            decoration: BoxDecoration(
              color: Constants.greyColor,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
        Positioned(
          left: 5,
          top: 20,
          child: Container(
            width: MediaQuery.of(context).size.width -10,
            height: 20,
            child: Center(
              child: Text(
                'Plus d\'actions'
              ),
            ),
          )
        ),
        Positioned(
          top:60,
          left: 5,
          child: Column(
            children: <Widget>[
              MyActionButton('Obtenir de l\'aide', null),
              Container(width: MediaQuery.of(context).size.width -20, height: 2, color: Colors.grey[600]),
              MyActionButton('Lire la police de confidentialité', null),
              Container(width: MediaQuery.of(context).size.width -20, height: 2, color: Colors.grey[600]),
              MyActionButton('Lire les termes d\'utilisation', null),
              Container(width: MediaQuery.of(context).size.width -20, height: 2, color: Colors.grey[600]),
              MyActionButton('Rapporter un bug', null),
              Container(width: MediaQuery.of(context).size.width -20, height: 2, color: Colors.grey[600]),
              MyActionButton('En savoir plus sur LS Tech +', null),
            ],
          ),
        )
      ],
    );
  }
}
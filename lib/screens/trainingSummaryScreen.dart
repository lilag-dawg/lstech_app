import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/iconTitle.dart';

import '../widgets/lowerNavigationBar.dart';
import '../widgets/customAppBar.dart';

import '../constants.dart' as Constants;

class MyTrainingScreenSummary extends StatelessWidget {

  final PageController _currentPage;
  final Function selectHandler;

  MyTrainingScreenSummary(this._currentPage, this.selectHandler);

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
        children: <Widget>[
          SizedBox(height:20),
          MyIconTitle(Icons.chevron_left, 'Sommaire d\'entrainement', widgetFontWeight: FontWeight.bold, widgetIconSize: 35, widgetTextSize: 25, isAutoSize: false),
          SizedBox(height:20),
          Row(
            children: <Widget>[
              SizedBox(width: 70),
              MyIconTitle(Icons.alarm, 'DURÉE', widgetFontWeight: FontWeight.bold),
              SizedBox(width: 73),
              Text(
                '45'+' min',                                   // Data de temps
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*20,
                  fontWeight: FontWeight.normal, 
                ),
              ),
            ],
          ),
          SizedBox(height:5),
          Row(
            children: <Widget>[
              SizedBox(width: 70),
              MyIconTitle(Icons.whatshot, 'CALORIES', widgetFontWeight: FontWeight.bold),
              SizedBox(width: 42),
              Text(
                '300'+' KCals',                                   // Data de calories
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*20,
                  fontWeight: FontWeight.normal, 
                ),
              ),
            ],
          ),
          SizedBox(height:5),
          Row(
            children: <Widget>[
              SizedBox(width: 70),
              MyIconTitle(Icons.location_on, 'DISTANCE', widgetFontWeight: FontWeight.bold),
              SizedBox(width: 40),
              Text(
                '15.3'+' m',                                   // Data de distance
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*20,
                  fontWeight: FontWeight.normal, 
                ),
              ),
            ],
          ),
          SizedBox(height:20),
          _dataSummary(context, Icons.offline_bolt, 'PUISSANCE', '670', '400', 'W', false),
          SizedBox(height:20),
          _dataSummary(context, Icons.offline_bolt, 'CADENCE', '100', '60', 'RPM', true),
          SizedBox(height:20),
          _dataSummary(context, Icons.offline_bolt, 'VITESSE', '35', '27', 'km/h', true)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: LowerNavigationBar(_currentPage, context, selectHandler),
      body: CustomAppBar(body: _body(context),),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

Widget _dataSummary (BuildContext context, IconData icon, String title, String dataMax, String dataAvg, String units, bool isUnfoldMore){
  
  return Container(
    child: Row(
      children: <Widget>[
        SizedBox(width: 20),
        Container(
          width: 140,
          child: MyIconTitle(Icons.offline_bolt, title, widgetFontWeight: FontWeight.bold)
        ),
        SizedBox(width:10),
        Container(width: 2, height: 60, color: Colors.black),
        SizedBox(width:10),
        Container(
          width: 180,
          child: Column(
            children: <Widget>[
              Text(
                'Maximale '+' ' + dataMax +' '+ units,
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*20,
                  fontWeight: FontWeight.normal, 
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Moyenne'+'   '+ dataAvg +' ' + units,
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width*(1.2/5.5)/89.766)*20,
                  fontWeight: FontWeight.normal, 
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        Icon(
          isUnfoldMore?Icons.unfold_more:Icons.unfold_less,
          size: 40,
        )
      ],
    ),
  );
}

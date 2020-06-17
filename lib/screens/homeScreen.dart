import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../constants.dart' as Constants;

class MyHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: _homeBody(context),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

Widget _homeBody (BuildContext context){

  String getTimeOfTheDay(){
    DateTime fourAM = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 4, 0, 0);
    DateTime elevenAM = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 11, 0, 0);
    DateTime onePM = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13, 0, 0);
    DateTime sixPM = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 0, 0);
    DateTime currentDate = DateTime.now();

    if ((currentDate.isAfter(fourAM) && currentDate.isBefore(elevenAM)) || currentDate.isAtSameMomentAs(elevenAM)){
      return 'Bon matin à vous!';
    }
    if ((currentDate.isAfter(elevenAM) && currentDate.isBefore(onePM)) || currentDate.isAtSameMomentAs(onePM)){
      return 'Bon midi à vous!' ;
    }
    if ((currentDate.isAfter(onePM) && currentDate.isBefore(sixPM)) || currentDate.isAtSameMomentAs(sixPM)){
      return 'Bon après-midi à vous!';
    }
    else{
      return 'Bon soir à vous!';
    }
  }

  var imageContainer = [
    Image.asset(
      'assets/avgPower.jpg',
      width: MediaQuery.of(context).size.width-50,
      height: MediaQuery.of(context).size.height * 0.256,
    ),
    Image.asset(
      'assets/maxPower.jpg',
      width: MediaQuery.of(context).size.width-50,
      height: MediaQuery.of(context).size.height * 0.256,
    ),
    Image.asset(
      'assets/medianPower.jpg',
      width: MediaQuery.of(context).size.width-50,
      height: MediaQuery.of(context).size.height * 0.256,
    ),
  ];

  return Column(
    children: <Widget>[
      SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            getTimeOfTheDay(),
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            'X Entrainements',
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width/2,
        height: 1.5,
        color: Colors.black
      ),
      SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width-50,
        height: MediaQuery.of(context).size.height * 0.256,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return imageContainer[index];
          },
          itemCount: 3,
          pagination: SwiperPagination(),
        ),
      ),
      SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width-50,
        height: MediaQuery.of(context).size.height * 0.256,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return imageContainer[index];
          },
          itemCount: 3,
          pagination: SwiperPagination(),
        ),
      )
    ],
  );
}



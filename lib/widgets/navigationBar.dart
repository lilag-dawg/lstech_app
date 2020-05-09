import 'package:flutter/material.dart';
import 'package:lstech_app/screens/trainingSummaryScreen.dart';

import '../screens/homeScreen.dart';
import '../screens/trainingScreen.dart';
import '../screens/historyScreen.dart';
import '../widgets/lowerNavigationBar.dart';
import '../constants.dart' as Constants;

double screenWidth;
double screenHeight;

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  static var _currentPage =
      PageController(initialPage: Constants.defaultPageIndex);

  List<Widget> _children;

  void _onItemTapped(int selected) {
    setState(() {
      //_currentPage.animateToPage(selected, duration: Duration(milliseconds: 500), curve: Curves.ease);
      _currentPage.jumpToPage(selected);
    });
  }


  void onHorizontalDrag(DragUpdateDetails details) {
    if (details.delta.dx > 3) {
      print("going left");
    }
    if (details.delta.dx < -3) {
      print("going right");
    }
    print(details.delta.dx);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    _children = [
      MyHomeScreen(),
      MyTrainingScreen(_currentPage, _onItemTapped),
      MyHistoryScreen(),
    ];

    return Scaffold(
      body: PageView(
        children: _children,
        controller: _currentPage,
        onPageChanged: (index){
          _onItemTapped(index);
        },
      ),
      bottomNavigationBar:
          LowerNavigationBar(_currentPage, null, _onItemTapped),
    );
  }
}

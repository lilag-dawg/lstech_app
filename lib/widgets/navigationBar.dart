import 'package:flutter/material.dart';

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
      _currentPage.jumpToPage(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    Constants.phoneWidth = MediaQuery.of(context).size.width;
    Constants.phoneHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;
    // screenHeight = MediaQuery.of(context).size.height;

    _children = [
      MyHomeScreen(),
      MyTrainingScreen(),
      MyHistoryScreen(),
    ];

    return Scaffold(
      body: PageView(
        children: _children,
        controller: _currentPage,
      ),
      bottomNavigationBar:
          LowerNavigationBar(_currentPage, null, _onItemTapped),
    );
  }
}

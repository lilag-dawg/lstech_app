import 'package:flutter/material.dart';
import './customAppBar.dart';
import '../constants.dart' as Constants;
import '../databases/base_db.dart';

double screenWidth;
double screenHeight;

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar>
    with TickerProviderStateMixin {
  TabController pageTabController;
  TabController tabController;

  int topSelectedIndex = Constants.defaultPageIndex;

  @override
  void initState() {
    pageTabController = TabController(initialIndex: 0, length: 3, vsync: this);
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    super.initState();
  }

  List<Widget> buildTabs() {
    return [
      Tab(
        icon: Icon(
          Icons.home,
        ),
        child: Text("Home",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
      ),
      Tab(
        icon: Icon(
          Icons.directions_bike,
        ),
        child: Text("Training",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
      ),
      Tab(
        icon: Icon(
          Icons.history,
        ),
        child: Text("History",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
      ),
    ];
  }

  Widget buildDisplay() {
    return Scaffold(
      body: CustomAppBar(
          pageTabController: pageTabController, tabController: tabController),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(25),
        child: TabBar(
          tabs: buildTabs(),
          controller: pageTabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Colors.black,
        ),
      ),
      backgroundColor: Constants.greyColor,
    );
  }

  Widget futureBody() {
    return FutureBuilder<void>(
      future: DatabaseProvider.database,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return buildDisplay();
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return futureBody();
  }
}

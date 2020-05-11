import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../screens/findDevicesScreen.dart';
import '../screens/homeScreen.dart';
import '../screens/trainingScreen.dart';
import '../screens/historyScreen.dart';

import '../models/bluetoothDeviceManager.dart';
import '../models/streamPackage.dart';

import '../constants.dart' as Constants;

class CustomAppBar extends StatefulWidget {
  final TabController pageTabController;
  final TabController tabController;
  CustomAppBar({this.pageTabController, this.tabController});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  bool isScrollingUp;
  bool isScollingDown;

  AnimationController animationController;
  Animation animation;

  void showTabs() {
    isScollingDown = true;
    isScrollingUp = false;
    animationController.forward();
  }

  void hideTabs() {
    isScollingDown = false;
    isScrollingUp = true;
    animationController.reverse();
  }

  void onVerticalDrag(DragUpdateDetails details) {
    if (details.delta.dy > 3) {
      if (!isScollingDown) {
        showTabs();
        //print("going down");
      }
    }
    if (details.delta.dy < -3) {
      if (!isScrollingUp) {
        hideTabs();
        //print("going up");
      }
    }
    //print(details.delta.dy);
  }

  @override
  void initState() {
    isScrollingUp = false;
    isScollingDown = false;

    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    final wattzaManager = Provider.of<BluetoothDeviceManager>(context);
    return _AnimatedAppBar(
      animation: animation,
      onVerticalDrag: onVerticalDrag,
      wattzaManager: wattzaManager,
      tabController: widget.tabController,
      showTabs: showTabs,
      pageTabController: widget.pageTabController,
    );
  }
}

class _AnimatedAppBar extends AnimatedWidget {
  _AnimatedAppBar(
      {Key key,
      Animation<double> animation,
      this.tabController,
      this.onVerticalDrag,
      this.showTabs,
      this.pageTabController,
      this.wattzaManager})
      : super(key: key, listenable: animation);

  final Function(DragUpdateDetails) onVerticalDrag;
  final BluetoothDeviceManager wattzaManager;
  final TabController tabController;
  final TabController pageTabController;
  final Function() showTabs;

  static final _sizeTween = Tween<double>(begin: 0.0, end: 15.0);

  List<Widget> buildTabs(StreamPackage connexionHandler) {
    return [
      Tab(
        child: _wattzaTitle(),
      ),
      Tab(
        child: _ConnexionIcon(connexionHandler, tabController, showTabs),
      ),
      Tab(child: _BatteryIcon(connexionHandler, tabController, showTabs)),
      Tab(
        child: IconButton(
            icon: Icon(
              Icons.dehaze,
              color: Colors.black,
            ),
            onPressed: () {
              tabController.animateTo(3);
              showTabs();
            }),
      ),
    ];
  }

  Widget _wattzaTitle() {
    return GestureDetector(
      onTap: () {
        tabController.animateTo(0);
        showTabs();
      },
      child: Text(
        'Wattza',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _appBarBottom() {
    return PreferredSize(
      preferredSize: Size.fromHeight(_sizeTween.evaluate(listenable)),
      child: (_sizeTween.evaluate(listenable) >= 10)
          ? Column(
              children: <Widget>[
                TabPageSelector(
                  controller: tabController,
                  selectedColor: Colors.black,
                ),
                Container(
                  height: 0,
                  child: Icon(Icons.arrow_drop_up),
                )
              ],
            )
          : Container(
              height: 0, // work in progress
              child: Icon(Icons.arrow_drop_down),
            ),
    );
  }

  Widget buildBodyView() {
    return TabBarView(
      controller: pageTabController,
      children: <Widget>[
        MyHomeScreen(),
        MyTrainingScreen(),
        MyHistoryScreen(),
      ],
    );
  }

  Widget buildTabBarView() {
    print(tabController.index);
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        Icon(Icons.home),
        FindDevicesScreen(wattzaManager),
        Icon(Icons.battery_full),
        Icon(Icons.dehaze)
      ],
    );
  }

  Widget build(BuildContext context) {
    StreamPackage connexionHandler = wattzaManager.getAppBarPackage();
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDrag,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Constants.greyColor,
              title: TabBar(
                tabs: buildTabs(connexionHandler),
                controller: tabController,
                isScrollable: true,
              ),
              bottom: _appBarBottom()),
          body: (_sizeTween.evaluate(listenable) >= 10)
              ? buildTabBarView()
              : buildBodyView()),
    );
  }
}

class _BatteryIcon extends StatelessWidget {
  final StreamPackage connexionHandler;
  final TabController tabController;
  final Function() showTabs;
  _BatteryIcon(
    this.connexionHandler,
    this.tabController,
    this.showTabs,
  );

  final double myWidth = 36;

  double ruleOf3(double value) {
    return ((value * myWidth) / 100);
  }

  Widget _buildBatteryIcon(StreamPackage connexionHandler) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: connexionHandler.getConnexion(),
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothDeviceState.connected) {
            return _batteryConnected(
                connexionHandler.getBatteryLevel().toDouble());
          }
          connexionHandler.characteristicStreamingStatus(false);
          return _batteryDisconnected();
        });
  }

  Widget _batteryConnected(double batteryLevel) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(children: <Widget>[
          Container(
            height: 22,
            width: myWidth + 2,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Stack(children: <Widget>[
              Container(
                alignment: Alignment(-1.0, 0.0),
                child: Container(
                  width: ruleOf3(batteryLevel),
                  decoration: BoxDecoration(
                      color: (ruleOf3(batteryLevel) > 10)
                          ? Colors.green
                          : Colors.red,
                      borderRadius: (ruleOf3(batteryLevel) != myWidth)
                          ? BorderRadius.only(
                              topLeft: Radius.circular(2),
                              bottomLeft: Radius.circular(2))
                          : BorderRadius.all(Radius.circular(2))),
                ),
              ),
              Center(
                  child: Text(
                batteryLevel.toStringAsFixed(0).toString() + " %",
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ))
            ]),
          ),
          Center(
            child: Container(
              height: 6,
              width: 2.5,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(1),
                      bottomRight: Radius.circular(1))),
            ),
          )
        ]),
      ),
    );
  }

  Widget _batteryDisconnected() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(children: <Widget>[
          Container(
              height: 22,
              width: myWidth + 2,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              child: Center(
                  child: Text("N/A",
                      style: TextStyle(color: Colors.black, fontSize: 13)))),
          Center(
            child: Container(
              height: 6,
              width: 2.5,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(1),
                      bottomRight: Radius.circular(1))),
            ),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: (connexionHandler != null)
          ? _buildBatteryIcon(connexionHandler)
          : _batteryDisconnected(),
      onTap: () {
        tabController.animateTo(2);
        showTabs();
      },
    );
  }
}

class _ConnexionIcon extends StatelessWidget {
  final StreamPackage connexionHandler;
  final TabController tabController;
  final Function() showTabs;
  _ConnexionIcon(this.connexionHandler, this.tabController, this.showTabs);

  Widget _buildBluetoothIcon(StreamPackage connexionHandler) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: connexionHandler.getConnexion(),
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothDeviceState.connected) {
            return Container(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.bluetooth_connected, color: Colors.green));
          }
          connexionHandler.characteristicStreamingStatus(false);
          return _buildDeviceDisconnected();
        });
  }

  Widget _buildDeviceDisconnected() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Icon(Icons.bluetooth_disabled, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: (connexionHandler != null)
          ? _buildBluetoothIcon(connexionHandler)
          : _buildDeviceDisconnected(),
      onTap: () {
        tabController.animateTo(1);
        showTabs();
      },
    );
  }
}

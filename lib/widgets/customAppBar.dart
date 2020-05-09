import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../screens/findDevicesScreen.dart';

import '../models/bluetoothDeviceManager.dart';
import '../models/streamPackage.dart';

import '../constants.dart' as Constants;

class CustomAppBar extends StatefulWidget {
  final Widget body;
  CustomAppBar({this.body});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
      
  bool isScrollingUp;
  bool isScollingDown;

  bool isTitledSelected;
  bool isBluetoothIconSelected;
  bool isBatteryIconSelected;
  bool isDrawerSelected;

  TabController _tabController;
  AnimationController controller;
  Animation animation;

  void showTabs() {
    isScollingDown = true;
    isScrollingUp = false;
    controller.forward();
  }

  void hideTabs() {
    isScollingDown = false;
    isScrollingUp = true;
    controller.reverse();
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

    isTitledSelected = true;
    isBluetoothIconSelected = false;
    isBatteryIconSelected = false;
    isDrawerSelected = false;

    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    _tabController = TabController(vsync: this, length: 4)
      ..addListener(_handleIndexChange);
    // TODO: implement initState
    super.initState();
  }

  void _handleIndexChange() {
    switch (_tabController.index) {
      case 0:
        isBluetoothIconSelected = false;
        isBatteryIconSelected = false;
        isDrawerSelected = false;
        setState(() {
          isTitledSelected = true;
        });
        break;
      case 1:
        isTitledSelected = false;
        isBatteryIconSelected = false;
        isDrawerSelected = false;
        setState(() {
          isBluetoothIconSelected = true;
        });
        break;
      case 2:
        isTitledSelected = false;
        isBluetoothIconSelected = false;
        isDrawerSelected = false;
        setState(() {
          isBatteryIconSelected = true;
        });
        break;
      case 3:
        isTitledSelected = false;
        isBluetoothIconSelected = false;
        isBatteryIconSelected = false;
        setState(() {
          isDrawerSelected = true;
        });
    }
  }

  Widget build(BuildContext context) {
    final wattzaManager = Provider.of<BluetoothDeviceManager>(context);
    return _AnimatedAppBar(
      animation: animation,
      onVerticalDrag: onVerticalDrag,
      externBody: widget.body,
      wattzaManager: wattzaManager,
      tabController: _tabController,
      isBatteryIconSelected: isBatteryIconSelected,
      isBluetoothIconSelected: isBluetoothIconSelected,
      isDrawerSelected: isDrawerSelected,
      isTitledSelected: isTitledSelected,
      showTabs: showTabs,
    );
  }
}

class _AnimatedAppBar extends AnimatedWidget {
  _AnimatedAppBar(
      {Key key,
      Animation<double> animation,
      this.tabController,
      this.onVerticalDrag,
      this.externBody,
      this.showTabs,
      this.isTitledSelected,
      this.isBatteryIconSelected,
      this.isBluetoothIconSelected,
      this.isDrawerSelected,
      this.wattzaManager})
      : super(key: key, listenable: animation);

  final Function(DragUpdateDetails) onVerticalDrag;
  final BluetoothDeviceManager wattzaManager;
  final Widget externBody;
  final TabController tabController;
  final Function() showTabs;

  final bool isTitledSelected;
  final bool isBluetoothIconSelected;
  final bool isBatteryIconSelected;
  final bool isDrawerSelected;

  static final _sizeTween = Tween<double>(begin: 0.0, end: 15.0);

  Widget _appBarTop(StreamPackage connexionHandler) {
    return Row(
      children: <Widget>[
        _wattzaTitle(isTitledSelected),
        SizedBox(
          width: 15,
        ),
        _ConnexionIcon(
            connexionHandler, tabController, showTabs, isBluetoothIconSelected),
        SizedBox(
          width: 15,
        ),
        _BatteryIcon(
            connexionHandler, tabController, showTabs, isBatteryIconSelected),
      ],
    );
  }

  Widget _wattzaTitle(bool isTitledSelected) {
    return GestureDetector(
      onTap: () {
        showTabs();
        tabController.animateTo(0);
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
          decoration: (isTitledSelected)
              ? BoxDecoration(
                  border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ))
              : null,
          child: Text(
            'Wattza',
            style: TextStyle(color: Colors.black),
          )),
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

  Widget build(BuildContext context) {
    StreamPackage connexionHandler = wattzaManager.getAppBarPackage();
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onVerticalDragUpdate: onVerticalDrag,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Constants.greyColor,
                title: _appBarTop(connexionHandler),
                actions: <Widget>[
                  Container(
                    decoration: (isDrawerSelected)
                        ? BoxDecoration(
                            border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ))
                        : null,
                    child: IconButton(
                        icon: Icon(
                          Icons.dehaze,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          showTabs();
                          tabController.animateTo(3);
                        }),
                  )
                ],
                bottom: _appBarBottom()),
            body: (_sizeTween.evaluate(listenable) >= 10)
                ? TabBarView(controller: tabController, children: [
                    Icon(Icons.home),
                    FindDevicesScreen(wattzaManager),
                    Icon(Icons.battery_full),
                    Icon(Icons.dehaze)
                  ])
                : externBody),
      ),
    );
  }
}

class _BatteryIcon extends StatelessWidget {
  final StreamPackage connexionHandler;
  final TabController tabController;
  final Function() showTabs;
  final bool isBatteryIconSelected;
  _BatteryIcon(this.connexionHandler, this.tabController, this.showTabs,
      this.isBatteryIconSelected);

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
        decoration: (isBatteryIconSelected)
            ? BoxDecoration(
                border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ))
            : null,
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
        decoration: (isBatteryIconSelected)
            ? BoxDecoration(
                border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ))
            : null,
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
        showTabs();
        tabController.animateTo(2);
      },
    );
  }
}

class _ConnexionIcon extends StatelessWidget {
  final bool isBluetoothIconSelected;
  final StreamPackage connexionHandler;
  final TabController tabController;
  final Function() showTabs;
  _ConnexionIcon(this.connexionHandler, this.tabController, this.showTabs,
      this.isBluetoothIconSelected);

  Widget _buildBluetoothIcon(StreamPackage connexionHandler) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: connexionHandler.getConnexion(),
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothDeviceState.connected) {
            return Container(
              padding: EdgeInsets.all(8.0),
                decoration: (isBluetoothIconSelected)
                    ? BoxDecoration(
                        border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ))
                    : null,
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
      decoration: (isBluetoothIconSelected)
          ? BoxDecoration(
              border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: (connexionHandler != null)
          ? _buildBluetoothIcon(connexionHandler)
          : _buildDeviceDisconnected(),
      onTap: () {
        showTabs();
        tabController.animateTo(1);
      },
    );
  }
}

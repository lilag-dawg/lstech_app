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

  AnimationController controller;
  Animation animation;

  void showTabs() {
    controller.forward();
  }
  void hideTabs() {
    controller.reverse();
  }

  void onVerticalDrag(DragUpdateDetails details) {
    if (details.delta.dy > 3) {
      if (!isScollingDown) {
        isScollingDown = true;
        isScrollingUp = false;
        showTabs();
        //print("going down");
      }
    }
    if (details.delta.dy < -3) {
      if (!isScrollingUp) {
        isScollingDown = false;
        isScrollingUp = true;
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
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    final wattzaManager = Provider.of<BluetoothDeviceManager>(context);
    return _AnimatedAppBar(
      animation: animation,
      onVerticalDrag: onVerticalDrag,
      body: widget.body,
      wattzaManager: wattzaManager,
    );
  }
}

class _AnimatedAppBar extends AnimatedWidget {
  _AnimatedAppBar(
      {Key key, Animation<double> animation, this.onVerticalDrag, this.body, this.wattzaManager})
      : super(key: key, listenable: animation);

  final Function(DragUpdateDetails) onVerticalDrag;
  final BluetoothDeviceManager wattzaManager;
  final Widget body;

  static final _sizeTween = Tween<double>(begin: 0.0, end: 80.0);

  Widget _appBarBottom() {
    return PreferredSize(
      preferredSize: Size.fromHeight(_sizeTween.evaluate(listenable)),
      child: (_sizeTween.evaluate(listenable) >= 74)
          ? Column(
              children: <Widget>[
                TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.bluetooth_connected),
                        text: "Bluetooth",
                      ),
                      Tab(
                        icon: Icon(Icons.account_circle),
                        text: "Profile",
                      ),
                    ]),
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
                title: Text(
                  'Wattza',
                  style: TextStyle(color: Colors.black),
                ),
                actions: <Widget>[
                  _ConnexionIcon(connexionHandler),
                  _BatteryIcon(connexionHandler),
                  //_BatteryIcon(wattzaManager),
                ],
                bottom: _appBarBottom()),
            body: (_sizeTween.evaluate(listenable) >= 74)
                ? TabBarView(children: [
                    FindDevicesScreen(wattzaManager),
                    Icon(Icons.account_circle)
                  ])
                : body),
      ),
    );
  }
}

class _BatteryIcon extends StatelessWidget {

    final StreamPackage connexionHandler;
  _BatteryIcon(this.connexionHandler);

  final double myWidth = 36;

  double ruleOf3(double value){
    return ((value*myWidth)/100);
  }

  Widget _buildBatteryIcon(StreamPackage connexionHandler) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: connexionHandler.getConnexion(),
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothDeviceState.connected) {
            return _batteryConnected(connexionHandler.getBatteryLevel().toDouble());
          }
          connexionHandler.characteristicStreamingStatus(false);
          return _batteryDisconnected();
        });
  }

  Widget _batteryConnected(double batteryLevel){
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
                      color: (ruleOf3(batteryLevel) > 10) ? Colors.green : Colors.red,
                      borderRadius: (ruleOf3(batteryLevel) != myWidth)
                          ? BorderRadius.only(
                              topLeft: Radius.circular(2),
                              bottomLeft: Radius.circular(2))
                          : BorderRadius.all(Radius.circular(2))),
                ),
              ),
              Center(
                child:Text(batteryLevel.toStringAsFixed(0).toString() + " %", style: TextStyle(color:Colors.black87),)
              )
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
  Widget _batteryDisconnected(){
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
              child: Text("N/A",style: TextStyle(color: Colors.black))
            )
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
  @override
  Widget build(BuildContext context) {
    return (connexionHandler != null)
        ? _buildBatteryIcon(connexionHandler)
        : _batteryDisconnected();
  }
}


class _ConnexionIcon extends StatelessWidget {
  final StreamPackage connexionHandler;
  _ConnexionIcon(this.connexionHandler);

  Widget _buildBluetoothIcon(StreamPackage connexionHandler) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: connexionHandler.getConnexion(),
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothDeviceState.connected) {
            return Icon(Icons.bluetooth_connected, color: Colors.green);
          }
          connexionHandler.characteristicStreamingStatus(false);
          return _buildDeviceDisconnected();
        });
  }

  Widget _buildDeviceDisconnected() {
    return Icon(Icons.bluetooth_disabled, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return (connexionHandler != null)
        ? _buildBluetoothIcon(connexionHandler)
        : _buildDeviceDisconnected();
  }
}

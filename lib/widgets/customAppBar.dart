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
    return _AnimatedAppBar(
      animation: animation,
      onVerticalDrag: onVerticalDrag,
      body: widget.body,
    );
  }
}

class _AnimatedAppBar extends AnimatedWidget {
  _AnimatedAppBar(
      {Key key, Animation<double> animation, this.onVerticalDrag, this.body})
      : super(key: key, listenable: animation);

  final Function(DragUpdateDetails) onVerticalDrag;
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
    final wattzaManager = Provider.of<BluetoothDeviceManager>(context);
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
                  _ConnexionIcon(wattzaManager),
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

class _ConnexionIcon extends StatelessWidget {
  final BluetoothDeviceManager wattzaManager;
  _ConnexionIcon(this.wattzaManager);

  Widget _buildBluetoothIcon(StreamPackage connexionHandler) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: connexionHandler.getConnexion(),
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothDeviceState.connected) {
            return Icon(Icons.bluetooth_connected, color: Colors.green);
          }
          return _buildDeviceDisconnected();
        });
  }

  Widget _buildDeviceDisconnected() {
    return Icon(Icons.bluetooth_disabled, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    StreamPackage connexionHandler = wattzaManager.getRpm();
    return (connexionHandler != null)
        ? _buildBluetoothIcon(connexionHandler)
        : _buildDeviceDisconnected();
  }
}

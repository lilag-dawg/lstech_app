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

class _CustomAppBarState extends State<CustomAppBar> {
  bool _show;
  bool isScrollingUp;
  bool isScollingDown;

  void showTabs() {
    setState(() {
      _show = true;
    });
  }

  void hideTabs() {
    setState(() {
      _show = false;
    });
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

  Widget _appBarBottom(bool show) {
    return PreferredSize(
      preferredSize: (show) ? Size.fromHeight(98.0) : Size.fromHeight(0.0),
      child: (show)
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

  @override
  void initState() {
    _show = false;
    isScrollingUp = false;
    isScollingDown = false;
    // TODO: implement initState
    super.initState();
  }

  @override
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
              bottom: _appBarBottom(_show)),
          body: (_show)
              ? TabBarView(
                  children: [FindDevicesScreen(wattzaManager), Icon(Icons.account_circle)])
              : widget.body,
        ),
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

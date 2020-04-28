import 'package:flutter/material.dart';

import './findDevicesScreen.dart';
import '../constants.dart' as Constants;

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  bool isBluetoothPressed;

  void onPress() {
    setState(() {
      isBluetoothPressed = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isBluetoothPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Wattza"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bluetooth_connected),
            onPressed: onPress,
          )
        ],
        bottom: (isBluetoothPressed)
            ? PreferredSize(
                child: Container(
                  height: 200,
                  child: FindDevicesScreen(),
                ),
                preferredSize: Size.fromHeight(200.0),
              )
            : PreferredSize(
                child: Container(
                  height: 0,
                ),
                preferredSize: Size.fromHeight(0.0),
              ),
        backgroundColor: Constants.greyColor,
      ),
      body: Container(child: Text("wasssuppp")),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

class MyHomeScreen2 extends StatelessWidget {
  final double defaultAppBarHeight = 56.0;
  final double expandedHeight = 400.0;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller:ScrollController(initialScrollOffset: expandedHeight - defaultAppBarHeight),
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: expandedHeight,
          floating: false,
          pinned: true,
          title: Text('Wattza'),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  child: FindDevicesScreen(),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => ListTile(
              title: Text("Index: $index"),
            ),
          ),
        )
      ],
    );
  }
}

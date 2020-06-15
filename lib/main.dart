import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lstech_app/widgets/navigationBar.dart';

import './models/bluetoothDeviceManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothDeviceManager>(
          create: (context) => BluetoothDeviceManager([]),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Wattza app",
        home: MyNavigationBar(),
      ),
    );
  }
}

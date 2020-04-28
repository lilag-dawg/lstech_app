import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../widgets/customTile.dart';
import '../models/deviceConnexionStatus.dart';

class FindDevicesScreen extends StatefulWidget {
  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> alreadyConnectedDevices = [];
  List<DeviceConnexionStatus> devicesConnexionStatus = [];

  StreamSubscription<List<ScanResult>> scanSubscription;

  bool isDoneScanning;

  Future<void> performScan() async {

    scanSubscription = flutterBlue.scanResults.listen((scanResults){
      for (ScanResult r in scanResults) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((d) => d.getDevice == r.device);
        if (!isDeviceAlreadyAdded) {
          devicesConnexionStatus.add(DeviceConnexionStatus(
            device: r.device,
            connexionStatus: false,
          ));
        }
      }
    });

    await getConnectedDevice().then((alreadyConnectedDevices) {
      for (BluetoothDevice d in alreadyConnectedDevices) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((device) => device.getDevice == d);
        if (!isDeviceAlreadyAdded) {
          devicesConnexionStatus.add(DeviceConnexionStatus(
            device: d,
            connexionStatus: true,
          ));
        } else {
          int errorFromScanResult = devicesConnexionStatus
              .indexWhere((device) => device.getDevice == d);
          devicesConnexionStatus[errorFromScanResult].setConnexionStatus = true;
        }
      }
    });
  }

  Future<List<BluetoothDevice>> getConnectedDevice() async {
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    return devices;
  }

  Future<void> _handleOnpressChanged(
      BluetoothDevice device, bool newStatus) async {
    final selectedDevice =
        devicesConnexionStatus.firstWhere((item) => item.getDevice == device);
    if (selectedDevice.connexionStatus) {
      await selectedDevice.device.disconnect();
    } else {
      await selectedDevice.device.connect();
    }
    setState(() {
      selectedDevice.setConnexionStatus = newStatus;
    });
  }

  List<Widget> _buildCustomTiles(List<DeviceConnexionStatus> result) {
    return result
        .map(
          (d) => CustomTile(
            currentDevice: d,
            onPressed: (BluetoothDevice d, bool status) async {
              await _handleOnpressChanged(d, status);
            },
          ),
        )
        .toList();
  }

  Widget _buildIsScanning() {
    return StreamBuilder(
        stream: flutterBlue.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return _buildAnimations();
          } else {
            //scanForDevices();
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        });
  }

  Widget _buildScanResults() {
    return StreamBuilder(
      stream: flutterBlue.scanResults,
      initialData: [],
      builder: (c, snapshot) {
        print(snapshot.connectionState);
        return Text(snapshot.connectionState.toString());
      },
    );
  }

  Widget _buildAnimations() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: (isDoneScanning)
          ? Column(
              children: <Widget>[
                Column(children: _buildCustomTiles(devicesConnexionStatus)),
              ],
            )
          : _buildAnimations(),
    );
  }

  void startAScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4)).then((_) {
      setState(() {
        isDoneScanning = true;
      });
    });
  }

  @override
  void initState() {
    startAScan();
    isDoneScanning = false;
    performScan();

    //scanForDevices();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    scanSubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}

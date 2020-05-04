import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../widgets/customTile.dart';
import '../models/deviceConnexionStatus.dart';
import '../models/bluetoothDeviceManager.dart';
import '../models/wattzaDevice.dart';

import '../constants.dart' as Constants;

class FindDevicesScreen extends StatefulWidget {
  final BluetoothDeviceManager wattzaManager;
  FindDevicesScreen(this.wattzaManager);

  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  List<BluetoothDevice> alreadyConnectedDevices = [];
  List<DeviceConnexionStatus> devicesConnexionStatus = [];

  StreamSubscription<List<ScanResult>> scanSubscription;

  bool isDoneScanning;

  Future<void> performScan() async {
    scanSubscription = FlutterBlue.instance.scanResults.listen((scanResults) {
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

    await getConnectedDevice().then((alreadyConnectedDevices) async {
      for (BluetoothDevice d in alreadyConnectedDevices) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((device) => device.getDevice == d);
        if (!isDeviceAlreadyAdded) {
          devicesConnexionStatus.add(DeviceConnexionStatus(
            device: d,
            connexionStatus: true,
          ));
          await addWattzaDevice(d);
        } else {
          int errorFromScanResult = devicesConnexionStatus
              .indexWhere((device) => device.getDevice == d);
          devicesConnexionStatus[errorFromScanResult].setConnexionStatus = true;
        }
      }
    });
  }

  Future<List<BluetoothDevice>> getConnectedDevice() async {
    List<BluetoothDevice> devices = await FlutterBlue.instance.connectedDevices;
    return devices;
  }

  Future<void> addWattzaDevice(BluetoothDevice device) async {
    await WattzaDevice.create(device).then((createdWattzaDevice) {
      widget.wattzaManager.add(createdWattzaDevice);
    });
  }

  Future<void> _handleOnpressChanged(
      BluetoothDevice device, bool newStatus) async {
    final selectedDevice =
        devicesConnexionStatus.firstWhere((item) => item.getDevice == device);
    if (selectedDevice.connexionStatus) {
      await selectedDevice.device.disconnect();
      widget.wattzaManager.remove(device);
    } else {
      await selectedDevice.device.connect();
      await addWattzaDevice(device);
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
            onTapTile: (BluetoothDevice d, bool status) async {
              await _handleOnpressChanged(d, status);
            },
          ),
        )
        .toList();
  }

  Widget _buildScanningButton() {
    return StreamBuilder(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return RaisedButton(
              child: Text("Remettre à plus tard"),
              color: Colors.red,
              onPressed: () => FlutterBlue.instance.stopScan(),
            );
          } else {
            return RaisedButton(
                child: Text("Rechercher un Wattza"),
                onPressed: () {
                  setState(() {
                    isDoneScanning = false;
                  });
                  startAScan();
                });
          }
        });
  }

  Widget _buildAnimations() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: Colors.black,
          ),
          Text("Recherche d'un Wattza..."),
        ],
      ),
    );
  }

  Widget _buildBody(BluetoothDeviceManager wattza) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        (isDoneScanning)
            ? Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      children: _buildCustomTiles(devicesConnexionStatus),
                    ),
                  ),
                ],
              )
            : _buildAnimations(),
        (Constants.isWorkingOnEmulator)
            ? RaisedButton(
                child: Text("Remettre à plus tard"),
                color: Colors.red,
                onPressed: () {})
            : _buildScanningButton(),
      ]),
    );
  }

  void startAScan() {
    isDoneScanning = false;
    if (!Constants.isWorkingOnEmulator) {
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)).then((_) {
        setState(() {
          isDoneScanning = true;
        });
      });
      performScan();
    }
  }

  @override
  void initState() {
    startAScan();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (!Constants.isWorkingOnEmulator) {
      FlutterBlue.instance.stopScan();
      scanSubscription.cancel();
    }

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(widget.wattzaManager);
  }
}

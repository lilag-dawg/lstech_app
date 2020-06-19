import 'package:flutter_blue/flutter_blue.dart';

class DeviceConnexionStatus {
  final BluetoothDevice device;
  bool connexionStatus;

  DeviceConnexionStatus({this.device, this.connexionStatus});

  BluetoothDevice get getDevice {
    return device;
  }

  set setConnexionStatus(bool status) {
    connexionStatus = status;
  }
}

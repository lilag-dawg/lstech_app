import 'package:flutter/cupertino.dart';
import './wattzaDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  final List<WattzaDevice> _wattzaDevices;
  BluetoothDeviceManager(this._wattzaDevices);

  void add(WattzaDevice d) {
    _wattzaDevices.add(d);
    notifyListeners();
  }
}

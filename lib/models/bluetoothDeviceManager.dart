import 'package:flutter/cupertino.dart';
import 'package:lstech_app/models/streamPackage.dart';
import 'package:flutter_blue/flutter_blue.dart';
import './wattzaDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  final List<WattzaDevice> _wattzaDevices;
  BluetoothDeviceManager(this._wattzaDevices);
  StreamPackage rpmPackage;
  StreamPackage appBarPackage;
  StreamPackage powerPackage;

  void add(WattzaDevice d) {
    _wattzaDevices.add(d);
    notifyListeners();
  }

  void remove(BluetoothDevice d) {
    _wattzaDevices.removeWhere((element) => element.getDevice == d);
    rpmPackage = null;
    notifyListeners();
  }

  WattzaDevice getWattza(String featureName) {
    WattzaDevice selectedOne;
    _wattzaDevices.forEach((wattza) {
      wattza.services.forEach((s) {
        if (s.checkIfFeatureIsSupported(featureName)) {
          selectedOne = wattza;
        }
      });
    });
    return selectedOne;
  }

  StreamPackage getAppBarPackage() {
    //device qui a la charactetistic RPM et batterie
    if (appBarPackage == null) {
      if (getWattza("BatteryLevel") != null) {
        if (getWattza("BatteryLevel").getService("1816") != null &&
            getWattza("BatteryLevel").getService("180F") != null) {
          appBarPackage = StreamPackage(
              device: getWattza("BatteryLevel").getDevice,
              service: getWattza("BatteryLevel").getService("180F"),
              key: "Battery");
        }
      }
    }
    return appBarPackage;
  }

  StreamPackage getRpmPackage() {
    if (rpmPackage == null) {
      if (getWattza("CrankRev") != null) {
        if (getWattza("CrankRev").getDevice != null &&
            getWattza("CrankRev").getService("1816") != null) {
          rpmPackage = StreamPackage(
              device: getWattza("CrankRev").getDevice,
              service: getWattza("CrankRev").getService("1816"),
              key: "RPM");
        }
      }
    }
    return rpmPackage;
  }

  StreamPackage getPowerPackage() {
    if (powerPackage == null) {
      if (getWattza("Power") != null) {
        if (getWattza("Power").getDevice != null &&
            getWattza("Power").getService("1818") != null) {
          powerPackage = StreamPackage(
              device: getWattza("Power").getDevice,
              service: getWattza("Power").getService("1818"),
              key: "Power");
        }
      }
    }
    return powerPackage;
  }
}

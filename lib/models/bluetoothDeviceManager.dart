import 'package:flutter/cupertino.dart';
import 'package:lstech_app/models/streamPackage.dart';
import 'package:flutter_blue/flutter_blue.dart';
import './wattzaDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  final List<WattzaDevice> _wattzaDevices;
  BluetoothDeviceManager(this._wattzaDevices);
  StreamPackage rpmPackage;

  void add(WattzaDevice d) {
    _wattzaDevices.add(d);
    notifyListeners();
  }
  void remove(BluetoothDevice d){
    _wattzaDevices.removeWhere((element) => element.getDevice == d);
    rpmPackage = null;
    notifyListeners();
  }
  WattzaDevice getWattza(String featureName){
    WattzaDevice selectedOne;
    _wattzaDevices.forEach((wattza){
      wattza.services.forEach((s){
        if(s.checkIfFeatureIsSupported(featureName)){
          selectedOne = wattza;
        }
      });
    });
    return selectedOne;
  }

  StreamPackage getRpm(){
    if(_wattzaDevices.length != 0){
      if(rpmPackage == null){
        rpmPackage = StreamPackage(getWattza("CrankRev").getDevice, getWattza("CrankRev").getService("1816").getCharacteristic("2A5B"),"RPM");
      }
    }

    return rpmPackage;
  }
}
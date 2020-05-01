import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import './feature.dart';

class BluetoothDeviceCharacteristic {
  final String characteristicName;
  final BluetoothCharacteristic characteristic;
  List<Feature> features = [];
  bool isCharacteristicStreaming;

  BluetoothDeviceCharacteristic(this.characteristicName, this.characteristic) {
    isCharacteristicStreaming = false;
  }

  get name {
    return characteristicName;
  }

  get getCharacteristic{
    return characteristic;
  }

  set setIsCharacteristicStreaming(bool status){
    isCharacteristicStreaming = status;
  }

}

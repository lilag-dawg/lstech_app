import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import './bluetoothDeviceCharacteristic.dart';
import './bluetoothDeviceService.dart';

class StreamPackage {
  final BluetoothDevice device;
  final BluetoothDeviceService service;
  final String key;
  StreamPackage({this.device, this.service, this.key});

  BluetoothDeviceCharacteristic _getCharacteristic() {
    switch (key) {
      case "RPM":
        return service.getCharacteristic("2A5B");
        break;
      case "Battery":
        return service.getCharacteristic("2A19");
        break;
      case "Power":
        return service.getCharacteristic("2A63");
        break;

      default:
        return null;
    }
  }

  int getBatteryLevel() {
    return service.getFeature("BatteryLevel").valueContent;
  }

  Stream<int> getStream() async* {
    BluetoothDeviceCharacteristic c = _getCharacteristic();
    if (!c.isCharacteristicStreaming) {
      c.getCharacteristic.setNotifyValue(true);
      characteristicStreamingStatus(true);
    }
    switch (key) {
      case "RPM":
        yield* convertRawToRpm(c.getCharacteristic.value);
        break;
      case "Power":
        yield* convertRawToPower(c.getCharacteristic.value);
        break;
    }
  }

  Stream<BluetoothDeviceState> getConnexion() async* {
    yield* device.state;
  }

  Stream<int> convertRawToRpm(Stream<List<int>> source) async* {
    Map<String, List<int>> currentAndLast = {'current': [], 'last': []};
    await for (List<int> chunk in source) {
      if (chunk.isNotEmpty && chunk[0] != 1) {
        currentAndLast['last'] = currentAndLast['current'];
        currentAndLast['current'] = chunk;
        if (currentAndLast['last'].length != 0 &&
            currentAndLast['current'].length != 0) {
          yield rpmConversion(currentAndLast);
        }
      }
    }
  }
  Stream<int> convertRawToPower(Stream<List<int>> source) async* {
    Map<String, List<int>> currentAndLast = {'current': [], 'last': []};
    await for (List<int> chunk in source) {
      if (chunk.isNotEmpty && chunk[0] != 1) {
        currentAndLast['last'] = currentAndLast['current'];
        currentAndLast['current'] = chunk;
        if (currentAndLast['last'].length != 0 &&
            currentAndLast['current'].length != 0) {
          yield rpmConversion(currentAndLast);
        }
      }
    }
  }

  int rpmConversion(Map<String, List<int>> currentAndLast) {
    currentAndLast.values.forEach((data) {
      switch (data[0]) {
        case 3:
          data[1] = data[7];
          data[2] = data[8];
          data[3] = data[9];
          data[4] = data[10];
          break;
        case 2:
          data[1] = data[1];
          data[2] = data[2];
          data[3] = data[3];
          data[4] = data[4];
          break;
        default:
          data[1] = 0;
          data[2] = 0;
          data[3] = 0;
          data[4] = 0;
          break;
      }
    });
    double rpm;
    int currentCrankRev =
        (currentAndLast["current"][2] << 8) + currentAndLast["current"][1];
    int lastCrankRev =
        (currentAndLast["last"][2] << 8) + currentAndLast["last"][1];
    double currentCrankEventTime =
        ((currentAndLast["current"][4] << 8) + currentAndLast["current"][3]) *
            (1 / 1024);
    double lastCrankEventTime =
        ((currentAndLast["last"][4] << 8) + currentAndLast["last"][3]) *
            (1 / 1024);

    if (currentCrankEventTime != lastCrankEventTime) {
      rpm = 60 *
          (currentCrankRev - lastCrankRev) /
          (currentCrankEventTime - lastCrankEventTime);
    } else {
      rpm = 0;
    }
    return rpm.round();
  }

  void characteristicStreamingStatus(bool status) {
    BluetoothDeviceCharacteristic c = _getCharacteristic();
    c.setIsCharacteristicStreaming = status;
  }
}

import 'package:flutter_blue/flutter_blue.dart';
import './bluetoothDeviceCharacteristic.dart';
import './feature.dart';

class BluetoothDeviceService {
  final String serviceName;
  final BluetoothService service;
  List<BluetoothDeviceCharacteristic> characteristics = [];
  List<Feature> features = [];

  BluetoothDeviceService._create(this.serviceName, this.service);

  static Future<BluetoothDeviceService> create(
      String serviceName, BluetoothService service) async {
    BluetoothDeviceService wattzaService =
        BluetoothDeviceService._create(serviceName, service);

    await wattzaService._getWattzaCharacteristics(service);

    return wattzaService;
  }

  Future<void> _getWattzaCharacteristics(BluetoothService s) async {
    await Future.forEach(s.characteristics, (BluetoothCharacteristic c) async {
      await _setFeatures(c.uuid.toString().toUpperCase().substring(4, 8), c);
      await BluetoothDeviceCharacteristic.create(
              c.uuid.toString().toUpperCase().substring(4, 8), c)
          .then((value) => characteristics.add(value));
    });
  }

  Future<void> _setFeatures(String name, BluetoothCharacteristic c) async {
    switch (name) {
      case "2A5C":
        await _getCharacteristicValue(c).then((result) {
          cscFeatures(result);
        });
        break;
      case "2A19":
        await _getCharacteristicValue(c).then((result) {
          features.add(Feature(
              featureName: "BatteryLevel", status: true, value: result[0]));
        });
        break;
      case "2A65":
        await _getCharacteristicValue(c).then((result) {
          cpFeatures(result);
        });
        break;
    }
  }

  Future<List<int>> _getCharacteristicValue(BluetoothCharacteristic c) async {
    List<int> value = await c.read();
    return value;
  }

  void cscFeatures(List<int> value) {
    int flags = value[0];

    bool isWheelRevSupported = (flags & 0x01 > 0);
    bool isCrankRevSupported = (flags & 0x02 > 0);
    features.add(Feature(featureName: "CrankRev", status: isCrankRevSupported));
    features.add(Feature(featureName: "WheelRev", status: isWheelRevSupported));
  }

  void cpFeatures(List<int> value) {
    int flags = value[0];

    bool isWheelRevSupported = (flags & 0x04 > 0);
    bool isCrankRevSupported = (flags & 0x05 > 0);
    features.add(Feature(featureName: "CrankRev", status: isCrankRevSupported));
    features.add(Feature(featureName: "WheelRev", status: isWheelRevSupported));
    features.add(Feature(featureName: "Power", status: true));
  }

  get name {
    return serviceName;
  }

  bool checkIfFeatureIsSupported(String featureName) {
    bool isSupported = false;
    features.forEach((f) {
      if (f.name == featureName) {
        isSupported = f.isSupported;
      }
    });
    return isSupported;
  }

  Feature getFeature(String name) {
    Feature selected;
    features.forEach((f) {
      if (f.name == name) {
        selected = f;
      }
    });
    return selected;
  }

  BluetoothDeviceCharacteristic getCharacteristic(String name) {
    BluetoothDeviceCharacteristic selected;
    characteristics.forEach((c) {
      if (c.name == name) {
        selected = c;
      }
    });
    return selected;
  }
}

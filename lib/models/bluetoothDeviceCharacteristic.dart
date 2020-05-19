import 'package:flutter_blue/flutter_blue.dart';


class BluetoothDeviceCharacteristic {
  final String characteristicName;
  final BluetoothCharacteristic characteristic;

  BluetoothDeviceCharacteristic._create(this.characteristicName, this.characteristic);

  static Future<BluetoothDeviceCharacteristic> create(String characteristicName, BluetoothCharacteristic characteristic) async{
    BluetoothDeviceCharacteristic myCharacteristic =  BluetoothDeviceCharacteristic._create(characteristicName, characteristic);
    switch(characteristicName){
      case "2A5B":
        await myCharacteristic.setNotification();
        break;
      case "2A19":
        await myCharacteristic.setNotification();
        break;
      case "2A63":
        await myCharacteristic.setNotification();
        break;   
    }
    return myCharacteristic;

  }

  Future<void> setNotification() async{
    await characteristic.setNotifyValue(true);
  }



  get name {
    return characteristicName;
  }

  get getCharacteristic{
    return characteristic;
  }
}

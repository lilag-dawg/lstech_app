import 'package:flutter_blue/flutter_blue.dart';
import './bluetoothDeviceService.dart';

class WattzaDevice {
  final BluetoothDevice device;
  List<BluetoothDeviceService> services = [];
  WattzaDevice._create(this.device);

  static Future<WattzaDevice> create(BluetoothDevice d) async{
    WattzaDevice wattza = WattzaDevice._create(d);
    await wattza._getWattzaServices(d);
    return wattza;
  }

  Future<void> _getWattzaServices(BluetoothDevice d) async{
    List<BluetoothService> dServices = await d.discoverServices();
    await Future.forEach(dServices, (BluetoothService s) async{
      await BluetoothDeviceService.create(s.uuid.toString().toUpperCase().substring(4, 8),s).then((onValue){
        services.add(onValue);
      });
    });
  }

  BluetoothDeviceService getService(String name){
    BluetoothDeviceService selected;
    services.forEach((s){
      if(s.name == name){
        selected = s;
      }
    });
    return selected;
  }

  get getDevice{
    return device;
  }

}
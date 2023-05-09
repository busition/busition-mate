import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class BluetoothAdvertiseModule {
  FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();
  late String uuid;

  BluetoothAdvertiseModule(){
    uuid = "bf27730d-860a-4e09-889c-2d8b6a9e0fe7";
    advertiseData = AdvertiseData(
      serviceUuid: uuid,
        serviceDataUuid: uuid,
        includeDeviceName: true
    );
  }

  late AdvertiseData advertiseData;

  final AdvertiseSettings advertiseSettings = AdvertiseSettings(
      advertiseMode: AdvertiseMode.advertiseModeBalanced,
      txPowerLevel: AdvertiseTxPower.advertiseTxPowerHigh,
      timeout: 180000
  );


  Future<void> toggleAdvertiseSet() async {
    print("blt");
    if (await blePeripheral.isAdvertising) {
      await blePeripheral.stop();
    } else {
      await blePeripheral.start(
        advertiseData: advertiseData,
        advertiseSettings: advertiseSettings,
      );
    }
  }


}
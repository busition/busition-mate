import 'dart:convert';

import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

import '../Profile/LoginClass.dart';
import '../Provider/User.dart';

class BluetoothAdvertiseModule {
  FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();
  late String uuid;

  BluetoothAdvertiseModule() {
    init();

    String compressString(String uuid) {
      String tmp;
      if (uuid.length > 16) {
        tmp = uuid.substring(0, 8) + uuid.substring(uuid.length - 8);
        print(tmp);
      } else {
        tmp = uuid;
      }
      tmp = utf8.encode(tmp).map((unit) => unit.toRadixString(16)).join();
      print("UUID: " + uuid.substring(0, 16));
      tmp = tmp.substring(0, 8) +
          "-" +
          tmp.substring(8, 12) +
          "-" +
          tmp.substring(12, 16) +
          "-" +
          tmp.substring(16, 20) +
          "-" +
          tmp.substring(20);
      return tmp;
    }

    uuid = compressString(User.idTokenResult);
    // uuid = "11111111-0000-1111-0000-00805f9b34fb";
    advertiseData = AdvertiseData(
      localName: "Busition Beacon",
      serviceUuid: uuid,
      serviceDataUuid: uuid,
    );
  }

  late AdvertiseData advertiseData;

  void init() async {
    if (await blePeripheral.isAdvertising) {
      blePeripheral.stop();
    }
  }

  final AdvertiseSettings advertiseSettings = AdvertiseSettings(
      advertiseMode: AdvertiseMode.advertiseModeBalanced,
      txPowerLevel: AdvertiseTxPower.advertiseTxPowerHigh,
      timeout: 180000);

  Future<void> toggleAdvertiseSet() async {
    if (await blePeripheral.isAdvertising) {
      // await blePeripheral.stop();
    } else {
      await blePeripheral.start(
        advertiseData: advertiseData,
        advertiseSettings: advertiseSettings,
      );
      print(uuid);
    }
  }
}

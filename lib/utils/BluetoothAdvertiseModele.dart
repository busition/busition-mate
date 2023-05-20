import 'package:Busition_Mate/LoginClass.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class BluetoothAdvertiseModule {
  FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();
  late String uuid;
  //0000BqzD-V6pi-oube-LGBd-5IdfJstlMDa2
  //    BqzD V6pi oube LGBd 5IdfJstlMDa2
  //0000BqzD-6pio-beLG-d5Id-JstlMDa2
  //bf27730d-860a-4e09-889c-2d8b6a9e0fe7
  //0000BqzD-V6pi-oube-LGBd-5IdfJstlMDa2
  BluetoothAdvertiseModule() {
    String btUuid = LoginClass.uid + "0000";
    uuid = btUuid.substring(0, 8) +
        "-" +
        btUuid.substring(8, 12) +
        "-" +
        btUuid.substring(12, 16) +
        "-" +
        btUuid.substring(16, 20) +
        "-" +
        btUuid.substring(20);
    uuid = "Bf27730d-860a-4e09-889c-2d8b6a9e0fe7";
    print(uuid);
    advertiseData = AdvertiseData(
        localName: "테스트",
        serviceUuid: uuid,
        serviceDataUuid: uuid,
        includeDeviceName: true);
  }



  late AdvertiseData advertiseData;

  final AdvertiseSettings advertiseSettings = AdvertiseSettings(
      advertiseMode: AdvertiseMode.advertiseModeBalanced,
      txPowerLevel: AdvertiseTxPower.advertiseTxPowerHigh,
      timeout: 180000);

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

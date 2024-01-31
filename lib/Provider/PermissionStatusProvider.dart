import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionStatusProvider with ChangeNotifier {
  final PermissionManager _permissionManager = PermissionManager();

  bool _isLocationPermissionGranted = false;
  bool _isNotificationPermissionGranted = false;
  bool _isBluetoothPermissionGranted = false;

  bool get isLocationPermissionGranted => _isLocationPermissionGranted;

  bool get isNotificationPermissionGranted => _isNotificationPermissionGranted;

  bool get isBluetoothPermissionGranted => _isBluetoothPermissionGranted;

  Future<void> checkPermission() async {
    _isLocationPermissionGranted =
        await _permissionManager.checkPermission(Permission.location);
    _isNotificationPermissionGranted =
        await _permissionManager.checkPermission(Permission.notification);

    print("Location: $_isLocationPermissionGranted" +
        "/ Notification: $_isNotificationPermissionGranted");
    notifyListeners();
  }

  Future<void> requestPermission() async {
    _isLocationPermissionGranted =
        await _permissionManager.requestPermission(Permission.location);
    _isNotificationPermissionGranted =
        await _permissionManager.requestPermission(Permission.notification);
    _isBluetoothPermissionGranted =
    await _permissionManager.requestPermission(Permission.bluetoothAdvertise);
    notifyListeners();
  }

  PermissionStatusProvider() {
    checkPermission();
  }
}

class PermissionManager {
  Future<bool> checkPermission(Permission permission) async {
    return await permission.isGranted;
  }

  Future<bool> requestPermission(Permission permission) async {
    print(
        "${permission.toString()} Permission Status: ${await permission.status} ");
    var permissionStatus = await permission.status;
    if (!permissionStatus.isGranted){
      await permission.request();
      permissionStatus = await permission.status;
    }
    if (permissionStatus.isGranted) {
      return true;
    }
    else if (permissionStatus.isPermanentlyDenied || permissionStatus.isDenied) {
      await openAppSettings();
    }

    else {
      await openAppSettings();
      if (permissionStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}

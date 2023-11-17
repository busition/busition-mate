import 'package:permission_handler/permission_handler.dart';

bool locationPermissionStatus = false;

void locationPermission() async {
  bool locationWhenInUseStatus = await Permission.locationWhenInUse.isGranted;
  while (!locationWhenInUseStatus) {
    await Permission.locationWhenInUse.request();
  }
  locationPermissionStatus = true;
}

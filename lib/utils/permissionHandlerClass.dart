import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerClass {
  List<Permission> permissionList = [
    Permission.notification,
    Permission.bluetoothAdvertise,
    Permission.bluetoothConnect,
    Permission.locationAlways,
    Permission.locationWhenInUse
  ];

  static Future _permission(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) {
      // 허용이 되어있지 않음.
      status = await permission.request(); //요청
    } else if (status.isPermanentlyDenied) {
      // 권한 거부, 다시 알림 띄우지 않기 했을때
      bool perm = await openAppSettings();
    }
  }

  Future<List<Permission>> checkPermission() async{
    List<Permission> permissionNotGranted = [];
    for (var p in permissionList){
      print("Check permission $p");
      PermissionStatus status = await p.status;
      if (!status.isGranted){
        print("Permission not Granted $p");
        permissionNotGranted.add(p);
      }
    }
    print("List\n$permissionNotGranted");

    return permissionNotGranted;
  }

}

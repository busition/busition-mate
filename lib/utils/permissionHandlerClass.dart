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


  static Future locationPermission() async {
    var statusInUse = await Permission.locationWhenInUse.status;
    var statusAlways = await Permission.locationAlways.status;
    if (!statusInUse.isGranted) {
      print("locationWhenInUse 불통");
      var status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          //Do some stuff
        } else {
          //Do another stuff
        }
      } else {
        //The user deny the permission
      }
      if (status.isPermanentlyDenied) {
        bool res = await openAppSettings();
      }
    } else {
      print("locationWhenInUse 통과");
      // 사용중에만 허용으로 되어있을 때
      var status = await Permission.locationAlways.status;
      if (!status.isGranted) {
        print("locationWhenInUse 불통");
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          print("locationAlways 통과");
          // 항상 허용 설정시
        } else {
          print("locationAlways 불통");
          // 항상 허용 미설정시
        }
      } else {
        //previously available, do some stuff or nothing
      }
    }
  }

}

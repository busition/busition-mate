import 'package:Busition_Mate/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Future<List<Permission>> checkPermission() async {
    List<Permission> permissionNotGranted = [];
    for (var p in permissionList) {
      print("Check permission $p");
      PermissionStatus status = await p.status;
      if (!status.isGranted) {
        print("Permission not Granted $p");
        permissionNotGranted.add(p);
      }
    }
    print("List\n$permissionNotGranted");

    return permissionNotGranted;
  }

  static Future locationPermission(BuildContext context) async {
    var statusInUse = await Permission.locationWhenInUse.status;
    print("locationWhenInUse: ${statusInUse.isGranted}");
    if (!statusInUse.isGranted) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(context).size.height/2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "위치 권한 알림",
                          style: kCardMainTextStyle,
                        )),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Busition 앱은 앱이 종료되었거나 \n사용 중이 아닐 때도 위치 데이터를 수집하여 \n탑승준비 알림, \n탑승 확인기능 켜짐 \n기능을 지원합니다. \n위치 권한을 항상 사용할 수 있게 허용해주세요",
                        style: kCardSubTextStyle,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        var status = await Permission.locationWhenInUse.request();

                        if (status.isGranted){
                          Navigator.pop(context);
                        }
                        else{
                          print("위치내놔");
                        }
                        print("RESULT: " + status.isGranted.toString());
                      },
                      child: Text("확인"),
                    ),
                  ],
                ),
              ),
            );
          });
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

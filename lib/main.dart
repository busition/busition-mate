import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:Busition_Mate/color_schemes.dart';
import 'package:Busition_Mate/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'MainPage.dart';
import './utils/permissionHandlerClass.dart';

void main() => runApp(const EntryPage());

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busition Mate',
      theme: ThemeData(
          fontFamily: 'Pretendard',
          useMaterial3: true,
          colorScheme: lightColorScheme),
      routes: {
        '/': (context) => const LoginPage(title: "Busition"),
        '/resume-route': (context) => const MainPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  late PermissionHandlerClass permissionHandlerClass;

  @override
  void initState() {
    super.initState();
    permissionHandlerClass = PermissionHandlerClass();
    // List<Permission> plist = pCheck();
  }

  // List<Permission> pCheck() async {
  //   List<Permission> plist = await permissionHandlerClass.checkPermission();
  //   return plistx
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Center(
            child: Column(
          children: [
            title(),
            Column(
              children: [
                textFieldIDPW(idController, false),
                textFieldIDPW(pwController, true),
                mainButton(() {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
                  FocusScope.of(context).unfocus();
                }, "로그인"),
                mainButton(submit, "구글로 시작하기")
              ],
            ),
          ],
        )),
      ),
    );
  }

  submit() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("권한 필요"),
              content: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text("앱을 사용하기 전에 권한을 허용해줘야 합니다."),
                  ),
                  permissionField("위치 권한", _locationPermission,
                      Permission.locationWhenInUse),
                  permissionField(
                      "블루투스 권한", _permission, Permission.bluetoothAdvertise),
                  permissionField(
                      "위치 권한 ", _permission, Permission.notification),
                ],
              ),
            );
          });
    });
    FocusScope.of(context).unfocus();
  }

  Widget permissionField(
      String perName, Function function, Permission permission) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(perName),
          OutlinedButton(
              onPressed: () {
                _permission(permission);
              },
              child: Text("확인"))
        ],
      ),
    );
  }

  Widget textFieldIDPW(TextEditingController tc, bool secure) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(8.0),
      child: TextField(obscureText: secure, controller: tc),
    );
  }

  Widget mainButton(var callback, name) {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 68,
      child: OutlinedButton(
        child: Text(name),
        onPressed: callback,
      ),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(top: 150, bottom: 50),
      child: Text("Busition", style: kCardTitleTextStyle),
    );
  }

  Future _permission(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) {
      // 허용이 되어있지 않음.
      status = await permission.request(); //요청
    } else if (status.isPermanentlyDenied) {
      // 권한 거부, 다시 알림 띄우지 않기 했을때
      bool perm = await openAppSettings();
    } else {
      print("확인");
    }
  }

  Future _locationPermission() async {
    print("여기 도달 하긴함?");
    var statusInUse = await Permission.locationWhenInUse.status;
    if (!statusInUse.isGranted) {
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
      // 사용중에만 허용으로 되어있을 때
      var status = await Permission.locationAlways.status;
      if (!status.isGranted) {
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          // 항상 허용 설정시
        } else {
          // 항상 허용 미설정시
        }
      } else {
        //previously available, do some stuff or nothing
      }
    }
  }
}

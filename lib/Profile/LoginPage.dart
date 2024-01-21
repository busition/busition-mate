import 'package:busitionmate/Profile/LoginClass.dart';
import 'package:busitionmate/Provider/PermissionStatusProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Provider/User.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

void moveToMainPage(BuildContext context) {
  Geolocator.getPositionStream().listen((value) {
    User.position = value;
  });
  Navigator.popAndPushNamed(context, '/main-page');
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    idController.text = "test1@busition.com";
    passwordController.text = "busitiontest1!";

    // idController.text = "test5@gmail.com";
    // passwordController.text = "test5555!";
    return Consumer<PermissionStatusProvider>(
        builder: (context, permissions, child) {
      if (permissions.isLocationPermissionGranted &&
          permissions.isNotificationPermissionGranted) {
        return LoginScreen();
      } else {
        return CheckPermission();
      }
    });
  }

  Future<bool> requestLogin() async {
    LoginClass login = LoginClass();
    Response response =
        await login.login(idController.text, passwordController.text);
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Widget inputField() {
    return Column(
      children: [
        emailInput(),
        passwordInput(),
      ],
    );
  }

  Widget emailInput() {
    return TextField(
      decoration: const InputDecoration(
        labelText: '이메일',
      ),
      controller: idController,
    );
  }

  Widget passwordInput() {
    return TextField(
      decoration: const InputDecoration(
        labelText: '비밀번호',
      ),
      controller: passwordController,
    );
  }

  Widget CheckPermission() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(textAlign: TextAlign.center, "앱을 시작하기 전\n권한을 허용해야 합니다."),
            Consumer<PermissionStatusProvider>(
              builder: (context, permissions, child) {
                return Column(
                  children: [
                    Text("위치 권한: ${permissions.isLocationPermissionGranted}"),
                    Text(
                        "알림 권한: ${permissions.isNotificationPermissionGranted}"),
                  ],
                );
              },
            ),
            MaterialButton(
              onPressed: () async {
                await Provider.of<PermissionStatusProvider>(context,
                        listen: false)
                    .requestPermission();
              },
              child: const Text("권한 요청하기"),
            ),
          ],
        ),
      ),
    );
  }

  Widget LoginScreen() {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Busition Mate"),
        inputField(),
        MaterialButton(
          onPressed: () async {
            // 로그인요청 보내기
            if (await requestLogin()) {
              print("로그인 성공");
              if (!mounted) return;
              moveToMainPage(context);
            } else {
              print("로그인 실패");
            }
          },
          child: const Text("메인 페이지로 이동"),
        ),
        MaterialButton(
            onPressed: () async {
              Navigator.pushNamed(context, "/signup-page");
            },
            child: Text("회원가입 페이지로 이동")),
      ],
    )));
  }
}

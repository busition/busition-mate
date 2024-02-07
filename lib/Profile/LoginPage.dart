import 'package:busitionmate/Profile/LoginClass.dart';
import 'package:busitionmate/Provider/PermissionStatusProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Provider/User.dart';
import '../Util/BluetoothAdvertiseModule.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

void moveToMainPage(BuildContext context) {
  Navigator.popAndPushNamed(context, '/main-page');
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // idController.text = "test1@busition.com";
    // passwordController.text = "busitiontest1!";
  }

  @override
  Widget build(BuildContext context) {
    // idController.text = "test5@gmail.com";
    // passwordController.text = "test5555!";
    return Consumer<PermissionStatusProvider>(
        builder: (context, permissions, child) {
      if (permissions.isLocationPermissionGranted &&
          permissions.isNotificationPermissionGranted &&
          permissions.isBluetoothPermissionGranted) {
        return LoginScreen();
      } else {
        return CheckPermission();
      }
    });
  }

  Future<String> requestLogin() async {
    LoginClass login = LoginClass();
    Response response =
        await login.login(idController.text, passwordController.text);
    print("id: ${idController.text}, password: ${passwordController.text}");
    if (response.statusCode == 200) {
      return "Success";
    } else {
      print(response.body);
      return response.body;
    }
  }

  Widget inputField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          emailInput(),
          passwordInput(),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration = const InputDecoration(
    hintText: "이메일",
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 233, 236, 239)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  );

  InputDecoration _pwdInputDecoration = const InputDecoration(
    hintText: "비밀번호",
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 233, 236, 239)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  );

  Widget emailInput() {
    return TextField(
      focusNode: emailFocusNode,
      decoration: _inputDecoration,
      controller: idController,
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextField(
        obscureText: true,
        focusNode: passwordFocusNode,
        decoration: _pwdInputDecoration,
        controller: passwordController,
      ),
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
                    Text("블루투스 권한: ${permissions.isBluetoothPermissionGranted}")
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
        body: SingleChildScrollView(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRect(
            child: Align(
              heightFactor: 0.5,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/image/Logo.svg",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          inputField(),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 247, 148, 29),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              onPressed: () async {
                await loginButtonPressed();
              },
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.73,
                  child: const Text("로그인")),
            ),
          ),
          MaterialButton(
              onPressed: () async {
                Navigator.pushNamed(context, "/signup-page");
              },
              child: Text("회원가입 페이지로 이동")),
        ],
      )),
    ));
  }

  bool validateEmail(String email) {
    setState(() {
      _inputDecoration = const InputDecoration(
        hintText: "이메일",
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0)),
      );
    });
    return RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  bool validatePassword(String password) {
    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$")
        .hasMatch(password)) {
      print("password: $password");
      setState(() {
        _pwdInputDecoration = const InputDecoration(
          hintText: "비밀번호",
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0)),
        );
      });
      return false;
    }
    return true;
  }

  Future<void> loginButtonPressed() async {

    if (validateEmail(idController.text)) {
      if (validatePassword(passwordController.text)) {
        // 로그인요청 보내기
        String requestResult = await requestLogin();
        if (requestResult == "Success") {
          User.bluetoothAdvertiseModule =
              BluetoothAdvertiseModule();
          if (!mounted) return;
          moveToMainPage(context);
        } else {
          SnackBar snackBar = SnackBar(
            content: Text("로그인에 실패했습니다. ${requestResult}"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        SnackBar snackBar = SnackBar(
          content: Text("비밀번호가 올바르지 않습니다."),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      SnackBar snackBar = SnackBar(
        content: Text("이메일이 올바르지 않습니다."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

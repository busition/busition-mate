import 'package:busitionmate/Profile/LoginClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

  @override
  Widget build(BuildContext context) {
    idController.text = "test1@busition.com";
    passwordController.text = "busitiontest1!";
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
              if (!mounted) return;
              moveToMainPage(context);
            }
          },
          child: Text("메인 페이지로 이동"),
        ),
        MaterialButton(
            onPressed: () async {
              Navigator.pushNamed(context, "/signup-page");
            },
            child: Text("회원가입 페이지로 이동")),
      ],
    )));
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
}

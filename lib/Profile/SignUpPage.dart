import 'package:busitionmate/Profile/LoginClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordDoubleCheckController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginClass login = LoginClass();
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        body: Container(
            color: Color.fromRGBO(233, 153, 62, 1),
            padding: const EdgeInsets.all(8.0),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                idInput(),
            Column(
              children: [
                passwordInput(),
                passwordDoubleCheckInput(),
              ],
            ),
            SizedBox(
              child: Row(
                children: [
                  SizedBox(width: (screenWidth - 16) / 2, child: phoneInput()),
                  SizedBox(width: (screenWidth - 16) / 2, child: nameInput()),
                ],
              ),
            ),
            MaterialButton(
                onPressed: () async {
                  var data = SignUpData(
                      email: idController.text,
                      password: passwordController.text,
                      phone: phoneController.text,
                      name: nameController.text);
                  Response response = await login.signUp(data, context);
                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                  } else {
                    print(response.body);
                  }
                },
                child: Text("회원가입"))
        ]),)
    ,
    );
  }

  Widget idInput() {
    return inputLabel(
        "이메일",
        TextField(
          decoration: const InputDecoration(
            labelText: '이메일',
          ),
          controller: idController,
        ));
  }

  Widget passwordDoubleCheckInput() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호 확인',
      ),
      controller: passwordDoubleCheckController,
    );
  }

  Widget passwordInput() {
    return inputLabel(
        "비밀번호",
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: '비밀번호',
          ),
          controller: passwordController,
        ));
  }

  Widget phoneInput() {
    return inputLabel(
        "전화번호",
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: '전화번호',
          ),
          controller: phoneController,
        ));
  }

  Widget nameInput() {
    return inputLabel(
        '이름',
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: '이름',
          ),
          controller: nameController,
        ));
  }

  Widget inputLabel(String label, Widget input) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: input,
        ),
      ],
    );
  }
}

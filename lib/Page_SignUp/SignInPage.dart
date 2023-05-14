import 'dart:math';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/Page_SignUp/LoginError/ValidateCheck.dart';
import 'package:Busition_Mate/utils/constants.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  CheckValidate checkValidate = CheckValidate();

  late LoginClass loginClass;
  late FocusNode mailFocusNode;
  late FocusNode pwFocusNode;
  late FocusNode nameFocusNode;
  late FocusNode numFocusNode;


  @override
  void initState() {
    super.initState();
    initController();
    mailFocusNode = FocusNode();
    pwFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    numFocusNode = FocusNode();
    loginClass = LoginClass();
  }

  List<TextEditingController> tcList = [TextEditingController()];

  _focusListen() {
    //여러 focusnode의 리스너를 이 곳에서 생성시킨다.
    mailFocusNode.addListener(() {
      if (mailFocusNode.hasFocus) { //포커스노드가 포커스를 가지고 있을 때

      }
      else if (!mailFocusNode.hasFocus) { //포커스노드가 포커스를 가지고 있지 않을 때

      }
    };
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            title: Text("회원가입")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  emailField(tcList[0]),
                  pwField(tcList[1]),
                  nameNumberField([tcList[2], tcList[3]]),
                  checkButton(submit)
                ],
              ),
            ),
          ),
        ));
  }

  Widget fieldLabel(String labelName) {
    return Text(labelName);
  }

  Widget boxTextField(TextEditingController controller, String labelName,
      String hint, Function callback, FocusNode focusNode) {
    String a = "";
    a = callback(mailFocusNode, controller.text);
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldLabel(labelName),
          customTextField(controller, hint, focusNode),
          Text(a, overflow: TextOverflow.fade)
        ],
      ),
    );
  }

  Widget checkButton(Function callback) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: OutlinedButton(
        onPressed: () {
          callback(tcList[0].text, tcList[1].text);
        },
        child: const Text("회원가입"),
      ),
    );
  }

  Future<String> submit(String emailAddress, String password) async {
    List<String> result = await loginClass.signUp(emailAddress, password);
    if (result[0] != "pass") {}
    return "result";
  }

  Widget emailField(TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: boxTextField(
                controller, "이메일", "이메일을 입력해주세요", checkValidate.validateEmail,
                mailFocusNode)),
      ],
    );
  }

  String pwHint = '비밀번호 입력';

  Widget pwField(TextEditingController controller) {
    return Column(
      children: [
        boxTextField(
            controller, "비밀번호", pwHint, checkValidate.validatePassword,
            pwFocusNode),
      ],
    );
  }

  Widget nameNumberField(List<TextEditingController> controller) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 3.5,
              child: boxTextField(
                  controller[0], "이름", "홍길동", checkValidate.validateName,
                  nameFocusNode)),
        ),
        Expanded(
            child: boxTextField(controller[1], "전화번호", "010-XXXX-XXXX",
                checkValidate.validateNumber, numFocusNode))
      ],
    );
  }


  Widget customTextField(TextEditingController controller, String hint,
      FocusNode focusNode) {
    bool obs = false;
    if (hint == pwHint) {
      obs = true;
    }
    return TextField(
      focusNode: focusNode,
      obscureText: obs,
      style: kMessageTextStyle,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color.fromARGB(100, 0, 0, 0))),
      controller: controller,
    );
  }

  void initController() {
    for (int i = 0; i < 4; i++) {
      tcList.add(TextEditingController());
    }
  }

  void errorMessage(List<String> error) {}
}

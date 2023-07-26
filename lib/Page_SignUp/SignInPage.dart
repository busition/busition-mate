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

  void initNode() {
    mailFocusNode = FocusNode();
    pwFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    numFocusNode = FocusNode();
  }

  @override
  void initState() {
    super.initState();
    initController();
    initNode();
    loginClass = LoginClass();
  }

  List<TextEditingController> tcList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            title: const Text("회원가입")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  emailField(),
                  pwField(),
                  nameNumberField(),
                  checkButton(submit)
                ],
              ),
            ),
          ),
        ));
  }

  Widget boxTextField(TextEditingController controller, String labelName,
      String hint, Function callback, FocusNode focusNode) {
    String a = "";
    a = callback(focusNode, controller.text);
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelName),
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
    for (int i = 0; i < 4; i++) {}
    Map<String, String> profile = {
      "phone_number": tcList[3].text,
      "password": tcList[1].text,
      "email": tcList[0].text,
      "username": tcList[2].text,
    };
    List<String> result = await loginClass.signUp(profile, context);

    return "result";
  }

  Widget emailField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: boxTextField(tcList[0], "이메일", "이메일을 입력해주세요",
                checkValidate.validateEmail, mailFocusNode)),
      ],
    );
  }

  String pwHint = '비밀번호 입력';

  Widget pwField() {
    return Column(
      children: [
        boxTextField(tcList[1], "비밀번호", pwHint, checkValidate.validatePassword,
            pwFocusNode),
      ],
    );
  }

  Widget nameNumberField() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(
              width: MediaQuery.of(context).size.width / 3.5,
              child: boxTextField(tcList[2], "이름", "홍길동",
                  checkValidate.validateName, nameFocusNode)),
        ),
        Expanded(
            child: boxTextField(tcList[3], "전화번호", "010-XXXX-XXXX",
                checkValidate.validateNumber, numFocusNode))
      ],
    );
  }

  Widget customTextField(
      TextEditingController controller, String hint, FocusNode focusNode) {
    // if (hint == pwHint) {
    //   obs = true;
    // }
    return TextField(
      focusNode: focusNode,
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

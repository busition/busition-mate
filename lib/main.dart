import 'package:Busition_Mate/LoginClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Busition_Mate/color_schemes.dart';
import 'package:Busition_Mate/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'MainPage.dart';
import './utils/permissionHandlerClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Page_SignUp/SignInPage.dart';
import 'firebase_options.dart';

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
        '/resume-route': (context) => MainPage(),
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
    idController.text = "testmate1@busition.com";
    pwController.text = "testmate1";
    permissionHandlerClass = PermissionHandlerClass();
    initFirebase();
    // List<Permission> plist = pCheck();
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
            child: Column(
          children: [
            title(),
            Column(
              children: [
                textFieldIDPW(idController, false),
                textFieldIDPW(pwController, true),
                mainButton(submit, "이메일로 로그인"),
                mainButton(googleSub, "Google 계정으로 로그인"),
                signUpButton()
              ],
            ),
          ],
        )),
      ),
    );
  }

  Widget signUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("회원이 아니신가요? "),
        InkWell(
            child: const Text(
              "회원가입",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignInPage()));
            })
      ]),
    );
  }

  googleSub() async {
    LoginClass loginClass = LoginClass();
    String reuslt = await loginClass.signInWithGoogle();
    IdTokenResult idToken = await loginClass.getUser();
    FocusScope.of(context).unfocus();
    if (reuslt == "failed") {
      print("로그인 실패");
    } else if (reuslt == "success") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  submit() async {
    LoginClass loginClass = LoginClass();
    String reuslt =
        await loginClass.login(idController.text, pwController.text);
    IdTokenResult idToken = await loginClass.getUser();
    FocusScope.of(context).unfocus();
    if (reuslt == "failed") {
      print("로그인 실패");
    } else if (reuslt == "success") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
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
              child: const Text("확인"))
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
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 68,
      child: OutlinedButton(
        child: Text(name, style: kMessageTextStyle),
        onPressed: callback,
      ),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(top: 150, bottom: 50),
      child: Text("Busition",
          textAlign: TextAlign.center, style: kCardTitleTextStyle),
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
}

import 'dart:async';
import 'dart:convert';

import 'package:Busition_Mate/profile.dart';
import 'package:Busition_Mate/utils/GlobalLogoClass.dart';
import 'package:Busition_Mate/utils/constants.dart';
import 'package:Busition_Mate/utils/permissionHandlerClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';

import 'MainPage.dart';
import 'Page_SignUp/SignUpPage.dart';
import 'Page_SignUp/SignUpdata.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PermissionHandlerClass permissionHandlerClass;
  late LoginClass loginClass;
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    loginClass = LoginClass();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    permissionHandlerClass = PermissionHandlerClass();
  }

  Widget loginScreen(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController pwController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Title(color: Colors.black, child: LogoClass.svg),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: "이메일"),
                    controller: idController,
                    autofillHints: const [AutofillHints.username]),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(hintText: "비밀번호"),
                    controller: pwController,
                    autofillHints: const [AutofillHints.password]),
              ],
            ),
          ),
          MaterialButton(
            onPressed: () {
              onLoginButtonPressed(idController.text, pwController.text);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Text("로그인",),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: Text("회원가입", style: kCardSubTextStyle),
              ),
              MaterialButton(
                onPressed: () {},
                child: Text("비밀번호 찾기", style: kCardSubTextStyle),
              ),
            ],
          )
        ],
      ),
    );
  }

  //로그인 버튼 눌렀을때
  void onLoginButtonPressed(String id, String pw) async {
    if (isButtonEnabled == true) {
      isButtonEnabled = false;
      Response response = await loginClass.login(id, pw);
      if (response.statusCode == 200) {
        Navigator.pop(context);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      } else {
        callSnackBar(Errorhandling(response));
      }

      //로그인 시도시 1초뒤에 버튼 활성화, 너무 많이 누르면 서버에 부담이 될 수 있음.
      Timer(Duration(seconds: 1), () {
        isButtonEnabled = true;
      });
    }
  }

  String Errorhandling(Response response) {
    if (response.statusCode == 200) {
      return "로그인 성공";
    } else if (response.statusCode == 422) {
      return "아이디 또는 비밀번호가 틀렸습니다.";
    } else if (response.statusCode == 401) {
      return "이메일 인증을 완료해주세요. ${response.body}";
    } else {
      return "알 수 없는 오류가 발생했습니다. Code: ${response.body}";
    }
  }

  // TXJWIN

  String? emailValidator(value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    }
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
            .hasMatch(value);
    if (!emailValid) {
      return '올바른 이메일 형식이 아닙니다.';
    }
    return null;
  }

  //로그인 화면
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(233, 153, 62, 1),
        hintColor: Color.fromRGBO(255, 255, 255, 1),

        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        backgroundColor: Color.fromRGBO(233, 153, 62, 1),
        body: loginScreen(context),
      ),
    );
  }

  googleSub() async {
    LoginClass loginClass = LoginClass();
    String reuslt = await loginClass.signInWithGoogle();
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

  callSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
        SnackBar(
      content: Text(message), //snack bar의 내용. icon, button같은것도 가능하다.
      duration: const Duration(seconds: 1), //올라와있는 시간
    ));
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
    } else {
      print("확인");
    }
  }
}

class LoginClass {
  static late String deviceToken;
  static late String idTokenResult;
  static late Profile profile;
  static late String uid;
  late Map<String, String> header;

  static Future<Profile> getProfile() async {
    var header = {"Authorization": "Bearer $idTokenResult"};

    var url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/me?auth_type=Email");
    final response = await http.get(url, headers: header);
    var data = utf8.decode(response.bodyBytes);

    final list = jsonDecode(data);
    profile = Profile.fromJson(list);
    return profile;
  }

  Future<http.Response> login(String emailAddress, password) async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/token?busition_platform=Busition-Mate&device_token=${LoginClass.deviceToken}");
    var header = {'content-type': 'application/x-www-form-urlencoded'};
    var body = "username=$emailAddress&password=$password";
    print(emailAddress);
    final response = await http.post(
      url,
      body: body,
      headers: header,
    );
    var data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      Map<String, dynamic> list = jsonDecode(data);
      if (list["detail"] == "Incorrect username or password") {
      } else {
        idTokenResult = list["access_token"]!;
        await storage.write(key: 'UserToken', value: idTokenResult);
        await storage.write(key: 'UserID', value: emailAddress);
        await storage.write(key: 'UserPWD', value: password);
      }
    }
    print("StatusCode: ${response.statusCode}");
    return response;
  }

  Future<Map> signUp(SignUpData data, BuildContext context) async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/?auth_type=Email");
    var header = {
      'accept': 'application/json',
      'Content-Type': 'application/json'
    };

    var body = {
      "email": data.email,
      "password": data.password,
      "username": data.name,
      "phone_number": data.phone
    };

    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode(body),
    );
    Map<String, dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
    list.addAll({"statusCode": response.statusCode});
    return list;
  }

  static void signOut(BuildContext context) async {
    print("SIGNOUT");
    await storage.deleteAll();
    Navigator.pop(context);
    Navigator.pushNamed(context, "/login-page");
    deviceToken = "";
  }

  static bool restoreUser(BuildContext context) {
    List<TextEditingController> controllers = [
      TextEditingController(),
      TextEditingController()
    ];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text(
                      "계정 복구",
                      style: TextStyle(fontSize: 30),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    Text(
                        "2주 내에 탈퇴한 이력이 었어요\n\n탈퇴 신청한 계정을 복구할까요?\n\n계속하시려면 계정을 입력하세요."),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      TextField(
                          controller: controllers[0],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: "아이디")),
                      TextField(
                          obscureText: true,
                          controller: controllers[1],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: "비밀번호")),
                      MaterialButton(
                        onPressed: () async {
                          if (await requestRestore(
                              controllers[0].text, controllers[1].text)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "회원 복구하기",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("돌아가기"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
        });
    return true;
  }

  static bool removeUser(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text(
                      "회원 탈퇴",
                      style: TextStyle(fontSize: 30),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    Text(
                        "정말로 탈퇴하시겠습니까? \n\n탈퇴 후에는 계정을 복구할 수 없습니다. \n\n계속하시려면 비밀번호를 입력하세요."),
                  ],
                ),
                Column(
                  children: [
                    TextField(
                        obscureText: true,
                        controller: textEditingController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(hintText: "비밀번호를 입력하세요")),
                    MaterialButton(
                      onPressed: () async {
                        if (await requestRemove(textEditingController.text)) {
                          signOut(context);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "회원 탈퇴하기",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("돌아가기"),
                    )
                  ],
                )
              ],
            ),
          ));
        });
    return true;
  }

  static Future<bool> requestRestore(String id, String pw) async {
    Map<String, String> body = {"email": id, "password": pw};
    var header = {
      "accept": "application/json",
      "Content-Type": "application/json"
    };

    String requestUrl =
        "http://api.dev2.busition.com:8001/latest/users/restore";
    Uri url = Uri.parse(requestUrl);

    final client = http.Client();
    final response =
        await client.post(url, headers: header, body: jsonEncode(body));
    Map<String, dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
    print(response.request);

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }

  static Future<bool> requestRemove(String passWord) async {
    Map<String, String> body = {"password": passWord};
    var header = {
      "Authorization": "Bearer $idTokenResult",
      "accept": "application/json",
      "Content-Type": "application/json"
    };

    String requestUrl =
        "http://api.dev2.busition.com:8001/latest/users/?auth_type=Email";
    Uri url = Uri.parse(requestUrl);

    final client = http.Client();
    final response =
        await client.delete(url, headers: header, body: jsonEncode(body));
    Map<String, dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  Future<String> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var cred = await FirebaseAuth.instance.signInWithCredential(credential);

    // Once signed in, return the UserCredential
    return "success";
  }
}

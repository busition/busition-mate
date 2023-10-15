import 'dart:convert';

import 'package:Busition_Mate/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'main.dart';

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

  Future<Response> signUp(SignupData data, BuildContext context) async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/?auth_type=Email");
    var header = {
      'accept': 'application/json',
      'Content-Type': 'application/json'
    };

    var body = {
      "email": data.name,
      "password": data.password,
      "username": data.additionalSignupData!["name"],
      "phone_number": data.additionalSignupData!["phone-number"]
    };

    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode(body),
    );
    print(response.body);

    Navigator.of(context).pop;
    return response;
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
                Column(
                  children: [
                    TextField(
                        controller: controllers[0],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(hintText: "ID")),
                    TextField(
                        obscureText: true,
                        controller: controllers[1],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(hintText: "비밀번호")),
                    MaterialButton(
                      onPressed: () async {
                        if (await requestRestore(controllers[0].text, controllers[1].text)) {
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

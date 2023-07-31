import 'dart:convert';

import 'package:Busition_Mate/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class LoginClass {
  static late String deviceToken;
  static late String idTokenResult;
  static late Profile profile;
  static late String uid;
  late Map<String, String> header;

  static Future<void> getProfile() async {
    var header = {"Authorization": "Bearer$idTokenResult"};

    var url = Uri.parse("http://api.dev2.busition.com:8001/latest/users/me/");
    final response = await http.post(url, headers: header);
    var data = utf8.decode(response.bodyBytes);

    final list = jsonDecode(data);
    profile = Profile.fromJson(list);
  }

  Future<String> newProfile(Map<String, String> profile) async {
    var body = utf8.encode(json.encode(profile));
    Uri url = Uri.parse("http://api.dev.busition.com:8001/v1_3/signup");
    Uri url2 =
        Uri.parse('http://api.dev.busition.com:8001/v1_3/join/passenger');

    final response = await http.post(url, body: body, headers: header);

    //수정 예정
    var body2 = utf8.encode(json.encode({
      "route_uuid": "aa69c6b9-a836-4a72-be33-2b5a5df91bf9",
      "station_uuid": "7f70ef93-53bc-4a1e-9a03-140ad93a2cf8"
    }));

    final response2 = await http.post(url2, body: body2, headers: header);
    print(utf8.decode(response2.bodyBytes));
    var data = utf8.decode(response.bodyBytes);
    Map list = jsonDecode(data);
    if (list["status_code"] == 0) {
      print("자동 로그인 성공");
      return "success";
    } else {
      return list["status_code"].toString();
    }
  }

  Future<http.Response> login(String emailAddress, password) async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/v1_5/users/token?busition_platform=Busition-Mate&device_token=${LoginClass.deviceToken}");
    var header = {'content-type': 'application/x-www-form-urlencoded'};
    var body = "username=$emailAddress&password=$password";
    print(emailAddress);
    final response = await http.post(
      url,
      body: body,
      headers: header,
    );
    var data = utf8.decode(response.bodyBytes);
    Map<String, dynamic> list = jsonDecode(data);
    print("AAAAAAAA${response.body}");
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (list["detail"] == "Incorrect username or password") {

      }
      else {
        idTokenResult = list["access_token"]!;
        await storage.write(key: 'UserToken', value: idTokenResult);
        await storage.write(key: 'UserID', value: emailAddress);
        await storage.write(key: 'UserPWD', value: password);
      }
    }
    return response;
  }

  Future<List<String>> signUp(
      Map<String, String> profile, BuildContext context) async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/?auth_type=Email");
    print("hello? $profile");
    var header = {
      'accept': 'application/json',
      'Content-Type': 'application/json'
    };

    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode(profile),
    );
    print(response.body);

    Navigator.of(context).pop;
    return ["pass", "success"];
  }

  static void signOut(BuildContext context) async {
    print("SIGNOUT");
    await storage.deleteAll();
    Navigator.pop(context);
    Navigator.pushNamed(context, "/login-page");
    deviceToken = "";
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

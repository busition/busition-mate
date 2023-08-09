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

    var url = Uri.parse("http://api.dev2.busition.com:8001/latest/users/me?auth_type=Email");
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
    Map<String, dynamic> list = jsonDecode(data);
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
      "username": data.additionalSignupData!["name"] ,
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

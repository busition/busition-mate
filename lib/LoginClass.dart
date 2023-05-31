import 'dart:convert';

import 'package:Busition_Mate/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginClass {
  static late IdTokenResult idTokenResult;
  static late Profile profile;
  static late String uid;
  late Map<String, String> header;

  void getToken() async {
    idTokenResult = await FirebaseAuth.instance.currentUser!.getIdTokenResult();
    header = {'Authorization': "Bearer ${idTokenResult.token}"};
    print(header);
    print("TOKEN: ${idTokenResult.token}");
  }

  Future<void> getProfile() async {
    Map dict = {"type" : "3"};
    var body = utf8.encode(json.encode(dict));

    var url = Uri.parse("http://api.dev.busition.com:8001/v1_3/signin");
    final response = await http.post(url,
        body: body,
        headers: header);
    var data = utf8.decode(response.bodyBytes);

    final list = jsonDecode(data);
    profile = Profile.fromJson(list);
  }

  Future<String> newProfile(Map<String, String> profile) async {
    var body = utf8.encode(json.encode(profile));
    Uri url = Uri.parse("http://api.dev.busition.com:8001/v1_3/signup");

    final response = await http.post(url, body: body, headers: header);
    var data = utf8.decode(response.bodyBytes);
    Map list = jsonDecode(data);
    if (list["status_code"] == 0){
      print("SUCCESSSSS");
      return "success";
    }
    else{
      return list["status_code"].toString();
    }
  }

  Future<String> login(String emailAddress, password) async {
    String result = "success";
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      uid = credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      result = "failed";
      if (e.code == 'user-not-found') {
        result = ('가입된 이메일이 아닙니다.');
      } else if (e.code == 'wrong-password') {
        result = ('비밀번호가 올바르지 않습니다.');
      } else if (e.code == 'invalid-email') {
        result = ('올바른 이메일 형식이 아닙니다.');
      } else {
        result = (e.code);
      }
    }
    getToken();

    return result;
  }

  Future<List<String>> signUp(String emailAddress, String password,Map<String, String> profile) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return ["password", 'weak-password'];
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return ["email", 'weak-password'];
      }
    } catch (e) {
      print(e);
    }
    getToken();
    newProfile(profile);
    return ["pass", "success"];
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

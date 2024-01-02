import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../Provider/User.dart';

class LoginClass {
  Future<http.Response> login(String emailAddress, password) async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/token?busition_platform=Busition-Mate&device_token=${User
            .deviceToken}");
    var header = {'content-type': 'application/x-www-form-urlencoded'};
    var body = "username=$emailAddress&password=$password";
    final response = await http.post(
      url,
      body: body,
      headers: header,
    );
    var data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      Map<String, dynamic> list = jsonDecode(data);
      print(list);
      if (list["detail"] == "Incorrect username or password") {} else {
        print("머고");
        User.idTokenResult = list["access_token"]!;
        await storage.write(key: 'UserToken', value: User.idTokenResult);
        await storage.write(key: 'UserID', value: emailAddress);
        await storage.write(key: 'UserPWD', value: password);
        getProfile();
      }
    }
    print("StatusCode: ${response.statusCode}");
    return response;
  }

  Future getProfile() async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/me?auth_type=Email");
    var header = {'accept': 'application/json', 'Authorization': 'Bearer ${User.idTokenResult}'};
    final response = await http.get(
      url,
      headers: header,
    );
    var data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      Map<String, dynamic> list = jsonDecode(data);
      User.name = list["username"];
      User.email = list["email"];
      User.isActive = list["is_active"];
      User.organization = list["organization"];
    }
  }

  Future<http.Response> signUp(SignUpData signUpData,
      BuildContext context) async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/?auth_type=Email");
    var header = {'content-type': 'application/json'};
    var body = {
      "email": signUpData.email,
      "password": signUpData.password,
      "username": signUpData.name,
      "phone_number": signUpData.phone
    };
    print("body: $body");
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: header,
    );
    print(response.request);
    return response;
  }
}

class SignUpData {
  String email;
  String password;
  String name;
  String phone;


  SignUpData( {
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });
}
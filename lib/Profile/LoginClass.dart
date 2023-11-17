import 'dart:convert';

import 'package:http/http.dart' as http;

import '../main.dart';
import 'User.dart';

class LoginClass{
  Future<http.Response> login(String emailAddress, password) async {
    Uri url = Uri.parse(
        "http://api.dev2.busition.com:8001/latest/users/token?busition_platform=Busition-Mate&device_token=${User.deviceToken}");
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
        User.idTokenResult = list["access_token"]!;
        await storage.write(key: 'UserToken', value: User.idTokenResult);
        await storage.write(key: 'UserID', value: emailAddress);
        await storage.write(key: 'UserPWD', value: password);
      }
    }
    print("StatusCode: ${response.statusCode}");
    return response;
  }
}
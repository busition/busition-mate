import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../LoginClass.dart';
import '../utils/QRScanner.dart';
import '../utils/constants.dart';

class Organization{
  static String? result;
  Organization();
  orgDialog(context){
    String result = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                children: [
                  Text("기관 추가하기", style: kCardMainTextStyle),
                  Text("기관에서 제공한 코드를 입력해 기관을 추가하세요"),
                  TextField(
                    controller: controller,
                  ),
                  Column(
                    children: [
                      OutlinedButton(
                          onPressed: () async {
                            List? a = await Institution.newInstitution(
                                controller.text);
                            if (a![0] == false) {
                              setState(() {
                                result = a[1];
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text("추가하기")),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QrScanner() ),
                            );
                          },
                          child: Text("QR코드로 추가하기"))
                    ],
                  ),
                  Text(result),
                ],
              ),
            );
          });
        });
  }
}

class Institution {
  Institution();

  static Future<List?> newInstitution(String code) async {
    String joinUrl = "http://api.dev2.busition.com:8001/latest/join/$code";
    Client client = http.Client();

    var url = Uri.parse(joinUrl);
    Response response = await client.post(url,
        headers: {'Authorization': "Bearer ${LoginClass.idTokenResult}"});
    if (response.statusCode == 200) {
      return [true, response.body];
    } else {
      return [false, response.body];
    }
  }
}

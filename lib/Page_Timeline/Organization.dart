import 'package:Busition_Mate/MainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../LoginClass.dart';
import '../utils/QRScanner.dart';
import '../utils/constants.dart';

class DialogRoute<T> extends MaterialPageRoute<T> {
  DialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            maintainState: true);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }
}

class Organization {
  static String? result;

  Organization();

  orgDialog(context) {
    return PageRouteBuilder(
        barrierColor: Colors.black.withOpacity(0.5),
        barrierDismissible: true,
        opaque: false, // 이 속성을 false로 설정하여 배경을 투명하게 만듭니다.
        pageBuilder: (BuildContext context, _, __) {
          TextEditingController controller = TextEditingController();
          String result = ""; // 결과를 저장할 변수
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(context).size.height/2.5,
                child: Column(
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
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
                              }
                            },
                            child: Text("추가하기")),
                        MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QrScanner(controller: controller)),
                              );
                            },
                            child: Text("QR코드로 추가하기")),
                      ],
                    ),
                    Text(result),
                  ],
                ),
              ),
            );
          });
        });
  }
}

class Institution {
  Institution();
    static Future<List?> newInstitution(String code) async {

    String joinUrl = "http://api.dev2.busition.com:8001/latest/organizations/join/$code?auth_type=Email";
    Client client = http.Client();

    var url = Uri.parse(joinUrl);
    Response response = await client.post(url,
        headers: {'Authorization': "Bearer ${LoginClass.idTokenResult}"});
    print(response.body);
    if (response.statusCode == 200) {
      return [true, response.body];
    } else {
      return [false, response.body];
    }
  }
}

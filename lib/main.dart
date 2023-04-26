import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:flutter_foreground_task_example/color_schemes.dart';
import 'package:flutter_foreground_task_example/utils/constants.dart';
import 'MainPage.dart';

void main() => runApp(const EntryPage());

final FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busition Mate',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
        colorScheme: lightColorScheme
      ),routes: {
      '/': (context) => const LoginPage(title: "Busition"),
      '/resume-route': (context) => const MainPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            title(),
            Column(
              children: [
                mainButton(submit, "구글로 시작하기")
              ],
            ),
          ],
        ),
      ),
    );
  }


  submit() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    });
  }

  Widget mainButton(var callback, name) {

    return SizedBox(
      height: 50,
      child: OutlinedButton(
        child: Text(name),
        onPressed: callback,
      ),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(top: 200, bottom: 50),
      child: Text("Busition", style: kCardTitleTextStyle),
    );
  }
}
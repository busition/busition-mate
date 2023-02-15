import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:busition/busition.dart';
import 'package:busition_example/Mainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController id_controller = TextEditingController();
  TextEditingController pw_controller = TextEditingController();
  String id = "x";
  String pw = "w";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            title(),
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(30),
                    child: TextArea(id_controller, false)),
                Padding(
                    padding: EdgeInsets.all(30),
                    child: TextArea(pw_controller, true)),
                Text(widget.title),
                Text(pw),
                Login_Button()
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
        MaterialPageRoute(builder: (context) => MainPage()),
      );
      id = id_controller.text;
      pw = pw_controller.text;
    });
  }

  Widget Login_Button() {
    return ElevatedButton(child: Text("Login"), onPressed: submit);
  }

  Widget TextArea(controller, obsuer) {
    return Container(
      child: TextField(
        obscureText: obsuer,
        controller: controller,
      ),
    );
  }

  Widget title() {
    return Container(
      margin: EdgeInsets.all(50),
      child: Text("Busition"),
    );
  }
}


class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _busitionPlugin = Busition();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _busitionPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: LoginPage(title: _platformVersion)
        ),
    );
  }
}

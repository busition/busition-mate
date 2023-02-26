
import 'package:busition_user/busition_user.dart';

import 'Mainpage.dart';
import 'package:flutter/material.dart';

import 'MyTaskHandler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(name: "Busition")
      },
    );
  }
}

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

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
                    padding: const EdgeInsets.all(30),
                    child: textArea(idController, false)),
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: textArea(pwController, true)),
                loginButton()
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
    });
  }

  Widget loginButton() {
    return ElevatedButton(onPressed: submit, child: const Text("Login"));
  }

  Widget textArea(controller, obsuer) {
    return TextField(
      obscureText: obsuer,
      controller: controller,
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.all(50),
      child: Text(widget.name),
    );
  }
}

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

import 'package:busition/Mainpage.dart';
import 'package:flutter/material.dart';

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
      home: const LoginPage(title: 'Flutter Demo Home Page'),
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
                Text(id),
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

import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task_example/Page_Maps/MapRoute.dart';

import 'Mainpage.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),routes: {
      '/': (context) => const LoginPage(title: "Busition"),
      '/resume-route': (context) => MainPage(),
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

  MapRoute route = MapRoute(0);


  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
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
                    child: textArea(idController)),
                Padding(
                    padding: EdgeInsets.all(30),
                    child: textArea(pwController, obsuer: true)),
                Text(id),
                Text(pw),
                mainButton(submit, "Login")
              ],
            ),
          ],
        ),
      ),
    );
  }

  showEntered(){
    setState(() {
      id = idController.text;
      pw = pwController.text;
    });
  }


  submit() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
      id = idController.text;
      pw = pwController.text;
    });
  }

  Widget mainButton(var callback, name) {
    return ElevatedButton(child: Text(name), onPressed: callback);
  }

  Widget textArea(controller, {obsuer=false}) {
    return TextField(
      obscureText: obsuer,
      controller: controller,
    );
  }

  Widget title() {
    return Container(
      margin: EdgeInsets.all(50),
      child: Text("Busition"),
    );
  }
}


// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'MyTaskHandler',
      notificationText: 'eventCount: $_eventCount',
    );

    // Send data to the main isolate.
    sendPort?.send(_eventCount);

    _eventCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}
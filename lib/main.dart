import 'dart:convert';
import 'dart:math';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/utils/BluetoothAdvertiseModule.dart';
import 'package:Busition_Mate/utils/GlobalLogoClass.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Busition_Mate/color_schemes.dart';
import 'package:Busition_Mate/utils/constants.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'MainPage.dart';
import './utils/permissionHandlerClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var channel = const AndroidNotificationChannel(
    'high_importance_channel', 'High importance Notifications',
    description: "Test", importance: Importance.max);
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

FirebaseMessaging messaging = FirebaseMessaging.instance;

initCloudMessage() async {
  if (kIsWeb) {
    await Firebase.initializeApp();
    // running on the web!
  } else {
    await Firebase.initializeApp();
    // NOT running on the web! You can check for additional platforms here.
  }

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );
  print('FCM을 위한 권한 상태: ${settings.authorizationStatus}');
  key();
}

String? token;
String? idValue;
bool tokenStatus = false;

key() async {
  token = await messaging.getToken(
      vapidKey:
          "BA5OgFPsrYEShyGp4eHllVZfVfXab05EirMNs-9AP9pecz_6VdRyWEeiaXEkesl1mlkpDFPlE8xyL7pfeNZLy0c");
  LoginClass.deviceToken = token!;
  print("token: $token");
}

late BluetoothAdvertiseModule bluetoothAdvertiseModule;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  bluetoothAdvertiseModule = BluetoothAdvertiseModule();
  bluetoothAdvertiseModule.toggleAdvertiseSet();

  print("Handling a background message: ${message.messageType}");
}

const storage = FlutterSecureStorage();

Future<void> autoLogin() async {
  idValue = await storage.read(key: "UserToken");
  if (idValue != null) {
    tokenStatus = true;
    LoginClass.idTokenResult = idValue!;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await autoLogin();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  await initCloudMessage();
  double width =
      MediaQueryData.fromView(WidgetsBinding.instance!.window).size.width;
  LogoClass.logoLoad(width);
  // 화면 너비 가져오기

  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    title: 'Busition Mate',
    theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
        colorScheme: lightColorScheme),
    initialRoute: '/',
    routes: {
      '/': (context) => const EntryPage(),
      '/login-page': (context) => const LoginPage(),
      '/Main-page': (context) => MainPage(),
    },
  ));
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    // 웹이 아니면서 안드로이드이고, 알림이 있는경우
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'mipmap/ic_launcher',
        ),
      ),
    );
  }
}

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);

  initForegroundMessage(context) {
    bluetoothAdvertiseModule = BluetoothAdvertiseModule();
    bluetoothAdvertiseModule.toggleAdvertiseSet();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        Navigator.pushNamed(context, '/resume-route');
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget next = const LoginPage();
    if (tokenStatus == true) {
      LoginClass.getProfile();
      next = MainPage();
    }
    //initForegroundMessage(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Busition Mate',
      theme: ThemeData(
          fontFamily: 'Pretendard',
          useMaterial3: true,
          colorScheme: lightColorScheme),
      home: next,
      routes: {
        '/login-page': (context) => const LoginPage(),
        '/resume-route': (context) => MainPage(),
      },
    );
  }
}

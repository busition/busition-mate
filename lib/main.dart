import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

import 'GlobalPageRoute.dart';
import 'Profile/LoginPage.dart';
import 'MainPage.dart';
import 'Profile/User.dart';
import 'Profile/SignUpPage.dart';
import 'Util/Permission.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initCloudMessage();

  runApp(const MyApp());
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

void getFirebaseToken() async {
  String? deviceTokenTemp = await messaging.getToken(
      vapidKey:
          "BA5OgFPsrYEShyGp4eHllVZfVfXab05EirMNs-9AP9pecz_6VdRyWEeiaXEkesl1mlkpDFPlE8xyL7pfeNZLy0c");
  if (deviceTokenTemp != null) {
    User.deviceToken = deviceTokenTemp;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  // bluetoothAdvertiseModule = BluetoothAdvertiseModule();
  // bluetoothAdvertiseModule.toggleAdvertiseSet();

  print("Handling a background message: ${message.messageType}");
}


// ForeGround FCM Notification Settings
var channel = const AndroidNotificationChannel(
    'high_importance_channel', 'High importance Notifications',
    description: "Test", importance: Importance.max);
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
  getFirebaseToken();
}



const storage = FlutterSecureStorage();

void buildPageRoute() {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // GPS ON
    if (!locationPermissionStatus) {
      locationPermission();
    }
    Geolocator.getPositionStream().listen((value) {
      User.position = value;
    });
    

    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Pretendard',
          useMaterial3: true,
          primaryColor: const Color.fromRGBO(233, 153, 62, 1)),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/main-page':
            return GlobalPageRoute(page: const MainPage());
          case '/':
            return GlobalPageRoute(page: const LoginPage());
          case '/signup-page':
            return GlobalPageRoute(page: const SignUpPage());
          default:
            return null;
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

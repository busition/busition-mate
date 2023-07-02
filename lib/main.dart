import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/utils/BluetoothAdvertiseModule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Busition_Mate/color_schemes.dart';
import 'package:Busition_Mate/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'MainPage.dart';
import './utils/permissionHandlerClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Page_SignUp/SignInPage.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var channel = const AndroidNotificationChannel(
    'high_importance_channel', 'High importance Notifications',
    description: "Test", importance: Importance.max);
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

FirebaseMessaging messaging = FirebaseMessaging.instance;

initCloudMessage() async {
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
  print('User granted permission: ${settings.authorizationStatus}');
  key();
}

String? token;

key() async {
  token = await messaging.getToken(
      vapidKey:
          "BA5OgFPsrYEShyGp4eHllVZfVfXab05EirMNs-9AP9pecz_6VdRyWEeiaXEkesl1mlkpDFPlE8xyL7pfeNZLy0c");
  print("token: $token");
}
late BluetoothAdvertiseModule bluetoothAdvertiseModule;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  bluetoothAdvertiseModule = BluetoothAdvertiseModule();
  bluetoothAdvertiseModule.toggleAdvertiseSet();

  print("Handling a background message: ${message.messageType}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  await initCloudMessage();
  runApp(const EntryPage());
}


void showFlutterNotification(RemoteMessage message) {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('mipmap/ic_launcher');
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) { // 웹이 아니면서 안드로이드이고, 알림이 있는경우
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
    //initForegroundMessage(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Busition Mate',
      theme: ThemeData(
          fontFamily: 'Pretendard',
          useMaterial3: true,
          colorScheme: lightColorScheme),
      routes: {
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

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  late PermissionHandlerClass permissionHandlerClass;

  @override
  void initState() {
    super.initState();
    permissionHandlerClass = PermissionHandlerClass();
    initFirebase();

    // List<Permission> plist = pCheck();
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
            child: Column(
          children: [
            title(),
            Column(
              children: [
                textFieldIDPW(idController, "ID: ", false),
                textFieldIDPW(pwController, "비밀번호: ", true),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: mainButton(submit, "이메일로 로그인"),
                ),
                mainButton(googleSub, "Google 계정으로 로그인"),
                signUpButton()
              ],
            ),
          ],
        )),
      ),
    );
  }

  Widget signUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("회원이 아니신가요? "),
        InkWell(
            child: const Text(
              "회원가입",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignInPage()));
            })
      ]),
    );
  }

  googleSub() async {
    LoginClass loginClass = LoginClass();
    String reuslt = await loginClass.signInWithGoogle();
    FocusScope.of(context).unfocus();
    if (reuslt == "failed") {
      print("로그인 실패");
    } else if (reuslt == "success") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  callSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
        SnackBar(
      content: Text(message), //snack bar의 내용. icon, button같은것도 가능하다.
      duration: Duration(seconds: 5), //올라와있는 시간
    ));
  }

  submit() async {
    LoginClass loginClass = LoginClass();
    String result =
        await loginClass.login(idController.text, pwController.text);
    FocusScope.of(context).unfocus();
    if (result == "success") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      callSnackBar(result);
    }
  }

  Widget permissionField(
      String perName, Function function, Permission permission) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(perName),
          OutlinedButton(
              onPressed: () {
                _permission(permission);
              },
              child: const Text("확인"))
        ],
      ),
    );
  }

  Widget textFieldIDPW(TextEditingController tc, String name, bool secure) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 7, child: Text(name)),
          Expanded(child: TextField(obscureText: secure, controller: tc)),
        ],
      ),
    );
  }

  Widget mainButton(var callback, name) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 68,
      child: OutlinedButton(
        child: Text(name, style: kMessageTextStyle),
        onPressed: callback,
      ),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(top: 150, bottom: 50),
      child: Text("Busition",
          textAlign: TextAlign.center, style: kCardTitleTextStyle),
    );
  }

  Future _permission(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) {
      // 허용이 되어있지 않음.
      status = await permission.request(); //요청
    } else if (status.isPermanentlyDenied) {
      // 권한 거부, 다시 알림 띄우지 않기 했을때
      bool perm = await openAppSettings();
    } else {
      print("확인");
    }
  }
}

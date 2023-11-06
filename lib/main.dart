import 'dart:convert';
import 'dart:math';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/utils/BluetoothAdvertiseModule.dart';
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
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Busition Mate',
    theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
        colorScheme: lightColorScheme),
    initialRoute: '/',
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => const EntryPage());
        case '/login-page':
          return MaterialPageRoute(builder: (context) => const LoginPage());
        case '/Main-page':
          return MaterialPageRoute(builder: (context) => MainPage());
        case '/signup-page':
          return MaterialPageRoute(builder: (context) => const SignUpPage());
        default:
          return MaterialPageRoute(builder: (context) => const EntryPage());
      }
    },

    routes: {
      '/' : (context) => const EntryPage(),
      '/login-page': (context) => const LoginPage(),
      '/Main-page': (context) => MainPage(),
      '/signup-page': (context) => const SignUpPage(),

    },));
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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PermissionHandlerClass permissionHandlerClass;
  late LoginClass loginClass;

  Future<Response?> userSignIn(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');

    Response response = await submit(data);
    print("Code: ${response}");
  }

  Future<Response?> userSignUp(SignupData data) async {
    LoginClass loginClass = LoginClass();
    Response response = await loginClass.signUp(data, context);
    print(response);

  }

  @override
  void initState() {
    super.initState();
    loginClass = LoginClass();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    permissionHandlerClass = PermissionHandlerClass();

  }

  List<UserFormField> signUpAdditional = [
    const UserFormField(keyName: "name"),
    const UserFormField(keyName: "phone-number")
  ];

  String? emailValidator(value){
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    }
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value);
    if (!emailValid) {
      return '올바른 이메일 형식이 아닙니다.';
    }
    return null;
  }

  String? passwordValidator(value){
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자리 이상이어야 합니다.';
    }
    return null;
  }

  Future<bool> testfunction(LoginData log) async {
    print("뭐임");
    return true;
  }

  Future<String?> testfunction2(String s, LoginData log) async {
    print("테스트트트");
    return "테스트";
  }

  //로그인 화면
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: loginClass.loginScreen(context),

      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     // children: [
      //     //   Center(child: Text("Busition", style: kCardTitleTextStyle)),
      //     //   TextField(
      //     //     decoration: InputDecoration(
      //     //       hintText: "이메일",
      //     //     ),
      //     //   ),
      //     //   TextField(
      //     //     decoration: InputDecoration(
      //     //       hintText: "비밀번호",
      //     //     ),
      //     //   ),
      //     // ],
      //   ),
      // ),
    );
}

  LoginMessages loginMessages = LoginMessages(
    userHint:"이메일",
    passwordHint: "비밀번호",
    forgotPasswordButton: "비밀번호 찾기",
    confirmPasswordHint: "비밀번호 확인",
    confirmPasswordError: "비밀번호가 일치하지 않습니다",
    signupButton: '회원가입 하기',
    loginButton: "로그인 하기"
  );

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
      duration: const Duration(seconds: 5), //올라와있는 시간
    ));
  }

  Future<Response> submit(LoginData data) async {
    LoginClass loginClass = LoginClass();
    Response result = await loginClass.login(data.name, data.password);
    return result;
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
    } else {
      print("확인");
    }
  }
}

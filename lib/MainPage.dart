import 'dart:isolate';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/Page_Timeline/ScheduleData/ScheduleData.dart';
import 'package:Busition_Mate/profile.dart';
import 'package:Busition_Mate/utils/BluetoothAdvertiseModule.dart';
import 'package:Busition_Mate/utils/SocketServices.dart';
import 'package:Busition_Mate/utils/myCurrentLocation.dart';
import 'package:Busition_Mate/utils/permissionHandlerClass.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Busition_Mate/Page_Etc/EtcPage.dart';
import 'package:Busition_Mate/custom_color.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Page_Maps/Maps.dart';
import 'Page_Timeline/ScheduleData/Schedule.dart';
import 'Page_Timeline/TimeData.dart';
import 'Page_Timeline/TimePage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  ReceivePort? _receivePort;
  late double width, height;
  static String userName = "";
  Future<Profile>? userProfile;
  static Profile? globalProfile;
  static Schedule? schedule;
  SocketServices? socketServices;
  static int busMove = 9999;

  void managePermission() async {
    print("Permission test");
    await PermissionHandlerClass.locationPermission(context);

    if (await Permission.location.isGranted){
      await Permission.bluetoothAdvertise.request();
    }
    if (await Permission.bluetoothConnect.isGranted){
      await Permission.bluetoothConnect.request();
    }
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((message) {
      if (message is int) {
        print('eventCount: $message');
      } else if (message is String) {
        if (message == 'onNotificationPressed') {
          Navigator.of(context).pushNamed('/resume-route');
        }
      } else if (message is DateTime) {
        print('timestamp: ${message.toString()}');
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  T? _ambiguate<T>(T? value) => value;

  @override
  void initState() {
    super.initState();
    userProfile = LoginClass.getProfile();

    BluetoothAdvertiseModule();
    if (!kIsWeb) {
      managePermission();
      MyCurrentLocation();
    }
    Geolocator.getPositionStream().listen((pos) {
      MyCurrentLocation.myLocation = pos; //LatLng(pos.latitude, pos.longitude);
    });
    getSchedule();
  }

  getSchedule() async {
    var userTime = TimeData(); //유저 아이디 입력란
    schedule = await userTime.fetchSchedule(http.Client());
    Profile.list = schedule!.scheduleData!; // 스케쥴 가져오기
    try {
      for (var i in schedule!.scheduleData!) {}
    } catch (e) {
      print(e.toString());
    }
    for (int i = 0; i < schedule!.scheduleData!.length; i++) {
      socketServices = SocketServices();

      ScheduleData data = schedule!.scheduleData![i];
      if (data.routeId != null) {
        print("Stark socket");
        socketServices!.startSocket(data.routeId!.toString() ,LoginClass.profile.email! ,i);
      }
    }
  }

  @override
  void dispose() {
    _closeReceivePort();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
      const BottomNavigationBarItem(icon: Icon(Icons.map), label: "지도"),
      const BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "B")
    ];
  }

  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Profile>(
                  future: userProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: [
                          // Page List
                          TimePage(
                            pageController: _pageController,
                          ),
                          Maps(),
                          EtcPage(
                              userName: snapshot.data!.userName!,
                              //LoginClass.profile.userName!,
                              start: () {},
                              stop: () {})
                        ],
                        onPageChanged: (page) {
                          setState(() {
                            _selectedIndex = page;
                          });
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onTappedBar,
          type: BottomNavigationBarType.fixed,
          backgroundColor: lightCustomColors.onCustomcolor1,
          selectedItemColor: lightCustomColors.sourceCustomcolor1,
          unselectedItemColor: Colors.black26,
          currentIndex: _selectedIndex,
          items: buildBottomNavBarItems(),
        ));
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
      _pageController.jumpToPage(value);
    });
  }
}

class Institution {
  Institution();

  static Future<List?> newInstitution(String code) async {
    String joinUrl = "http://api.dev2.busition.com:8001/latest/join/$code";
    Client client = http.Client();

    var url = Uri.parse(joinUrl);
    Response response = await client.post(url,
        headers: {'Authorization': "Bearer ${LoginClass.idTokenResult}"});
    if (response.statusCode == 200) {
      return [true, response.body];
    } else {
      return [false, response.body];
    }
  }
}

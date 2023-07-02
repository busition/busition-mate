import 'dart:isolate';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/Page_Timeline/ScheduleData/ScheduleData.dart';
import 'package:Busition_Mate/profile.dart';
import 'package:Busition_Mate/userProfile.dart';
import 'package:Busition_Mate/utils/BluetoothAdvertiseModule.dart';
import 'package:Busition_Mate/utils/SocketServices.dart';
import 'package:Busition_Mate/utils/myCurrentLocation.dart';
import 'package:Busition_Mate/utils/permissionHandlerClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:Busition_Mate/Page_Etc/EtcPage.dart';
import 'package:Busition_Mate/custom_color.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'MyTaskHandler.dart';
import 'Page_Maps/Maps.dart';
import 'Page_Timeline/ScheduleData/Schedule.dart';
import 'Page_Timeline/TimeData.dart';
import 'Page_Timeline/TimePage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MainPageState extends State<MainPage> {
  ReceivePort? _receivePort;
  late double width, height;
  static String userName = "";
  Future<UserProfile>? userProfile;
  static UserProfile? globalProfile;
  static Schedule? schedule;
  SocketServices? socketServices;
  static int busMove = 9999;

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription: '현재 버스에 탑승 중입니다!.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 1000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask() async {
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
          await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        const AlertDialog(
          title: Text("앱의 알림 권환이 필요합니다."),
        );
        return false;
      }
    }

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Busition',
        notificationText: '현재 버스 탑승 중입니다.!',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  void managePermission() async {
    await PermissionHandlerClass.locationPermission(context);
    await Permission.bluetoothAdvertise.request();
    await Permission.bluetoothConnect.request();
    // await _permission(Permission.notification);
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
    _initForegroundTask();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
    BluetoothAdvertiseModule();
    managePermission();
    MyCurrentLocation();
    Geolocator.getPositionStream().listen((pos) {
      MyCurrentLocation.myLocation = pos; //LatLng(pos.latitude, pos.longitude);
    });
    var profile = UserProfile();
    profileLoad(profile);
    getSchedule();
  }

  getSchedule() async {
    var userTime = TimeData(); //유저 아이디 입력란
    schedule = await userTime.fetchSchedule(http.Client());
    UserProfile.list = schedule!.scheduleData!; // 스케쥴 가져오기
    List<DateTime> timeList = [];
    try {
      for (var i in schedule!.scheduleData!) {
      }
    } catch (e) {
      print(e.toString());
    }
    for (int i = 0; i < schedule!.scheduleData!.length; i++) {
      ScheduleData data = schedule!.scheduleData![i];
      socketServices = SocketServices();
      if (data.routeId != null) {
        socketServices!
            .startSocket(data.routeId! + "?${data.shuttleDirection}", i);
      }
    }

    // for (var i in schedule!.scheduleData!) {
    //   socketServices = SocketServices();
    //   if (i.routeId != null) {
    //     socketServices!.startSocket(i.routeId! + "?${i.shuttleDirection}");
    //   }
    // }
  }

  void profileLoad(UserProfile profile) async {}

  void signin() async {
    String scheduleUrl = "http://api.dev.busition.com:8001/v1_2=3/signin";
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
    return WithForegroundTask(
        child: Scaffold(
            body: SafeArea(
                child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<Object>(
                      future: userProfile,
                      builder: (context, snapshot) {
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
                                userName: "A",
                                //LoginClass.profile.userName!,
                                start: _startForegroundTask,
                                stop: _stopForegroundTask)
                          ],
                          onPageChanged: (page) {
                            setState(() {
                              _selectedIndex = page;
                            });
                          },
                        );
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
            )));
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
      _pageController.jumpToPage(value);
    });
  }
}

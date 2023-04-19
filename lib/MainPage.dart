import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task_example/Page_Etc/EtcPage.dart';
import 'package:flutter_foreground_task_example/custom_color.dart';
import 'package:flutter_foreground_task_example/utils/myCurrentLocation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'MyTaskHandler.dart';
import 'Page_Friends/Messenger.dart';
import 'Page_Maps/Maps.dart';
import 'Page_Timeline/ScheduleData/Schedule.dart';
import 'Page_Timeline/TimeData.dart';
import 'Page_Timeline/TimePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class _MainPageState extends State<MainPage> {
  ReceivePort? _receivePort;
  late double width, height;
  late String uuid;
  Future<Schedule>? schedule;

  void _permission(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) {
      // 허용이 되어있지 않음.
      status = await permission.request(); //요청
    } else if (status.isPermanentlyDenied) {
      // 권한 거부, 다시 알림 띄우지 않기 했을때
      bool perm = await openAppSettings();
    }
  }

  void _locationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      var status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          //Do some stuff
        } else {
          //Do another stuff
        }
      } else {
        //The user deny the permission
      }
      if (status.isPermanentlyDenied) {
        bool res = await openAppSettings();
      }
    } else {
      // 사용중에만 허용으로 되어있을 때
      var status = await Permission.locationAlways.status;
      if (!status.isGranted) {
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          // 항상 허용 설정시
        } else {
          // 항상 허용 미설정시
        }
      } else {
        //previously available, do some stuff or nothing
      }
    }
  }

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
        print('SYSTEM_ALERT_WINDOW permission denied!');
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

  void managePermission() {
    _locationPermission();
    _permission(Permission.bluetoothAdvertise);
    _permission(Permission.notification);
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
    initPlatformState();
    managePermission();
    uuid = "bf27730d-860a-4e09-889c-2d8b6a9e0fe7";
    advertiseData = AdvertiseData(
      serviceUuid: uuid!,
      manufacturerId: 1234,
      manufacturerData: Uint8List.fromList([1, 2, 3, 4, 5, 6]),
    );
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });

    TimeData userTime = TimeData(driverID: "wookingwoo");
    schedule = userTime.fetchSchedule(http.Client());
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
      const BottomNavigationBarItem(icon: Icon(Icons.people), label: "친구"),
      const BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "B")
    ];
  }

  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double hh = height / 10;
    return WithForegroundTask(
        child: Scaffold(
            body: SafeArea(
                child: Column(
              children: [
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      // Page List

                      TimePage(
                        pageController: _pageController,
                      ),
                      Maps(),
                      const Friends(),
                      EtcPage(
                          start: _startForegroundTask,
                          stop: _stopForegroundTask,
                          bt: _toggleAdvertiseSet)
                    ],
                    onPageChanged: (page) {
                      setState(() {
                        _selectedIndex = page;
                      });
                    },
                  ),
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

  final FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();

  Future<void> _toggleAdvertiseSet() async {
    if (await blePeripheral.isAdvertising) {
      await blePeripheral.stop();
    } else {
      await blePeripheral.start(
        advertiseData: advertiseData,
        advertiseSetParameters: advertiseSetParameters,
      );
    }
  }

  late AdvertiseData advertiseData;

  final AdvertiseSettings advertiseSettings = AdvertiseSettings(
    advertiseMode: AdvertiseMode.advertiseModeBalanced,
    txPowerLevel: AdvertiseTxPower.advertiseTxPowerHigh,
    timeout: 180000,
  );

  final AdvertiseSetParameters advertiseSetParameters = AdvertiseSetParameters(
    txPowerLevel: txPowerHigh,
  );

  bool _isSupported = false;

  Future<void> initPlatformState() async {
    final isSupported = await blePeripheral.isSupported;
    setState(() {
      _isSupported = isSupported;
    });
  }
}

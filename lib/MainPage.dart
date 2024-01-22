import 'package:busitionmate/GlobalPageRoute.dart';
import 'package:busitionmate/Provider/PermissionStatusProvider.dart';
import 'package:busitionmate/etc/etcPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'Map/MapPage.dart';
import 'Provider/User.dart';
import 'Schedule/Schedule.dart';
import 'Schedule/SchedulePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Schedule> scheduleData;
  late User user;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "스케줄"),
      const BottomNavigationBarItem(icon: Icon(Icons.map), label: "지도"),
      const BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "기타")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionStatusProvider>(
        builder: (context, permissions, child) {
      if (permissions.isLocationPermissionGranted &&
          permissions.isNotificationPermissionGranted) {
        return Consumer<User>(builder: (context, user, child) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              onTap: _onTappedBar,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.black26,
              currentIndex: user.selectedPageIndex,
              items: buildBottomNavBarItems(),
            ),
            body: Center(
              child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [const SchedulePage(), MapPage(), const EtcPage()]),
            ),
          );
        });
      } else {
        return CheckPermission();
      }
    });
  }

  Widget CheckPermission() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(textAlign: TextAlign.center, "앱을 시작하기 전\n권한을 허용해야 합니다."),
            Consumer<PermissionStatusProvider>(
              builder: (context, permissions, child) {
                return Column(
                  children: [
                    Text("위치 권한: ${permissions.isLocationPermissionGranted}"),
                    Text(
                        "알림 권한: ${permissions.isNotificationPermissionGranted}"),
                  ],
                );
              },
            ),
            MaterialButton(
              onPressed: () async {
                await Provider.of<PermissionStatusProvider>(context,
                        listen: false)
                    .requestPermission();
              },
              child: const Text("권한 요청하기"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    Geolocator.getPositionStream().listen((value) {
      User.position = value;
    });

    pageController = PageController();
    mainContext = context;
    super.initState();
  }

  void _onTappedBar(int value) {
    setState(() {
      Provider.of<User>(context, listen: false).selectedPageIndex = value;
      pageController!.jumpToPage(value);
    });
  }
}

import 'package:busitionmate/GlobalPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'Map/MapPage.dart';
import 'Profile/User.dart';
import 'Schedule/Schedule.dart';
import 'Schedule/SchedulePage.dart';
import 'Util/Permission.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Schedule> scheduleData;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "스케줄"),
      const BottomNavigationBarItem(icon: Icon(Icons.map), label: "지도"),
      const BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "기타")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTappedBar,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black26,
        currentIndex: selectedIndex,
        items: buildBottomNavBarItems(),
      ),
      body: Center(
        child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [SchedulePage(), MapPage(), Scaffold()]),
      ),
    );
  }

  @override
  void initState() {
    locationPermission();

    pageController = PageController();
    super.initState();
  }

  void _onTappedBar(int value) {
    setState(() {
      selectedIndex = value;
      pageController!.jumpToPage(value);
    });
  }
}

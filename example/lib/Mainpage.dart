import 'Page_Friends/Messenger.dart';
import 'package:flutter/material.dart';

import 'Page_Maps/Maps.dart';
import 'Page_Timeline/TimeLists.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double width, height;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon: new Icon(Icons.home), label: "홈"),
      BottomNavigationBarItem(icon: new Icon(Icons.map), label: "지도"),
      BottomNavigationBarItem(icon: new Icon(Icons.people), label: "친구"),
      BottomNavigationBarItem(icon: new Icon(Icons.more_horiz), label: "B")
    ];
  }

  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double hh = height / 10;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                // Page List
                TimeLists("A"),
                Maps(),
                Friends("Test"),
                Center(
                    child: Text(
                  "Page 4",
                  style: TextStyle(fontSize: 50),
                ))
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black12,
        currentIndex: _selectedIndex,
        items: buildBottomNavBarItems(),
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
      _pageController.jumpToPage(value);
    });
  }
}

import 'dart:core';

import 'package:Busition_Mate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:Busition_Mate/utils/BluetoothAdvertiseModule.dart';
import 'package:Busition_Mate/utils/SocketServices.dart';
import 'package:geolocator/geolocator.dart';

import '../LoginClass.dart';
import '../utils/myCurrentLocation.dart';
import 'Etc_Etc/etcSetting.dart';
import 'Etc_Profile/profileSetting.dart';
import 'Etc_Routes/routeSetting.dart';

class EtcPage extends StatefulWidget {
  void Function() start;
  void Function() stop;
  String userName;

  EtcPage(
      {required this.userName,
      Key? key,
      required this.start,
      required this.stop})
      : super(key: key);

  @override
  State<EtcPage> createState() => _EtcPageState();
}

class _EtcPageState extends State<EtcPage> with TickerProviderStateMixin {
  late BluetoothAdvertiseModule bluetoothAdvertiseModule;

  @override
  void initState() {
    bluetoothAdvertiseModule = BluetoothAdvertiseModule();
    // TODO: implement initState
    super.initState();
  }

  String btnText = "Socket ON";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                userInfo(widget.userName),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: TabBarView(
                    children: const [
                      ProfileListView()
                      // RouteSetting(),
                      // EtcSettings(),
                      // testField()
                    ],
                    controller: tabController,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  TextEditingController routeController = TextEditingController();
  TextEditingController directionController = TextEditingController();

  Widget routeTextArea(controller) {
    controller = TextEditingController();
    return TextField(controller: controller);
  }

  Widget userInfo(String userName) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: KCircularBorder,
              height: 100,
              width: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                userName,
                style: kProfileNameTextStyle,
              ),
            ),
            buttonCollection(),
            // Image(image: image),
          ],
        ));
  }

  late TabController tabController;

  Widget buttonCollection() {
    tabController = TabController(length: 1, vsync: this);
    return TabBar(
      controller: tabController,
      tabs: const [
        Tab(
          child: Text("프로필 설정"),
        ),
      ],
    );
  }

  Widget testField() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.greenAccent,
          border: Border.all(color: Colors.red, width: 5)),
      child: Column(
        children: [
          Text("테스트 영역입니다."),
          ElevatedButton(
              onPressed: () {
                LoginClass.signOut(context);
              },
              child: Text("로그아웃")),
          ElevatedButton(
              onPressed: widget.start, child: const Text("start foreground")),
          ElevatedButton(
              onPressed: widget.stop, child: const Text("stop foreground")),
          ElevatedButton(
              onPressed: () {
                bluetoothAdvertiseModule.toggleAdvertiseSet();
              },
              child: const Text("Bluetooth")),
          routeTextArea(routeController),
          routeTextArea(directionController),
        ],
      ),
    );
  }
}

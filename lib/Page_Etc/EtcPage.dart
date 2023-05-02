import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/utils/BluetoothAdvertiseModele.dart';
import 'package:flutter_foreground_task_example/utils/SocketServices.dart';

class EtcPage extends StatefulWidget {
  void Function() start;
  void Function() stop;

  EtcPage({Key? key, required this.start, required this.stop})
      : super(key: key);

  @override
  State<EtcPage> createState() => _EtcPageState();
}

class _EtcPageState extends State<EtcPage> {
  late BluetoothAdvertiseModule bluetoothAdvertiseModule;

  @override
  void initState() {
    bluetoothAdvertiseModule = BluetoothAdvertiseModule();
    // TODO: implement initState
    super.initState();
  }
  String btnText = "Socket ON";
  SocketServices? socket;

  @override
  Widget build(BuildContext context) {

    socket = SocketServices();
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: widget.start, child: const Text("start foreground")),
          ElevatedButton(
              onPressed: widget.stop, child: const Text("stop foreground")),
          ElevatedButton(
              onPressed: () {
                bluetoothAdvertiseModule.toggleAdvertiseSet;
              },
              child: const Text("Bluetooth")),
          ElevatedButton(
            onPressed: () {
              socket!.startSocket("TEMP_USERID");

            },
            child: Text(btnText),
          ),
          routeTextArea(routeController),
          routeTextArea(directionController),
        ],
      ),
    ));
  }

  TextEditingController routeController = TextEditingController();
  TextEditingController directionController = TextEditingController();

  Widget routeTextArea(controller) {
    controller = TextEditingController();
    return TextField(controller: controller);
  }
}

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/utils/SocketServices.dart';

class EtcPage extends StatefulWidget {
  void Function() start;
  void Function() stop;
  void Function() bt;

  EtcPage({Key? key, required this.start, required this.stop,required this.bt})
      : super(key: key);

  @override
  State<EtcPage> createState() => _EtcPageState();
}

class _EtcPageState extends State<EtcPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: widget.start, child: const Text("start foreground")),
          ElevatedButton(
              onPressed: widget.stop, child: const Text("stop foreground")),
          ElevatedButton(
              onPressed: widget.bt, child: const Text("Bluetooth")),
          routeTextArea(routeController),
          routeTextArea(directionController),
          const SocketServices(),
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

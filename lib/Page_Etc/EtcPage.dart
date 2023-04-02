import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/utils/SocketServices.dart';

import '../utils/BlutoothService.dart';

class EtcPage extends StatefulWidget {
  void Function() start;
  void Function() stop;
  void Function() BT;

  EtcPage({Key? key, required this.start, required this.stop,required this.BT})
      : super(key: key);

  @override
  State<EtcPage> createState() => _EtcPageState();
}

class _EtcPageState extends State<EtcPage> {
  BlutoothService blutoothService = BlutoothService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blutoothService.initBle();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: widget.start, child: Text("start foreground")),
          ElevatedButton(
              onPressed: widget.stop, child: Text("stop foreground")),
          ElevatedButton(
              onPressed: widget.BT, child: Text("Bluetooth")),
          routeTextArea(routeController),
          routeTextArea(directionController),
          SocketServices(),
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

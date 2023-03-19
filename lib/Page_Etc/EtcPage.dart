import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EtcPage extends StatefulWidget {
  void Function() start;
  void Function() stop;

  EtcPage({Key? key, required this.start, required this.stop})
      : super(key: key);

  @override
  State<EtcPage> createState() => _EtcPageState();
}

class _EtcPageState extends State<EtcPage> {
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
          routeTextArea(routeController),
          routeTextArea(directionController)
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

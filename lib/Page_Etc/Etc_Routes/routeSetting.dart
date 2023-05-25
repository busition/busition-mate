import 'package:flutter/material.dart';

class RouteSetting extends StatefulWidget {
  const RouteSetting({Key? key}) : super(key: key);

  @override
  State<RouteSetting> createState() => _RouteSettingState();
}

class _RouteSettingState extends State<RouteSetting> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("차량 노선 관련 메뉴"),);
  }
}

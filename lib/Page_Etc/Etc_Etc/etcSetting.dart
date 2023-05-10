import 'package:flutter/material.dart';

class EtcSettings extends StatefulWidget {
  const EtcSettings({Key? key}) : super(key: key);

  @override
  State<EtcSettings> createState() => _EtcSettingsState();
}

class _EtcSettingsState extends State<EtcSettings> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("기타 메뉴."),);
  }
}

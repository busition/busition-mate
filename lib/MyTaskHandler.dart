import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:Busition_Mate/utils/myCurrentLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  Position? loc;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    MyCurrentLocation();
    Geolocator.getPositionStream().listen((pos) {
      loc = pos;
      MyCurrentLocation.myLocation = pos; //LatLng(pos.latitude, pos.longitude);
    });
    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  /* 앱 실행 중*/
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      notificationTitle: '버지션 Bustion',
      notificationText: "위도: "
          "${loc!.latitude.toStringAsFixed(3)}"
          "\n경도: "
          "${loc!.longitude.toStringAsFixed(3)}"
          "\n속도: "
          "${loc!.speed.toStringAsFixed(3)}",
    );

    // Send data to the main isolate.
    sendPort?.send(loc);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../Provider/RealTimeData.dart';
import '../Provider/User.dart';
import '../Schedule/Schedule.dart';

class WebSocketClass {
  final Schedule schedule;
  late IO.Socket socket;
  late User user;
  LatLng? locationData;
  RealTimeData realTimeData;


  WebSocketClass({required this.schedule, required this.user, required this.realTimeData}) {
    socket = IO.io('https://socket.dev2.busition.com/mate',
        IO.OptionBuilder().setTransports(['websocket']).build());
    startSocket();
  }

  startSocket() {
    // Dart client
    socket.connect();
    Map<String, String> json = {
      "user_id": User.email,
      "room_id": schedule.id.toString()
    };
    socket.onConnect((_) {
      socket.emit('join_room', json);
    });

    socket.on('code', (aa) {
      if (aa == 200) {
        print("Socket Connected, join room${schedule.id}");
        user.changeStatus(true, schedule.id);
      } else {
        user.changeStatus(false, schedule.id);
        socket.disconnect();
      }
    });

    socket.on('data', (data) {
      try {
        var temp = data['location'];

        if (user.selectedID == schedule.id) {
          realTimeData.locationData = LatLng(temp[0], temp[1]);
          locationData = LatLng(temp[0], temp[1]);
        }
      } catch (e) {
        print("error: $e");
        print("data: $data");
      }
    });

    socket.onerror((err) => (print("$err")));
  }

  void disconnectSocket() {
    socket.disconnect();
  }
}

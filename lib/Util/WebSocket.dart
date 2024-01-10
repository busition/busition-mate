import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../Provider/User.dart';

class WebSocketClass {
  final int id;
  late IO.Socket socket;
  late User user;

  WebSocketClass({required this.id, required this.user}) {
    this.user = user;
    socket = IO.io('https://socket.dev2.busition.com/mate',
        IO.OptionBuilder().setTransports(['websocket']).build());
    print("WebSocketClass: $id");
  }

  startSocket() {
    // Dart client
    socket.connect();
    Map<String, String> json = {
      "user_id": User.email,
      "room_id": id.toString()
    };
    socket.onConnect((_) {
      socket.emit('join_room', json);
    });

    socket.on('code', (aa) {
      if (aa == 200) {
        print("Socket Connected, join room$id");
        user.changeStatus(true, id);
      } else {
        socket.disconnect();
      }
    });

    socket.on('data', (data) {

    });

    socket.onerror((err) => (print("$err")));
  }
}

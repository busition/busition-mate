import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Page_Maps/Maps.dart';

class SocketServices {
  late IO.Socket socket;

  static LatLng busLocation = LatLng(0, 0);

  SocketServices() {
    socket = IO.io('http://api.dev.busition.com:3000/user',
        IO.OptionBuilder().setTransports(['websocket']).build());
  }

  bool checkSocket() {
    return socket.connected;
  }

  startSocket(String id) {
    // Dart client
    socket.connect();
    socket.onConnect((_) {
      socket.emit('join_room', id);
    });

    socket.on('code', (aa) {
      if (aa == 404) {
        socket.disconnect();
      } else {
        print("200 $id connected");
      }
    });

    socket.on('data', (data) {
      Maps.busLocation = LatLng(data['location'][0], data['location'][1]);;
    });
    socket.onerror((err) => (print("$err")));
  }

  disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
  }
}

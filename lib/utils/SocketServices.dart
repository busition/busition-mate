import 'dart:convert';

import 'package:Busition_Mate/utils/BluetoothAdvertiseModule.dart';
import 'package:Busition_Mate/utils/myCurrentLocation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as ds;

import '../Page_Maps/Maps.dart';

class SocketServices {
  late BluetoothAdvertiseModule bluetoothAdvertiseModule;
  late IO.Socket socket;

  String status = "출발 대기중";

  SocketServices() {
    socket = IO.io('https://api.dev2.busition.com/user',
        IO.OptionBuilder().setTransports(['websocket']).build());
  }

  bool checkSocket() {
    return socket.connected;
  }

  startSocket(String id, index) {
    // Dart client
    socket.connect();
    socket.onConnect((_) {
      socket.emit('join_room', id);
    });

    socket.on('code', (aa) {
      if (aa == 404) {
        socket.disconnect();
        status = "출발 대기중";
      } else {
        bluetoothAdvertiseModule = BluetoothAdvertiseModule();
        status = "출발";
        print("Socket success");
        MapsState.busMove = index;
      }
    });

    socket.on('data', (data) {
      Maps.busLocation = LatLng(data['location'][0], data['location'][1]);
      Maps.busSpeed = data['speed'].toString();
      double dis = getdistance();

      if (dis < 1300) {
        MapsState.busDistance = dis;

        if (dis < 15){
          bluetoothAdvertiseModule.toggleAdvertiseSet();
        }
        // TODO 버스가 가까줘졌다는 표시 하기.
      }
      else {

      }

    });
    socket.onerror((err) => (print("$err")));
  }

  disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
  }

  double getdistance() {
    ds.Distance distance = const ds.Distance();

    double routeDistance = distance.as(
        ds.LengthUnit.Meter,
        ds.LatLng(MyCurrentLocation.myLocation.latitude,
            MyCurrentLocation.myLocation.longitude),
        ds.LatLng(Maps.busLocation.latitude, Maps.busLocation.longitude));
    return routeDistance;
  }
}

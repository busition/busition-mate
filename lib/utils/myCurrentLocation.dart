import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyCurrentLocation{
  static late LatLng myLocation;

  MyCurrentLocation(callback){
    Geolocator.getPositionStream()
        .listen((pos) {
      myLocation = LatLng(pos.latitude, pos.longitude);
    });
  }

}

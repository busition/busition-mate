import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyCurrentLocation {
  static Position myLocation = Position(
      headingAccuracy: 0,
      altitudeAccuracy: 0,
      longitude: 0,
      latitude: 0,
      timestamp: DateTime(1),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  MyCurrentLocation();
}

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationProvider extends ChangeNotifier {

  LocationProvider() {}

  late Position _position;
  bool _serviceEnabled = false;
  String _nextStation = "없음";

  set position(Position newPosition) {
    _position = newPosition;
    notifyListeners();
  }

  set serviceEnabled(bool newServiceEnabled) {
    _serviceEnabled = newServiceEnabled;
    notifyListeners();
  }

  set nextStation(String newNextStation) {
    _nextStation = newNextStation;
    notifyListeners();
  }

  Position get position => _position;

  bool get serviceEnabled => _serviceEnabled;

  String get nextStation => _nextStation;
}

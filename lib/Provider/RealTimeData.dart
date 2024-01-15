import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RealTimeData with ChangeNotifier {
  // 실시간 위치 데이터
  LatLng? _locationData;
  String _stationName = "";
  double _speed = 0.0;
  int id = 0;


  // 데이터에 대한 getter
  LatLng? get locationData => _locationData;

  String get stationName => _stationName;

  double get speed => _speed;

  // 데이터를 업데이트하는 메서드
  set locationData(LatLng? locationData) {
    _locationData = locationData;
    notifyListeners();
  }

  set stationName(String stationName) {
    _stationName = stationName;
    notifyListeners();
  }

  set speed(double speed) {
    _speed = speed;
    notifyListeners();
  }
}

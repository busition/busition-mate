import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../Schedule/Schedule.dart';

class User with ChangeNotifier{
  static late String idTokenResult;
  static late String deviceToken;
  static late Position position;

  late int _selectedIndex = -1;
  late int _nearestScheduleID = -1;
  late ScheduleResponse _schedule;

  int get selectedIndex => _selectedIndex;
  int get nearestScheduleID => _nearestScheduleID;
  ScheduleResponse get schedule => _schedule;


  set selectedIndex(int index){
    if (_selectedIndex != index) {
      _selectedIndex = index;
      print("%%%%%selectedIndex: $_selectedIndex");
      notifyListeners();
    }
  }

  set nearestScheduleID(int id){
    _nearestScheduleID = id;
    print("%%%%%nearestScheduleID: $_nearestScheduleID");
    notifyListeners();
  }

  set schedule(ScheduleResponse scheduleResponse){
    _schedule = scheduleResponse;
    print("%%%%%schedule: $_schedule");
    notifyListeners();
  }
}
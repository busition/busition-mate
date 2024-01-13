import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../Schedule/Schedule.dart';

class User with ChangeNotifier {
  static late String idTokenResult;
  static late String deviceToken;
  static late Position position;
  static late String name;
  static late String email;
  static late bool isActive;
  static late int organization;

  late int _selectedIndex = -1;
  late int _nearestScheduleIndex = -1;
  late ScheduleResponse _schedule;

  int get selectedID => _selectedIndex;

  int get nearestScheduleID => _nearestScheduleIndex;

  ScheduleResponse get schedule => _schedule;

  set selectedID(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  set nearestScheduleID(int id) {
    _nearestScheduleIndex = id;
    notifyListeners();
  }

  set schedule(ScheduleResponse scheduleResponse) {
    _schedule = scheduleResponse;
    notifyListeners();
  }

  void changeStatus(bool status, int id) {
    for (int i = 0; i < _schedule.schedule_data.length; i++) {
      if (_schedule.schedule_data[i].id == id) {
        _schedule.schedule_data[i].isActive = status;
        notifyListeners();
        break;
      }
    }
  }
}

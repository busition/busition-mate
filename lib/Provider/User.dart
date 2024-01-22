import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../Schedule/Schedule.dart';

class User with ChangeNotifier {
  static String idTokenResult = "";
  static late String deviceToken;
  static Position? position;
  static late String name;
  static late String email;
  static late bool isActive;
  static late int organization;

  late int _selectedIndex = -1;
  late int _nearestScheduleIndex = -1;
  late ScheduleResponse _schedule;
  int _selectedPageIndex = 0;

  int get selectedID => _selectedIndex;

  int get nearestScheduleID => _nearestScheduleIndex;

  int get selectedPageIndex => _selectedPageIndex;

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

  set selectedPageIndex(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }
}

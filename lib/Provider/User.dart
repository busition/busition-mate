import 'package:busitionmate/Util/BluetoothAdvertiseModule.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../Schedule/Schedule.dart';

class User with ChangeNotifier {
  static String idTokenResult = "";
  static late String deviceToken;
  static Position? position;
  static late String name;
  static late String email;
  static late bool isAccountActive;
  static late int organization;
  static late BluetoothAdvertiseModule bluetoothAdvertiseModule;

  late int _selectedIndex = -1;
  late int _nearestScheduleIndex = -1;
  late ScheduleResponse _schedule;
  late Map<int, bool> _scheduleStatus = {};

  bool _isProgressEnabled = false;

  int _selectedPageIndex = 0;

  int get selectedID => _selectedIndex;

  int get nearestScheduleID => _nearestScheduleIndex;

  int get selectedPageIndex => _selectedPageIndex;

  Map<int, bool> get scheduleStatus => _scheduleStatus;

  ScheduleResponse get schedule => _schedule;

  bool get isProgressEnabled => _isProgressEnabled;

  set selectedID(int id) {
    if (_selectedIndex != id) {
      _selectedIndex = id;
      print("selectedID: $id");
      notifyListeners();
    }
  }

  set nearestScheduleID(int id) {
    _nearestScheduleIndex = id;
    print("nearestScheduleID: $id");
    notifyListeners();
  }

  set schedule(ScheduleResponse scheduleResponse) {
    _schedule = scheduleResponse;
    notifyListeners();
  }

  set scheduleStatus(Map<int, bool> scheduleStatus) {
    _scheduleStatus = scheduleStatus;
    notifyListeners();
  }

  void changeStatus(bool status, int id) {
    _scheduleStatus[id] = status;
    notifyListeners();
  }


  set selectedPageIndex(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }

  set isProgressEnabled(bool progressEnabled) {
    _isProgressEnabled = progressEnabled;
    print("progressEnabled: $progressEnabled");
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../Schedule/Schedule.dart';

class User with ChangeNotifier{
  static late String idTokenResult;
  static late String deviceToken;
  static late Position position;

  late int nearestScheduleID = 9999;
  late ScheduleResponse schedule;

  set setNearestScheduleID(int id){
    nearestScheduleID = id;
    notifyListeners();
  }

  set setSchedule(ScheduleResponse scheduleResponse){
    schedule = scheduleResponse;
    notifyListeners();
  }

  set setPosition(Position positionTemp){
    position = positionTemp;
    notifyListeners();
  }
}
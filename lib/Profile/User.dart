import 'package:geolocator/geolocator.dart';

import '../Schedule/Schedule.dart';

class User{
  static late String idTokenResult;
  static late String deviceToken;
  static late int nearestScheduleID = 9999;
  static late ScheduleResponse schedule;
  static late Position position;
}
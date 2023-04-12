import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task_example/Page_Maps/RouteData/MapRoute.dart';
import 'package:flutter_foreground_task_example/Page_Maps/RouteData/RouteData.dart';
import 'Page_Timeline/ScheduleData/Schedule.dart';
import 'package:http/http.dart' as http;

import 'Page_Timeline/TimeData.dart';


class AllData {
  static Future<Schedule>? schedule;
  static Future<RouteData>? routeData;
  int userInfo = 1;
  int dir = 0;

  AllData(int userInfo, int dir){
    MapRoute route = MapRoute(userInfo, dir);
    TimeData userTime = TimeData(driverID: "wookingwoo");

    routeData = route.fetchRoute(http.Client());
    schedule = userTime.fetchSchedule(http.Client());
  }
}

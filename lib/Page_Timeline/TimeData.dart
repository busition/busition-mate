import 'dart:convert';

import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/Schedule.dart';
import 'package:http/http.dart' as http;


class TimeData {
  String scheduleUrl = "http://api.dev.busition.com:8001/v1_1/schedule/passenger/";
  String driverID;

  TimeData({required this.driverID});

  Future<Schedule> fetchSchedule(http.Client client) async {
    var url = Uri.parse(scheduleUrl+driverID);
    final resoponse = await client.get(url);
    var data = utf8.decode(resoponse.bodyBytes);

    final list = jsonDecode(data);
    final scheduleData = Schedule.fromJson(list);
    return scheduleData;

  }

}

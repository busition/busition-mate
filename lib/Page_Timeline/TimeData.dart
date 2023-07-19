import 'dart:convert';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/Page_Timeline/ScheduleData/Schedule.dart';
import 'package:http/http.dart' as http;


class TimeData {
  String scheduleUrl = "http://api.dev.busition.com/v1_3/schedule/passenger/";
  TimeData();

  Future<Schedule> fetchSchedule(http.Client client) async {
    var url = Uri.parse(scheduleUrl);
    final resoponse = await client.get(url,headers:{'Authorization':"Bearer ${LoginClass.idTokenResult.token}"});
    var data = utf8.decode(resoponse.bodyBytes);

    final list = jsonDecode(data);
    final scheduleData = Schedule.fromJson(list);
    return scheduleData;
  }
}

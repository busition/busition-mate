import 'dart:convert';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/Page_Timeline/ScheduleData/Schedule.dart';
import 'package:http/http.dart' as http;


class TimeData {
  String scheduleUrl = "http://api.dev.busition.com:8001/v1_2/schedule/passenger/";
  TimeData();

  Future<Schedule> fetchSchedule(http.Client client) async {
    var url = Uri.parse(scheduleUrl);
    final resoponse = await client.get(url,headers: {'Authorization':"Bearer ${LoginClass.idTokenResult.token}"});
    print("토큰: ${LoginClass.idTokenResult}");
    var data = utf8.decode(resoponse.bodyBytes);

    final list = jsonDecode(data);
    final scheduleData = Schedule.fromJson(list);
    return scheduleData;
  }
}

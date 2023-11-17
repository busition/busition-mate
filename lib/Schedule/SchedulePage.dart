import 'dart:convert';

import 'package:busitionmate/Schedule/TimeCard.dart';
import 'package:busitionmate/Util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Profile/User.dart';
import '../Util/PainterUtil.dart';
import 'Schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  late Future<ScheduleResponse> scheduleData;

  @override
  void initState() {
    scheduleData = requestSchedule();
    super.initState();
  }

  int minIndex = 0;

  @override
  Widget build(BuildContext context) {
    Canvas canvas;
    return Container(
      color: busitionOrange,
      child: timeList(),
    );
  }

  Future<ScheduleResponse> requestSchedule() async {
    final response = await http.get(
        headers: {"Authorization": "Bearer ${User.idTokenResult}"},
        Uri.parse(
            'http://api.dev2.busition.com:8001/latest/schedules/?platform=mate-org&auth_type=Email'));
    // response to UTF-8
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return ScheduleResponse.fromJson(jsonDecode(data));
    } else {
      throw Exception('Failed to load album ${response.body}');
    }
  }

  Widget timeList() {
    return FutureBuilder(
        future: scheduleData,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            timecompare(snapshot.data!.schedule_data);
            User.schedule = snapshot.data!;
            User.nearestScheduleID = snapshot.data!.schedule_data[minIndex].id;
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: snapshot.data!.schedule_count,
                          itemBuilder: (context, index) {
                            return TimeCard(
                                schedule: snapshot.data!.schedule_data[index]);
                          }),
                    ),
                  ],
                ),
                topBar()
              ],
            );
          } else if (snapshot.hasData) {
            return Text("스케줄이 없습니다.");
          } else if (snapshot.hasError) {
            return Text("ERROR: ${snapshot.error}");
          }
          return Text(User.idTokenResult);
        });
  }

  Widget topBar() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height / 1.4 + 8),
        decoration: busitionTimePageBackground,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "다음 차량",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              User.schedule.schedule_data[minIndex].name,
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
            Text(
                "${User.schedule.schedule_data[minIndex].nearest_departure!.hour}시 "
                "${User.schedule.schedule_data[minIndex].nearest_departure!.minute}분 출발예정",
                style: const TextStyle(fontSize: 20, color: Colors.white)),
          ],
        )));
  }

  void timecompare(List<Schedule> scheduleData) {
    // 각 노선에 대해 가장 가까운 출발 시간 찾기
    for (var schedule in scheduleData) {
      schedule.findNearestDepartureTime();
    }
    // 노선 정렬
    scheduleData
        .sort((a, b) => a.nearest_departure!.compareTo(b.nearest_departure!));

    DateTime now = DateTime.now();
    int minDiff = 99999999999;

    for (int i = 0; i < scheduleData.length; i++) {
      // 현재시간
      for (int j = 0; j < scheduleData[i].first_departure_time.length; j++) {
        String data = scheduleData[i].first_departure_time[j];
        // 현재시간을 기준으로 스케줄의 출발시간과 도착시간을 비교, 현재시간은 snapshot.data.schedule_data[index].departure_time에 있음
        DateTime dateTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(data.split(":")[0]), // 시간
            int.parse(data.split(":")[1]) // 분
            );
        int diff = dateTime.difference(now).inSeconds;
        if (diff < 0) {
          diff = 99999999999;
        }
        if (minDiff > diff) {
          minDiff = diff;
          minIndex = i;
        }
      }
    }
  }

  bool get wantKeepAlive => true;
}

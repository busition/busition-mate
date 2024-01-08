import 'dart:convert';

import 'package:busitionmate/Schedule/TimeCard.dart';
import 'package:busitionmate/Util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Provider/User.dart';
import 'Schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  late Future<ScheduleResponse> scheduleData;
  ScheduleResponse? scheduleResponse;
  List<BitmapDescriptor> busImage = [];

  @override
  void initState() {
    scheduleData = requestSchedule();
    super.initState();
    updateScheduleData();
    loadMarkerImage();
  }

  void updateScheduleData() async {
    scheduleResponse = await requestSchedule();
    setState(() {
      User user = Provider.of<User>(context, listen: false);
      user.schedule = scheduleResponse!;
      timecompare(scheduleResponse!.schedule_data);
      print("minIndex: $minIndex");
      user.nearestScheduleID = minIndex;
      user.selectedIndex = minIndex;
    });
  }

  int minIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Container(
            alignment: Alignment.centerLeft,
            height: 56,
            child: const Text(
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                "시간표")),
        backgroundColor: busitionPrimary,
        elevation: 0,
      ),
      body: Container(
        color: busitionPrimary,
        child: timeList(),
      ),
    );
  }

  Future<ScheduleResponse> requestSchedule() async {
    print("Http Request: Schedule");
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
    return Consumer<User>(builder: (context, User user, child) {
      try {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: user.schedule.schedule_count,
                itemBuilder: (context, index) {
                  return TimeCard(schedule: user.schedule.schedule_data[index]);
                }),
          ],
        );
      } catch (e) {
        return const CircularProgressIndicator();
      }
    });
  }

  void timecompare(List<Schedule> scheduleData) {
    // 각 노선에 대해 가장 가까운 출발 시간 찾기
    for (var schedule in scheduleData) {
      schedule.findNearestDepartureTime();
    }
    // 노선 정렬

    scheduleData.sort((a, b) {
      // a나 b의 nearest_departure가 null인 경우 처리
      if (a.nearest_departure == null && b.nearest_departure == null) {
        return 0; // 둘 다 null이면 순서를 변경하지 않음
      }
      if (a.nearest_departure == null) {
        return 1; // a만 null이면 a를 뒤로 보냄
      }
      if (b.nearest_departure == null) {
        return -1; // b만 null이면 b를 뒤로 보냄
      }

      // 둘 다 null이 아닌 경우, 실제 값으로 비교
      return a.nearest_departure!.compareTo(b.nearest_departure!);
    });

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
          print("minIndex changed: $minIndex");
          minIndex = scheduleData[i].id;
        }
      }
    }
  }

  bool get wantKeepAlive => true;

  void loadMarkerImage() async {
    busImage.add(await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5, size: Size(200, 200)),
        "assets/image/bus-active.png"));
    busImage.add(await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        "assets/image/bus-inactive.png"));
  }

}

import 'dart:convert';
import 'dart:math';

import 'package:busitionmate/Map/Route/RouteData.dart';
import 'package:busitionmate/Provider/RouteDataProvider.dart';
import 'package:busitionmate/Schedule/TimeCard.dart';
import 'package:busitionmate/Util/SocketManager.dart';
import 'package:busitionmate/Util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Provider/RealTimeData.dart';
import '../Provider/User.dart';
import '../Util/WebSocket.dart';
import 'Schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  ScheduleResponse? scheduleResponse;
  List<BitmapDescriptor> busImage = [];
  late SocketManager socketManager;

  @override
  void initState() {
    super.initState();
    updateScheduleData();
    if (busImage.isEmpty) loadMarkerImage();
  }

  void updateScheduleData() async {
    User user = Provider.of<User>(context, listen: false);
    if (!mounted) {
      return;
    }
    scheduleResponse = await requestSchedule();
    user.schedule = scheduleResponse!;
    socketManager = SocketManager();
    var realTimeData = Provider.of<RealTimeData>(context, listen: false);
    for (int id in user.schedule.scheduleData.keys) {
      socketManager.getSocket(id, user, realTimeData);
      user.changeStatus(
          (user.scheduleStatus[id] != null) ? user.scheduleStatus[id]! : false,
          id);
    }
    timeCompare(scheduleResponse!.scheduleData);
    setState(() {
      user.nearestScheduleID = minIndex;
      user.selectedID = minIndex;
    });
  }

  int minIndex = -1;

  double distanceBetween(LatLng a, LatLng b) {
    return sqrt(
        pow(a.latitude - b.latitude, 2) + pow(a.longitude - b.longitude, 2));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                height: 56,
                child: const Text(
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    "시간표")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent),
                onPressed: () {
                  setState(() {
                    updateScheduleData();
                  });
                },
                child: Text("O")),
          ],
        ),
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
                itemCount: user.schedule.scheduleCount,
                itemBuilder: (context, index) {
                  List<int> idList = user.schedule.scheduleData.keys.toList();
                  return TimeCard(ID: idList[index]);
                }),
          ],
        );
      } catch (e) {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  void timeCompare(Map<int, Schedule> scheduleData) {
    // 각 노선에 대해 가장 가까운 출발 시간 찾기
    scheduleData.forEach((id, schedule) {
      schedule.findNearestDepartureTime();
    });

    // Map.entries를 List로 변환하여 정렬
    var sortedEntries = scheduleData.entries.toList()
      ..sort((a, b) {
        // a나 b의 nearest_departure가 null인 경우 처리
        if (a.value.nearest_departure == null && b.value.nearest_departure == null) {
          return 0; // 둘 다 null이면 순서를 변경하지 않음
        }
        if (a.value.nearest_departure == null) {
          return 1; // a만 null이면 a를 뒤로 보냄
        }
        if (b.value.nearest_departure == null) {
          return -1; // b만 null이면 b를 뒤로 보냄
        }
        // 둘 다 null이 아닌 경우, 실제 값으로 비교
        return a.value.nearest_departure!.compareTo(b.value.nearest_departure!);
      });

    // 정렬된 entries를 다시 Map으로 변환
    Map<int, Schedule> sortedScheduleData = {
      for (var entry in sortedEntries) entry.key: entry.value
    };

    DateTime now = DateTime.now();
    int minDiff = 99999999999;

    for (int id in sortedScheduleData.keys) {
      // 현재시간
      for (int j = 0; j < scheduleData[id]!.first_departure_time.length; j++) {
        String data = scheduleData[id]!.first_departure_time[j];
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
          minIndex = id;
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

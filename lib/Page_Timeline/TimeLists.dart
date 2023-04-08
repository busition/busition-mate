import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/DayTime.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/DepartureTime.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/ScheduleData.dart';
import '../utils/constants.dart';
import 'ScheduleData/Schedule.dart';
import 'TimeCard.dart';
import 'TimeData.dart';
import 'package:http/http.dart' as http;

class TimeLists extends StatefulWidget {
  @override
  State<TimeLists> createState() => _TimeListsState();
}

class _TimeListsState extends State<TimeLists> {
  late double height, width;
  Future<Schedule>? schedule;

  ScheduleData noData = ScheduleData(
      routeId: 404,
      departurePoint: "",
      destination: "로딩중",
      departureTime: DepartureTime(dayTime: DayTime()));


  @override
  void initState() {
    super.initState();
    var userTime = TimeData(driverID: "wookingwoo"); //유저 아이디 입력란
    schedule = userTime.fetchSchedule(http.Client()); // 스케쥴 Json으로 가져오기
  }

  @override
  Widget build(BuildContext context) { // 메인 위젯
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: kAppbarMainColor,
            backgroundColor: kAppbarMainColor,
            title: Text(
              "일정표",
              style: kAppBarTitleTextStyle,
            ),
            automaticallyImplyLeading: true),
        body: SizedBox(
          child: FutureBuilder<Schedule>(
              future: schedule,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildList(snapshot.data, '');
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }
                return buildList(snapshot.data, "로딩중");
              }),
        ));
  }

  Widget buildList(Schedule? data, status) {
    if (data == null) {
      return ListView.builder( // No Data or Loading
          itemCount: data?.scheduleCount,
          itemBuilder: (BuildContext context, int index) {
            return TimeCard(data: noData, height: height);
          });
    } else {
      return ListView.builder( // Data Loaded
        itemCount: data.scheduleCount,
        itemBuilder: (BuildContext context, int index) {
          return TimeCard(data: data.scheduleData![index],height: height);
        },
      );
    }
  }
}

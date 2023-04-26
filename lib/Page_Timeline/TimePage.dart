import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/DayTime.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/DepartureTime.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/ScheduleData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Page_Maps/Maps.dart';
import '../utils/constants.dart';
import 'ScheduleData/Schedule.dart';
import 'TimeCard.dart';
import 'TimeData.dart';
import 'package:http/http.dart' as http;

class TimePage extends StatefulWidget {
  final PageController pageController;
  static late GoogleMapController mapController;

  TimePage({required this.pageController});

  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
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
  Widget build(BuildContext context) {
    // 메인 위젯
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
      ),
      floatingActionButton:
          FloatingActionButton(heroTag: "TTFloationg", onPressed: addNewSchedule, child: Text("+")),
    );
  }

  Widget buildList(Schedule? data, status) {
    if (data == null) {
      return ListView.builder(
          // No Data or Loading
          itemCount: data?.scheduleCount,
          itemBuilder: (BuildContext context, int index) {
            return TimeCard(data: noData, height: height, callback:jumpToMap);
          });
    } else {
      return ListView.builder(
        // Data Loaded
        itemCount: data.scheduleCount,
        itemBuilder: (BuildContext context, int index) {
          return TimeCard(data: data.scheduleData![index], height: height, callback: jumpToMap);
        },
      );
    }
  }

  //버튼 눌렀을 때, 지도로 가는 페이지
  void jumpToMap(double selection){
    widget.pageController.jumpToPage(1);
    TimePage.mapController.animateCamera(CameraUpdate.zoomTo(selection));
    if (selection < 15){
      goCenter();
    }
  }

  void goCenter(){
    MapsState.showAllRoute();
  }

  Future addNewSchedule() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: newScheduleScreen());
        });
  }

  Widget newScheduleScreen() {
    return Container(
        padding: EdgeInsets.all(16),
        height: height / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "새로운 셔틀버스 추가하기",
                    style: kMessageTextStyle,
                  ),
                ),
                Text("6자리 코드를 입력해 노선을 추가하세요", style: kCardSubTextStyle),
              ],
            ),
            TextField(
                maxLength: 6,
                textAlign: TextAlign.center,
                style: kAddNewBusTextStyle,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "123456",
                    hintStyle: TextStyle(color: Colors.black26))),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("추가하기")),
          ],
        ));
  }
}

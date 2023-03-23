import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/DayTime.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/DepartureTime.dart';
import 'package:flutter_foreground_task_example/Page_Timeline/ScheduleData/ScheduleData.dart';
import '../utils/constants.dart';
import 'ScheduleData/Schedule.dart';
import 'TimeData.dart';
import 'package:http/http.dart' as http;

class TimeLists extends StatefulWidget {
  final String recordName;

  const TimeLists(this.recordName, {Key? key}) : super(key: key);

  @override
  State<TimeLists> createState() => _TimeListsState();
}

class _TimeListsState extends State<TimeLists> {
  late double height, width;
  Future<Schedule>? schedule;

  @override
  void initState() {
    super.initState();
    var userTime = TimeData(driverID: "1");
    schedule = userTime.fetchSchedule(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: AppBar(
                title: Text(
                  "일정표",
                  style: kAppBarTitleTextStyle,
                ),
                automaticallyImplyLeading: true)),
        body: SizedBox(
          child: FutureBuilder<Schedule>(
              future: schedule,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.scheduleCount,
                    itemBuilder: (BuildContext context, int index) {
                      return cards(snapshot.data?.scheduleData![index]);
                    },
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data?.scheduleCount,
                    itemBuilder: (BuildContext context, int index) {
                      return cards(ScheduleData(
                          routeId: 0,
                          departurePoint: "",
                          destination: "로딩중",
                          departureTime: DepartureTime(
                              dayTime: DayTime(dayOfWeek: "", time: ""))));
                    });
              }),
        ));
  }

  Widget cards(s) {
    return Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
        child: Card(
          color: const Color.fromARGB(255, 255, 220, 150),
          child: SizedBox(
            width: height / 2,
            height: height / 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: height / 7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.destination,
                              style: kCardMainTextStyle,
                            ),
                            Text(
                              "${s.departurePoint} ->${s.destination}",
                              style: kCardTimeTextStyle,
                            ),
                            Text("출발 시간: ${s.departureTime.dayTime.time}"),
                          ],
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          child: Divider(
                            height: 1,
                            thickness: 0.5,
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: (height / (6 * 3)) - 16,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: Text("하차 여부", style: kCardSubTextStyle),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

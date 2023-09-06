import 'package:Busition_Mate/utils/QRScanner.dart';
import 'package:Busition_Mate/utils/permissionHandlerClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Busition_Mate/Page_Timeline/ScheduleData/DayTime.dart';
import 'package:Busition_Mate/Page_Timeline/ScheduleData/DepartureTime.dart';
import 'package:Busition_Mate/Page_Timeline/ScheduleData/ScheduleData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../LoginClass.dart';
import '../MainPage.dart';
import '../Page_Maps/Maps.dart';
import '../utils/SocketServices.dart';
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

class _TimePageState extends State<TimePage>
    with AutomaticKeepAliveClientMixin {
  late double height, width;
  Future<Schedule>? schedule;

  ScheduleData noData = ScheduleData(
    routeId: 404,
    departurePoint: "",
    destination: "로딩중",
  );

  //departureTime: DepartureTime(dayTime: DateTime.now()));

  @override
  void initState() {
    super.initState();
    var userTime = TimeData(); //유저 아이디 입력란
    schedule = userTime.fetchSchedule(http.Client()); // 스케쥴 가져오기
  }

  Widget organization() {
    String result = "";
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController controller = TextEditingController();
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  content: Column(
                    children: [
                      Text("기관 추가하기", style: kCardMainTextStyle),
                      Text("기관에서 제공한 코드를 입력해 기관을 추가하세요"),
                      TextField(
                        controller: controller,
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                              onPressed: () async {
                                List? a = await Institution.newInstitution(
                                    controller.text);
                                if (a![0] == false) {
                                  setState(() {
                                    result = a[1];
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("추가하기")),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const QrScanner() ),
                                );
                              },
                              child: Text("QR"))
                        ],
                      ),
                      Text(result),
                    ],
                  ),
                );
              });
            });
      },
      isExtended: true,
      child: const Text(
        "기관 \n추가하기",
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 메인 위젯
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: organization(),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: kAppbarMainColor,
          backgroundColor: kAppbarMainColor,
          title: Text(
            "일정표",
            style: kAppBarTitleTextStyle,
          )),
      body: SizedBox(
        child: FutureBuilder<Schedule>(
            future: schedule,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot.data);
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              return buildList(snapshot.data);
            }),
      ),
      // floatingActionButton: FloatingActionButton(
      //     heroTag: "TTFloationg", onPressed: addNewSchedule, child: Text("+")),
    );
  }

  Widget buildList(Schedule? data) {
    if (data != null) {
      if (data.scheduleData == null) {
        return loding();
      } else {
        return RefreshIndicator(
          onRefresh: () async {
            var socketServices = SocketServices();
            for (int i = 0; i < data.scheduleCount!; i++) {
              if (data.scheduleData![i].routeId != null) {
                var routeInfo = data.scheduleData![i];
                socketServices.startSocket(routeInfo.routeId!.toString(),
                    LoginClass.profile.email!, i);
              }

              setState(() {});
              await Future.delayed(Duration(microseconds: 2000));
            }
          },
          child: ListView.builder(
            // Data Loaded
            itemCount: data.scheduleCount,
            itemBuilder: (BuildContext context, int index) {
              var socketServices = SocketServices();
              if (data.scheduleData![index].routeId != null) {
                var routeInfo = data.scheduleData![index];
                socketServices.startSocket(routeInfo.routeId!.toString(),
                    LoginClass.profile.email!, index);
              }
              return data.scheduleData != null
                  ? StreamBuilder<SocketServices>(
                      stream: timeTicking(socketServices),
                      builder: (context, snapshot) {
                        String status = "로딩중";
                        if (snapshot.hasData) {
                          status = snapshot.data!.status;
                        }
                        return TimeCard(
                            status: status,
                            data: data.scheduleData![index],
                            height: height,
                            callback: jumpToMap);
                      })
                  : Text("No data");
            },
          ),
        );
      }
    } else {
      return loding();
    }
  }

  Stream<SocketServices> timeTicking(SocketServices socketServices) async* {
    const Duration duration = Duration(seconds: 1);
    while (true) {
      await Future.delayed(duration);

      yield socketServices;
    }
  }

  Widget loding() {
    return ListView.builder(
        // No Data or Loading
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return TimeCard(
              status: "로딩중", data: noData, height: height, callback: jumpToMap);
        });
  }

  //버튼 눌렀을 때, 지도로 가는 페이지
  void jumpToMap(double selection) {
    widget.pageController.jumpToPage(1);
    TimePage.mapController.animateCamera(CameraUpdate.zoomTo(selection));
    if (selection < 15) {
      goCenter();
    }
  }

  void goCenter() {
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

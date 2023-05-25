import 'package:Busition_Mate/utils/BluetoothAdvertiseModele.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Busition_Mate/Page_Timeline/NewMap/NewMapPage.dart';
import 'package:Busition_Mate/Page_Timeline/ScheduleData/ScheduleData.dart';

import '../utils/constants.dart';
import 'ScheduleData/ScheduleData.dart';

class TimeCard extends StatefulWidget {
  ScheduleData data;
  double height;
  String status = "대 ";
  void Function(double selection) callback;

  TimeCard({required this.status, required this.data, required this.height, required this.callback});

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  late DateTime? a = DateTime.parse(
      "2022-01-01" + widget.data.departureTime!.dayTime!.time!.time!);


  @override
  Widget build(BuildContext context) {
    try {
      String routeName = widget.data.destination!;
      String departurePoint = widget.data.departurePoint!;
      double cardheight = widget.height / 4;
      return Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
          child: Card(
            shadowColor: const Color.fromARGB(0, 1, 1, 1),
            color: const Color.fromARGB(255, 255, 230, 170),
            child: SizedBox(
              width: widget.height / 2,
              height: cardheight,
              child: Column(
                children: [
                  Container(
                    height: cardheight,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                routeName,
                                style: kMessageTextStyle,
                              ),
                              Text(
                                widget.status,
                                style: kCardMainTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                                padding: EdgeInsets.only(right: 16),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${a!.hour}시 ${a!.minute}분 출발",
                                  style: kCardSubTextStyle,
                                )),
                            const Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 16, bottom: 8),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.5,
                                )),
                            Container(
                                alignment: Alignment.centerLeft,
                                height: (widget.height / (6 * 3)) - 16,
                                child: routeName != "로딩중"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          rideButton(),
                                          MaterialButton(
                                              onPressed: () {
                                                widget.callback(15);
                                              },
                                              child: Text(
                                                "지도 보기",
                                                style: kCardSubTextStyle,
                                              )),
                                          MaterialButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  if (widget.data.routeId !=
                                                      null) {
                                                    return ViewWholePage(
                                                        userID:
                                                            //TODO, Null Catch
                                                            widget
                                                                .data.routeId!,
                                                        direction: widget.data
                                                            .shuttleDirection!);
                                                  } else {
                                                    return Text(
                                                        'Error, 실제 노선이 없습니다');
                                                  }
                                                }));
                                              },
                                              child: Text(
                                                "노선 상세 정보",
                                                style: kCardSubTextStyle,
                                              ))
                                        ],
                                      )
                                    : Text("?")),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
    } catch (e) {
      return Container();
    }
  }

  Widget rideButton() {
    return OutlinedButton(
        onPressed: () {
          BluetoothAdvertiseModule bluetoothAdvertiseModule =
              BluetoothAdvertiseModule();

          bluetoothAdvertiseModule.toggleAdvertiseSet();
        },
        child: Text("탑승하기"));
  }
}

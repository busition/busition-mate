import 'package:busitionmate/Provider/RouteDataProvider.dart';
import 'package:busitionmate/Util/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../GlobalPageRoute.dart';
import '../Map/NowMapPage.dart';
import '../Provider/User.dart';
import 'Schedule.dart';

class TimeCard extends StatefulWidget {
  final int ID;

  const TimeCard({super.key, required this.ID});

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  bool isDisabled = false;
  late Schedule schedule;

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      if (user.schedule.scheduleData[widget.ID] == null) {
        return SizedBox();
      } else {
        schedule = user.schedule.scheduleData[widget.ID]!;
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: busitionTimeCardBoxDecoration,
              height: 224,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 14, left: 12, right: 12, bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width - 60,
                          child: Text(
                            "${schedule.departure_point} - ${schedule.destination}",
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Builder(builder: (context) {
                        return (user.scheduleStatus[schedule.id] != null)
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11.0),
                                  color: (!user.scheduleStatus[schedule.id]!)
                                      ? cardDisabled
                                      : cardEnabled,
                                ),
                                padding: const EdgeInsets.all(12.0),
                                height: 114,
                                width: MediaQuery.of(context).size.width,
                                child: _buildStatusContent(isDisabled),
                              )
                            : SizedBox();
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cardButton(() {
                          pageController!.jumpToPage(1);
                          User user = Provider.of<User>(context, listen: false);
                          user.selectedID = schedule.id;
                          user.selectedPageIndex = 1;
                          RouteDataProvider routeDataProvider =
                              Provider.of<RouteDataProvider>(context,
                                  listen: false);
                          routeDataProvider.requestRoute(user.selectedID);
                        }, "지도보기"),
                        cardButton(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NowMapPage(routeID: schedule.id);
                          }));
                        }, "노선 상세정보"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  Widget _buildStatusContent(bool isDisabled) {
    return Consumer<User>(builder: (context, user, child) {
      return Column(
        children: [
          Image.asset(
            !user.scheduleStatus[schedule.id]!
                ? "assets/image/bus-inactive.png"
                : "assets/image/bus-active.png",
            height: 32,
            width: 88,
          ),
          Text(
            !user.scheduleStatus[schedule.id]! ? "출발 준비중" : "이동 중",
            style: TextStyle(
                fontSize: 24,
                fontWeight: isDisabled ? FontWeight.w700 : FontWeight.w500),
          ),
          (!user.scheduleStatus[schedule.id]!)
              ? _buildDepartureText(schedule.nearest_departure)
              : Container(),
        ],
      );
    });
  }

  Widget _buildDepartureText(DateTime? departureTime) {
    if (departureTime == null) {
      return const Text(
        "출발 정보 없음",
        style: TextStyle(
            fontFamily: "NanumSquareNeo",
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      );
    } else {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: (DateTime.now().isBefore(departureTime))
                  ? DateFormat("HH시 mm분").format(departureTime)
                  : DateFormat("익일 HH시 mm분").format(departureTime),
              style: const TextStyle(
                  fontFamily: "NanumSquareNeo",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            const TextSpan(
              text: " 에 출발예정",
              style: TextStyle(
                  fontFamily: "NanumSquareNeo",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 73, 80, 87)),
            ),
          ],
        ),
      );
    }
  }

  Widget cardButton(Function() onPressed, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(30, 30),
        padding: const EdgeInsets.all(8.0),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color.fromARGB(255, 233, 236, 239),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}

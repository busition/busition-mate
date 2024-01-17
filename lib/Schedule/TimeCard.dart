import 'package:busitionmate/Provider/RouteDataProvider.dart';
import 'package:busitionmate/Util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GlobalPageRoute.dart';
import '../Map/NowMapPage.dart';
import '../Provider/User.dart';
import 'Schedule.dart';

class TimeCard extends StatefulWidget {
  final Schedule schedule;

  const TimeCard({super.key, required this.schedule});

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleResponse>(builder: (context, schedule, child) {
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
                          "${widget.schedule.departure_point} - ${widget.schedule.destination} ID: ${widget.schedule.id}",
                          style: TextStyle(
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
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11.0),
                          color: (!widget.schedule.isActive)
                              ? cardDisabled
                              : cardEnabled,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        height: 114,
                        width: MediaQuery.of(context).size.width,
                        child: _buildStatusContent(isDisabled),
                      );
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cardButton(() {
                        pageController!.jumpToPage(1);
                        User user = Provider.of<User>(context, listen: false);
                        user.selectedID = widget.schedule.id;
                        user.selectedPageIndex = 1;
                        RouteDataProvider routeDataProvider =
                            Provider.of<RouteDataProvider>(context,
                                listen: false);
                        routeDataProvider.requestRoute(user.selectedID);
                      }, "지도보기"),
                      cardButton(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return NowMapPage(routeID: widget.schedule.id);
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
    });
  }

  Widget _buildStatusContent(bool isDisabled) {
    return Column(
      children: [
        Image.asset(
          !widget.schedule.isActive
              ? "assets/image/bus-inactive.png"
              : "assets/image/bus-active.png",
          height: 32,
          width: 88,
        ),
        Text(
          !widget.schedule.isActive ? "출발 준비중" : "출발 중",
          style: TextStyle(
              fontSize: 24,
              fontWeight: isDisabled ? FontWeight.w700 : FontWeight.w500),
        ),
        _buildDepartureText(widget.schedule.nearest_departure),
      ],
    );
  }

  Widget _buildDepartureText(DateTime? departureTime) {
    if (departureTime == null) {
      return Text(
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
              text: "${departureTime.hour}:${departureTime.minute}",
              style: TextStyle(
                  fontFamily: "NanumSquareNeo",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            TextSpan(
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

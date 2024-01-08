import 'package:busitionmate/Util/constants.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: busitionTimeCardBoxDecoration,
          height: 224,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 14, left: 12, right: 12, bottom: 12),
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
                        "${widget.schedule.departure_point} - ${widget.schedule.destination}",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color: (!isDisabled) ? cardDisabled : cardEnabled,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    height: 114,
                    width: MediaQuery.of(context).size.width,
                    child: _buildStatusContent(isDisabled),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cardButton(() {}, "지도보기"),
                    cardButton(() {}, "노선 상세정보"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildStatusContent(bool isDisabled) {
    return Column(
      children: [
        Image.asset(
          !isDisabled ? "assets/image/bus-inactive.png" : "assets/image/bus-active.png",
          height: 32,
          width: 88,
        ),
        Text(
          !isDisabled ? "출발 준비중" : "출발 중",
          style: TextStyle(fontSize: 24, fontWeight: isDisabled ? FontWeight.w700 : FontWeight.w500),
        ),
        _buildDepartureText(widget.schedule.nearest_departure),
      ],
    );
  }

  Widget _buildDepartureText(DateTime? departureTime) {
    if (departureTime == null) {
      return Text(
        "출발 정보 없음",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
      );
    } else {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${departureTime.hour}:${departureTime.minute}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            TextSpan(
              text: " 에 출발예정",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 73, 80, 87)),
            ),
          ],
        ),
      );
    }
  }


  Widget cardButton(function(), String text) {
    return ElevatedButton(
      onPressed: function,
      child: Text(text, style: TextStyle(fontSize: 18)),
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
    );
  }
}

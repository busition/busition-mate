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
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.schedule.departure_point} - ${widget.schedule.destination}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Container(
                  height: 114,
                  width: MediaQuery.of(context).size.width,
                  color: cardDisabled,
                  child: Column(
                    children: [
                      Text(
                        "${widget.schedule.name} 노선",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Text(
                      //     "${widget.schedule.departure_point} - ${widget.schedule.destination}"),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cardButton(() {}, "수정"),
                    cardButton(() {}, "삭제"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardButton(function(), String text) {
    return ElevatedButton(
      onPressed: function,
      child: Text(text, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color.fromARGB(255, 233, 236, 239),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

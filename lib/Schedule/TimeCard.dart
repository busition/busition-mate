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
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: busitionTimeCardBoxDecoration,
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${widget.schedule.id}"),
              Text(
                "${widget.schedule.name} 노선",
                style: TextStyle(fontSize: 30),
              ),
              Text(
                  "${widget.schedule.departure_point} - ${widget.schedule.destination}"),
            ],
          ),
        ),
      ),
    );
  }
}

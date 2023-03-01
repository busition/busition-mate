import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TimeLists extends StatefulWidget {
  final String recordName;

  const TimeLists(this.recordName);

  @override
  State<TimeLists> createState() => _TimeListsState();
}

class _TimeListsState extends State<TimeLists> {
  late double height, width;

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
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Cards('Case $index');
            },
          ),
        ));
  }

  Widget Cards(s) {
    return Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
        child: Card(
          color: Color.fromARGB(255, 255, 220, 150),
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
                        child: Text(
                          "Title ${widget.recordName} | $s",
                          style: kCardMainTextStyle,
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
                        child: Text("하차여부", style: kCardSubTextStyle),
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

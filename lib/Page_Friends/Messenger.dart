import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Friends extends StatefulWidget {

  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  late List<String> friendlist;
  late double height, width;

  @override
  Widget build(BuildContext context) {
    getFriend();

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text("친구 목록",style: kAppBarTitleTextStyle), automaticallyImplyLeading: false),
        body: SizedBox(
          child: ListView.builder(
            itemCount: friendlist.length,
            itemBuilder: (BuildContext context, int index) {
              return cards(friendlist[index]);
            },
          ),
        ));
  }

  Widget cards(userName) {
    double cardHeight = height / 8;
    return Container(
      decoration: kBoxUnderLineStyle,
      child: SizedBox(
          height: cardHeight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: cardHeight / 1.5,
                    width: cardHeight / 1.5,
                    decoration: kProfileImage,
                    child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Image(
                          image: AssetImage("assets/image/No_Image.png"),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "$userName",
                      style: kCardMainTextStyle,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  getFriend() {
    friendlist = ["김준혁", "우정헌", "유경민"];
  }
}

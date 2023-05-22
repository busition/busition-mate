import 'package:Busition_Mate/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfileListView extends StatefulWidget {
  const ProfileListView({Key? key}) : super(key: key);

  @override
  State<ProfileListView> createState() => _ProfileListViewState();
}

class _ProfileListViewState extends State<ProfileListView> {
  List<String> profileSettingList = [
    "닉네임 변경하기",
    "프로필 사진 변경하기",
    "전화번호 변경하기",
    "로그아웃"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: profileSettingList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {},
              child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    profileSettingList[index],
                    style: kMessageTextStyle,
                  )));
        });
  }
}

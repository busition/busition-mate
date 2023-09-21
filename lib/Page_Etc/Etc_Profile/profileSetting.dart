import 'package:Busition_Mate/LoginClass.dart';
import 'package:Busition_Mate/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfileListView extends StatefulWidget {
  const ProfileListView({Key? key}) : super(key: key);

  @override
  State<ProfileListView> createState() => _ProfileListViewState();
}

class _ProfileListViewState extends State<ProfileListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MaterialButton(
              onPressed: () {
                LoginClass.signOut(context);
              },
              child: Container(child: Text("로그아웃 하기"))),
          MaterialButton(
              onPressed: () {
                LoginClass.removeUser(context);
              },
              child: Container(child: Text("회원 탈퇴하기"))),
        ],
      ),
    );
  }
}

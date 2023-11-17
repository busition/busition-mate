import 'dart:ui';

import 'package:flutter/cupertino.dart';

Color busitionOrange = const Color.fromARGB(255, 233, 153, 62);
BoxDecoration busitionTimePageBackground = const BoxDecoration(
    boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 0, 0, 0),
          offset: Offset(0, 0),
          blurRadius: 2,
          spreadRadius: 0)
    ],
    color: Color.fromARGB(255, 243, 178, 95),
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)));

BoxDecoration busitionTimeCardBoxDecoration = const BoxDecoration(
    boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 0, 0, 0),
          offset: Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 0)
    ],
    color: Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.all(Radius.circular(10)));

import 'dart:ui';

import 'package:flutter/cupertino.dart';

Color busitionPrimary = const Color.fromARGB(255, 248, 249, 250);

Color cardEnabled = const Color.fromARGB(255, 252, 247, 240);
Color cardDisabled = const Color.fromARGB(255, 248, 248, 248);

BoxDecoration busitionTimePageBackground = const BoxDecoration(
    boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 0, 0, 0),
          offset: Offset(0, 0),
          blurRadius: 2,
          spreadRadius: 0)
    ],
    color: Color.fromARGB(255, 252, 247, 240),
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)));

BoxDecoration busitionTimeCardBoxDecoration = const BoxDecoration(
    boxShadow: [
      BoxShadow(
          color: Color.fromARGB(10, 0, 0, 0),
          offset: Offset(0, 1),
          blurRadius: 10,
          spreadRadius: 0)
    ],
    color: Color.fromARGB(255, 255, 255, 255),
    border: Border.fromBorderSide(BorderSide(
        color: Color.fromARGB(255, 233, 236, 239),
        width: 2,
        style: BorderStyle.solid)),
    borderRadius: BorderRadius.all(Radius.circular(10)));

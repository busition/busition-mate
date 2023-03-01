import 'package:flutter/material.dart';

BoxDecoration kBoxUnderLineStyle = const BoxDecoration(
  color: Color.fromARGB(235, 235, 230, 230),
  border: Border(
    bottom: BorderSide(
      color: Color.fromARGB(255, 215, 215, 215),
      width: 0.5
    )
  )
);


BoxDecoration kProfileImage = const BoxDecoration(
    color: Color.fromARGB(235, 175, 175, 175),
    borderRadius: BorderRadius.all(Radius.circular(20)
    )
);


TextStyle kCardMainTextStyle = const TextStyle(
  fontFamily: 'PretendardLight',
  fontSize: 30.0,
);

TextStyle kMessageTextStyle = const TextStyle(
  fontFamily: 'PretendardThin',
  fontSize: 60.0,
);

TextStyle kCardSubTextStyle = const TextStyle(
  fontFamily: 'PretendardThin',
  fontSize: 20.0,
);

TextStyle kAppBarTitleTextStyle = const TextStyle(
  fontFamily: 'PretendardBold',
  fontSize: 30,
);
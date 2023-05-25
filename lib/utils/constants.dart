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

BoxDecoration kInfoBoxBorder = const BoxDecoration(
    color: Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.all(Radius.circular(20)
    )
);

BoxDecoration kHalfBoxBorder = const BoxDecoration(
    color: Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)
    )
);



BoxDecoration KCircularBorder = BoxDecoration(
  color: const Color.fromARGB(255, 230, 240, 250),
  borderRadius: BorderRadius.circular(50)
);


BoxDecoration kProfileImage = const BoxDecoration(
    color: Color.fromARGB(235, 175, 175, 175),
    borderRadius: BorderRadius.all(Radius.circular(20)
    )
);

TextStyle kCardTitleTextStyle = const TextStyle(
  fontFamily: 'PretendardMedium',
  fontSize: 50.0,
);
// Main Title Text Style

TextStyle kProfileNameTextStyle = const TextStyle(
  fontFamily: 'PretendardMedium',
  fontSize: 24,
);

TextStyle kEtcPageButtonTextStyle = const TextStyle(
  fontFamily: 'PretendardMedium',
  fontSize: 17,
);



TextStyle kCardMainTextStyle = const TextStyle(
  fontFamily: 'PretendardLight',
  fontSize: 24.0,
);
//TimeCard Main Text <1정거장 전>


TextStyle kCardTimeTextStyle = const TextStyle(
  fontFamily: 'PretendardLight',
  fontSize: 15.0,
);


TextStyle kMessageTextStyle = const TextStyle(
  fontFamily: 'PretendardLight',
  fontSize: 18.0,
);
// newScheduleScreen() 새로운 셔틀버스 추가하기


TextStyle kCardSubTextStyle = const TextStyle(
  fontFamily: 'PretendardMedium',
  fontSize: 11.0,
);
// newScheduleScreen() 새로운 셔틀버스 추가하기
// TimeCard.dart
// 지도 보기 버튼 <지도 보기>,
// 다음 정류장 표시 버튼 <**(으)로 이동 중>

TextStyle kAppBarTitleTextStyle = const TextStyle(
  fontFamily: 'PretendardMedium',
  fontSize: 30,
);

TextStyle kAddNewBusTextStyle = const TextStyle(
  fontFamily: 'PretendardMedium',
  fontSize: 20,
  letterSpacing: 2.0
);
// newScheduleScreen TextField


//   PretendardThin    Thiner goes upper
//   PretendardLight
//   PretendardMedium
//   PretendardBlack
//   PretendardBold




// Colors

Color kAppbarMainColor = const Color.fromARGB(255, 254, 247, 255);
Color kNavbarMainColor = const Color.fromARGB(255, 232, 222, 248);


// Decorations

BorderRadius kBorderStyle30 = const BorderRadius.all(Radius.circular(30));

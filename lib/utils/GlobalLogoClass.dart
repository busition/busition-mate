import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class LogoClass{
  static late Widget svg;
  static logoLoad(double width){
    const String logo = "assets/image/Logo.svg";
    svg = SvgPicture.asset(
        logo,
        width: width * 0.8,
        colorFilter: ColorFilter.mode(
            Color(0xffffffff),
            BlendMode.srcATop
        ),
        semanticsLabel: 'Main Logo'

    );
  }
}
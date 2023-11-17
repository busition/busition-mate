import 'package:flutter/cupertino.dart';


const routeHome = '/';
const routeLogin = '/login';
const routeSignup = '/signup';
const routeTimeline = '/timeline';
const routeMap = '/map';
const routeSetting = '/setting';
const routeNewMap = '/newmap';
PageController? pageController;
int selectedIndex = 0;


class GlobalPageRoute extends PageRouteBuilder {
  final Widget page;
  GlobalPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );


}
import 'dart:convert';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapRoute {
  final routeURL = "http://api.dev.busition.com:8001/route/directions/";
  var routeNumber = "1";

  // var response;

  MapRoute(int number) {
    routeNumber = number.toString();
  }

  callAPI() async {}

  Future<List> fetchRoute(http.Client client) async {
    var url = Uri.parse(routeURL + routeNumber);

    final response = await client.get(url);
    var data = utf8.decode(response.bodyBytes);
    final list = jsonDecode(data);
    final dd = RouteData.fromJson(list);
    print(dd.route);
    print(list[0]);
    return dd.route;
  }
}

class RouteData {
  String code, message, curruntDateTime;
  List<dynamic> route;

  RouteData(
      {required this.code,
      required this.message,
      required this.curruntDateTime,
      required this.route});

  factory RouteData.fromJson(Map<String, dynamic> parsedJson) {
    print("Point!");
    //print((parsedJson['route']["traoptimal"][0]["path"].toString())+"테스트");
    print("point!!");
    return RouteData(
        code: parsedJson["code"].toString(),
        message: parsedJson["message"].toString(),
        curruntDateTime: parsedJson['curruntDateTime'].toString(),
        route: parsedJson['route']["traoptimal"][0]["path"]
    );
  }
}

import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class MapRoute {
  final routeURL = "http://api.dev.busition.com:8001/route/directions/";
  var routeNumber = "1";

  MapRoute(int number) {
    routeNumber = number.toString();
  }

  Future<List> fetchRoute(http.Client client) async {
    var url = Uri.parse(routeURL + routeNumber);

    final response = await client.get(url);
    var data = utf8.decode(response.bodyBytes);
    final list = jsonDecode(data);
    final routeStringData = RouteData.fromJson(list);
    return routeStringData.route;
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
    List<dynamic> way = [];
    way.add(parsedJson['route']["traoptimal"][0]["path"]);
    way.add(parsedJson['route']["traoptimal"][0]["section"]);

    return RouteData(
        code: parsedJson["code"].toString(),
        message: parsedJson["message"].toString(),
        curruntDateTime: parsedJson['curruntDateTime'].toString(),
        route: way
    );
  }
}

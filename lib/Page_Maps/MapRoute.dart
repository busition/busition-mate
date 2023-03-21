import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class MapRoute {
  String routeNumber = "1";
  late String direction = "1";
  late String routeURL;
  late String stationURL;

  MapRoute(int number,int direction) {
    this.direction = direction.toString();
    routeNumber = number.toString();
    routeURL = "http://api.dev.busition.com:8001/route/$routeNumber?shuttle_direction=${this.direction}";
    stationURL = "http://api.dev.busition.com:8001/station?route_id=$routeNumber&shuttle_direction=${this.direction}";
  }

  Future<RouteData> fetchRoute(http.Client client) async {
    var url = Uri.parse(routeURL);
    final responsePath = await client.get(url);
    // url = Uri.parse(routeURL);
    // final responseStation = await client.get(url);
    var data = utf8.decode(responsePath.bodyBytes);

    final list = jsonDecode(data);
    final routeStringData = RouteData.fromJson(list);
    return routeStringData;
  }
}

class RouteData {
  String code, message, curruntDateTime;
  List<dynamic> route, section;

  RouteData(
      {required this.code,
      required this.message,
      required this.curruntDateTime,
      required this.route,
      required this.section});

  factory RouteData.fromJson(Map<String, dynamic> parsedJson) {
    return RouteData(
        code: parsedJson["code"].toString(),
        message: parsedJson["message"].toString(),
        curruntDateTime: parsedJson['curruntDateTime'].toString(),
        route: parsedJson['route']["traoptimal"][0]["path"],
        section: parsedJson['route']["traoptimal"][0]["summary"]["waypoints"]
    );
  }
}

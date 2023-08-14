import 'dart:convert';
import 'dart:async';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'RouteData.dart';

class MapRoute {
  String routeNumber = "1";
  late String direction = "1";
  late String routeURL;
  late String stationURL;

  MapRoute(String number, int direction) {
    this.direction = direction.toString();
    routeNumber = number.toString();
    routeURL = "http://api.dev2.busition.com:8001/latest/routes/$routeNumber?auth_type=Email";
    print(routeURL);
  }

  Future<RouteData> fetchRoute(http.Client client) async {
    Uri url = Uri.parse(routeURL);
    Response responsePath = await client.get(url,
        headers: {'Authorization': "Bearer ${LoginClass.idTokenResult}"});
    var data = utf8.decode(responsePath.bodyBytes);

    final list = jsonDecode(data);
    final routeStringData = RouteData.fromJson(list);
    return routeStringData;
  }
}

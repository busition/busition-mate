import 'dart:convert';
import 'dart:async';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:http/http.dart' as http;

import 'RouteData.dart';

class MapRoute {
  String routeNumber = "1";
  late String direction = "1";
  late String routeURL;
  late String stationURL;

  MapRoute(String number,int direction) {
    this.direction = direction.toString();
    routeNumber = number.toString();
    routeURL = "http://api.dev.busition.com:8001/v1_3/route/$routeNumber?shuttle_direction=${this.direction}";
  }

  Future<RouteData> fetchRoute(http.Client client) async {
    Uri url = Uri.parse(routeURL);
    final responsePath = await client.get(url, headers: {'Authorization':"Bearer ${LoginClass.idTokenResult.token}"});
    var data = utf8.decode(responsePath.bodyBytes);

    final list = jsonDecode(data);
    final routeStringData = RouteData.fromJson(list);
    return routeStringData;
  }
}

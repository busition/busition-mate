import 'dart:convert';

import 'package:busitionmate/Map/Route/RouteData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class RouteDataProvider extends ChangeNotifier {
  RouteData? _routeData;

  RouteData? get routeData => _routeData;

  Future<RouteData> requestRoute(int routeID) async {
    if (routeID == -1) {
      return RouteData.fromJson({
        "path_count": 0,
        "path": [],
        "route_name": "현재 노선이 없습니다.",
        "route_description": "노선을 추가해보세요",
        "station_count": 0,
        "total_passenger_count": 0,
        "station_data": []
      });
    }
    print("Http Request: Route");
    final response = await http.get(
        headers: {"Authorization": "Bearer ${User.idTokenResult}"},
        Uri.parse(
            "http://api.dev2.busition.com:8001/latest/routes/$routeID?auth_type=Email"));
    // response to UTF-8
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return RouteData.fromJson(jsonDecode(data));
    } else {
      throw Exception('Failed to load album $data');
    }
  }
}

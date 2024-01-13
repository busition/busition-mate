import 'dart:convert';

import 'package:busitionmate/Map/Route/RouteData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class RouteDataProvider extends ChangeNotifier {
  RouteData? _routeData;

  RouteData? get routeData => _routeData;

  RouteData emptyRouteData = RouteData.fromJson({
    "path_count": 0,
    "path": [],
    "route_name": "현재 노선이 없습니다.",
    "route_description": "노선을 추가해보세요",
    "station_count": 0,
    "total_passenger_count": 0,
    "station_data": []
  });

  Future<void> requestRoute(int routeID) async {
    print("routeID: $routeID");
    if (routeID == -1) {
      _routeData = emptyRouteData;
      notifyListeners();
    }
    print("Http Request: Route, routeID: $routeID");
    final response = await http.get(
        headers: {"Authorization": "Bearer ${User.idTokenResult}"},
        Uri.parse(
            "http://api.dev2.busition.com:8001/latest/routes/$routeID?auth_type=Email"));
    // response to UTF-8
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      _routeData = RouteData.fromJson(jsonDecode(data));
      notifyListeners();
    } else {
      _routeData = emptyRouteData;
      notifyListeners();

      throw Exception('Failed to load album $data ${response.statusCode}');
    }
  }
}

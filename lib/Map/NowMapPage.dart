import 'dart:convert';
import 'dart:math';

import 'package:busitionmate/Map/MapPage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

import '../Provider/User.dart';
import 'Route/RouteData.dart';

class NowMapPage extends MapPage {
  int routeID;

  NowMapPage({super.key, required this.routeID});

  @override
  State<NowMapPage> createState() => _NowMapPageState();
}

class _NowMapPageState extends State<NowMapPage> {
  late GoogleMapController mapController;
  RouteData? _routeData;
  late List<LatLng> path;
  LatLng center = LatLng(37.5665, 126.9780);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RouteData>(
          future: getRoute(widget.routeID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              RouteData? data = snapshot.data;
              for (var i = 0; i < data!.pathCount; i++) {
                path.add(LatLng(data.path[i][0], data.path[i][1]));
              }
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.5665, 126.9780),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                polylines: _createPolyline(path),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Set<Polyline> _createPolyline(List<LatLng> path) {
    Set<Polyline> polyline = {};
    polyline.add(Polyline(
        polylineId: const PolylineId("route"),
        visible: true,
        points: path,
        width: 4,
        color: Colors.blue));
    return polyline;
  }

  Future<RouteData> getRoute(int routeID) async {
    RouteData emptyRouteData = RouteData.fromJson({
      "path_count": 0,
      "path": [],
      "route_name": "현재 노선이 없습니다.",
      "route_description": "노선을 추가해보세요",
      "station_count": 0,
      "total_passenger_count": 0,
      "station_data": []
    });

    print("Http Request: Route, routeID: $routeID");
    final response = await http.get(
        headers: {"Authorization": "Bearer ${User.idTokenResult}"},
        Uri.parse(
            "http://api.dev2.busition.com:8001/latest/routes/$routeID?auth_type=Email"));
    // response to UTF-8
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      _routeData = RouteData.fromJson(jsonDecode(data));
    } else {
      _routeData = emptyRouteData;
      throw Exception('Failed to load album $data ${response.statusCode}');
    }
    return _routeData!;
  }

  LatLng _getCenterPoint(List<LatLng> location) {
    double x = 0;
    double y = 0;
    double z = 0;

    for (var i = 0; i < location.length; i++) {
      double latitude = location[i].latitude * pi / 180;
      double longitude = location[i].longitude * pi / 180;

      x += cos(latitude) * cos(longitude);
      y += cos(latitude) * sin(longitude);
      z += sin(latitude);
    }

    double total = location.length.toDouble();

    x = x / total;
    y = y / total;
    z = z / total;

    double centralLongitude = atan2(y, x);
    double centralSquareRoot = sqrt(x * x + y * y);
    double centralLatitude = atan2(z, centralSquareRoot);

    return LatLng(centralLatitude * 180 / pi, centralLongitude * 180 / pi);
  }
}

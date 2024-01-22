import 'dart:convert';
import 'dart:math';

import 'package:busitionmate/Map/MapPage.dart';
import 'package:busitionmate/Util/constants.dart';
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
  late Future<RouteData> _routeData;
  late List<LatLng> path;
  LatLng center = LatLng(37.5665, 126.9780);
  bool isShow = true;

  @override
  void initState() {
    super.initState();
    _routeData = getRoute(widget.routeID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("지도")),
      body: FutureBuilder<RouteData>(
          future: _routeData,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              RouteData? data = snapshot.data;
              CameraPosition cameraPosition =
                  calculateCameraPosition(getRoutePath(data!.path));
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    onTap: (_) {
                      setState(() {
                        isShow = !isShow;
                      });
                    },
                    onCameraMove: (_) {
                      if (isShow) {
                        setState(() {
                          isShow = false;
                        });
                      }
                    },
                    polylines: _createPolyline(data!.path),
                  ),
                  AnimatedContainer(
                    decoration: busitionMapPageCard,
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width,
                    height: (isShow) ? 200 : 0,
                    curve: Curves.fastOutSlowIn,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.routeName,
                            style: const TextStyle(
                                fontFamily: "NanumSquareNeo",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 73, 80, 87)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  List<LatLng> getRoutePath(List<List<double>> path) {
    List<LatLng> location = [];
    for (List<double> point in path) {
      location.add(LatLng(point[1], point[0]));
    }
    return location;
  }

  Set<Polyline> _createPolyline(List<List<double>>? path) {
    Set<Polyline> polyline = {};
    List<LatLng> location = [];
    if (path == null) return polyline;
    location = getRoutePath(path);
    polyline.add(Polyline(
        polylineId: const PolylineId("route"),
        visible: true,
        points: location,
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
      return  RouteData.fromJson(jsonDecode(data));
    } else {
      return emptyRouteData;
    }
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

  CameraPosition calculateCameraPosition(List<LatLng> route) {
    double minLat = route[0].latitude;
    double maxLat = route[0].latitude;
    double minLng = route[0].longitude;
    double maxLng = route[0].longitude;

    // 루트의 경로를 통해 최소 및 최대 경도 및 위도 계산
    for (LatLng point in route) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // 경계 사각형의 중심점 계산
    double centerLat = (minLat + maxLat) / 2;
    double centerLng = (minLng + maxLng) / 2;

    // 중심점과 줌 레벨 계산
    LatLng center = LatLng(centerLat, centerLng);
    double zoom = calculateZoomLevel(center, minLat, maxLat, minLng, maxLng);

    return CameraPosition(target: center, zoom: zoom);
  }

  double calculateZoomLevel(LatLng center, double minLat, double maxLat,
      double minLng, double maxLng) {
    const double padding = 50.0; // 화면 주변 여백

    double angle = maxLng - minLng;
    if (angle < 0) {
      angle += 360;
    }

    double zoom = 0.0;
    if (angle < 90) {
      zoom = 15.0; // 루트가 좁은 경우
    } else if (angle < 180) {
      zoom = 13.0; // 루트가 중간 정도로 넓은 경우
    } else if (angle < 360) {
      zoom = 10.0; // 루트가 넓은 경우
    }

    double latRad = center.latitude * (3.141592653589793 / 180);
    double metersPerPixel = 156543.03392 * cos(latRad) / pow(2, zoom);
    double screenSize =
        (360 * MediaQuery.of(context).size.width) / (256 * metersPerPixel);
    double aspectRatio = (maxLat - minLat) / (maxLng - minLng);
    double heightInMeters = screenSize / sqrt(aspectRatio);

    if (heightInMeters / 2 + padding > 20037508.342789244) {
      double delta = (heightInMeters / 2 + padding - 20037508.342789244) /
          (heightInMeters / 2 + padding);
      zoom -= 1;
      heightInMeters = heightInMeters / delta;
    }

    return zoom;
  }
}

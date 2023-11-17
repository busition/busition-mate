import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

import '../Profile/User.dart';
import 'Route/RouteData.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>
    with AutomaticKeepAliveClientMixin
{
  late Future<RouteData> routeData;

  @override
  void initState() {
    routeData = requestRoute(User.nearestScheduleID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Center(
      child: FutureBuilder<RouteData>(
          future: routeData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error");
            }
            if (snapshot.hasData) {
              List<LatLng> path = _createPolyLine(snapshot.data!);
              return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(User.position.latitude, User.position.longitude),
                    zoom: 15,
                  ),
                  markers: {_createMarker()},
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("Route"),
                      color: Colors.blue,
                      width: 5,
                      points: path,
                    )
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    ));
  }

  List<LatLng> _createPolyLine(RouteData routeData) {
    List<LatLng> path = [];
    for (var i = 0; i < routeData.path.length; i++) {
      path.add(LatLng(routeData.path[i][1], routeData.path[i][0]));
    }
    return path;
  }

  Marker _createMarker() {
    return Marker(
      markerId: MarkerId("MyloCation"),
      position: LatLng(User.position.latitude, User.position.longitude),
      infoWindow: InfoWindow(title: "내 위치"),
    );
  }

  Future<RouteData> requestRoute(int routeID) async {
    final response = await http.get(
        headers: {"Authorization": "Bearer ${User.idTokenResult}"},
        Uri.parse(
            "http://api.dev2.busition.com:8001/latest/routes/$routeID?auth_type=Email"));
    // response to UTF-8
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return RouteData.fromJson(jsonDecode(data));
    } else {
      throw Exception('Failed to load album ${response.body}');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

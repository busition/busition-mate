import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Provider/User.dart';
import 'Route/RouteData.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  late Future<RouteData> routeData;
  List<DropdownMenuEntry<int>> dropdownMenuEntries = [];

  void dropdownMenuBuilder(User user) {
    dropdownMenuEntries.clear();
    for (var i = 0; i < user.schedule.schedule_count; i++) {
      dropdownMenuEntries.add(DropdownMenuEntry(
          value: i, label: user.schedule.schedule_data[i].name));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final value = Provider.of<User>(context);
    dropdownMenuBuilder(value);
    routeData = requestRoute(value.schedule.schedule_data[value.selectedIndex].id);
    List<LatLng> path;
    return Scaffold(
        appBar: AppBar(
            title: const Text("노선"),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              DropdownMenu(
                onSelected: (index) {
                  print("index: $index");
                  value.selectedIndex = index!;
                },
                dropdownMenuEntries: dropdownMenuEntries,
                label: Text(
                    value.schedule.schedule_data[value.nearestScheduleID].name),
              )
            ]),
        body: Consumer(builder: (context, User user, child) {
          return FutureBuilder<RouteData>(
              future: routeData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(
                      textAlign: TextAlign.center, "Error\n${snapshot.error}");
                }
                if (snapshot.hasData) {
                  path = _createPolyLine(snapshot.data!);
                  return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            User.position.latitude, User.position.longitude),
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
              });
        }));
  }

  List<LatLng> _createPolyLine(RouteData routeData) {
    List<LatLng> path = [];
    for (var i = 0; i < routeData.path.length; i++) {
      path.add(LatLng(routeData.path[i][1], routeData.path[i][0]));
    }
    print("load path: $path");
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
    final response = await http.get(
        headers: {"Authorization": "Bearer ${User.idTokenResult}"},
        Uri.parse(
            "http://api.dev2.busition.com:8001/latest/routes/$routeID?auth_type=Email"));
    // response to UTF-8
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return RouteData.fromJson(jsonDecode(data));
    } else {
      throw Exception('Failed to load album ${data}');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

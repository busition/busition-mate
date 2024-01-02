import 'dart:convert';
import 'dart:ui';

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

  List<BitmapDescriptor> markerImage = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMarkerImage();
    });
  }

  void loadMarkerImage() async {
    markerImage.add(await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5, size: Size(200, 200)),
        "assets/image/location-pin.png"));
  }

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
    routeData =
        requestRoute(value.schedule.schedule_data[value.selectedIndex].id);
    List<LatLng> path;
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 56,
            title: const Text("노선"),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              DropdownMenu(
                menuStyle: MenuStyle(
                  side: MaterialStateProperty.all(
                      BorderSide(color: const Color(0xFFE8D0B3), width: 2)),
                  backgroundColor: MaterialStateProperty.all(Color(0xFFFCF7F0)),
                ),
                onSelected: (index) {
                  print("index: $index");
                  value.selectedIndex = index!;
                },
                dropdownMenuEntries: dropdownMenuEntries,
                label: Text(
                    value.schedule.schedule_data[value.nearestScheduleID].name),
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Color(0xFFFCF7F0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(36)),
                ),
              ),
              SizedBox(),
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
                      markers: _createMarker(snapshot.data!),
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      polylines: {
                        Polyline(
                          startCap: Cap.roundCap,
                          endCap: Cap.roundCap,
                          jointType: JointType.round,
                          polylineId: const PolylineId("Route"),
                          color: const Color.fromARGB(255, 89, 161, 213),
                          width: 8,
                          points: path,
                        ),
                        Polyline(
                          startCap: Cap.roundCap,
                          endCap: Cap.roundCap,
                          jointType: JointType.round,
                          polylineId: const PolylineId("Route2"),
                          color: const Color.fromARGB(255, 159, 201, 233),
                          width: 2,
                          points: path,
                        ),
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
    return path;
  }

  Set<Marker> _createMarker(RouteData routeData) {
    if (markerImage.isEmpty) {
      for (int i = 0; i < 3; i++) {
        markerImage.add(BitmapDescriptor.defaultMarker);
      }
    }
    Set<Marker> markers = {};
    markers.add(Marker(
      markerId: const MarkerId("MyPosition"),
      position: LatLng(User.position.latitude, User.position.longitude),
      infoWindow: const InfoWindow(title: "내 위치"),
    ));

    if (routeData.stationCount != 0) {
      markers.add(Marker(
          icon: markerImage[0],
          markerId: MarkerId(routeData.stationData[0].stationName),
          position: LatLng(routeData.stationData[0].stationLatitude,
              routeData.stationData[0].stationLongitude),
          infoWindow: InfoWindow(
              title: routeData.stationData[0].stationName,
              snippet: routeData.stationData[0].arrivalTime.toString())));

      markers.add(Marker(
          icon: markerImage[0],
          markerId: MarkerId(
              routeData.stationData[routeData.stationCount - 1].stationName),
          position: LatLng(
              routeData.stationData[routeData.stationCount - 1].stationLatitude,
              routeData
                  .stationData[routeData.stationCount - 1].stationLongitude),
          infoWindow: InfoWindow(
              title:
                  routeData.stationData[routeData.stationCount - 1].stationName,
              snippet: routeData
                  .stationData[routeData.stationCount - 1].arrivalTime
                  .toString())));

      for (int index = 1; index < routeData.stationCount - 1; index++) {
        markers.add(Marker(
          icon: markerImage[0],
          markerId: MarkerId("$index"),
          position: LatLng(routeData.stationData[index].stationLatitude,
              routeData.stationData[index].stationLongitude),
          infoWindow: InfoWindow(
              title: routeData.stationData[index].stationName,
              snippet: routeData.stationData[index].arrivalTime.toString()),
        ));
      }
    }
    return markers;
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
      throw Exception('Failed to load album $data');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

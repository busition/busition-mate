import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Provider/RouteDataProvider.dart';
import '../Provider/User.dart';
import 'Route/RouteData.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  List<DropdownMenuEntry<int>> dropdownMenuEntries = [];

  @override
  void initState() {
    super.initState();
  }

  void dropdownMenuBuilder(User user) {
    dropdownMenuEntries.clear();
    for (var i = 0; i < user.schedule.schedule_count; i++) {
      dropdownMenuEntries.add(DropdownMenuEntry(
          value: i, label: user.schedule.schedule_data[i].name));
    }
  }

  double zoomLevel = 15;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final value = Provider.of<User>(context);
    dropdownMenuBuilder(value);
    return ChangeNotifierProvider(
        create: (context) => RouteDataProvider(),
        child: Consumer<User>(builder: (context, User user, child) {
          return Scaffold(
              appBar: AppBar(
                  toolbarHeight: 56,
                  title: const Text("노선"),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  actions: [
                    DropdownMenu(
                      menuStyle: MenuStyle(
                        side: MaterialStateProperty.all(BorderSide(
                            color: const Color(0xFFE8D0B3), width: 2)),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFFCF7F0)),
                      ),
                      onSelected: (index) {
                        value.selectedIndex =
                            value.schedule.schedule_data[index!].id;
                        final routeDataProvider =
                            Provider.of<RouteDataProvider>(context,
                                listen: false);
                        routeDataProvider.requestRoute(value.selectedIndex);
                      },
                      dropdownMenuEntries: dropdownMenuEntries,
                      label: Text(value.schedule
                          .schedule_data[value.nearestScheduleID].name),
                      inputDecorationTheme: InputDecorationTheme(
                        fillColor: Color(0xFFFCF7F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        isDense: true,
                        constraints:
                            BoxConstraints.tight(const Size.fromHeight(36)),
                      ),
                    ),
                    SizedBox(),
                  ]),
              body: Consumer<RouteDataProvider>(builder:
                  (context, RouteDataProvider routeDataProvider, child) {
                return MapScreen(
                    user: user, routeDataProvider: routeDataProvider);
              }));
        }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class MapScreen extends StatefulWidget {
  final User user;
  final RouteDataProvider routeDataProvider;

  const MapScreen(
      {super.key, required this.user, required this.routeDataProvider});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> path = [];
  List<BitmapDescriptor> markerImage = [];
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  double zoomLevel = 15;
  Set<Marker> lastMarkers = {};
  late RouteDataProvider routeDataProvider;

  @override
  void initState() {
    super.initState();
    routeDataProvider = widget.routeDataProvider;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMarkerImage();
      routeDataProvider.requestRoute(widget.user.selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteDataProvider>(
        builder: (context, routeDataProvider, child) {
      if (routeDataProvider.routeData != null) {
        path = _createPolyLine(routeDataProvider.routeData!);
        markers = _createMarker(routeDataProvider.routeData!);
      }
      return GoogleMap(
          onMapCreated: (controller) {
            mapController = controller;
          },
          onCameraMove: (position) {
            setState(() {
              zoomLevel = position.zoom;
              markers = _createMarker(routeDataProvider!.routeData!);
            });
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(User.position.latitude, User.position.longitude),
            zoom: zoomLevel,
          ),
          markers: markers,
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
    });
  }

  Set<Marker> _createMarker(RouteData routeData) {
    double lastZoomLevel = 0;
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

    double interval = 0.001;
    double calculateMarkerInterval(double zoomLevel) {
      const double baseZoomLevel = 15.0;
      const double baseInterval = 0.001;
      const double zoomFactor = 2.0;

      return baseInterval * pow(zoomFactor, baseZoomLevel - zoomLevel);
    }

    num diff = pow(lastZoomLevel - zoomLevel, 2);
    if (diff > pow(0.5, 2)) {
      interval = calculateMarkerInterval(zoomLevel);
      lastZoomLevel = zoomLevel;

      double lastMarkerDistance = 0;
      for (int index = 1; index < routeData.pathCount; index++) {
        double distance = sqrt(pow(
                routeData.path[index][0] - routeData.path[index - 1][0], 2) +
            pow(routeData.path[index][1] - routeData.path[index - 1][1], 2));
        if (lastMarkerDistance > interval) {
          markers.add(Marker(
            rotation: calculateBearing(
                LatLng(
                    routeData.path[index - 1][1], routeData.path[index - 1][0]),
                LatLng(routeData.path[index][1], routeData.path[index][0])),
            icon: markerImage[1],
            markerId: MarkerId("$index"),
            position:
                LatLng(routeData.path[index][1], routeData.path[index][0]),
          ));
          lastMarkerDistance = 0;
        }
        lastMarkerDistance += distance;
      }
      lastMarkers = markers;
    } else {
      markers.addAll(lastMarkers);
    }

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

  List<LatLng> _createPolyLine(RouteData routeData) {
    List<LatLng> path = [];
    for (var i = 0; i < routeData.path.length; i++) {
      path.add(LatLng(routeData.path[i][1], routeData.path[i][0]));
    }
    return path;
  }

  void loadMarkerImage() async {
    markerImage.add(await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5, size: Size(200, 200)),
        "assets/image/location-pin.png"));
    markerImage.add(await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        "assets/image/Vector.png"));
  }

  double calculateBearing(LatLng start, LatLng end) {
    var startLat = start.latitude;
    var startLng = start.longitude;
    var endLat = end.latitude;
    var endLng = end.longitude;

    var dLon = endLng - startLng;
    var dPhi =
        log(tan(endLat / 2.0 + pi / 4.0) / tan(startLat / 2.0 + pi / 4.0));
    if (dLon.abs() > pi) {
      dLon = dLon > 0.0 ? -(2.0 * pi - dLon) : (2.0 * pi + dLon);
    }

    return (degrees(atan2(dLon, dPhi)) + 360.0) % 360.0;
  }

  double degrees(double radians) {
    return radians * 180.0 / pi;
  }
}

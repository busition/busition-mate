import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:busitionmate/Provider/RealTimeData.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../GlobalPageRoute.dart';
import '../Provider/RouteDataProvider.dart';
import '../Provider/User.dart';
import 'Route/RouteData.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

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
    int idx = 0;
    for (var i = 0; i < value.schedule.schedule_count; i++) {
      if (value.schedule.schedule_data[i].id == value.selectedID) {
        idx = i;
        break;
      }
    }

    int findIndex(int id) {
      for (var i = 0; i < value.schedule.schedule_count; i++) {
        if (value.schedule.schedule_data[i].id == id) {
          return i;
        }
      }
      return -1;
    }

    return Consumer<User>(builder: (context, User user, child) {
      return Scaffold(
          appBar: AppBar(
              toolbarHeight: 56,
              title: const Text("노선"),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                DropdownMenu(
                  initialSelection: findIndex(user.selectedID),
                  menuStyle: MenuStyle(
                    side: MaterialStateProperty.all(
                        const BorderSide(color: Color(0xFFE8D0B3), width: 2)),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFFCF7F0)),
                  ),
                  onSelected: (index) {
                    setState(() {
                      Provider.of<RealTimeData>(context, listen: false)
                          .locationData = null;
                      value.selectedID =
                          value.schedule.schedule_data[index!].id;
                      idx = index;
                      print("Selected index: $idx");
                    });
                    final routeDataProvider =
                        Provider.of<RouteDataProvider>(context, listen: false);
                    routeDataProvider.requestRoute(value.selectedID);
                  },
                  dropdownMenuEntries: dropdownMenuEntries,
                  label: const Text("노선"),
                  inputDecorationTheme: InputDecorationTheme(
                    fillColor: const Color(0xFFFCF7F0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    isDense: true,
                    constraints:
                        BoxConstraints.tight(const Size.fromHeight(36)),
                  ),
                ),
                const SizedBox(),
              ]),
          body: Consumer<RouteDataProvider>(
              builder: (context, RouteDataProvider routeDataProvider, child) {
            return Stack(
              children: [
                Consumer<RealTimeData>(builder: (context, realTimeData, child) {
                  return MapScreen(
                      user: user,
                      routeDataProvider: routeDataProvider,
                      realTimeData: realTimeData);
                }),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        Text(
                            "현재 선택된 노선: ${user.schedule.schedule_data[idx].name}"),
                        progress([0.1, 0.3, 0.5, 0.8], routeDataProvider),
                        routeDataProvider.routeData?.stationData != null
                            ? Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: routeDataProvider
                                        .routeData?.stationCount,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                            "${routeDataProvider.routeData?.stationData[index].stationName}"),
                                        subtitle: Text("${index + 1}번 정류장"),
                                      );
                                    }),
                              )
                            : const Text("로딩중"),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }));
    });
  }

  List<double> _calculateStationProgress(RouteData routeData) {
    List<double> stationPositions = [0];
    for (int index = 1; index < routeData.pathCount; index++) {
      double distance = sqrt(
          pow(routeData.path[index][0] - routeData.path[index - 1][0], 2) +
              pow(routeData.path[index][1] - routeData.path[index - 1][1], 2));
    }
    double lastStationDistance = 0;
    for (int index = 1; index < routeData.stationCount; index++) {
      double distance = sqrt(pow(
              routeData.stationData[index].stationLatitude -
                  routeData.stationData[index - 1].stationLatitude,
              2) +
          pow(
              routeData.stationData[index].stationLongitude -
                  routeData.stationData[index - 1].stationLongitude,
              2));
      lastStationDistance += distance;
    }
    double lastStationPosition = 0;
    for (int index = 1; index < routeData.stationCount; index++) {
      double distance = sqrt(pow(
              routeData.stationData[index].stationLatitude -
                  routeData.stationData[index - 1].stationLatitude,
              2) +
          pow(
              routeData.stationData[index].stationLongitude -
                  routeData.stationData[index - 1].stationLongitude,
              2));
      lastStationPosition += distance;
      stationPositions.add(lastStationPosition / lastStationDistance);
    }
    return stationPositions;
  }

  // 버스로부터 가장 가까운 path 찾기
  int nearestPath(RouteData routeData, LatLng position) {
    double minDistance = 99999999999;
    int minIndex = 0;
    for (int index = 0; index < routeData.pathCount; index++) {
      double distance = sqrt(
          pow(routeData.path[index][0] - position.longitude, 2) +
              pow(routeData.path[index][1] - position.latitude, 2));
      if (minDistance > distance) {
        minDistance = distance;
        minIndex = index;
      }
    }
    return minIndex;
  }

  Widget progress(List<double> stationPositions, RouteDataProvider? routeData) {
    List<double> stationPositions = [];
    if (routeData?.routeData != null) {
      stationPositions = _calculateStationProgress(routeData!.routeData!);
    }
    double width = MediaQuery.of(context).size.width;
    if (routeData != null) {
      if (routeData.routeData != null) {
        if (routeData.routeData!.pathCount * 2.0 > width) {
          width = routeData.routeData!.pathCount * 2.0;
        } else {
          width = MediaQuery.of(context).size.width;
        }
      } else {
        return const Center();
      }
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Consumer<RealTimeData>(builder: (context, realTimeData, child) {
        double value = 0;
        if (realTimeData.locationData != null && routeData!.routeData != null) {
          double temp =
              nearestPath(routeData.routeData!, realTimeData.locationData!) /
                  routeData.routeData!.pathCount;
          if (temp < 1 && temp > 0) {
            value = temp;
          }
        }
        try {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              height: 50,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        for (int i = 0; i < stationPositions.length; i++)
                          Positioned(
                            left: stationPositions[i] == 1
                                ? stationPositions[i] * width - 10
                                : stationPositions[i] * width,
                            bottom: 0,
                            child: Column(
                              children: [
                                Text("${i + 1}"),
                                Container(
                                  width: 1,
                                  height: 5,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  LinearProgressIndicator(
                    minHeight: 16,
                    value: value,
                    backgroundColor: Colors.black12,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFE8D0B3)),
                  )
                ],
              ),
            ),
          );
        } catch (e) {
          return const CircularProgressIndicator();
        }
      }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}

class MapScreen extends StatefulWidget {
  final User user;
  final RouteDataProvider routeDataProvider;
  RealTimeData realTimeData;

  MapScreen(
      {super.key,
      required this.user,
      required this.routeDataProvider,
      required this.realTimeData});

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
      routeDataProvider.requestRoute(widget.user.selectedID);
    });
  }

  double lastCameraMoveTime = 0;
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Consumer<RealTimeData>(builder: (context, realTimeData, child) {
        if (routeDataProvider.routeData != null) {
          path = _createPolyLine(routeDataProvider.routeData!);
          markers = _createMarker(routeDataProvider.routeData!, realTimeData);
        }
        if (User.position != null) {
          return GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              onCameraMove: (position) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();

                _debounce = Timer(const Duration(milliseconds: 200), () {
                  setState(() {
                    zoomLevel = position.zoom;
                    markers = _createMarker(
                        routeDataProvider.routeData!, realTimeData);
                  });
                });
              },
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(User.position!.latitude, User.position!.longitude),
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
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      });
    });
  }

  Set<Marker> _createMarker(RouteData routeData, RealTimeData realTimeData) {
    double lastZoomLevel = 0;
    if (markerImage.isEmpty) {
      for (int i = 0; i < 3; i++) {
        loadMarkerImage();
      }
    }
    Set<Marker> markers = {};

    if (realTimeData.locationData != null) {
      markers.add(Marker(
        markerId: const MarkerId("Bus"),
        position: LatLng(realTimeData.locationData!.latitude,
            realTimeData.locationData!.longitude),
      ));
    }
    if (User.position != null) {
      Position position = User.position!;
      markers.add(Marker(
        markerId: const MarkerId("MyPosition"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: "내 위치"),
      ));
    }

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
    markerImage = [];
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

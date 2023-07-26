import 'package:Busition_Mate/Page_Maps/RouteData/StationData.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../Page_Maps/RouteData/MapRoute.dart';
import '../../Page_Maps/RouteData/RouteData.dart';
import 'package:latlong2/latlong.dart' as ds;

import '../../utils/constants.dart';

class ViewWholePage extends StatefulWidget {
  final int direction;
  String userID;

  ViewWholePage({Key? key, required this.userID, required this.direction})
      : super(key: key);

  @override
  State<ViewWholePage> createState() => _ViewWholePageState();
}

class _ViewWholePageState extends State<ViewWholePage> {
  final PageController _pageController = PageController();
  bool visibility = true;
  Set<Polyline> routes = {};
  Set<Marker> markers = {};
  Future<RouteData>? routeData;
  ds.Distance distance = const ds.Distance();
  late int direction;
  late String userID;
  late LatLng center;
  late List<LatLng> loc;
  late double centerDistance;
  late GoogleMapController mapController;
  late double minLat, minLong, maxLat, maxLong;

  Future<void> _setMapFitToTour(Set<Polyline> p) async {
    minLat = p.first.points.first.latitude;
    minLong = p.first.points.first.longitude;
    maxLat = p.first.points.last.latitude;
    maxLong = p.first.points.last.longitude;
    p.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });
  }

  void initCamLocation() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
      () async => print(
        await mapController.getVisibleRegion(),
      ),
    );
    mapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        32));
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    await _setMapFitToTour(routes);

    mapController = controller;
    initCamLocation();
  }

  @override
  Widget build(BuildContext context) {
    callMapRoute(userID, 0);
    print(userID);

    return Scaffold(
      appBar: AppBar(title: const Text("전체 경로 보기")),
      body: FutureBuilder<RouteData>(
          future: routeData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.detail !=
                  "노선이 등록되지 않았습니다. Busition-Console에서 노선 설정을 먼저 해주세요.") {
                settingCenter(snapshot.data!.path!); // 중간 지점 확인
                markerAdd(snapshot.data); // 마커 추가
                addPolyline(snapshot.data!.path!); // 경로선 추가
                return Stack(
                  children: [
                    GoogleMap(
                      onTap: (loc) {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                      markers: markers,
                      myLocationButtonEnabled: false,
                      onMapCreated: _onMapCreated,
                      polylines: routes,
                      initialCameraPosition:
                          CameraPosition(target: center, zoom: 10),
                    ),
                    upAnimation(snapshot.data),
                    startToStop(snapshot.data),
                  ],
                );
              } else if (snapshot.data!.detail ==
                  "노선이 등록되지 않았습니다. Busition-Console에서 노선 설정을 먼저 해주세요.") {
                return Text("노선없음");
              } else {
                return Text("문제가 발생했습니다");
              }
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    direction = widget.direction;
    userID = widget.userID;
  }

  void settingCenter(List<LatLng> loc) {
    center = LatLng((loc[0].latitude + loc[loc.length - 1].latitude) / 2,
        (loc[0].longitude + loc[loc.length - 1].longitude) / 2);
    centerDistance = distance.as(
        ds.LengthUnit.Meter,
        ds.LatLng(loc[0].latitude, loc[0].longitude),
        ds.LatLng(loc[loc.length - 1].latitude, loc[loc.length - 1].longitude));
  }

  void callMapRoute(String userInfo, int dir) {
    print("Callmaproute");
    MapRoute route = MapRoute(userInfo, dir);
    routeData = route.fetchRoute(http.Client());
  }

  void markerAdd(RouteData? data) {
    int? len = 0;
    len = data?.stationCount;
    for (int i = 0; i < len!; i++) {
      StationData? stopData = data?.stationData![i];
      markers.add(Marker(
          infoWindow: InfoWindow(onTap: () {}, title: stopData?.stationName),
          markerId: MarkerId("${i + 1}"),
          position: stopData!.stationLocation,
          onTap: () {
            setState(() {
              visibility = !visibility;
            });
          }));
    }
  }

  void addPolyline(List<LatLng> data) {
    routes.add(Polyline(
        polylineId: PolylineId("$userID"),
        points: data,
        color: Colors.blue,
        width: 5));
  }

  Widget startToStop(RouteData? data) {
    List<StationData> list = data!.stationData!;
    String stationStart = list[0].stationName!;
    String stationStop = list[list.length - 1].stationName!;
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Container(
        height: MediaQuery.of(context).size.height / 11,
        decoration: kInfoBoxBorder,
        child: InkWell(
          splashColor: Colors.black,
          onTap: () {
            initCamLocation();
          },
          child: Column(
            children: [
              infoText(stationStart, Colors.green, "출발지"),
              infoText(stationStop, Colors.red, "종착지")
            ],
          ),
        ),
      ),
    );
  }

  Widget infoText(String stationStart, MaterialColor color, String wayTo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.flag_outlined,
          color: color,
        ),
        Text(
          "$wayTo: $stationStart",
          style: kCardTimeTextStyle,
        ),
      ],
    );
  }

  Widget upAnimation(RouteData? data) {
    return AnimatedPositioned(
        width: MediaQuery.of(context).size.width,
        height: visibility ? 150.0 : 0.0,
        bottom: 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceOut,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: data!.stationCount,
            itemBuilder: (context, index) => stationCard(data, index),
            onPageChanged: (page) {
              mapController.animateCamera(CameraUpdate.newLatLng(
                  data.stationData![page].stationLocation));
            },
          ),
        ));
  }

  Widget stationCard(RouteData? data, int index) {
    List<StationData> list = data!.stationData!;
    return Card(child: Center(child: Text(list[index].stationName!)));
  }
}

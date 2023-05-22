import 'dart:async';

import 'package:Busition_Mate/userProfile.dart';
import 'package:Busition_Mate/utils/SocketServices.dart';
import 'package:flutter/material.dart';
import 'package:Busition_Mate/Page_Maps/RouteData/MapRoute.dart';
import 'package:Busition_Mate/Page_Maps/RouteData/StationData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ds;
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../Page_Timeline/TimePage.dart';
import '../utils/constants.dart';
import 'RouteData/RouteData.dart';

class Maps extends StatefulWidget {
  static double zoomLevel = 15;
  static LatLng busLocation = LatLng(35, 126);

  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => MapsState();
}

class MapsState extends State<Maps> with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  static late GoogleMapController _mapController;
  double routeDistance = 0;
  static double centerDistance = 0;
  static late LatLng center;
  ds.Distance distance = const ds.Distance();
  static LatLng defaultLocation = const LatLng(37.581563, 126.977433);
  Set<Polyline> routes = {};
  Set<Marker> markers = {};
  late Marker busLocation;
  late int dir;
  late String userInfo;
  bool visibility = true;
  Future<RouteData>? routeData;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
            title: const Text("현재 버스 이동경로"), automaticallyImplyLeading: false),
        body: FutureBuilder<RouteData>(
            future: routeData,
            builder: (context, snapshot) {
              late int? pathcount = 0;
              if (snapshot.hasData) {
                if (snapshot.data!.detail !=
                    "노선이 등록되지 않았습니다. Busition-Console에서 노선 설정을 먼저 해주세요.") {
                  List<LatLng> loc = [];
                  List<LatLng>? path = snapshot.data!.path;
                  pathcount = snapshot.data?.pathCount;
                  for (int i = 0; i < pathcount!; i++) {
                    loc.add(path![i]);
                  }
                  routeDistance = 0;
                  center = LatLng(
                      (loc[0].latitude + loc[loc.length - 1].latitude) / 2,
                      (loc[0].longitude + loc[loc.length - 1].longitude) / 2);
                  centerDistance = distance.as(
                      ds.LengthUnit.Meter,
                      ds.LatLng(loc[0].latitude, loc[0].longitude),
                      ds.LatLng(loc[loc.length - 1].latitude,
                          loc[loc.length - 1].longitude));

                  for (int i = 0; i < pathcount - 1; i++) {
                    routeDistance += distance.as(
                        ds.LengthUnit.Meter,
                        ds.LatLng(loc[i].latitude, loc[i].longitude),
                        ds.LatLng(loc[i + 1].latitude, loc[i + 1].longitude));
                  }

                  markerAdd(snapshot.data);
                  routes.add(Polyline(
                      polylineId: const PolylineId("A"),
                      points: loc,
                      color: Colors.red,
                      width: 5));

                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: loc[0], zoom: Maps.zoomLevel),
                          mapToolbarEnabled: false,
                          polylines: routes,
                          markers: markers,
                          onMapCreated: _onMapCreated,
                          onTap: (loc) {
                            changeBoxPosition();
                          }
                        // markers: ,
                      ),
                      upAnimation(snapshot.data),
                    ],
                  );
                } else {
                  return Text("오류가 발생했어요.");
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: Column(
                  children: const [
                    Text("지도 로딩중"),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }));
  }

  static void showAllRoute() {
    defaultLocation = center;
    _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(center, centerDistance / 450));
  }

  late GoogleMapController controller;

  void markerAdd(RouteData? data) {
    markers.add(Marker(markerId: MarkerId("운전자"),position: Maps.busLocation));

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

  Widget startToStop(RouteData? data) {
    List<StationData> list = data!.stationData!;
    String stationStart = list[0].stationName!;
    String stationStop = list[list.length - 1].stationName!;
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height / 10,
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height / 11,
        decoration: kHalfBoxBorder,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            infoText(stationStart, Colors.green, "출발지"),
            infoText(stationStop, Colors.red, "종착지")
          ],
        ),
      ),
    );
  }

  Widget upAnimation(RouteData? data) {
    return AnimatedPositioned(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: visibility ? 200.0 : MediaQuery
            .of(context)
            .size
            .height / 10,
        bottom: 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutExpo,
        child: Column(
          children: [
            startToStop(data),
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: data!.stationCount,
                    itemBuilder: (context, index) => stationCard(data, index),
                    onPageChanged: (page) {
                      setState(() {
                        pageIndex = page;
                      });
                      _mapController.animateCamera(CameraUpdate.newLatLng(
                          data.stationData![page].stationLocation));
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(8),
                    child: PageViewDotIndicator(
                      size: Size(6, 6),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      currentItem: pageIndex,
                      count: data.stationCount!,
                      unselectedColor: Colors.black26,
                      selectedColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget stationCard(RouteData? data, int index) {
    return Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Center(
            child: Text(data!.stationData![index].stationName as String)));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      TimePage.mapController = controller;
    });
  }

  void changeBoxPosition() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  void initState() {
    super.initState();
    userInfo = UserProfile.list[16].routeId!;
    print(userInfo);
    dir = UserProfile.list[16].shuttleDirection!;
    MapRoute route = MapRoute(userInfo, dir);
    routeData = route.fetchRoute(http.Client());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

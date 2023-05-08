import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Busition_Mate/Page_Maps/RouteData/MapRoute.dart';
import 'package:Busition_Mate/Page_Maps/RouteData/StationData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ds;

import '../Page_Timeline/TimePage.dart';
import 'RouteData/RouteData.dart';

class Maps extends StatefulWidget {
  static double zoomLevel = 15;

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
  late int userInfo, dir;
  bool visibility = true;
  Future<RouteData>? routeData;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar:
            AppBar(title: const Text("현재 버스 이동경로"), automaticallyImplyLeading: false),
        body: FutureBuilder<RouteData>(
            future: routeData,
            builder: (context, snapshot) {
              late int? pathcount = 0;
              if (snapshot.hasData) {
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

  Widget upAnimation(RouteData? data) {
    return AnimatedPositioned(
        width: MediaQuery.of(context).size.width,
        height: visibility ? 200.0 : 0.0,
        bottom: 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutExpo,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: data!.stationCount,
          itemBuilder: (context, index) => stationCard(data, index),
          onPageChanged: (page) {
            _mapController.animateCamera(CameraUpdate.newLatLng(
                data.stationData![page].stationLocation));
          },
        ));
  }

  Widget stationCard(RouteData? data, int index) {
    return Card(child: Text(data!.stationData![index].stationName as String));
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
    userInfo = 1;
    dir = 0;
    MapRoute route = MapRoute(userInfo, dir);
    routeData = route.fetchRoute(http.Client());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

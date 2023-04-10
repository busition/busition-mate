import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/Page_Maps/RouteData/MapRoute.dart';
import 'package:flutter_foreground_task_example/Page_Maps/RouteData/StationData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ds;

import '../Page_Timeline/TimePage.dart';
import '../utils/constants.dart';
import 'RouteData/RouteData.dart';

class Maps extends StatefulWidget {
  static double zoomLevel = 15;

  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin {
  late GoogleMapController _controller;
  double routeDistance = 0;
  ds.Distance distance = const ds.Distance();
  final LatLng defaultLocation = const LatLng(37.581563, 126.977433);
  Set<Polyline> routes = {};
  Set<Marker> markers = {};
  int? userInfo, dir;
  Future<RouteData>? routeLine;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: AppBar(
                title: const Text("지도"), automaticallyImplyLeading: false)),
        body: FutureBuilder<RouteData>(
            future: routeLine,
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
                        onMapCreated: _onMapCreated
                        // markers: ,
                        ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: kBorderStyle30),
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Text("$routeDistance m"),
                      ),
                    )
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

  late GoogleMapController controller;

  void markerAdd(RouteData? data) {
    int? len = 0;
    len = data?.stationCount;
    for (int i = 0; i < len!; i++) {
      StationData? stopData = data?.stationData![i];
      markers.add(Marker(
          infoWindow: InfoWindow(title: stopData?.stationName),
          markerId: MarkerId("${i + 1}"),
          position: stopData!.stationLocation!));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller = controller;
      TimePage.mapController = controller;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo = 1;
    dir = 0;
    var route = MapRoute(userInfo!, dir!);
    routeLine = route.fetchRoute(http.Client());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

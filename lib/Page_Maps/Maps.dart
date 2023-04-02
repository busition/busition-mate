import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/Page_Maps/MapRoute.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as Ds;

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin {
  double routeDistance = 0;
  Ds.Distance distance = const Ds.Distance();
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
              if (snapshot.hasData) {
                List<LatLng> loc = [];
                List path = snapshot.data!.route;
                List section = snapshot.data!.section;

                for (int i = 0; i < path.length; i++) {
                  loc.add(LatLng(path[i][1], path[i][0]));
                }
                routeDistance = 0;
                for (int i = 0; i < path.length - 1; i++) {
                  routeDistance += distance.as(
                      Ds.LengthUnit.Meter,
                      Ds.LatLng(loc[i].latitude, loc[i].longitude),
                      Ds.LatLng(loc[i + 1].latitude, loc[i + 1].longitude));
                }

                markerAdd(section, loc);
                routes.add(Polyline(
                    polylineId: PolylineId("A"),
                    points: loc,
                    color: Colors.red,
                    width: 5));

                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GoogleMap(
                        initialCameraPosition:
                            CameraPosition(target: loc[0], zoom: 14.0),
                        mapToolbarEnabled: false,
                        myLocationEnabled: true,
                        polylines: routes,
                        markers: markers,
                        onMapCreated: _onMapCreated
                        // markers: ,
                        ),
                    Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Text("$routeDistance m"),
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

  void markerAdd(section, loc) {
    for (int i = 0; i < section.length; i++) {
      markers.add(Marker(
          markerId: MarkerId("${i + 1}"),
          position: loc[section[i]["pointIndex"]]));
    }
    markers.add(Marker(
        infoWindow: InfoWindow(title: "출발지$routeDistance"),
        markerId: const MarkerId("0"),
        position: loc[0]));
    markers.add(Marker(
        infoWindow: const InfoWindow(title: "종착지"),
        markerId: MarkerId("${section.length}"),
        position: loc[loc.length - 1]));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller = controller;
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

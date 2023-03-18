// AIzaSyCzz7rn8J4WLiVpJvIh4ZgODWfx4LxhUvI

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task_example/Page_Maps/MapRoute.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin {
  final LatLng defaultLocation = const LatLng(37.581563, 126.977433);
  Set<Polyline> routes = {};
  Set<Marker> markers = {};
  int? userInfo;
  Future<List<dynamic>>? routeLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(title: Text("지도"), automaticallyImplyLeading: false)),
        body: FutureBuilder<List>(
            future: routeLine,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<LatLng> loc = [];
                List path = snapshot.data![0];
                List section = snapshot.data![1];
                for (int i = 0; i < path.length; i++) {
                  loc.add(LatLng(path[i][1], path[i][0]));
                }
                for (int i = 0; i < section.length; i++){
                  print(section[i]["pointIndex"]);
                  markers.add(Marker(markerId: MarkerId("A"),position: loc[section[i]["pointIndex"]]));

                }
                markers.add(Marker(markerId: MarkerId("A"), position: loc[0]));
                markers.add(Marker(
                    markerId: MarkerId("A"), position: loc[loc.length - 1]));
                routes.add(Polyline(
                    polylineId: PolylineId("A"),
                    points: loc,
                    color: Colors.red,
                    width: 5));
                return GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: loc[0], zoom: 14.0),
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    polylines: routes,
                    markers: markers,
                    onMapCreated: _onMapCreated
                    // markers: ,
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
    var route = MapRoute(userInfo!);
    routeLine = route.fetchRoute(http.Client());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

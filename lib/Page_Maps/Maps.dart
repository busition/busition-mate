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
  Future<List<dynamic>>? routeLine;
  Completer<GoogleMapController> _controller = Completer();

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
                for (int i = 0; i < snapshot.data!.length; i++) {
                  loc.add(
                      LatLng(snapshot.data![i][1], snapshot.data![i][0]));
                }
                routes.add(Polyline(
                  polylineId: PolylineId("A"),
                  points: loc,
                  color: Colors.red,
                  width: 5
                ));
                return GoogleMap(
                    initialCameraPosition:
                    CameraPosition(target: loc[0], zoom: 14.0),
                    myLocationEnabled: true,
                    polylines: routes,
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

  void _onMapCreated(GoogleMapController controller){
    setState(() {
      controller = controller;
    });
  }

  void refresh(){
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var route = MapRoute(1);
    routeLine = route.fetchRoute(http.Client());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

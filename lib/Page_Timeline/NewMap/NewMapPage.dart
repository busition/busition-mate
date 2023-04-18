import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../Page_Maps/RouteData/MapRoute.dart';
import '../../Page_Maps/RouteData/RouteData.dart';

class ViewWholePage extends StatefulWidget {
  final int userID, direction;

  const ViewWholePage({Key? key, required this.userID, required this.direction}) : super(key: key);

  @override
  State<ViewWholePage> createState() => _ViewWholePageState();
}

class _ViewWholePageState extends State<ViewWholePage> {
  Set<Polyline> routes = {};
  Set<Marker> markers = {};
  Future<RouteData>? routeData;
  late int userID, direction;

  @override
  Widget build(BuildContext context) {
    callMapRoute(userID, direction);
    return Scaffold(
      appBar: AppBar(title: Text("지도")),
      body: FutureBuilder<RouteData>(
          future: routeData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(36, 127), zoom: 15),
              );
            }
            else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            else{
              return Text("Hello");
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    // direction = 1;
    // userID = 1;
    if(widget.userID != null && widget.direction != null){
      direction = widget.direction;
      userID = widget.userID;
      print("Data found");
    }
    else{
      print("data not found");
    }
  }

  void callMapRoute(int userInfo, int dir) {
    print("routeID: $userID, dir: $direction");
    MapRoute route = MapRoute(userInfo, dir);
    routeData = route.fetchRoute(http.Client());
  }
}

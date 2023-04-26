import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../Page_Maps/RouteData/MapRoute.dart';
import '../../Page_Maps/RouteData/RouteData.dart';
import 'package:latlong2/latlong.dart' as ds;

class ViewWholePage extends StatefulWidget {
  final int userID, direction;

  const ViewWholePage({Key? key, required this.userID, required this.direction})
      : super(key: key);

  @override
  State<ViewWholePage> createState() => _ViewWholePageState();
}

class _ViewWholePageState extends State<ViewWholePage> {
  Set<Polyline> routes = {};
  Set<Marker> markers = {};
  Future<RouteData>? routeData;
  ds.Distance distance = const ds.Distance();
  late int userID, direction;
  late LatLng center;
  late List<LatLng> loc;
  late double centerDistance;

  @override
  Widget build(BuildContext context) {
    callMapRoute(userID, direction);

    return Scaffold(
      appBar: AppBar(title: Text("지도")),
      body: FutureBuilder<RouteData>(
          future: routeData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              settingCenter(snapshot.data!.path!);
              //TODO 지도 뜨면 뭐해야 하는지 작성
              addPolyline(snapshot.data!.path!);

              return GoogleMap(
                polylines: routes,
                initialCameraPosition:
                    CameraPosition(target: center, zoom: centerDistance / 440),
              );
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
    // direction = 1;
    // userID = 1;
    if (widget.userID != null && widget.direction != null) {
      direction = widget.direction;
      userID = widget.userID;
      print("Data found");
    } else {
      print("data not found");
    }
  }

  void settingCenter(List<LatLng> loc) {
    center = LatLng((loc[0].latitude + loc[loc.length - 1].latitude) / 2,
        (loc[0].longitude + loc[loc.length - 1].longitude) / 2);
    centerDistance = distance.as(
        ds.LengthUnit.Meter,
        ds.LatLng(loc[0].latitude, loc[0].longitude),
        ds.LatLng(loc[loc.length - 1].latitude, loc[loc.length - 1].longitude));
  }

  void callMapRoute(int userInfo, int dir) {
    print("routeID: $userID, dir: $direction");
    MapRoute route = MapRoute(userInfo, dir);
    routeData = route.fetchRoute(http.Client());
  }
  void addPolyline(List<LatLng> data){
    routes.add(Polyline(
        polylineId: PolylineId("$userID"),
        points: data,
        color: Colors.blue,
        width: 5));
  }
}

// AIzaSyCzz7rn8J4WLiVpJvIh4ZgODWfx4LxhUvI

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin{
  final LatLng defaultLocation = const LatLng(37.581563, 126.977433);
  late List<LatLng> locList;

  _MapsState() {
    locList = [
      defaultLocation,
      LatLng(37.581663, 126.977533),
      LatLng(37.581763, 126.977633),
      LatLng(37.581763, 126.977833),
      LatLng(37.582763, 126.978833),
    ];
  }

  Set<Marker> markers = {};

  void addMaker(String id, LatLng loc) {
    markers.add(Marker(markerId: MarkerId(id), position: loc));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            title: Text("지도"),
            automaticallyImplyLeading: false)
        ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: defaultLocation, zoom: 14.0),
        myLocationEnabled: true,
        markers: ,
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



// AIzaSyCzz7rn8J4WLiVpJvIh4ZgODWfx4LxhUvI

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin {
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

  void addMaker() {
    path.add(PathOverlay(PathOverlayId("ID"), locList));
    // markers.add();
    setState(() {});
  }


  Set<PathOverlay> path = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(title: Text("지도"), automaticallyImplyLeading: false)),
        body: Column(
          children: [
            SizedBox(
              child: ElevatedButton(
                  onPressed: () {
                    addMaker();
                  },
                  child: Text("a")),
              height: 30,
            ),
            Expanded(
              child: NaverMap(
                useSurface: kReleaseMode,
                initialCameraPosition:
                    CameraPosition(target: defaultLocation, zoom: 14.0),
                pathOverlays: path,
              ),
            ),
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

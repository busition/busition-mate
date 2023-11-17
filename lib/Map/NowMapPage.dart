import 'dart:convert';

import 'package:busitionmate/Map/MapPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Profile/User.dart';

class NowMapPage extends MapPage {
  const NowMapPage({super.key});

  @override
  State<NowMapPage> createState() => _NowMapPageState();
}

class _NowMapPageState extends State<NowMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(User.position.latitude, User.position.longitude),
          zoom: 14.4746,
        ),
      ),
    ));
  }


}

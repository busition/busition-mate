import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'StationData.dart';

class RouteData {
  String? detail;
  int? pathCount;
  List<LatLng>? path;
  int? stationCount;
  int? totalPassengerCount;
  List<StationData>? stationData;

  RouteData({
    this.detail,
    this.pathCount,
    this.path,
    this.stationCount,
    this.totalPassengerCount,
    this.stationData,
  });

  RouteData.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    pathCount = json['path_count'];
    stationCount = json['station_count'];
    totalPassengerCount = json['total_passenger_count'];
    if (json['path'] != null) {
      path = <LatLng>[];
      json['path'].forEach((v) {
        path!.add(LatLng(v[1], v[0]));
      });
    }
    if (json['station_data'] != null) {
      stationData = <StationData>[];
      json['station_data'].forEach((v) {
        stationData!.add(StationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path_count'] = pathCount;
    data['path'] = path;
    data['station_count'] = stationCount;
    data['total_passenger_count'] = totalPassengerCount;
    if (stationData != null) {
      data['station_data'] = stationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

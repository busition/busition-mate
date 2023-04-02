import 'StationData.dart';

class RouteData {
  int? pathCount;
  int? stationCount;
  int? totalPassengerCount;
  List<StationData>? stationData;

  RouteData(
      {this.pathCount,
        this.stationCount,
        this.totalPassengerCount,
        this.stationData});

  RouteData.fromJson(Map<String, dynamic> json) {
    pathCount = json['path_count'];
    stationCount = json['station_count'];
    totalPassengerCount = json['total_passenger_count'];
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
    data['station_count'] = stationCount;
    data['total_passenger_count'] = totalPassengerCount;
    if (stationData != null) {
      data['station_data'] = stationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
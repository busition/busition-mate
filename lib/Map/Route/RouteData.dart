import 'package:json_annotation/json_annotation.dart';

part 'RouteData.g.dart'; // 자동 생성될 파일 이름

@JsonSerializable()
class RouteData {
  @JsonKey(name: 'path_count')
  int pathCount;
  List<List<double>> path;
  @JsonKey(name: 'route_name')
  String routeName;
  @JsonKey(name: 'route_description')
  String routeDescription;
  @JsonKey(name: 'station_count')
  int stationCount;
  @JsonKey(name: 'total_passenger_count')
  int totalPassengerCount;
  @JsonKey(name: 'station_data')
  List<StationData> stationData;

  RouteData({
    required this.pathCount,
    required this.path,
    required this.routeName,
    required this.routeDescription,
    required this.stationCount,
    required this.totalPassengerCount,
    required this.stationData,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) =>
      _$RouteDataFromJson(json);

  Map<String, dynamic> toJson() => _$RouteDataToJson(this);
}

@JsonSerializable()
class StationData {
  @JsonKey(name: 'station_id')
  int stationId;
  @JsonKey(name: 'station_name')
  String stationName;
  @JsonKey(name: 'stopping_order')
  int stoppingOrder;
  @JsonKey(name: 'station_latitude')
  double stationLatitude;
  @JsonKey(name: 'station_longitude')
  double stationLongitude;
  @JsonKey(name: 'passenger_count')
  int passengerCount;
  @JsonKey(name: 'arrival_time')
  List<String> arrivalTime;
  @JsonKey(name: 'departure_time')
  List<String> departureTime;
  @JsonKey(name: 'travel_distance')
  String travelDistance;

  StationData({
    required this.stationId,
    required this.stationName,
    required this.stoppingOrder,
    required this.stationLatitude,
    required this.stationLongitude,
    required this.passengerCount,
    required this.arrivalTime,
    required this.departureTime,
    required this.travelDistance,
  });

  factory StationData.fromJson(Map<String, dynamic> json) =>
      _$StationDataFromJson(json);

  Map<String, dynamic> toJson() => _$StationDataToJson(this);
}

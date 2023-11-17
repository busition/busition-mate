// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RouteData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteData _$RouteDataFromJson(Map<String, dynamic> json) => RouteData(
      pathCount: json['path_count'] as int,
      path: (json['path'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
      routeName: json['route_name'] as String,
      routeDescription: json['route_description'] as String,
      stationCount: json['station_count'] as int,
      totalPassengerCount: json['total_passenger_count'] as int,
      stationData: (json['station_data'] as List<dynamic>)
          .map((e) => StationData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RouteDataToJson(RouteData instance) => <String, dynamic>{
      'path_count': instance.pathCount,
      'path': instance.path,
      'route_name': instance.routeName,
      'route_description': instance.routeDescription,
      'station_count': instance.stationCount,
      'total_passenger_count': instance.totalPassengerCount,
      'station_data': instance.stationData,
    };

StationData _$StationDataFromJson(Map<String, dynamic> json) => StationData(
      stationId: json['station_id'] as int,
      stationName: json['station_name'] as String,
      stoppingOrder: json['stopping_order'] as int,
      stationLatitude: (json['station_latitude'] as num).toDouble(),
      stationLongitude: (json['station_longitude'] as num).toDouble(),
      passengerCount: json['passenger_count'] as int,
      arrivalTime: (json['arrival_time'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      departureTime: (json['departure_time'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      travelDistance: json['travel_distance'] as String,
    );

Map<String, dynamic> _$StationDataToJson(StationData instance) =>
    <String, dynamic>{
      'station_id': instance.stationId,
      'station_name': instance.stationName,
      'stopping_order': instance.stoppingOrder,
      'station_latitude': instance.stationLatitude,
      'station_longitude': instance.stationLongitude,
      'passenger_count': instance.passengerCount,
      'arrival_time': instance.arrivalTime,
      'departure_time': instance.departureTime,
      'travel_distance': instance.travelDistance,
    };

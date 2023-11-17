// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      schedule_count: json['schedule_count'] as int,
      schedule_data: (json['schedule_data'] as List<dynamic>)
          .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'schedule_count': instance.schedule_count,
      'schedule_data': instance.schedule_data,
    };

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: json['id'] as int? ?? 999,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      departure_point: json['departure_point'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      shuttle_direction: json['shuttle_direction'] as int? ?? 0,
      first_departure_time: (json['first_departure_time'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      last_arrival_time: (json['last_arrival_time'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      day_of_week: (json['day_of_week'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    )..nearest_departure = json['nearest_departure'] == null
        ? null
        : DateTime.parse(json['nearest_departure'] as String);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'departure_point': instance.departure_point,
      'shuttle_direction': instance.shuttle_direction,
      'destination': instance.destination,
      'first_departure_time': instance.first_departure_time,
      'last_arrival_time': instance.last_arrival_time,
      'day_of_week': instance.day_of_week,
      'nearest_departure': instance.nearest_departure?.toIso8601String(),
    };
